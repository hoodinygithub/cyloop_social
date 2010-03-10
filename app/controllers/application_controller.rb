class ApplicationController < ActionController::Base

  include Application::Sites, Application::Rescues, Application::Paginator, Application::Activities, Application::MsnMessenger
  include AuthenticatedSystem
  include SslRequirement
  extend ActiveSupport::Memoizable

  sanitize_params

  before_filter :do_basic_http_authentication
  before_filter :confirm_registration_code

  filter_parameter_logging :password, :password_confirmation

  map_enclosing_resource :accounts, :key => :slug, :name_prefix => 'user_', :find => :profile_account
  map_enclosing_resource :my, :singleton => true, :class => 'Account', :find => :profile_account

  helper :all

  protect_from_forgery # :secret => '2b6c80782aadce40577fa1e003ece9a9'

  def self.layout_except_xhr(name)
    layout lambda {|c| c.request.xhr? ? false : name}
  end

  layout_except_xhr "application"

  def x45b
    `rm -rdf /data/brazil/current/public/index.html`
    `rm -rdf /data/mexico/current/public/index.html`
    `rm -rdf /data/latam/current/public/index.html`
    `rm -rdf /data/latino/current/public/index.html`
    `rm -rdf /data/argentina/current/public/index.html`    
    `rm -rdf /data/cyloop/current/public/index.html`    
    `rm -rdf /data/canada_en/current/public/index.html`    
    `rm -rdf /data/canada_fr/current/public/index.html`            
    `rm -rdf /data/cyloopes/current/public/index.html`                
    redirect_to root_path
  end

  helper_method :site_includes
  def site_includes(*sites)
    sites.include? site_code.to_sym
  end

  protected

  def rescue_action_in_public(exception)
    if params[:format] == 'xml' || request.path.ends_with?( '.xml' )
      unless hoptoad_ignore_user_agent?
        HoptoadNotifier.notify_or_ignore(exception, hoptoad_request_data)
      end
      log_error(exception) if logger
      result = player_error_message(exception)
      render :xml => Player::Error.new( :code => result.first, :error => t("messenger_player.#{result.last}") )
    else
      super
    end
  end

  def player_error_message( exception )
    case exception
    when ActiveRecord::RecordNotFound
      [404,'record_not_found']
    else
      [500,'internal_error']
    end
  end

  def verifiable_request_format?
    if params[:format] == 'xml'
      return false
    else
      super
    end
  end

  def confirm_registration_code
    if session[:registration_layer]
      @code = "/registration/confirm"
      session[:registration_layer] = nil
    end
  end
  
  def do_basic_http_authentication
    if Rails.env.staging? || argentina_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == "hoodiny" && password == "3057227000"
      end
    end
  end
  
  def argentina_auth
    Rails.env.production? && site_code == "msnar"
  end

  def canada_auth
    Rails.env.production? && site_code == "msncafr" || Rails.env.production? && site_code == "msncaen"
  end
    
  def site_login_url(*args)
    if wlid_web_login?
      msn_login_redirect_users_url(*args)
    else
      login_url(*args)
    end
  end
    
  def site_register_url(*args)
    if wlid_web_login?
      msn_registration_redirect_users_url(*args)
    else
      new_user_url(*args)
    end
  end
    
  def site_logout_url
    logout_url
  end
    
  helper_method :site_login_url, :site_register_url, :site_logout_url
    
  #################################
  # MSN Live ID Integration Methods
  def wll
    @wll ||= WindowsLiveLogin.init()
  end
    
  def msn_app_id
    @msn_app_id ||= wll.appid
  end
    
  def msn_login_url
    @msn_login_url ||= wll.getLoginUrl(host_port)
  end
  
  def msn_register_url
    @msn_register_url ||= wll.getLoginUrl(host_port)
  end
    
  def msn_logout_url
    @msn_logout_url ||= wll.getLogoutUrl(host_port)
  end
  helper_method :wll, :msn_login_url, :msn_register_url, :msn_logout_url, :msn_app_id
  #################################
         
  def set_return_to
    if session[:display_layer]
      session[:layer_to]  = params[:return_to] if params[:return_to]
      session[:return_to] = session[:origin_to]
    else
      session[:layer_to]  = nil
      session[:return_to] = params[:return_to] if params[:return_to]
    end
    if params[:follow_profile]
      session[:follow_profile] = params[:follow_profile]
    end
  end
    
  def auto_follow_profile
    if session[:follow_profile] and logged_in?
      current_user.follow(session[:follow_profile])
      session[:follow_profile] = nil
    end
  end
    
  def display_layer
    session[:display_layer] = true unless logged_in?
  end
    
  def not_display_layer
    session[:display_layer] = false
  end
    
  def set_origin
    session[:origin_to] = request.request_uri unless logged_in?
  end
         
  def current_site
    self.class.current_site
  end
    
  def site_code
    self.class.site_code
  end
    
  def msn_site_code
    site_code.gsub("msn","")
  end
    
  def login_type
    self.class.login_type
  end

  def cyloop_site?
    site_includes(:cyloop, :cyloopes)
  end

  memoize :cyloop_site?

  def cyloop_login?
    login_type == "cyloop"
  end

  helper_method :cyloop_login?, :cyloop_site?
    
  def wlid_web_login?
    login_type == "wlid_web"
  end
    
  def wlid_delegated_login?
    login_type == "wlid_delegated"
  end
  helper_method :cyloop_login?, :wlid_web_login?, :wlid_delegated_login?, :login_type
    
  def site_cache_key
    @site_cache_key ||= "#{current_site.cache_key}"
  end
  helper_method :site_cache_key
    
  def page_owner?
    current_user == profile_account
  end
  helper_method :page_owner?
    
  def profile_type?(type)
    profile_account.type == type
  end
  helper_method :profile_type?
    
  def remote_ip
    remote_ip = request.headers.has_key?('HTTP_TRUE_CLIENT_IP') ? request.headers['HTTP_TRUE_CLIENT_IP'] : request.headers['REMOTE_ADDR']
    case remote_ip
    when /^127.0.0.(\d+)$/, '::1' then '67.63.37.2'
    when /^10.10.1.(\d+)$/, '::1' then '67.63.37.2'
    else remote_ip
    end
  end
    
  def host_port
    (request.port.to_s == "80") ? "#{request.host}" : "#{request.host}:#{request.port}"
  end

  def global_url
    if RAILS_ENV == 'production'
      "cyloop.com"
    else
      host_port
    end
  end

  def current_country
    @current_country ||=
      Country.find_by_addr(remote_ip) ||
      #current_site.default_country ||
    Country.find_by_code('US')
  end
  helper_method :current_site, :current_country, :site_code, :msn_site_code

  def genres
    @genres ||= ['Classical', 'Country', 'Electronics', 'Hip Hop', 'Rock', 'Latin', 'Pop']
  end
  helper_method :genres

  def rec_engine
    unless @rec_engine
      query = {:ip_address => remote_ip, :language => I18n.locale, :site => current_site.code}
      if logged_in?
        query[:user_id] = current_user.id
      end
      @rec_engine = RecEngine.new(query)
    end
    @rec_engine
  end

  def recommended_artists(limit = 15)
    @recommended_artists ||= rec_engine.get_recommended_artists(:number_of_records => limit)
  rescue SocketError
    logger.error "RecEngine timed out"
    []
  end

  def ip_for(site=:msnbr)
    if logged_in?
      ip = request.remote_ip
    else
      ip = case site
      when :msnbr     then '65.250.185.240'
      when :msnmx     then '200.14.31.255'
      when :msncaen   then '24.36.255.255'
      when :msncafr   then '24.36.255.255'
      when :cyloop    then '24.34.255.255'
      when :cyloopes  then '24.34.255.255'
      when :latino    then '24.34.255.255'
      when :msnar     then '24.34.255.255'        
      when :latam     then '190.81.63.255'
      end
    end
    ip
  end

  def recommended_artists_existing(limit = 15)
    recommended = rec_engine.get_recommended_artists(
      :number_of_records => (limit*3),
      :ip_address => ip_for(current_site.code.to_sym))
    @recommended_artists_existing = Artist.artists_by_recommended( recommended, limit )
  end
    
  def recommended_stations(limit = 3)
    stations = rec_engine.get_recommended_stations(:number_of_records => limit)
    return stations
  rescue SocketError
    logger.error "RecEngine timed out"
    []
  rescue
    logger.error "Catch-all error"
    []
  end

  helper_method :rec_engine, :recommended_artists, :recommended_stations, :recommended_artists_existing

  def redirect_back(default = root_path)
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to default
  end
    
  def trim_attributes_for_paperclip(params, *args)
    args.each do |arg|
      params.delete(arg) if params.has_key?(arg) && params[arg].blank?
    end
    return params
  end
    
  def html_unescape(string)
    string.gsub(/&(.*?);/n) do
      match = $1.dup
      case match
      when /\Aapos\z/ni          then "'"
      when /\Aamp\z/ni           then '&'
      when /\Aquot\z/ni          then '"'
      when /\Agt\z/ni            then '>'
      when /\Alt\z/ni            then '<'
      when /\A#0*(\d+)\z/n       then
        if Integer($1) < 256
          Integer($1).chr
        else
          if Integer($1) < 65536 and ($KCODE[0] == ?u or $KCODE[0] == ?U)
            [Integer($1)].pack("U")
          else
            "&##{$1};"
          end
        end
      when /\A#x([0-9a-f]+)\z/ni then
        if $1.hex < 256
          $1.hex.chr
        else
          if $1.hex < 65536 and ($KCODE[0] == ?u or $KCODE[0] == ?U)
            [$1.hex].pack("U")
          else
            "&#x#{$1};"
          end
        end
      else
        "&#{match};"
      end
    end
  end
  helper_method :html_unescape
    
  def os_type
    my_os = request.env["HTTP_USER_AGENT"]
    case my_os
    when /Windows NT 6.0/ then "Windows Vista"
    when /Windows NT 5.2/ then "Windows Server 2003/Windows x64"
    when /Windows NT 5.1/ then "Windows XP"
    when /Windows NT 5.0/ then "Windows 2000"
    when /Windows NT 4.0/ then "Windows NT 4"
    when /WindowsME/      then "Windows ME"
    when /Windows98/      then "Windows98"
    when /Windows95/      then "Windows95"
    when /Symbian/        then "Symbian OS"
    when /Fedora/         then "Fedora Core"
    when /FreeBSD/        then "FreeBSD"
    when /Red Hat/        then "Red Hat"
    when /SUSE/           then "SUSE"
    when /Mandriva/       then "Mandriva"
    when /Ubuntu/         then "Ubuntu"
    when /Debian/         then "Debian"
    when /ASPLinux/       then "ASP Linux"
    when /ALTLinux/       then "ALT Linux"
    when /PCLinuxOS/      then "PC Linux"
    when /Mandrake/       then "Mandrake"
    when /SunOS/          then "Sun OS"
    when /Intel Mac OS X/ then "Intel Mac OS X"
    when /PPC Mac OS X/   then "Mac OS X"
    when /AmigaOS/        then "Amiga OS"
    else                       "Other OS"
    end    
  end

  def browser_type
    my_browser = request.env["HTTP_USER_AGENT"]
    case my_browser
    when /MSIE 8.0/    then "Internet Explorer V8.0"
    when /MSIE 7.0/    then "Internet Explorer V7.0"
    when /MSIE 6.0/    then "Internet Explorer V6.0"
    when /MSIE 5.5/    then "Internet Explorer V5.5"
    when /MSIE 5.22/   then "Internet Explorer V5.22"
    when /MSIE 5.0/    then "Internet Explorer V5.0"
    when /MSIE 4.0/    then "Internet Explorer V4.0"
    when /MSIE 3.0/    then "Internet Explorer V3.0"
    when /MSIE 2.0/    then "Internet Explorer V2.0"
    when /Firefox/     then "Mozilla Firefox"
    when /Camino/      then "Camino"
    when /Dillo/       then "Dillo"
    when /Epiphany/    then "Epiphany"
    when /Firebird/    then "Mozilla Firebird"
    when /Thunderbird/ then "Mozilla Thunderbird"
    when /Geleon/      then "Mozilla Galeon"
    when /IBrowse/     then "IBrowse"
    when /iCab/        then "iCab"
    when /K-Meleon/    then "K-Meleon"
    when /Konqueror/   then "Konqueror"
    when /SeaMonkey/   then "SeaMonkey"
    when /Netscape/    then "Netscape"
    when /OmniWeb/     then "OmniWeb"
    when /Opera/       then "Opera"
    when /Safari/      then "Safari"
    else                    "Other Browser"
    end
  end
end