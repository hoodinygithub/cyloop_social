class PlaylistsController < ApplicationController
  current_tab :playlists
  current_filter :all

  before_filter :geo_check, :only => :show
  before_filter :xhr_login_required, :only => [:copy]
  before_filter :login_required, :except => [:index, :widget, :avatar_update, :show, :copy]
  before_filter :profile_ownership_required, :only => [:index, :avatar_update], :if => :profile_owner?

  def index
    @dashboard_menu = :mixes
    if profile_owner?
      params[:controller] = 'my'
      params[:action]     = 'playlists'
    end
    sort_types  = { :latest => 'playlists.updated_at DESC',
                    :alphabetical => 'playlists.name',
                    :highest_rated => 'playlists.rating_cache DESC',
                    :top => 'playlists.total_plays DESC'  }

    @sort_type = get_sort_by_param(sort_types.keys, :latest) #params.fetch(:sort_by, nil).to_sym rescue :latest
    @page = params[:page] || 1
    
    if profile_account.is_a?(Artist)
      @collection = profile_account.playlists(:order => sort_types[@sort_type], :sort_type => @sort_type).paginate(:per_page => 6, :page => @page)      
    else
      if profile_owner? and on_dashboard?
        # Can't use account.total_playlists b/c that doesn't include locked mixes which need to appear in private view.
        @collection = profile_account.playlists.paginate :page => @page, :per_page => 6, :order => sort_types[@sort_type]
      else
        # Using account.total_playlists here saves a count query when looking for unlocked, undeleted mixes.
        @collection = profile_account.playlists.unlocked(:order => sort_types[@sort_type]).paginate :page => @page, :per_page => 6, :total_entries => profile_account.total_playlists
      end        
    end
    
    if request.xhr?
      render :partial => 'ajax_list'
    else
      respond_to do |format|
        format.html
        format.xml { render :layout => false }
      end
    end
  end

  def avatar_update
    @playlist = Playlist.find(params[:id])
    if @playlist
      @playlist.update_attributes(params[:playlist])
      respond_to do |format|
        format.js do
          responds_to_parent do
            render :update do |page|
              page << "update_playlist_avatar('#update_layer_avatar', '#{@playlist.avatar.url.sub(/\/original\//,'/large/')}');"
            end
          end
        end
      end
    end
  end

  def create
    @page = params[:page] || 1
    @per_page = (params[:term] and (params[:scope]=='artist' or params[:scope]=='album')) ? 7 : 12
    @results,@scope,@result_text = get_seeded_results
    unless request.xhr?
      if request.post?
        session[:playlist_ids] = nil
        @playlist_item_ids = []
        @songs_in_order = params[:item_ids].split(',')
        @playlist_item_ids = Song.find_all_by_id(@songs_in_order).to_a rescue []
        #@playlist_item_ids = Song.find_all_by_id(params[:item_ids].split(',')).to_a rescue []
        unless @playlist_item_ids.empty?
          attributes = { :name => params[:name], :site_id => current_site.id }
          attributes[:avatar] = params[:avatar] if params[:avatar]

          ActiveRecord::Base.transaction do
            if @playlist = current_user.playlists.create(attributes)
              song = nil
              @songs_in_order.each_with_index do |item, index|
                song = @playlist_item_ids.select{ |s| s && s.id.equal?(item.to_i) }.first rescue nil
                @playlist.items.create(:song => song, :artist_id => song.artist_id, :position => index + 1) if song
              end
              @playlist.update_tags(params[:tags].split(','))
              @playlist.create_station
              current_user.increment!(:total_playlists);
            end
          end
          create_page_vars
          redirect_to :action => 'edit', :id => @playlist.id, :edited => true
        end
      else
        if session[:playlist_ids]
          #logger.info session[:playlist_ids].inspect
          @playlist_items = Song.find_all_by_id(session[:playlist_ids].split(',')).to_a rescue []
          #@playlist_items = session[:playlist_ids].split(',').map { |i| Song.find(i) rescue nil }.compact
        end
        create_page_vars
      end
    else
      render :partial => "/playlists/create/search_results", :layout => false
    end
  end

  def edit
    session[:playlist_ids] = nil
    @playlist = profile_user.playlists.find(params[:id]) rescue nil
    if @playlist
      #if request.xhr?
      @edited = params[:edited]
      @playlist_item_ids = @playlist.items.map(&:id) if @playlist
      if request.xhr? and request.post?
        @songs_in_order = params[:item_ids].split(',')
        @playlist_item_ids = Song.find_all_by_id(@songs_in_order).to_a rescue []
        unless @playlist_item_ids.empty?
          ActiveRecord::Base.transaction do
            PlaylistItem.destroy_all("playlist_id = #{@playlist.id}")
            song = nil
            @songs_in_order.each_with_index do |item, index|
              song = @playlist_item_ids.select{ |s| s && s.id.equal?(item.to_i) }.first rescue nil
              @playlist.items.create(:song => song, :artist_id => song.artist_id, :position => index + 1) if song
            end
            @playlist.update_tags(params[:playlist][:tags].split(',')) if params[:playlist][:tags]
            attributes = { :name => params[:playlist][:name], :site_id => current_site.id, :locked_at => nil }
            @playlist.update_attributes!(attributes)
          end
          render :text => 'updated'
          #redirect_to my_playlists_path
        end
      end
      create_page_vars
      #else
      #  render :layout => false
      #end
    else
      redirect_to :action => :create
    end
  end

  def save_state
    #logger.info session[:playlist_ids]
    session[:playlist_ids] = params[:playlist_ids]
    #logger.info session[:playlist_ids]
    render :text => "saved", :layout => false
  end

  def clear_state
    session[:playlist_ids] = nil
    render :text => "cleared", :layout => false
  end

  def artist_recommendations
    artist = Artist.find(params[:artist_id]) rescue nil

    @recommended_artists = []
    @recommended_artists = artist.similar(20) if artist

    if @recommended_artists and @recommended_artists.empty?
      @recommended_artists = current_site.top_artists.all(:limit => 10)
    else
      @recommended_artists = @recommended_artists.sort_by {rand}[0..9] if @recommended_artists.size > 9
    end

    render :partial => 'playlists/create/recommendations'
  end

  def update
    @playlist = profile_user.playlists.find(params[:id])
    @playlist.update_attribute(:name, params[:playlist][:name])
    respond_to do |format|
      format.html { redirect_to my_mixes_path }
      format.js
    end
  end

  def widget
    @playlist = Playlist.find(params["id"])
    @last_box = params["last_box"] == "true"
    render :layout => false, :partial => "widget_item"
  end

  def show
    if params[:id] != "0"
      begin

        @playlist = Playlist.find(params[:id])

        if request.xhr?
          respond_to do |format|
            for0mat.html { render :layout => false, :partial => "playlist_result", :object => @playlist }
            format.xml { render :layout => false }
          end
        elsif
          respond_to do |format|
            format.html { }
            format.xml { render :layout => false }
          end
        end
      rescue ActiveRecord::RecordNotFound
        redirect_to new_session_path
      end
    else
      if request.xhr?
        respond_to do |format|
          format.html { render :layout => false, :partial => "playlist_result" }
          format.xml { render :layout => false }
        end
      end
    end
  end

  def delete_confirmation
    @playlist = profile_user.playlists.find(params[:id])
    render :layout => false
  end

  def destroy
    @playlist = profile_user.playlists.find(params[:id])
    #This query is very heavy - checking the existence of the playlist at render-time instead
    #NewActivityStore.delete_all("data like '%\"playlist_id\":#{@playlist.id},%'")
    @playlist.deactivate!
    respond_to do |format|
      format.js
      format.html { redirect_to :back }
    end
  end

  def comment
    @playlist = Playlist.find(params[:id])
    has_commented = @playlist.comments.find_by_user_id(current_user.id)
    if !has_commented
      @comment_params = params
      render :json => { :error => true, :redirect_to => "reviews/#{has_commented.id}/duplicate_warning" }
    else
      comment = Comment.new(:comment => params[:comment],
      :rating  => params[:rating],
      :user_id => current_user.id )
      if comment.valid?
        @playlist.comments << comment
        @playlist.save!
        render :partial => 'radio/review_item', :collection => [comment]
      else
        render :json => { :error => true, :messages => comment.errors.full_messages }
      end
    end
  end

  def comments
    sort_types = { :latest => 'comments.updated_at DESC', :highest_rated => 'comments.rating DESC'  }
    sort_type  = params.fetch(:sort_by, nil).to_sym rescue :latest
    playlist   = Playlist.find(params[:id])
    collection = playlist.comments.paginate :page => params[:page], :per_page => 15, :order => sort_types[sort_type]
    render :partial => 'radio/review_item', :layout => false, :collection => collection
  end

  def copy
    @playlist = Playlist.find(params[:id])
  end

  def duplicate
    orig_playlist = Playlist.find(params[:id])

    attributes = {
      :site_id => current_site.id,
      # playlist_item has a counter_cache
      #:songs_count => orig_playlist.songs_count,
      :total_time => orig_playlist.total_time,
      :cached_artist_list => orig_playlist.cached_artist_list,
    }

    new_playlist = Playlist.new(attributes)

    new_playlist.name  = params[:playlist][:name].blank? ? nil : params[:playlist][:name]
    new_playlist.owner = current_user

    if new_playlist.save
      orig_playlist.items.each do |item|
        new_playlist.items.create(:song_id => item.song_id, :position => item.position, :artist_id => item.artist_id )
      end
      new_playlist.create_station
      PlaylistCopying.create(:original_playlist_id => orig_playlist.id, :new_playlist_id => new_playlist.id )
      render :json => { :success => true }
    else
      render :json => { :success => false, :errors => new_playlist.errors.to_json }
    end
  end

  private

  def geo_check
    unless current_country.enable_radio
      render :xml => "<player error='NO_RADIO'></player>"
    end
  end

  def xhr_login_required
    unless current_user
      session[:return_to] = request.referer
      registration_layer = render_to_string 'registration_layers/index'
      return render(:json => {
                              :status => 'redirect',
                              :html   => registration_layer
                              }
                   )
    end
  end

  def get_seeded_results
    results = nil
    result_text = ""

    order_by = (params[:order_by] =~ /(song|artist|album)/i) ? params[:order_by].to_sym : nil
    order_dir = params[:order_dir] || 'ASC'

    album_sort = Proc.new do |a, b|
      if a and b
        order_dir=='DESC' ? b.album.name <=> a.album.name : a.album.name <=> b.album.name
      end
    end

    artist_sort = Proc.new do |a, b|
      if a and b
        order_dir=='DESC' ? b.artist.name <=> a.artist.name : a.artist.name <=> b.artist.name
      end
    end

    title_sort = Proc.new do |a, b|
      if a and b
        order_dir=='DESC' ? b.title <=> a.title : a.title <=> b.title
      end
    end

    name_sort = Proc.new do |a, b|
      if a and b
        order_dir=='DESC' ? b.name <=> a.name : a.name <=> b.name
      end
    end

    search_opts = {}
    scope = (params[:scope] =~ /(song|artist|album)/i) ? params[:scope].to_sym : nil
    if(scope)
      obj = scope.to_s.classify.constantize
      search_opts.merge!(:page => @page) if @page
      search_opts.merge!(:per_page => @per_page) if @per_page
      if params[:term]
        search_opts.merge!(:star => true)
        if(order_by)
          if order_by == :artist
            results = if scope == :artist
            #obj.search(params[:term], search_opts).sort!(&name_sort) rescue nil
            obj.search(params[:term], search_opts.merge(:order => "normalized_name #{order_dir}")) rescue nil
          else
            # obj.search(params[:term], search_opts).sort!(&artist_sort) rescue nil
            obj.search(params[:term], search_opts.merge(:order => "artist_name #{order_dir}")) rescue nil
          end
        elsif order_by == :album
          results = if scope == :album
          #obj.search(params[:term], search_opts).sort!(&name_sort) rescue nil
          obj.search(params[:term], search_opts.merge(:order => "name #{order_dir}")) rescue nil
        else
          # obj.search(params[:term], search_opts).sort!(&album_sort) rescue nil
          obj.search(params[:term], search_opts.merge(:order => "album_name #{order_dir}")) rescue nil
        end
      else# :song
        results = case scope
        when :song
          #obj.search(params[:term], search_opts).sort!(&title_sort) rescue nil
          obj.search(params[:term], search_opts.merge(:order => "title #{order_dir}")) rescue nil
        when :artist
          #obj.search(params[:term], search_opts).sort!(&artist_sort) rescue nil
          obj.search(params[:term], search_opts.merge(:order => "normalized_name #{order_dir}")) rescue nil
        when :album
          #obj.search(params[:term], search_opts).sort!(&album_sort) rescue nil
          obj.search(params[:term], search_opts.merge(:order => "name #{order_dir}")) rescue nil
        end
      end
    else
      results = obj.search(params[:term], search_opts) rescue nil
      # if scope == :song
      #   #results = obj.search(params[:term], :include => [:artist, :album]) rescue nil
      # else
      #   results = obj.search(params[:term], search_opts) rescue nil
      #   #results = obj.search(params[:term]) rescue nil
      # end
    end
    result_text = params[:term]
  elsif params[:item_id]
    obj_item = obj.find(params[:item_id]) rescue nil
    search_opts.merge!( :with => { :artist_id => obj_item.id } ) if obj_item.is_a?(Artist)
    search_opts.merge!( :with => { :album_id => obj_item.id } ) if obj_item.is_a?(Album)
    search_opts.merge!(:page => @page) if @page
    search_opts.merge!(:per_page => @per_page) if @per_page

    if obj_item
      @item_id = obj_item.id
      if(order_by)
        if order_by == :artist
          results = if scope == :song
          #obj_item.songs.paginate(search_opts).sort!(&artist_sort)
          obj_item.songs.paginate(search_opts.merge(:order => "accounts.name #{order_dir}")) rescue nil
          #Song.search search_opts
          #obj_item.songs
        else
          #Song.search(search_opts).sort!(&artist_sort)
          Song.search(search_opts.merge(:order => "artist_name #{order_dir}"))
        end
      elsif order_by == :album
        results = if scope == :song
        #obj_item.songs.paginate(search_opts).sort!(&album_sort)
        obj_item.songs.paginate(search_opts.merge(:order => "album_name #{order_dir}"))
      else
        #Song.search(search_opts).sort!(&album_sort)
        Song.search(search_opts.merge(:order => "album_name #{order_dir}"))
      end
    else# :song
      results = if scope == :song
      #obj_item.songs.paginate(search_opts).sort!(&title_sort)
      obj_item.songs.paginate(search_opts.merge(:order => "title #{order_dir}"))
    else
      #Song.search(search_opts).sort!(&title_sort)
      Song.search(search_opts.merge(:order => "title #{order_dir}"))
    end
  end
else
  if scope == :song
    results = obj_item.songs.paginate(search_opts)
  else
    puts search_opts.inspect
    results = Song.search(search_opts)
  end
end
# if(order_by)
#   if order_by == :artist
#     results = case scope
#       when :song
#         obj_item.songs
#       when :artist
#         obj_item.songs.find(:all, :order => "title ASC", :include => [:artist, :album])
#       when :album
#         obj_item.songs.find(:all, :joins => :artist, :order => "accounts.name #{order_dir}, title ASC", :include => [:artist, :album])
#     end
#   elsif order_by == :album
#     results = case scope
#       when :song
#         obj_item.songs
#       when :artist
#         obj_item.songs.find(:all, :joins => :album, :order => "albums.name #{order_dir}, title ASC", :include => [:artist, :album])
#       when :album
#         obj_item.songs.find(:all, :order => "title ASC", :include => [:artist, :album])
#     end
#   else# :song
#     results = case scope
#       when :song
#         obj_item.songs
#       when :artist
#         obj_item.songs.find(:all, :order => "title #{order_dir}", :include => [:artist, :album])
#       when :album
#         obj_item.songs.find(:all, :order => "title #{order_dir}", :include => [:artist, :album])
#     end
#   end
# else
#   if scope == :song
#     results = obj_item.songs
#   else
#     results = obj_item.songs.find(:all, :include => [:artist, :album])
#   end
# end
result_text = obj_item.to_s
end
end
results.compact! unless results.nil?
end
[results, scope, result_text]
end

def create_page_vars
@player_id = current_site.players.all(:conditions => "player_key = 'ondemand_#{current_site.code}'")[0].id rescue nil
@recommended_artists = current_site.top_artists.all(:limit => 10)
@playlist_item_ids ||= session[:playlist_item_ids].nil? ? [] : session[:playlist_item_ids]
@playlist_items ||= @playlist_item_ids.empty? ? [] : @playlist.items
end
end
