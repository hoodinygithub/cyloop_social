class FollowersController < ApplicationController

  current_tab :community
  current_filter :followers

  def index
    @dashboard_menu = :followers
    @sort_type = params.fetch(:sort_by, nil).to_sym rescue :latest

    begin
        sort_types = { :latest => 'followings.approved_at DESC', :alphabetical => 'accounts.name'  }
        @collection = profile_user.followers.paginate :page => params[:page], :per_page => 12, :order => sort_types[@sort_type]
    rescue NoMethodError
      redirect_to new_session_path
    end
  end
end
