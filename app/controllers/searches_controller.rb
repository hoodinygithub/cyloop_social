class SearchesController < ApplicationController
  layout 'base'

  def show
    @scope = params[:scope].classify.constantize rescue Artist
    if [Artist, User, Song, Album].include?(@scope)
      @results = @scope.search params[:q], :page => params[:page]
    else
      render :status => 422, :nothing => true # TODO: Better way to handle this one?
    end
  end

  def autocomplete
    @results={}
    ["User","Song", "Album", "Artist" ].each do |scope|
      @scope = scope.classify.constantize
      q="#{params[:q]}"
      q="#{params[:q]}*" if scope=="Song" || scope=="Album"
      @partial_results = @scope.search q, :page => params[:page], :per_page => 4
      @results.store(scope,@partial_results)
    end
    #@cross_search=ThinkingSphinx::Search.search "#{params[:q]}" , :classes => [User, Song, Album, Artist ]
    render :partial => 'searches/list2', :object => @results, :locals => {:query => params[:q]}

  end

end

