class ActivitiesController < ApplicationController
  include ActionView::Helpers::DateHelper
  include ApplicationHelper

  before_filter :account
  before_filter :login_required, :only => [:update_status]

  def index
    @dashboard_menu = :activity
  end

  def get_activity
    # @activities = load_related_item_activity( account.transformed_activity_feed( activity_params ) )
    @activities = []
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
      item = {:message => params[:message]}
      activity_status = Activity::Status.new(current_user)
      hash_added = activity_status.put(item)
      hash_added['account'] = {'id' => hash_added['account_id']}
      render :partial => 'modules/activity/status_activity', :locals => {:status_activity => hash_added, :no_li => true}
    end
  end

  def latest_tweet
    @status = load_related_item_activity( account.transformed_activity_feed( activity_params.merge({:limit => 1, :type => :twitter}) ) ).first
    render :partial => 'shared/tweet_msg', :locals => {:slug => params[:slug]}
  end

  private

  def activity_params
    params[:page]   ||= 1
    @type             = params[:type] || nil
    @show_user        = (params[:su]=="true")
    @show_follow      = (params[:sf]=="true")
    @before_timestamp = params[:bts]
    @after_timestamp  = params[:ats]
    @limit            = params[:limit].to_i
    @just_update_qty  = (params[:juq] == "true")
    activity_parameters = {
      :kind             => @type && @type.to_sym,
      :page             => params[:page],
      :group            => activity_group,
      :before_timestamp => @before_timestamp,
      :after_timestamp  => @after_timestamp
    }
    activity_parameters[:limit] = @limit if @limit > 0
    activity_parameters
  end

  def activity_group
    # return :just_following if artist? || @type == "twitter"
    group = if params[:su] == 'true' && params[:sf] == 'true'
      :all
    elsif params[:su] == 'false' && params[:sf] == 'true'
      :just_following
    elsif params[:su] == 'true' && params[:sf] == 'false'
      :just_me
    end
    # raise "#{group}:::" + params.inspect
  end

  def artist?
    @account && @account.artist?
  end

  def account
    @account = params[:user] ? Account.find(params[:user]) : profile_account
    # TODO if @account is nil - redirect to login DZC 2010-05-17
  end
end

