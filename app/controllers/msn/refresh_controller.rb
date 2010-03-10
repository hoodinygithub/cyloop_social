class Msn::RefreshController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    if consent_token_cookie?
      refresh_cookies
      save_messenger_login
    end
    send_data "<html><head></head><body></body></html>", :type => "text/html", :disposition => 'inline'
  end

  def channel
    render :nothing => true
  end

  private

  def windows_live_login
    @messenger_live_login ||= MessengerLiveService.current_login( request.host )
  end

  def consent_token_cookie_name
    'msgr-consent-token'
  end

  def delegation_token_cookie_name
    'msgr-delegation-token'
  end

  def consent_token_cookie?
    !cookies[ consent_token_cookie_name ].blank?
  end

  def consent_token_cookie
    cookies[ consent_token_cookie_name ]
  end

  def delegation_token_cookie?
    !cookies[ delegation_token_cookie_name ].blank?
  end

  def refresh_cookies
    token = windows_live_login.process_consent_token(CGI.escape(consent_token_cookie));

    if (token.valid? && token.refresh) || !delegation_token_cookie?
      cookies[ delegation_token_cookie_name ] = token.delegationtoken
      cookies[ consent_token_cookie_name ] = CGI.unescape(token.token)
    else
      logger.debug "Consent Token is invalid."
      cookies.delete( delegation_token_cookie_name )
    end

  end

  def save_messenger_login

    session[:messenger_login] ||= {}
    options = {:ip_address => remote_ip,
          :consent_token => consent_token_cookie,
          :site_id => current_site.id}
    if logged_in?
      if session[:messenger_login].blank?
        messenger_login = MessengerLogin.create( options.merge( :account_id => current_user.id ) )
        session[:messenger_login] = { :id => messenger_login.id, :account_id => messenger_login.account_id }
      elsif session[:messenger_login][:account_id].blank?
        session[:messenger_login][:account_id] = current_user.id
        MessengerLogin.update_all( {:account_id => current_user.id}, :id => session[:messenger_login][:id] )
      end
    else
      if session[:messenger_login].blank?
        messenger_login = MessengerLogin.create( options )
        session[:messenger_login] = { :id => messenger_login.id }
      end
    end
  end

end