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
    if request.xhr?
      @results = search_all_types(4)
      @results.each_pair { |k, v| @counts.store(k, v.size) }  
      render :partial => 'searches/list'
    else
      unless @query.nil?
        @results = search_all_types 
        @results.each_pair { |k, v| @counts.store(k, v.size) }  
      end      
    end
  end

  private  
  
    def search_all_types (per_page = 20)
      results = {}
      opts = { :page => params[:page], :per_page => per_page }
      opts.merge!(:order => @sort_types[@sort_type]) unless @sort_types[@sort_type].nil?

      @search_types.each do |scope|
        obj_scope = scope == :stations ? :abstract_stations : scope
        obj = obj_scope.to_s.classify.constantize
        results.store(scope, obj.search(@query, opts))
      end
      results
    end
end

