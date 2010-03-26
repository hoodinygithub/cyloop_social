class SearchesController < ApplicationController
  layout 'base'

  def show
   @active_scope=params[:scope]
   @counts=cross_count (params[:q])
   @active_scope = @counts.sort {|a,b| a[1]<=>b[1]}.last.first.downcase if params[:scope] == "any"
   @results=individual_search (params[:q],@active_scope, per_page = 20)
  end

  def autocomplete
    @results=cross_search (params[:q], per_page = 4)
    render :partial => 'searches/list', :object => @results, :locals => {:query => params[:q]}
  end

  private
    def individual_search (q, scope, per_page = 20)
      @scope = scope.classify.constantize
      query="#{q}"
      query="#{q}*" if scope.downcase=="song" || scope.downcase=="album"
      results = @scope.search query, :page => params[:page], :per_page => per_page
    end

    def cross_search (q, per_page = 20)
      results={}
      ["User","Station", "Album", "Artist" ].each do |scope|
        @scope = scope.classify.constantize
        query="#{q}"
        query="#{q}*" if scope=="Song" || scope=="Album"
        partial_results = @scope.search query, :page => params[:page], :per_page => per_page
        results.store(scope,partial_results)
      end
      #@cross_search=ThinkingSphinx::Search.search "#{params[:q]}" , :classes => [User, Song, Album, Artist ]
      results
    end

    def cross_count (q)
      results={}
      ["User","Station", "Album", "Artist" ].each do |scope|
        @scope = scope.classify.constantize
        query="#{q}*"
        partial_results = @scope.search_count query
        results.store(scope,partial_results)
      end
      #@cross_search=ThinkingSphinx::Search.search "#{params[:q]}" , :classes => [User, Song, Album, Artist ]
      results
    end

end

