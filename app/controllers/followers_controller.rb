class FollowersController < ApplicationController

  current_tab :community
  current_filter :followers

  def index
    @dashboard_menu = :followers
    @sort_field = params.fetch(:sort_field, nil)
    @sort_order = params.fetch(:sort_order, nil)
    begin
      if @sort_field == 'name' and  @sort_order == 'asc'
        @collection = profile_account.followers.alphabetical.paginate :page => params[:page], :per_page => 12
      else
        @sort_field = 'created_at'
        @sort_order = 'desc'
        @collection = profile_account.followers.paginate :page => params[:page], :per_page => 12
      end
    rescue NoMethodError
      redirect_to new_session_path
    end
  end
end
