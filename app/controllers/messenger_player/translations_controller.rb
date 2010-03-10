
class MessengerPlayer::TranslationsController < MessengerPlayer::PlayerController

  def index
    respond_to do |format|
      format.xml
    end
  end

end