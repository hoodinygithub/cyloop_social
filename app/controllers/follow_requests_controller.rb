class FollowRequestsController < ApplicationController
  before_filter :profile_ownership_required

  layout "profile"

  def update
    following.approve!
    flash[:success] = t("following.approval", :name => following.follower.name)
    redirect_back_or_default(my_follow_requests_path)
  end

  def destroy
    following.destroy
    flash[:success] = t("following.denial", :name => following.follower.name)
    redirect_back_or_default(my_follow_requests_path)
  end

  protected
  def following
    @following ||= profile_account.follow_requests.find(params[:id])
  end
end
