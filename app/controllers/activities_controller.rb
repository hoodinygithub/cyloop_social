class ActivitiesController < ApplicationController
  include ActionView::Helpers::DateHelper
  include ApplicationHelper

  before_filter :account, :except => [:latest_activities]
  before_filter :set_page, :except => [ :song ]
  before_filter :login_required, :only => [:update_status]

  ACTIVITIES_MAX = 10

  def index
    @dashboard_menu = :activity
    # @collection = profile_user.followees.paginate :page => params[:page], :per_page => 15
    # @collection << profile_user

    @collection = profile_user.activity_status.latest_with_followings(:limit => ACTIVITIES_MAX)
  end

  def get_activity
    @activities = load_related_item_activity( account.transformed_activity_feed(:kind => params[:type].to_sym,
                                                    :page => params[:page],
                                                    :before_timestamp => @before_timestamp,
                                                    :after_timestamp => @after_timestamp,
                                                    :group => activity_group) )
    expires_now
    respond_to do |format|
      format.js { render :partial => "modules/activity/#{@type}_activity", :collection => @activities, :layout => false }
      format.json do
        message = ""
        items   = @activities.size
        link    = "<a id=\"push_notification_refresh\" href=\"#{my_dashboard_path}\">#{t("activity.push_notification_refresh")}</a>"
        message = t("activity.push_notification", { :count => items, :link  => link }) if items > 0
        render :json => { :message => message, :items => items, :juq => @just_update_qty }
      end
    end
  end

  def song
    @song = Song.find(params[:song_id])
    @activity = record_listen_song_activity(@song).merge( 'record' => @song )
    render(
      :partial => "modules/activity/listen_activity",
      :collection => [ @activity ])
  end

  def update
    if request.post? and request.xhr?
      if params[:type] == 'status'
        item = {:message => params[:message]}
      end

      activity_status = Activity::Status.new(current_user)
      hash_added = activity_status.put(item)

      render :json => latest_activities
    end
  end

  def latest
    render :json => latest_activities
  end

  def latest_tweet
    @account = get_account_by_slug(params[:slug])
    render :json => @account.transformed_activity_feed.first
  end

  private
  def latest_activities
    @account = get_account_by_slug(params[:slug])

    if @account
      activities = @account.activity_status.latest(:limit => ACTIVITIES_MAX)
      activities.each { |a| a['str_timestamp'] = nice_elapsed_time(a['timestamp']) }
      activities
    end
  end

  def set_page
    params[:page]   ||= 1
    @type             = params[:type] || nil
    @show_user        = !@account.is_a?(Artist) && (params[:su]=="true")
    @show_follow      = (params[:sf]=="true")
    @before_timestamp = params[:bts]
    @after_timestamp  = params[:ats]
    @just_update_qty  = (params[:juq] == "true")
    return
  end

  def activity_group
    return :just_following if artist? || @type == "twitter"
    if params[:su] == 'true' && params[:sf] == 'true'
      :all
    elsif params[:su] == 'false' && params[:sf] == 'true'
      :just_following
    elsif params[:su] == 'true' && params[:sf] == 'false'
      :just_me
    end
  end

  def artist?
    @account && @account.artist?
  end

  def account
    @account = params[:user] ? Account.find(params[:user]) : nil
  end

  def get_account_by_slug(slug)
    if slug
      @account = AccountSlug.find_by_slug(slug).account
    elsif current_user
      @account = current_user
    end
  end

end

