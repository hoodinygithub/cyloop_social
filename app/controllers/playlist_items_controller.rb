class PlaylistItemsController < ApplicationController
  before_filter :display_layer, :only => [:new, :create, :update]
  before_filter :login_required, :only => [:new, :create, :update]
  before_filter :profile_ownership_required, :only => :update


  def new
    @song = []
    @song << Song.find(params[:song_id] || params[:playlist_item][:song_id])
  end

  def create
    @song = []
    if params[:song_id]
      @song << Song.find(params[:song_id])
    else
      @song = params[:song_ids].to_a.map { |id| Song.find(id) }
    end
    @playlists = params[:playlist_ids].to_a.map {|id| current_user.playlists.find_by_id(id)}.compact
    if params[:new_playlist] && !params[:new_playlist_name].blank?
      @playlists << current_user.playlists.find_or_create_by_name(params[:new_playlist_name])
    end
    if @playlists.any?
      @playlists.each do |playlist|
        if @song.any?
          @song.each do |song|
            playlist.items.create(:song => song, :artist_id => song.artist_id)
            record_activity(playlist)
          end
        end
      end
      if request.xhr?
        render :nothing => true
      else
        redirect_to [@song[0].artist, @song[0].album] rescue root_path
      end
    else
      @error = t('playlist_items.create.errors.click_checkbox_first')
      render :action => 'new', :status => :unprocessable_entity
    end
  end

  def show
    @playlist_item = PlaylistItem.find(params[:id])
    redirect_to [@playlist_item.artist, @playlist_item.song]
  end

  def delete_confirmation
    @playlist_item = PlaylistItem.find(params[:id])
    render :layout => false
  end

  def destroy
    @ids = params[:ids].blank? ? [params[:id]] : params[:ids]
    PlaylistItem.destroy( @ids )

    respond_to do |format|
      format.js
      format.html { redirect_to :back }
    end
  end

  def update
    @playlist = profile_user.playlists.find(params[:playlist_id])
    @target_item = @playlist.items.find(params[:id])
    result = @target_item.insert_at(params[:position])
    render :nothing => true, :status => (result ? :ok : :unprocessable_entity)
  end

  private
    def record_activity(playlist)
      if(playlist.items.count == 3)
        artists_contained = playlist.artists_contained({:random => true, :limit => 4}).map { |k| {:artist => k.name, :slug => k.slug} }.to_json rescue ''
        begin
          tracker_payload = {
            :user_id => current_user.id,
            :playlist_id => playlist.id,
            :site_id => current_site.id,
            :visitor_ip_address => remote_ip,
            :timestamp => Time.now.to_i,
            :artists_contained => artists_contained
          }
          Resque.enqueue(PlaylistJob, tracker_payload)
        rescue
          Rails.logger.error("*** Could not record playlist activity! payload: #{tracker_payload}") and return true
        end
      end
    end
end

