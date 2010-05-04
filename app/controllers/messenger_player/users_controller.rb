
class MessengerPlayer::UsersController < MessengerPlayer::PlayerController
  before_filter :user_status
  caches_action :status, :cache_path => :users_cache_path.to_proc, :layout => false, :expires_delta => PLAYER_CACHE_EXPIRATION

  def status
    respond_to do |format|
      format.xml { render :show }
    end
  end
  
  def user_status
    if logged_in?
      'logged_in'
    elsif session[:msn_live_id]
      'msn_logged_in'
    else
      'anonymous'
    end
  end
  helper_method :user_status
  
  def users_cache_path
    path = "#{CURRENT_SITE.cache_key}/#{params[:controller]}/"
    unless user_status == 'anonymous'
      path << current_user.slug unless current_user.nil?
    else
      path << "anonymous"
    end
    path
  end

end
