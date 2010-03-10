require 'cgi'
class SessionsController < ApplicationController
  before_filter :set_return_to, :only => :new

  # GET /session/new
  def new
    if wlid_web_login?
      token = params[:stoken] || nil
      wll.setDebug(true) if Rails.env.development?

      if(token)
        msn_live_id = wll.processLogin(params) || nil

        if msn_live_id
          session[:msn_live_id] = msn_live_id
          account = Account.find_by_msn_live_id_and_deleted_at(msn_live_id, nil)
          if account
            do_login(account, 1, false)
          elsif session[:return_to] == '/messenger_player'
            redirect_to( session.delete(:return_to) )
          else
            redirect_to(new_user_path)
          end
        else
          flash[:error] = t("registration.msn_login_error")
          redirect_to "/"
        end
      else
        redirect_to msn_login_url
      end
    else # Cyloop Login
      render :new
    end
  end

  alias :show :new

  # POST /session
  def create
    # Cyloop Login
    unless wlid_web_login?
      account = Account.authenticate(params[:email], params[:password])
      do_login(account, params[:remember_me])
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete(:auth_token) if cookies.include?(:auth_token)
    reset_session

    if wlid_web_login?
      redirect_to(msn_logout_url)
    else
      redirect_back_or_default('/')
    end
  end

private
  # This is to get around a domain issue for WLID
  def corrected_registration_host
    session[:registered_from] || request.host
  end

  def do_login(account, remember_me, save_wlid=false)
    flash.discard(:error)    
    if account.kind_of?(Artist)
      flash[:error] = t("registration.artist_login_denied")
      redirect_to(new_user_path)
    elsif account
      self.current_user = account
      
      AccountLogin.create!( :account_id => account.id, :site_id => current_site.id )

      if remember_me == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end

      if save_wlid && wlid_web_login?
        account.update_attribute(:msn_live_id, session[:msn_live_id].to_s)
        session[:msn_live_id] = nil
      end
      session[:registered_from] = nil
      flash[:google_code] = 'loginOK'
      redirect_back_or_default(my_dashboard_path(:host => corrected_registration_host))
    elsif !wlid_web_login?
      flash[:error] = t("registration.login_failed")
      render :action => 'new'
      return false
    end
    flash.discard(:error)
    true
  end
end
