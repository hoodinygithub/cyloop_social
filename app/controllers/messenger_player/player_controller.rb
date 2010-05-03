class MessengerPlayer::PlayerController < ApplicationController
  PLAYER_CACHE_EXPIRATION = 10.minutes
  
  caches_action :stats, :cache_path => :player_cache_path.to_proc, :layout => false, :expires_delta => PLAYER_CACHE_EXPIRATION
  
  include Application::MsnRedirection

  layout nil

  def stats
    render :xml => (current_site.site_statistic || current_site.build_site_statistic).to_xml(:skip_types => true)
  end

  def msn_sign_in
    session[:return_to] = '/messenger_player'
    msn_registration_redirect
  end
  
  def player_cache_path
    "#{CURRENT_SITE.cache_key}/#{params[:controller]}/stats"
  end
end