class DashboardsController < ApplicationController
  before_filter :login_required
  before_filter :find_user_stations
  before_filter :auto_follow_profile  
  current_tab :dashboard 
  current_filter :songs
  layout_except_xhr "base"
  
  def show
    respond_to do |format|
      format.html
      format.json do
        render :text => profile_user.activity_feed
      end
    end
  end
  
private
  # this is solely to cache so we don't do a ton of queries
  def find_user_stations
    stations = profile_user.stations.find(:all, :limit => 5, :include => [:station])
    artist_ids = stations.map{|s| s.station.artist_id}
    Artist.find_all_by_id artist_ids
  rescue
  end
end
