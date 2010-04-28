
module MsnHelper

  def msn_app_verifier
    MessengerLiveService.current_login( request.host ).app_verifier
  end

  def render_messenger_live
    if is_msn_messenger_enabled?
      render 'msn/header'
    end
  end

  def render_messenger_app
    if is_msn_messenger_enabled? && current_site.is_msn?
      render 'msn/application'
    end
  end

end