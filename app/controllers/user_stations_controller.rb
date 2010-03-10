class UserStationsController < ApplicationController

  before_filter :profile_ownership_required, :only => :create
  # caches_action :show, :expires_in => 1.minute, :cache_path => :user_station_cache_key

  current_tab :stations
  current_filter :stations

  def create
    @station = Station.find(params[:station_id])
    unless @station.nil?
      user_station = current_user.stations.find_by_station_id(@station.id)
      unless user_station
        current_user.create_user_station(:station_id => @station.id, :current_site => current_site)
        record_activity(@station)
      end
    end

    redirect_to :action => :index
  end

  def index
    respond_to do |format|
      block = Proc.new do
        @stations = profile_user.stations
        render :xml => Player::Station.from(@stations, :ip => remote_ip, :user_id => logged_in? ? current_user.id : nil).to_xml(:root => 'user_stations')
      end
      format.html do
        @stations = profile_user.stations.paginate :page => params[:page], :per_page => 15
        render :layout => 'profile'
      end
      if logged_in?
        format.xml(&block)
        format.js(&block)
      else
        format.js { render :text => 'authentication required', :layout => false }
        format.xml { render :xml => { :error => 'authentication required' }.to_xml(:root => 'response') }
      end
    end
  end

  def show
    @station = profile_user.stations.find(params[:id])
    respond_to do |format|
      format.xml do
        render :layout => false
      end
    end
  end

  def edit
    @user_station = UserStation.find_by_id_and_owner_id!(params[:id], profile_user.id)
  end

  def update
    @user_station = UserStation.find_by_id_and_owner_id!(params[:id], profile_user.id)
    @user_station.update_attribute(:name, params[:user_station][:name])
    respond_to do |format|
      format.html do
        redirect_to my_stations_path
      end
      format.xml do
        render :xml => Player::Message.new( :message => t('messenger_player.station_edit_success') )
      end
      format.js
    end
  end

  def destroy
    UserStation.find_by_id_and_owner_id!(params[:id], profile_user.id).destroy
    respond_to do |format|
      format.html do
        redirect_to my_stations_path
      end
      format.xml do
        render :xml => Player::Message.new( :message => t('stations.deleted') )
      end
    end
  end

  def queue
    logger.info "station id: #{params[:station_id]}"
    if current_user.nil?
      redirect_to radio_path
    else
      s = Station.find(params[:station_id])
      if s.nil?
        redirect_to radio_path
      else
        @station = current_user.create_user_station(:station_id => s.id, :current_site => current_site)
        record_activity(s)
        redirect_to radio_path(:station_id => s.id, :queue => "true")
      end
    end
  end

  private
  def songs
    @songs ||= rec_engine.get_rec_engine_play_list(:artist_id => @station.amg_id)
  end
  helper_method :songs

  def user_station_cache_key_url
    "#{CURRENT_SITE.cache_key}/#{profile_user.cache_key}/station/#{params[:id]}"
  end

  def record_activity(station)
    begin
      tracker_payload = {
        :user_id => current_user.id,
        :station_id => station.id,
        :site_id => current_site.id,
        :visitor_ip_address => remote_ip,
        :timestamp => Time.now.to_i
      }
      Resque.enqueue(StationJob, tracker_payload)
    rescue
      Rails.logger.error("*** Could not record station activity! payload: #{tracker_payload}") and return true
    end
  end
end
