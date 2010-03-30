class Charts::ArtistsController < ApplicationController
  current_tab :charts
  current_filter :artists
  
  def index
    begin
      @artists = profile_user.most_listened_artists.paginate :page => params[:page], :per_page => 10
    rescue ActiveRecord::RecordNotFound
      redirect_to profile_account || new_session_path
    end
  end
end
