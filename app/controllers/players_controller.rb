class PlayersController < ApplicationController

  def show
    @configs = current_site.players.find_by_player_key(params[:id])
    respond_to do |format|
      format.xml {render :layout => false}
      format.html
    end
  end

end
