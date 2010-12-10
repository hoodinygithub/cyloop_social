class SearchesController < ApplicationController
  before_filter :msn_codes

  disable_sanitize_params
  strip_tags_from_params

  def show
    @query = CGI::unescape(params[:q]) rescue nil
    @search_types ||= [:artists , :stations, :mixes, :users]    
    @internal_search_types ||=  { :stations => :abstract_stations, :mixes => :playlists }

    @sort_types = { :latest => { :artists => nil, :stations => 'updated_at DESC', :playlists => 'updated_at DESC', :users => nil}, \
                    :alphabetical => 'normalized_name ASC', \
                    :relevance => nil, \
                    :highest_rated => { :playlists => 'rating_cache DESC', :users => nil, :artists => nil, :stations => 'rating_cache DESC' }, \
                    :top => { :mixes => 'playlist_total_plays DESC', :users => nil, :artists => nil, :stations => 'user_station_total_plays DESC' }  
    }

    @sort_type = get_sort_by_param(@sort_types.keys, :relevance) #params.fetch(:sort_by, nil).to_sym rescue :relevance

    @active_scope = params[:scope].nil? ? @search_types[0] : params[:scope].to_sym
    @page = params[:page] || 1

    @counts = {}
    @results = {}

    if request.xhr?
      if @active_scope == :all
        search_results(@search_types, 4)
        default_active_scope 
      else 
        search_results(@active_scope.to_a)
      end

      if params.has_key? :result_only
        render :partial => "searches/#{@active_scope.to_s}"
      else
        render :partial => 'searches/list'
      end      
    else
      unless @query.nil?
        if @active_scope == :all
          search_results(@search_types) 
          default_active_scope
        else
          search_results(@active_scope.to_a)
        end
      else
        @search_types.each do |t| 
          @results.store(t, [])
          @counts.store(t, 0)
        end      
      end      
    end

    # if request.xhr?
    #   @active_scope == :all ? search_all_types(4) : search_only_active_type(20)
    #   
    #   if params.has_key? :result_only
    #     render :partial => "searches/#{@active_scope.to_s}"
    #   else
    #     render :partial => 'searches/list'
    #   end      
    # else
    #   unless @query.nil?
    #     @active_scope == :all ? search_all_types : search_only_active_type
    #   end
    # end

  end

  def content
    @query = params[:q]    
    @content_search ||= true
    @search_types ||= [:artists, :songs, :albums]    
    @internal_search_types = []
    @sort_type = :relevance
    @sort_types = { :relevance => nil }

    @active_scope = params[:scope].nil? ? @search_types[0] : params[:scope].to_sym

    @counts = {}
    @results = {}

    @active_scope == :all ? search_results(@search_types, 4) : search_results(@active_scope.to_a)

    @local = true if params[:local]
    render :partial => 'searches/content_list'#, :layout => false
  end

  def twitstation
    @query = CGI::unescape(params[:q]) rescue nil
    
    if @query.nil?
      render :xml => {:error => { :message => "No query."}}
    else
      #@search_type = :artists
      @search_types = [:artists]
      @internal_search_types = []
      @sort_type = :relevance
      @sort_types = { :relevance => nil }
      @results = {}
      @counts = {}
      search_results(@search_types)
      
      if @results[:artists] && @results[:artists][0]
        artist = @results[:artists][0]
        playlist = artist.playlists(:order => 'playlists.total_plays DESC', :network_id => 2).first;
        if playlist.nil?
          render :xml => {:error => { :message => "No playlists for artist: #{artist.name}", :name => artist.name, :amg_id => (CGI::escape(artist.amg_id) rescue nil)}}
        else
          render :xml => {:playlist => playlist.station.id, :name => playlist.name, :artist => artist.name, :includes => playlist.cached_artist_list }
        end
      else 
        render :xml => {:error => { :message => "Artist not found: #{@query}"}}        
      end
    end
  end

  private  
    def default_active_scope
      @active_scope = @counts.sort{ |a, b| b[1] <=> a[1] }.first[0] unless @search_types.include? @active_scope
    end

    # def default_sort_type
    #   @sort_type = :relevance
    # end

    def sort_users_by_alpha(*args)
      args.first.sort!{ |a, b| a[1].name <=> b[1].name rescue 0 }
    end

    def search_results (types=[], per_page = 12)
      opts = { :page => @page, :per_page => per_page, :star => true, :retry_stale => true }

      @search_types.each do |scope|
        dataset = []
        obj_scope = @internal_search_types.fetch(scope, scope)
        obj = obj_scope.to_s.classify.constantize
        opts.delete(:order)

        if types.include? scope
          #default_sort_type scope == @active_scope
          sort_instruction = nil
          custom_sort = false

          if(@sort_types[@sort_type].is_a? Hash)
            sort_instruction = @sort_types[@sort_type][obj_scope]
            unless sort_instruction.nil?
              custom_sort = true if sort_instruction.is_a?(Symbol)
              opts.merge!(:order => @sort_types[@sort_type][obj_scope]) unless custom_sort
            end
          elsif @sort_type == :relevance and obj.name == "Artist"
            # Ordering by relevance isn't working.  All weights coming back as 1.  Using popularity as artist relevance.
            opts.merge!(:sql_order => "total_listen_count DESC")
          else
            sort_instruction = @sort_types[@sort_type]
            unless sort_instruction.nil?
              custom_sort = true if sort_instruction.is_a?(Symbol)
              opts.merge!(:order => @sort_types[@sort_type]) unless custom_sort
            end
          end
          dataset = obj.search(@query, opts) if types.include? scope          
          send(sort_instruction, dataset) if custom_sort
        end
        @results.store(scope, dataset)
        @counts.store(scope, obj.search_count(@query, opts))
      end
    end

    # 
    # def search_only_active_type (per_page = 20)
    #   opts = { :page => params[:page], :per_page => per_page, :star => true }
    #   opts.merge!(:order => @sort_types[@sort_type]) unless @sort_types[@sort_type].nil?
    # 
    #   @search_types.each do |scope|
    #     obj_scope = scope == :stations ? :abstract_stations : scope
    #     obj = obj_scope.to_s.classify.constantize
    # 
    #     @results.store(scope, (scope == @active_scope) ? obj.search(@query, opts) : [])
    #     @counts.store(scope, obj.search_count("#{@query}*"))
    #   end
    # end
    #   
    # def search_all_types (per_page = 20)
    #   opts = { :page => params[:page], :per_page => per_page, :star => true }
    #   opts.merge!(:order => @sort_types[@sort_type]) unless @sort_types[@sort_type].nil?
    # 
    #   @search_types.each do |scope|
    #     obj_scope = scope == :stations ? :abstract_stations : scope
    #     obj = obj_scope.to_s.classify.constantize
    # 
    #     @results.store(scope, obj.search(@query, opts))
    #     @counts.store(scope, obj.search_count("#{@query}*"))
    #   end
    #   default_active_scope
    # end

    def msn_codes
      @msn_properties={}
      @msn_properties[:page_name] = '\'Search\''
      @msn_properties[:prop3] = "\'Cyloop - Search \'"
      @msn_properties[:prop4] = "\'Search\'"
    end
end
