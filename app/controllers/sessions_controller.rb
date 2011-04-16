class SessionsController < ApplicationController
  before_filter :set_return_to, :only => :new
  before_filter :go_home_if_logged_in, :except => :destroy

  # GET /session/new
  def new
    #if wlid_web_login?
    #  token = params[:stoken] || nil
    #  wll.setDebug(true) if Rails.env.development?

    #  if(token)
    #    msn_live_id = wll.processLogin(params) || nil

    #    if msn_live_id
    #      session[:msn_live_id] = msn_live_id
    #      account = Account.find_by_msn_live_id_and_deleted_at(msn_live_id, nil)
    #      if account
    #        do_login(account, 1, false)
    #      elsif session[:return_to] == '/messenger_player'
    #        redirect_to( session.delete(:return_to) )
    #      else
    #        redirect_to(new_user_path)
    #      end
    #    else
    #      flash[:error] = t("registration.msn_login_error")
    #      redirect_to "/"
    #    end
    #  else
    #    redirect_to msn_login_url
    #  end
    if params[:wrap_verification_code]
      # Windows Connect through popup login

      # The return URL in the app settings.  Should match the Enzo login button URL.
      callback_url = RAILS_ENV =~ /staging/ ? 'http://hoodiny.com/session/new' : 'http://login.cyloop.com:8081/session/new'
      user = WindowsConnect.parse_verification_code(params[:wrap_verification_code], callback_url, cookies, params[:wrap_client_state], params[:exp])
      handle_windows_sso_user(user)

      # Close the Windows Connect login popup.
      render 'shared/_close_popup.html.erb', :layout => false 
    elsif cookies[:wl_internalState]
      # Clear the Windows Connect session on login page load
      # This might cause trouble in the future if we decide to use WindowsConnect widgets on the page.
      # Right now, this is the only way to cancel a bad, currently logged-in WC session.
      #Rails.logger.info cookies
      #Rails.logger.info session
      #
      #TODO: application level filter?
      WindowsConnect.clear_cookie_session(cookies)
    else
      # Cyloop Login
      # render :new
    end
  end

  alias :show :new

  # POST /session
  def create
    # Cyloop Login
    unless wlid_web_login?
      account = User.authenticate(params[:email], params[:password], current_site)
      do_login(account, params[:remember_me])
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete(:auth_token) if cookies.include?(:auth_token)
    reset_session

    #if wlid_web_login?
    #  redirect_to(msn_logout_url)
    #else
    redirect_back_or_default('/')
    #end
  end

private
  # This is to get around a domain issue for WLID
  def corrected_registration_host
    session[:registered_from] || request.host
  end

  #
  # Login
  # 
  def do_login(account, remember_me, p_render=true)
    if account.nil?
      flash[:error] = t("registration.login_failed")
      redirect_to login_path
      false
    elsif account.kind_of?(Artist)
      flash[:error] = t("registration.artist_login_denied")
      redirect_to(new_user_path)
      false
    elsif account.part_of_network?
      self.current_user = account
      AccountLogin.create!( :account_id => account.id, :site_id => current_site.id )

      if remember_me == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end

      # Attach current WindowsConnect session to upcoming user session.
      sso_windows_id = (session[:sso_user] and session[:sso_user]['sso_windows']) ? session[:sso_user]['sso_windows'] : nil
      account.update_attribute(:sso_windows, sso_windows_id) if sso_windows_id

      session[:sso_user] = nil
      session[:sso_type] = nil

      session[:registered_from] = nil
      flash[:google_code] = 'loginOK'
      redirect_back_or_default(my_dashboard_path(:host => corrected_registration_host)) if p_render
      true
    else
      # TODO: cross network login
      flash[:error] = t("registration.login_failed")
      render :new if p_render
      false
    end
  end

  # 
  # Windows SSO login
  #
  def handle_windows_sso_user(p_user)
    return nil if p_user.nil?

    # AccountUni search
    ## db enforces uniqueness of sso_windows, deleted_at, so pick first
    same_sso_user = User.find_with_exclusive_scope(:first, :conditions => { :sso_windows => p_user.sso_windows, :deleted_at => nil })
    unless same_sso_user.nil?
      do_login(same_sso_user, nil, false)
      return
    end

    # AccountUni search
    ## db doesn't enforce uniqueness of msn_live_id, deleted_at, so just pick the most recent one
    ## This case isn't going to work because the appid doesn't match.
    same_wlid_user = User.find_with_exclusive_scope(:first, :conditions => { :msn_live_id => p_user.msn_live_id, :deleted_at => nil }, :order => "created_at DESC")    
    unless same_wlid_user.nil?
      # Upgrade LiveID user to ConnectID user
      same_wlid_user.update_attribute(:sso_windows, p_user.sso_windows)
      do_login(same_wlid_user, nil, false)
      return
    end

    # AccountUni search
    ## Rails validation enforces global email uniqueness
    same_email_user = User.find_by_email_with_exclusive_scope(p_user.email, :first, :select => "slug, gender, encrypted_gender, email, encrypted_email, name, encrypted_name, born_on, encrypted_born_on_string, network_id")
    unless same_email_user.nil?
      # logger.info "Found same email user."
      same_email_user.sso_windows = p_user.sso_windows
      unless same_email_user.part_of_network?
        same_email_user.transfer_encrypted_demographics
      end
      session[:sso_user] = same_email_user
      session[:sso_type] = "Windows"
      return
    end

    session[:sso_user] = p_user
    session[:sso_type] = 'Windows'
  end

  # Skip login page if logged in.
  def go_home_if_logged_in
    if logged_in?
      redirect_to(my_dashboard_path)
      false
    end
  end
  
end

