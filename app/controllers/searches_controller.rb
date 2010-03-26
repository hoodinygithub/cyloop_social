class SearchesController < ApplicationController
  layout 'base'

  def show
   @results=cross_search (params[:q], per_page = 10)
   @results.each_pair do |key, value|
     @artists = value if key=='Artist'
     @albums = value if key=='Album'
     @songs = value if key=='Song'
     @users = value if key=='User'
     @stations = value if key=='Station'
   end

   @counts=cross_count (params[:q])

  end

  def autocomplete
    @results=cross_search (params[:q], per_page = 4)
    render :partial => 'searches/list', :object => @results, :locals => {:query => params[:q]}
  end

  private
    def cross_search (q, per_page = 10)
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

