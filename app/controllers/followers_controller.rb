class FollowersController < ApplicationController
  before_filter :msn_codes
  include ApplicationHelper

  current_tab :community
  current_filter :followers

  def index
    @title = t('meta.title.account_followers', :subject => profile_account.name) unless profile_account.nil?
    @meta_keywords = t("meta.keywords.account_followers", :subject => profile_account.name) unless profile_account.nil?
    @meta_description = t("meta.description.account_followers", :subject => profile_account.name) unless profile_account.nil?
    @dashboard_menu = :followers
    @sort_type = params.fetch(:sort_by, nil).to_sym rescue :latest

    begin
        sort_types  = { :latest => 'followings.approved_at DESC', :alphabetical => 'followings.follower_name'  }
        if profile_artist?
          @pending    = profile_artist.follow_requests
          @collection = profile_artist.followers.paginate :page => params[:page], :per_page => 12, :order => sort_types[@sort_type], :total_entries => profile_artist.follower_count
        else
          @pending    = profile_user.follow_requests
          @collection = profile_user.followers.paginate :page => params[:page], :per_page => 12, :order => sort_types[@sort_type], :total_entries => profile_user.follower_count
        end
        if request.xhr?
          render :partial => 'followings/ajax_list'
        end
    rescue NoMethodError
      redirect_to new_session_path
    end

    if profile_account.has_custom_profile? && FileTest.exists?("#{RAILS_ROOT}/app/views/custom_profiles/#{profile_account.slug}_followers.html.erb")
      render :template => "custom_profiles/#{profile_account.slug}_followers"
    end
  end

  private
  def msn_codes
    @msn_properties={}
    if profile_account.nil?
      # anon user trying to access my/followers
      redirect_to new_session_path
    elsif profile_account.artist?
      @msn_properties[:page_name] = '\'Artist Profile\''
      @msn_properties[:prop3] = "\'Cyloop - Artist Profile \'"
      @msn_properties[:prop4] = "\'Artist Profile - #{profile_account.name}\'"
    else
      @msn_properties[:page_name] = '\'User Profile\''
      @msn_properties[:prop3] = "\'Cyloop - User Profile \'"
      @msn_properties[:prop4] = "\'User Profile - #{profile_account.name}\'"
    end
  end
end

