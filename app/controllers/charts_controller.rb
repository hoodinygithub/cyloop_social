class ChartsController < ApplicationController
  current_tab :charts

  def index
    redirect_to user_charts_songs_path(params[:slug] || "my")
  end

end
