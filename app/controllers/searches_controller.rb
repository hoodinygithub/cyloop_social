class SearchesController < ApplicationController
  layout 'base'

  def show
   @active_scope=params[:scope]
   @counts=cross_count (params[:q])
   @active_scope = @counts.sort {|a,b| a[1]<=>b[1]}.last.first.downcase if params[:scope] == "any"
   @results=individual_search (params[:q],@active_scope, 20, sorting(@active_scope,params[:order]))
  end

  def autocomplete
    @results=cross_search (params[:q], per_page = 4)
    render :partial => 'searches/list', :object => @results, :locals => {:query => params[:q]}
  end

  private
    def individual_search (q, scope, per_page = 20, order = :name )
      @scope = scope.classify.constantize
      query="#{q}"
      query="#{q}*" if scope.downcase=="song" || scope.downcase=="album"
      results = @scope.search query, :page => params[:page], :per_page => per_page,:sql_order=> order
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

    def sorting(scope,sort)
      result='id'
      case scope
      when 'artist'
        result='name' if sort=='alpha'
      when 'station'
        result='name' if sort=='alpha'
      end
      logger.error "#{scope}------#{sort}----------#{result}"
      result
    end

end

