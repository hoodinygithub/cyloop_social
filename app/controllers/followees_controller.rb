class FolloweesController < ApplicationController
  before_filter :profile_ownership_required, :only => [:update, :show, :destroy]

  layout "base"
  current_tab :community
  current_filter :following
  
  def index
    @followees = profile_user.followees.paginate :page => params[:page], :per_page => 15
  end

  def update
    @following = profile_user.follow(params[:id])

    unless request.xhr?
      if @following.new_record?
        flash[:error] = @following.errors.full_messages.join(', ')
      else
        flash[:success] = t(
          @following.approved? ? 'followings.create_success' : 'followings.awaiting_approval_from',
          :name => @following.followee.name)
      end

      redirect_back(my_following_index_path)
    else
      render :partial => 'artist_recommendations/artist_recommendation',
        :locals => {:following => @following, :artist_id => params[:id], :skip_auto_width => params[:skip_auto_width]}
    end

    deliver_friend_request_email if @following.approved? && profile_user.receives_following_notifications?
  end

  alias :show :update

  def destroy
    if following = profile_user.unfollow(params[:id])
      if request.xhr?
        render :partial => 'artist_recommendations/artist_recommendation', 
          :locals => {:following => false, :artist_id => params[:id], :skip_auto_width => params[:skip_auto_width]}
      else
        flash[:success] = t('followings.delete_success', :name => following.followee.name)
        redirect_back(my_following_index_path)
      end
    end
  end

  private

  def deliver_friend_request_email
    if followee = Account.find(params[:id])
      user_domain = followee.site.domain rescue "www.cyloop.com"
      user_link   = user_url(current_account, :host => user_domain)
      UserNotification.send_following_request(
        :followee_id => followee.id,
        :follower_id => current_account.id,
        :user_link => user_link,
        :my_community => my_follow_requests_url,
        :site_id => request.host)
    end
  end

end
