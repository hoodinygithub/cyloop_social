class BiographyController < ApplicationController
  layout "profile"

  def index
    profile_artist
  end
  
end
