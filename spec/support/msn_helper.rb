module MsnHelper

  class WindowsLive
    attr_reader :wll, :msn_live_id, :stoken
    
    def initialize
      @wll = WindowsLiveLogin.init()
      @msn_live_id = nil
      @stoken = File.open(RAILS_ROOT + "/spec/fixtures/msn_token","r").readline
    end
    
    def logout
      @wll.getLogoutUrl
    end
    
    def login
      @msn_live_id = wll.processLogin(:stoken => @stoken)
    end

  end
  
  def do_logout_msn
    WindowsLive.new.logout
  end
  
  def do_login_msn
    WindowsLive.new.login
  end
  
  def get_stoken
    WindowsLive.new.stoken
  end
  
end