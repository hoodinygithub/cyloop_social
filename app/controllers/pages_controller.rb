class PagesController < ApplicationController
  caches_page :home, :if => Proc.new { |c| !c.request.format.js? }
  before_filter :authenticate, :only => [:x46b]
  layout "logged_out"

  def banner
    @options = params
    render :layout => false
  end

  def home
    respond_to do |format|
      format.html do        
        @latest_stations      = UserStation.latest_stations
        @recommended_stations = recommended_stations(6).map { |s| s.station.try(:playable) }.compact
        @top_abstract_stations = current_site.top_abstract_stations.limited_to(6)
        @top_user_stations = current_site.top_user_stations.limited_to(6)

        # if site_includes(:msnmx, :msnbr,:msnlatam,:msnlatino, :msnar)
        #   url_featured    = "/shared/feeds/current/#{site_code}_url_featured.xml"
        #   url_invasion    = "/shared/feeds/current/#{site_code}_url_invasion.xml"
        #   url_detour      = "/shared/feeds/current/#{site_code}_url_detour.xml"
        #   @feed_featured  = FeedManager.new(site_code, url_featured, true).get_drupal_feed(5)
        #   @feed_detour    = FeedManager.new(site_code, url_detour, true).get_drupal_feed(1).first
        #   @feed_invasion  = FeedManager.new(site_code, url_invasion, true).get_drupal_feed(1).first
        # end
        # 
        # if site_includes(:msnlatino, :msnbr)
        #   # url_promo         = "/shared/feeds/current/#{site_code}/#{site_code}_home_promo.xml"
        #   url_promo = "/shared/feeds/current/#{site_code}_url_promo.xml"
        #   @feed_promo       = FeedManager.new(site_code, url_promo, true).get_drupal_feed(1).first
        # end
        # 
        # if site_includes(:msnlatam, :msnar)
        #   url_promo         = "/shared/feeds/current/#{site_code}_url_promo.xml"
        #   @feed_promo       = FeedManager.new(site_code, url_promo, true).get_single_msn_feed(1).first
        # end
        # 
        # if site_includes(:msnmx)
        #   url_homepage = "/shared/feeds/current/#{site_code}_url_homepage.xml"
        #   fm = FeedManager.new(site_code, url_homepage, true)
        #   @feed_entrevistas = fm.get_mixed_msn_feed(1, 'HOT')
        #   @feed_noticias    = fm.get_mixed_msn_feed(4, 'Noticias')
        #   @feed_especiales  = fm.get_mixed_msn_feed(5, 'Especiales')
        #   @feed_conciertos  = fm.get_mixed_msn_feed(1, 'Flash - Reseñas').first
        #   @feed_promo       = fm.get_mixed_msn_feed(1, 'Flash - INFOPANE - NEW').first
        # end
        # 
        # if site_includes(:msnbr)
        #   url_noticias      = "/shared/feeds/current/#{site_code}_url_noticias.xml"
        #   url_albums        = "/shared/feeds/current/#{site_code}_url_albums.xml"
        #   #url_baladas       = "/shared/feeds/current/#{site_code}_url_baladas.xml"
        #   @feed_noticias    = FeedManager.new(site_code, url_noticias, true).get_single_msn_feed(4)
        #   @feed_albums      = FeedManager.new(site_code, url_albums, true).get_single_msn_feed(4)
        #   #@feed_baladas     = FeedManager.new(site_code, url_baladas, true).get_single_msn_cp_feed(4).rand
        # end
        # 
        # if site_includes(:msnlatino)
        #   url_noticias      = "/shared/feeds/current/#{site_code}_url_noticias.xml"
        #   @feed_noticias    = FeedManager.new(site_code, url_noticias, true).get_single_msn_feed(6)
        # end
        # 
        # if site_includes(:msncafr)
        #   # Live feeds
        #   url_detour   = "/shared/feeds/current/#{site_code}_url_detour.xml"
        #   url_invasion = "/shared/feeds/current/#{site_code}_url_invasion.xml"
        #   url_featured = "/shared/feeds/current/#{site_code}_url_featured.xml"
        #   url_news     = "/shared/feeds/current/#{site_code}_url_news.xml"
        #   url_promo    = "/shared/feeds/current/#{site_code}_url_promo.xml"
        #   url_photos   = "/shared/feeds/current/#{site_code}_url_photos.xml"
        #   url_reviews  = "/shared/feeds/current/#{site_code}_url_reviews.xml"
        #   url_videos   = "/shared/feeds/current/#{site_code}_url_videos.xml"
        # 
        #   @feed_detour    = drupal_feed(      url_detour,   1).first
        #   @feed_invasion  = drupal_feed(      url_invasion, 1).first
        #   @feed_featured  = featured_feed(    url_featured, 5)
        #   @feed_news      = single_msn_feed(  url_news,     6)
        #   @feed_promo     = drupal_feed(      url_promo,    1).first
        #   @feed_videos    = video_feed(       url_videos,   7)
        #   @feed_reviews   = reviews_msn_feed( url_reviews,  6)
        #   @feed_photos    = photos_msn_feed(  url_photos,  10)
        # 
        # end
        # 
        # if site_includes(:msncaen)
        #   # Live feeds
        #   url_detour   = "/shared/feeds/current/#{site_code}_url_detour.xml"
        #   url_invasion = "/shared/feeds/current/#{site_code}_url_invasion.xml"
        #   url_featured = "/shared/feeds/current/#{site_code}_url_featured.xml"
        #   url_news     = "/shared/feeds/current/#{site_code}_url_news.xml"
        #   url_promo    = "/shared/feeds/current/#{site_code}_url_promo.xml"
        #   url_photos   = "/shared/feeds/current/#{site_code}_url_photos.xml"
        #   url_reviews  = "/shared/feeds/current/#{site_code}_url_reviews.xml"
        #   url_videos   = "/shared/feeds/current/#{site_code}_url_videos.xml"
        #   url_blog     = "/shared/feeds/current/#{site_code}_url_blog.xml"
        # 
        #   @feed_news      = single_msn_feed(  url_news,     6)
        #   @feed_featured  = featured_feed(    url_featured, 5)
        #   @feed_detour    = drupal_feed(      url_detour,   1).first
        #   @feed_invasion  = drupal_feed(      url_invasion, 1).first
        #   @feed_promo     = drupal_feed(      url_promo,    1).first
        #   @feed_videos    = video_feed(       url_videos,   7)
        #   @feed_reviews   = reviews_msn_feed( url_reviews,  3)
        #   @feed_photos    = photos_msn_feed(  url_photos,  10)
        #   @feed_blog      = blog_feed(        url_blog,     1)
        # end

        @feed_featured ||= []
      end

      format.js do
        if logged_in?
          @artists = Artist.artists_by_recommended( rec_engine.get_recommended_artists(:number_of_records => 30), 5)
          render :template => 'pages/home.js.erb', :layout => false
        else
          head :ok
        end
      end

    end
  end

  def flash_callback
    respond_to do |format|
      format.js { render :template => 'pages/flash.js.erb', :layout => false }
    end
  end

  def about
    @title = t 'site.about_cyloop'
    render "pages/#{site_code}/about"
  end

  def faq
    @title = t 'site.faq'
    render "pages/#{site_code}/faq"
  end

  def feedback
    render :layout => false if request.xhr?
    if request.post?
      mailto = "#{request.host}@hoodiny.com"
      UserNotification.send_feedback_message( :site_id => current_site.code, :mailto => mailto, :address => params[:address], :country  => params[:country], :os => params[:os], :browser => params[:browser], :feedback => params[:feedback])
      redirect_to(root_url) unless request.xhr?
    end
  end

  def privacy_policy
    @title = t 'site.privacy_policy'
    render "pages/#{site_code}/privacy_policy"
  end

  def safety_tips
    @title = t 'site.safety_tips'
    render "pages/#{site_code}/safety_tips"
  end

  def terms_and_conditions
    @title = t 'site.terms_and_conditions'
    render "pages/#{site_code}/terms_and_conditions"
  end

  def block_alert
    render :layout => false
  end

  def profile_not_found
  end

  def profile_not_available
  end

  def sample_flag_desc
    render :layout => false
  end

  def contact_us
    if request.post?
      @contact_us = ContactUs.new
      @contact_us.attributes = params[:contact_us]
      if @contact_us.save
        data=params[:contact_us]
        profile = logged_in? ? "http://#{request.host}/#{current_user.slug}" : "User Not Logged"
        mailto = "#{request.host}@hoodiny.com"
        UserNotification.send_contact_us_message( :site_id => current_site.code, :mailto => mailto, :address => data[:address], :country  => data[:country], :os => data[:os], :browser => data[:browser], :feedback => data[:message], :category => data[:category], :host => request.host, :profile => profile)
        render 'pages/contact_us_confirmation' unless request.xhr?
      end

    else
       @contact_us = ContactUs.new(:address => logged_in? ? current_user.email : "User Not Logged",
                                :os      => os_type,
                                :browser => browser_type,
                                :country => current_country,
                                :message => t("contact_us.form.feedback_default"))
      if params[:only_form] == true
        render :layout => true, :params => { "only_form" => true }
      else
        render :layout => true, :params => { "only_form" => false }
      end

    end
  end

  def x46b
    @geo = { :remote_ip => remote_ip, :current_country => current_country }
    render "pages/x46b"
  end

  private
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "hoodiny" && password == "3057227000"
      end
    end

    def drupal_feed(url, size, full = true)
      FeedManager.new(site_code, url, full).get_drupal_feed( size )
    end

    def single_msn_feed( url, size, full = true )
      FeedManager.new(site_code, url, full).get_single_msn_feed(size)
    end

    def featured_feed( url, size, full = true )
      FeedManager.new(site_code, url, full).get_featured_feed(size)
    end

    def video_feed( url, size, full = true )
      FeedManager.new(site_code, url, full).get_video_feed(size)
    end

    def photos_msn_feed( url, size, full = true )
      FeedManager.new(site_code, url, full).get_photos_msn_feed(size)
    end

    def reviews_msn_feed(url, size, full = true)
      FeedManager.new(site_code, url, full).get_reviews_msn_feed(size)
    end

    def blog_feed( url, size, full = true )
      FeedManager.new(site_code, url, full).get_blog_feed(size)
    end

end

