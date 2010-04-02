class DashboardsController < ApplicationController
  before_filter :login_required
  before_filter :find_user_stations
  before_filter :auto_follow_profile  
  
  current_tab :dashboard 
  current_filter :songs
  layout_except_xhr 'application'
  
  RECOMMENDED_STATIONS = 6
  
  def show
    @dashboard_menu = :home
    @mixes_recommended = (1..6).to_a
    
    @latest_activity_status = current_user.activity_status.latest_with_followings
    @last_activity_status     = current_user.activity_status.last
    
    if @latest_activity_status and @latest_activity_status.size > 0
      if @latest_activity_status.first['message'] == @last_activity_status['message']
        @latest_activity_status.shift
      end
    end

    stations = recommended_stations(30)
    @recommended_stations = stations[0..(RECOMMENDED_STATIONS-1)]
    @recommended_stations_queue = stations[RECOMMENDED_STATIONS..(stations.size)]
    
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
    stations = profile_user.stations.all(:limit => 5, :include => [:abstract_station])
    artist_ids = stations.map{|s| s.abstract_station.artist_id}
    Artist.find_all_by_id artist_ids
  rescue
  end
end
