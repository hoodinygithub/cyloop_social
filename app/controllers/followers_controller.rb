class FollowersController < ApplicationController

  layout "profile"

  current_tab :community
  current_filter :followers

  def index
    begin
      @followers = profile_account.followers.paginate :page => params[:page], :per_page => 15
    rescue NoMethodError
      redirect_to new_session_path
    end
  end
end
