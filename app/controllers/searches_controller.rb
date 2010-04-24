class SearchesController < ApplicationController

  def show
    @query = params[:q]    
    @search_types ||= [:artists, :stations, :users]    
    @sort_type = params.fetch(:sort_by, nil).to_sym rescue :relevance
    @sort_types = { :latest => 'created_at DESC', :alphabetical => 'name ASC', :relevance => nil }

    @active_scope = if params[:scope].nil?
      @search_types[0]
    else
      unless @search_types.include? params[:scope].to_sym 
        @search_types[0] 
      else
        params[:scope].to_sym 
      end
    end

    @counts = {}
    @results = {}
    if request.xhr?
      params[:scope].to_sym == :all ? search_all_types(4) : search_only_active_type(20)

      if params.has_key? :result_only
        render :partial => "searches/#{@active_scope.to_s}"
      else
        render :partial => 'searches/list'
      end      
    else
      unless @query.nil?
        if params[:scope].to_sym == :all
          search_all_types 
        else
          search_only_active_type
        end      
      end      
    end
  end

  private  

    def search_only_active_type (per_page = 20)
      opts = { :page => params[:page], :per_page => per_page }
      opts.merge!(:order => @sort_types[@sort_type]) unless @sort_types[@sort_type].nil?

      @search_types.each do |scope|
        obj_scope = scope == :stations ? :abstract_stations : scope
        obj = obj_scope.to_s.classify.constantize

        @results.store(scope, (scope == @active_scope) ? obj.search(@query, opts) : [])
        @counts.store(scope, obj.search_count("#{@query}*"))
      end
    end
  
    def search_all_types (per_page = 20)
      opts = { :page => params[:page], :per_page => per_page }
      opts.merge!(:order => @sort_types[@sort_type]) unless @sort_types[@sort_type].nil?

      @search_types.each do |scope|
        obj_scope = scope == :stations ? :abstract_stations : scope
        obj = obj_scope.to_s.classify.constantize

        @results.store(scope, obj.search(@query, opts))
        @counts.store(scope, obj.search_count("#{@query}*"))
      end
    end
end

