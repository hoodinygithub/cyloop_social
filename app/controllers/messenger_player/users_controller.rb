
class MessengerPlayer::UsersController < MessengerPlayer::PlayerController

  def status
    respond_to do |format|
      format.xml { render :show }
    end
  end

end