class CommentsController < ApplicationController
  before_filter :login_required, :only => [:new, :create]
  before_filter :require_ownership, :only => [:destroy]

  def create
    @comment = Comment.new(params[:comment])
    @commentable = User.find_by_slug(params[:slug]) if params[:slug]
    @comment.owner = current_user if current_user
    @comment.commentable = @commentable
    if @comment.save
      flash[:notice] = t('comments.create_success')
      redirect_to user_path(@commentable)
    else
      render :action => 'new'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = t('comments.delete_success')
    redirect_to user_path(@comment.commentable)
  end
  
  
  protected
  def require_ownership
    @comment ||= Comment.find(params[:id])
    unless @comment.owner == current_user
      redirect_to new_session_path
      false
    end
  end
end
