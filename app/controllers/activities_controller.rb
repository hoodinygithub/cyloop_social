class ActivitiesController < ApplicationController
  include ActionView::Helpers::DateHelper
  include ApplicationHelper

  before_filter :account, :except => [:latest_activities]
  before_filter :set_page, :except => [ :song ]
  before_filter :login_required, :only => [:update_status]
  before_filter :load_user_activities, :only => [:index, :latest]

  ACTIVITIES_MAX           = 15
  ACTIVITIES_DASHBOARD_MAX = 5
  ACTIVITY_SHOW_MORE_SIZE  = 5

  def index
    @collection = @collection[0..ACTIVITIES_MAX-1]
    @dashboard_menu = :activity
    if request.xhr?
      render :partial => 'shared/collection_to_li'
    end
  end

  def more
    @collection = @collection[0..ACTIVITIES_DASHBOARD_MAX-1]
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

      load_user_activities
      latest
    end
  end

  def latest
    if params[:after]
      last_element_index = @collection.collect {|a| a['timestamp']}.index(params[:after])
      @collection        = @collection.slice(0, last_element_index + ACTIVITY_SHOW_MORE_SIZE + 1)
    else
      @collection = @collection[0..ACTIVITIES_DASHBOARD_MAX-1]
    end

    if params[:public]
      render :partial => 'shared/public_user_activity_content'
    else
      render :partial => 'shared/collection_to_li'
    end
  end

  def latest_tweet
    account = get_account_by_slug(params[:slug])
    @collection = account.transformed_activity_feed.first
    render :partial => 'shared/tweet_msg', :locals => {:slug => params[:slug]}
  end

  private
  def load_user_activities
    @has_more = true

    if profile_account
      @account = profile_account
    else
      @account = get_account_by_slug(params[:slug])
    end

    group = :all
    
    if params[:profile_owner] and params[:profile_owner].to_i == 0
      group = :just_me
    end
    
    if params[:filter_by]
      @filter_type = params[:filter_by]
      group        = :all            if @filter_type == 'all'
      group        = :just_me        if @filter_type == 'me'
      group        = :just_following if @filter_type == 'following'
    end
    
    collection      = @account.activity_feed(:group => group)
    @collection     = collection.sort_by {|a| a['timestamp'].to_i}.reverse
    
    if collection.size - ACTIVITIES_MAX > 0
      @has_more = true
    end

    @collection.each do |a|
      a['account']  =  Account.find(a['account_id'])

      if a['type'] == 'station'
        station      = Station.find(a['item_id']).playable
        a['station'] = station
        a['artist']  = station.artist
      end
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

