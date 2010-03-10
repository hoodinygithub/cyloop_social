class BlocksController < ApplicationController

  def create
    @blockee = User.find(params[:blockee_id])
    current_user.block(@blockee)
    respond_to do |format|
      format.html do
        flash[:success] = t('blocks.been_blocked', :name => @blockee.name)
        redirect_to :back
      end
      format.js
    end
  end

end
