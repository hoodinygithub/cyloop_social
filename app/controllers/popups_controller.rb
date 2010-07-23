class PopupsController < ApplicationController
  layout 'widget'

  def widget
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
    render :layout => false, :partial => 'player'
  end

end
