class PopupsController < ApplicationController
  layout 'widget'
  
  def widget
    respond_to do |format|
      format.js
    end
  end

end