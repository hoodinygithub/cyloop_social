class PopupsController < ApplicationController

  layout 'widget'

  def widget
    @onpage_widget = true;
    player = Player.find_by_player_key(params[:player_key])
    @campaign = if !player.nil?
      player.active_campaign
    end
    if @campaign.ad_size == "300x250"
      @top_abstract_stations = current_site.top_abstract_stations(4)
    end
    respond_to do |format|
      format.js
    end
  end

  def player
    @station = Station.find(params[:station_id])
    player = Player.find_by_player_key(params[:player_key])
    @campaign = if !player.nil?
      @onpage_widget = false
      player.active_campaign
    end
    if @campaign.nil?
      render :text => "Sorry this service has been disabled. :*(", :layout => false
    else
      @top_abstract_stations = current_site.top_abstract_stations(4) if @campaign.ad_size == "300x250"
      render :layout => false, :partial => 'player'
    end
  end

  def album_detail
    if request.xhr? or params[:widget] == 'true'
      @station_obj = Station.find(params[:station_id]) rescue nil
      if @station_obj
        @station_obj = create_user_station(@station_obj)
        @station_obj.playable.track_a_play_for(current_user) if @station_obj.playable
        if params[:partial_prefix]
          render :partial => "#{partial_prefix}#{@station_obj.playable.class.to_s.underscore}"
        elsif params[:widget] == 'true'
          if @station_obj.playable_type == "EditorialStation"
            render :partial => '/popups/hp_editorial_station'
          else
            render :partial => 'abstract_station'
          end
        else
          render :partial => @station_obj.playable.class.to_s.underscore
        end
      end
    else
      redirect_to radio_path(:station_id => params[:station_id])
    end
  end

end
