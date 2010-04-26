class FolloweesController < ApplicationController
  before_filter :profile_ownership_required, :only => [:update, :show, :destroy]

  current_tab :community
  current_filter :following
  
  def index
    @dashboard_menu = :following
    @sort_type = params.fetch(:sort_by, nil).to_sym rescue :latest

    begin
        sort_types = { :latest => 'followings.approved_at DESC', :alphabetical => 'accounts.name'  }
        @collection = profile_user.followees.paginate :page => params[:page], :per_page => 12, :order => sort_types[@sort_type]
    rescue NoMethodError
      redirect_to new_session_path
    end
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

    if @following.approved? && profile_user.receives_following_notifications?
      deliver_friend_request_email(@following)
    end
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
end
