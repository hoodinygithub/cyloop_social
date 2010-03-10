module Application::MsnMessenger

  extend ActiveSupport::Memoizable

  def self.included( base )
    base.helper_method :is_msn_messenger_enabled?
  end

  def is_msn_messenger_enabled?
    request.port == 80 && MessengerLiveService.current_login( request.host )
  end

  memoize :is_msn_messenger_enabled?

end