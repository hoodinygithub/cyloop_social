
module Application::MsnRedirection

  def msn_login_redirect
    redirect_to_full_url "http://login.cyloop.com:8081/msn_login?from=#{request.host}&msn_login_link=#{CGI.escape(msn_login_url)}", 302
  end

  def msn_registration_redirect
    redirect_to_full_url "http://login.cyloop.com:8081/msn_signup?from=#{request.host}&msn_registration_link=#{CGI.escape(msn_register_url)}", 302
  end

end