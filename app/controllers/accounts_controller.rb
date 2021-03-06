class AccountsController < ApplicationController
  # caches_page :show
  before_filter :record_visit, :only => [:show]
  before_filter :assert_profile_is_available, :only => [ :show ]
  before_filter :auto_follow_profile, :only => [ :show ]

  current_tab :home

  def show
    return redirect_to( user_path( profile_account.slug ) ) if params[:slug] != profile_account.slug
    @dashboard_menu = :home
    @comments = (1..3).to_a

    @recent_reviews = []
    if profile_account.is_a? User
      @title = t 'meta.title.account_profile', :subject => profile_account.name
      @meta_keywords = t "meta.keywords.account_profile", :subject => profile_account.name
      @meta_description = t "meta.description.account_profile", :subject => profile_account.name
      @top_stations = profile_account.top_stations(6)
      @recent_reviews = profile_account.comments.latest(3)
      @latest_mixes = profile_account.playlists.latest(6)
    else
      @title = t 'meta.title.account_artist', :subject => profile_account.name
      @meta_keywords = profile_account.meta_keywords(current_site.bio_locale) + t("meta.keywords.account_artist", :subject => profile_account.name)
      @meta_description = profile_account.meta_description(current_site.bio_locale) || t("meta.description.account_artist", :subject => profile_account.name)
      @latest_mixes = profile_account.playlists(:order => 'playlists.updated_at DESC', :limit => 6)
    end

    @followers = profile_account.followers.all(:limit => 4)
    @latest_stations = profile_account.latest_stations(6)

    @msn_properties={}
    if profile_account.artist?
      @msn_properties[:page_name] = '\'Artist Profile\''
      @msn_properties[:prop3] = "\'Cyloop - Artist Profile \'"
      @msn_properties[:prop4] = "\'Artist Profile - #{profile_account.name}\'"
    else
      @msn_properties[:page_name] = '\'User Profile\''
      @msn_properties[:prop3] = "\'Cyloop - User Profile \'"
      @msn_properties[:prop4] = "\'User Profile - #{profile_account.name}\'"
    end

    respond_to do |format|
      format.html do
        render :template => "custom_profiles/#{profile_account.slug}" if profile_account.has_custom_profile?
      end
      format.rss do
        @activities = load_related_item_activity(
          profile_account.transformed_activity_feed(
            :kind => :listen,
            :group => :just_me
          )
        )
      end
    end
  end

private

  def assert_profile_is_available
    unless profile_account.visible?
      redirect_to(profile_not_available_path(params[:slug]))
    else
      true
    end
  end

  def record_visit
    begin
      if !logged_in? || (logged_in? && (current_user.slug != params[:slug]))
        tracker_payload = {
          :owner_id => profile_account.id,
          :visitor_id => (current_user.nil?)? nil : current_user.id,
          :site_id => current_site.id,
          :visitor_ip_address => remote_ip,
          :timestamp => Time.now.to_i
        }
        Resque.enqueue(ProfileVisitJob, tracker_payload)
      end
    rescue Exception => e
      Rails.logger.error("*** Could not record visit! #{e}\n#{e.backtrace.join("\n")}\n#{tracker_payload}") and return true
    end
    session[:origin_to] = request.request_uri if !logged_in?
  end

  def activity
    @activity ||= profile_account.parsed_activity_feed(false)#.lines(nil, false)
  end
  helper_method :activity

  def activity_for_page
    # @activity_for_page ||= activity[0..14] rescue []
    @activity_for_page ||= (activity.map{|a| a['activity']}[0..14])  rescue []
  end
  helper_method :activity_for_page

  def activity_for_js
    @activity_for_js ||= (activity[15..-1].collect{|a| "'" + a.to_json.gsub(/'/, "\\\\'") + "'"} rescue [])
  end
  helper_method :activity_for_js

  def type
    @type ||= (activity_for_page.first.feed_type.to_s rescue "listen")
  end
  helper_method :type

end

