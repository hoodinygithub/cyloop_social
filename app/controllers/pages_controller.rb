class PagesController < ApplicationController
  caches_page :home
  caches_page :about, :faq, :feedback, :privacy_policy, :safety_tips, :terms_and_conditions
  
  before_filter :authenticate, :only => [:x46b]
  layout "logged_out"

  def home
    respond_to do |format|
      format.html do
        @latest_stations       = current_site.user_stations.latest

        @top_abstract_stations = current_site.top_abstract_stations(6)
        #@top_user_stations     = current_site.top_user_stations(15).uniq_by(&:abstract_station_id)[0..5] rescue []
        @top_user_stations     = current_site.top_user_stations


        @feed_featured ||= []
        url_featured = ""
        if !site_includes(:cyloop, :cyloopes)
          url_featured    = "/shared/feeds/current/#{site_code}_url_featured_cysocial.xml"
        elsif site_includes(:cyloop)
          url_featured    = "/shared/feeds/current/cyloop_url_featured_cysocial.xml"
        elsif site_includes(:cyloopes)
          url_featured    = "/shared/feeds/current/cyloopes_url_featured_cysocial.xml"
        end
        url_featured    = "/shared/feeds/current/tvn_url_featured_cysocial.xml" if site_includes(:tvn)
        @feed_featured  = drupal_feed(url_featured, 5)
        
        @feed_news = ""
        @feed_promo = ""
        if site_includes(:msnlatino)
          url_news   = "/shared/feeds/current/msnlatino_url_news_cysocial.xml"
          @feed_news = single_msn_feed(url_news, 8)
                    
          url_promo   = "/shared/feeds/current/msnlatino_url_promo_cysocial.xml"
          @feed_promo = drupal_feed(url_promo, 1).first
        end
        
        @msn_properties={}
        @msn_properties[:page_name] = '\'MSN Latino Música\''
        @msn_properties[:prop3] = '\'Cyloop - Inicio\''
        @msn_properties[:prop4] = "\'Homepage\'"
      end

      format.js do
        @recommended_stations ||= transformed_recommended_stations(6, 40)
        render :template => 'pages/home.js.erb', :layout => false
      end

    end
  end
  
  def home_recommended_stations
    @recommended_stations = transformed_recommended_stations(6, 12)
    render :partial => 'shared/abstract_station', :collection => @recommended_stations, :locals => { :columns => 6 }
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

  def error_pages
    @search_types ||= [:artists, :stations, :users]    
    render '/error_pages/errors', :layout => "logged_out"
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

