class CustomArtistsController < ApplicationController

  include Application::VisitsRecorder
  record_visits

  def detour
    @profile_account = Artist.find_with_exclusive_scope(:first, :conditions => {:slug => "detour"})
    render :show
  end

  def invasion
    @profile_account = Artist.find_with_exclusive_scope(:first, :conditions => {:slug => "invasion"})
    render :show
  end

end
