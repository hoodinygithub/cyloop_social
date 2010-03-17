class FollowersController < ApplicationController

  layout 'base'

  current_tab :community
  current_filter :followers

  def index
    @dashboard_menu = :followers
    begin
      @collection = profile_account.followers.paginate :page => params[:page], :per_page => 15
      render :template => 'shared/community'
    rescue NoMethodError
      redirect_to new_session_path
    end
  end
end
