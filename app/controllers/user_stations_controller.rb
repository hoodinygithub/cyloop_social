class UserStationsController < ApplicationController

  before_filter :profile_ownership_required, :only => [:create]
  before_filter :auto_follow_profile, :only => [ :index ]
  # caches_action :show, :expires_in => 1.minute, :cache_path => :user_station_cache_key

  current_tab :stations
  current_filter :stations

  def create
    @station = Station.find(params[:station_id])
    create_user_station(@station)
    redirect_to :action => :index
  end

  def index

    @dashboard_menu = :stations

    respond_to do |format|
      block = Proc.new do
        @user_stations = profile_account.stations
        render :xml => Player::Station.from(@user_stations, :ip => remote_ip, :user_id => logged_in? ? current_user.id : nil).to_xml(:root => 'user_stations')
      end

      format.html do
        @sort_type = params.fetch(:sort_by, nil).to_sym rescue :latest

        begin
          @user_stations = profile_account.stations_paginate params[:page], 6, @sort_type
        rescue NoMethodError
          redirect_to new_session_path
        end
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
    @station = profile_account.stations.find(params[:id])
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
        if request.xhr?
          render :text => 'updated'
        else
          redirect_to my_stations_path
        end
      end

      format.xml do
        render :xml => Player::Message.new( :message => t('messenger_player.station_edit_success') )
      end

      format.js
    end
  end

  def destroy
    u = UserStation.find_by_id_and_owner_id!(params[:id], profile_user.id)
    u.deactivate!

    respond_to do |format|
      format.html do
        if request.xhr?
          render :text => 'destroyed'
        else
          redirect_to my_stations_path
        end
      end

      format.xml do
        render :xml => Player::Message.new( :message => t('stations.deleted') )
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
end

