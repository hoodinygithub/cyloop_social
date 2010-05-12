class PlayersController < ApplicationController

  def show
    respond_to do |format|
      block = Proc.new do
        @configs = current_site.players.find_by_player_key(params[:id])
        render :xml => Player::Player.from(@configs).to_xml(:root => "player")
      end
      format.xml(&block)
      format.js(&block)
      format.html
    end
  end

end
