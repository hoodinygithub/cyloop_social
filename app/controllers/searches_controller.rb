class SearchesController < ApplicationController

  def show
    @search_types = [:artists, :stations, :users]

    unless params[:scope].nil?
      params[:scope] = @search_types[0] unless @search_types.include? params[:scope].to_sym
    end

    @sort_type = params.fetch(:sort_by, nil).to_sym rescue :relevance
    @sort_types = { :latest => 'created_at DESC', :alphabetical => 'name ASC', :relevance => nil }
        
    @results = search_all_types(params[:q])
    @active_scope = params[:scope].nil? ? @results.sort { |a,b| b[1].size <=> a[1].size }.first[0] : params[:scope].to_sym

    @counts = {}
    @results.each_pair { |k, v| @counts.store(k, v.size) }  
  end

  def autocomplete
    @results=cross_search(params[:q], per_page = 4)
    render :partial => 'searches/list', :object => @results, :locals => {:query => params[:q]}
  end

  private
    def search_all_types (query, per_page = 20)
      results = {}
      opts = { :page => params[:page], :per_page => per_page }
      opts.merge!(:order => @sort_types[@sort_type]) unless @sort_types[@sort_type].nil?

      @search_types.each do |scope|
        obj_scope = scope == :stations ? :abstract_stations : scope
        obj = obj_scope.to_s.classify.constantize
        results.store(scope, obj.search(query, opts))
      end
      results
    end
end

