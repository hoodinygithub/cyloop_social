
class MessengerPlayer::TranslationsController < MessengerPlayer::PlayerController
  caches_action :index, :cache_path => :translations_cache_path.to_proc, :layout => false, :expires_delta => PLAYER_CACHE_EXPIRATION
  
  def index
    respond_to do |format|
      I18n.locale = params.fetch(:locale, I18n.locale)
      format.xml
    end
  end
  
  def translations_cache_path
    "#{CURRENT_SITE.cache_key}/#{params[:controller]}"
  end  

end
