class SearchesController < ApplicationController
  before_filter :msn_codes

  def show
    @query = params[:q]    
    @search_types ||= [:artists, :stations, :users]    
    @sort_type = params.fetch(:sort_by, nil).to_sym rescue :relevance
    @sort_types = { :latest => { :playlists => 'updated_at DESC', :users => 'created_at DESC' }, :alphabetical => 'name ASC', :relevance => nil }

    @active_scope = params[:scope].to_sym unless params[:scope].nil?

    @counts = {}
    @results = {}
    if request.xhr?
      @active_scope == :all ? search_all_types(4) : search_only_active_type(20)
      
      if params.has_key? :result_only
        render :partial => "searches/#{@active_scope.to_s}"
      else
        render :partial => 'searches/list'
      end      
    else
      unless @query.nil?
        @active_scope == :all ? search_all_types : search_only_active_type
      end
    end
  end

  private  
    def default_active_scope
      @active_scope = @counts.sort{ |a, b| b[1] <=> a[1] }.first[0] unless @search_types.include? @active_scope
    end
    
    def search_only_active_type (per_page = 20)
      opts = { :page => params[:page], :per_page => per_page, :star => true }
      opts.merge!(:order => @sort_types[@sort_type]) unless @sort_types[@sort_type].nil?

      @search_types.each do |scope|
        obj_scope = scope == :stations ? :abstract_stations : scope
        obj = obj_scope.to_s.classify.constantize

        @results.store(scope, (scope == @active_scope) ? obj.search(@query, opts) : [])
        @counts.store(scope, obj.search_count("#{@query}*"))
      end
    end
  
    def search_all_types (per_page = 20)
      opts = { :page => params[:page], :per_page => per_page, :star => true }
      opts.merge!(:order => @sort_types[@sort_type]) unless @sort_types[@sort_type].nil?

      @search_types.each do |scope|
        obj_scope = scope == :stations ? :abstract_stations : scope
        obj = obj_scope.to_s.classify.constantize

        @results.store(scope, obj.search(@query, opts))
        @counts.store(scope, obj.search_count("#{@query}*"))
      end
      default_active_scope
    end
    
    def msn_codes
      @msn_properties={}
      @msn_properties[:page_name] = '\'Search\''
      @msn_properties[:prop3] = "\'Cyloop - Search \'"
      @msn_properties[:prop4] = "\'Search\'"
    end
end

