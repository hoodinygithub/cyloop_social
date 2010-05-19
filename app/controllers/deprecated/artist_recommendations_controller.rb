class ArtistRecommendationsController < ApplicationController
  before_filter :login_required

  def show
    @artists = rec_engine.get_recommended_artists(:number_of_records => 48)
  end
end
