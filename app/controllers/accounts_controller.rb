class AccountsController < ApplicationController
  # caches_page :show
  before_filter :record_visit, :only => [:show]
  before_filter :assert_profile_is_available, :only => [ :show ]
  before_filter :auto_follow_profile, :only => [ :show ]

  current_tab :home

  def show
    redirect_to( user_path( profile_account.slug ) ) && return if params[:slug] != profile_account.slug
    respond_to do |format|
      format.html do
        unless profile_account.has_custom_profile?
          render :template => "#{profile_account.class.model_name.plural}/show",
            :layout => profile_account.is_a?(Artist) ? 'artist_profile_logged_out' : 'dashboard'
        else
          if profile_account.has_chat?(current_site)
            @chat           = profile_account.next_chat
            @follow_profile = @chat.profile.id
            if @chat.promotion?
              @followers_limit = 88
            elsif @chat.live? || @chat.finished? || @chat.down? || @chat.ustream?
              @messages = @chat.messages.not_pending
              @message  = @chat.messages.build
            elsif @chat.post?
              @followers_limit = 216
            end
            render :template => "custom_profiles/chat_#{@chat.artist.slug}"
          else
            # VERY TEMPORARY CONDITIONAL!!! 
            # RADIO VIEW WITH PROFILE TRACKING FEATURES
            if profile_account.slug == "gcbaradio"
              @top_stations = current_site.summary_top_stations.limited_to(5)
              @source_ip = remote_ip
            end
            ####################################### 
            render :template => "custom_profiles/#{profile_account.slug}"            
          end
        end
      end
      format.rss do
        @activities = load_related_item_activity(
          profile_account.transformed_activity_feed(
            :kind => :listen,
            :group => :just_me))
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