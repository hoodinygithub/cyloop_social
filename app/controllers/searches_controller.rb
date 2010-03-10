class SearchesController < ApplicationController
  def show
    @scope = params[:scope].classify.constantize rescue Artist
    if [Artist, User, Song, Album].include?(@scope)
      @results = @scope.search params[:q], :page => params[:page]
    else
      render :status => 422, :nothing => true # TODO: Better way to handle this one?
    end
  end
end