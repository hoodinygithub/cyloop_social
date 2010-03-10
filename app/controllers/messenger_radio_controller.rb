class MessengerRadioController < ApplicationController 
  layout false
  
  def analytics
    @code = params.fetch(:pageTracker, '/messenger_radio')
  end
end