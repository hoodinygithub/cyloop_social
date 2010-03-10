class MessengerPlayer::PlayerController < ApplicationController

  include Application::MsnRedirection

  layout nil

  def stats
    render :xml => (current_site.site_statistic || current_site.build_site_statistic).to_xml(:skip_types => true)
  end

  def msn_sign_in
    session[:return_to] = '/messenger_player'
    msn_registration_redirect
  end

end