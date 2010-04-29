class UsersController < ApplicationController

  include Application::MsnRedirection

  before_filter :find_account_by_slug, :only => [:follow, :unfollow, :block, :unblock, :approve, :deny]
  before_filter :xhr_login_required, :only => [:follow]
  before_filter :login_required, :only => [:edit, :update, :destroy, :confirm_cancellation, :remove_avatar]
  before_filter :set_return_to, :only => [:msn_login_redirect, :msn_registration_redirect]
  before_filter :set_dashboard_menu, :only => [:edit, :update]

  # TODO: Pending installation of Certificate on Server
  #ssl_required :create, :new if RAILS_ENV == "production"
  current_tab :settings
  disable_sanitize_params
  strip_tags_from_params

  # GET /users/id
  def show
    redirect_to :action => :edit
  end

  # GET /users/id/edit
  def edit
    @user = current_user
  end

  # POST /users/id
  def update
    @user                    = current_user
    params[:user]            = trim_attributes_for_paperclip(params[:user], :avatar)
    @user.attributes         = params[:user]
    twitter_username_changed = @user.twitter_username_changed?
    if @user.save
      Resque.enqueue(TwitterJob, {:user_id => @user.id, :twitter_username => @user.twitter_username}) if twitter_username_changed
      flash[:success] = t('settings.saved')
      redirect_to my_dashboard_path
    else
      flash[:error] = t('settings.not_saved')
      render :action => :edit
    end
  end

  # GET /users/new
  # This is a temp fix for the flash player to handle registration.
  # Temp as of 8/17/09
  def new
    if cyloop_login? || session[:msn_live_id]
      @user = User.new
    else
      msn_registration_redirect
    end
  end

  # POST /users
  def create
    params[:user] = trim_attributes_for_paperclip(params[:user], :avatar)
    @user = User.new(params[:user])
    @user.entry_point = current_site
    @user.ip_address  = remote_ip
    @user.msn_live_id = session[:msn_live_id] if wlid_web_login?

    if @user.save
      cookies.delete(:auth_token) if cookies.include?(:auth_token)
      session[:msn_live_id] = nil if wlid_web_login?
      session[:registration_layer] = true     
      self.current_user = @user

      subject = t("registration.email.subject")
      UserNotification.send_registration( :user_id => @user.id, :subject => subject, :host_url => request.host, :site_id => current_site.code, :global_url => global_url, :locale => current_site.default_locale)

      # Background validation to twitter username
      Resque.enqueue(TwitterJob, {
        :user_id => @user.id, :twitter_username => @user.twitter_username
      }) if @user.twitter_username_changed?

      respond_to do |format|
        format.html { redirect_back_or_default(my_dashboard_path) }
        format.xml  { render :xml => Player::Message.new( :message => t('messenger_player.registration.success') ) }
      end
    else
      respond_to do |format|
        format.html { render :action => :new }
        format.xml  { render_xml_errors( @user.errors ) }
      end
    end
  end

  def forgot
    if request.post?
      user = User.find_by_email( params[:user][:email] )
      if user && user.msn_live_id && wlid_web_login?
        flash.now[:error] = t('reset.msn_account')
      elsif user
        UserNotification.send_reset_notification(
          :user_id => user.id,
          :password => user.reset_password,
          :site_id => request.host)
        flash[:success] = t('forgot.reset_message_sent')

        redirect_back_or_default("/")
      else
        flash.now[:error] = t("reset.insert_valid_email")
      end
    elsif !request.referer.blank? && request.referer !=~ /forgot|session/
      session[:return_to] = request.referer
    end
  end

  # GET /users/errors_on?field=slug&value=foo
  def errors_on
    field = params[:field].to_sym
    user  = User.new(field => params[:value])

    field_name  = params[:field] == 'slug' ? t("registration.your_profile_name") : t("registration.email_address")
    exclamation = params[:field] == 'slug' ? t('registration.slug_available_exclamation') : t('registration.is_available_exclamation')

    user.valid?
    if user.errors.on(field)
      render :json => [user.errors.on(field), 'error'].to_json
    else
      message = "#{field_name} #{exclamation}"
      render :json => [message, 'info'].to_json
    end
  end

  def confirm_cancellation
  end

  def feedback
    feedback = params[:feedback]
    if feedback && !feedback.empty?
      options = {
        :site_id      => current_site.code,
        :mailto       => "#{request.host}@hoodiny.com",
        :address      => params[:address],
        :country      => params[:country],
        :os           => params[:os],
        :browser      => params[:browser],
        :feedback     => params[:feedback],
        :cancellation => true
      }
      puts options
      UserNotification.send_feedback_message( options )
    end
    redirect_to params[:redirect_to] if params[:redirect_to]
  end

  def destroy
    user = current_user
    result = { :user_id => user.id }
    password_valid = cyloop_login? ? user.authenticated?(params[:delete_password]) : true
    if params[:delete_info_accepted] and password_valid
      options = {
        :user_id => user.id,
        :site_id => request.host
      }
      if current_user.cancel_account!
        #UserNotification.send_cancellation(options)
        cookies.delete(:auth_token) if cookies.include?(:auth_token)
        result[:success] = true
        if wlid_web_login?
          result[:redirect_to] = msn_logout_url
          result[:email] = user.email
        else
          result[:redirect_to] = root_url
        end
      end
    else
      result[:errors] = { :delete_password => I18n.t('account_settings.password_required') }
    end
    render :json => result.to_json
  end

  def remove_avatar
    @user = current_user
    if @user.remove_avatar
      flash[:success] = t('settings.saved')
      redirect_to :action => :edit
    else
      flash[:error] = t('settings.not_saved')
      render :action => :edit
    end
  end
  
  def follow
    current_user.follow(@account) unless current_user.follows?(@account)
    if @account.private_profile?
      follow_status = {:status => 'pending'}
    else
      follow_status = {:status => 'following'}  
    end
    deliver_friend_request_email(@account) if @account.receives_following_notifications?
    render :json => follow_status
  end
  
  def unfollow
    if current_user.follows?(@account)
      current_user.unfollow(@account) 
    elsif @account.follow_requests.collect(&:follower_id).include? current_user.id
      @account.follow_requests.find_by_follower_id(current_user.id).destroy
    end
    render :layout => false, :text => ''
  end
  
  def approve
    f = current_user.follow_requests.select {|f| f.follower_id == @account.id}.first

    if f and f.approve!
      render :layout => false, :partial => 'shared/network_collection_info', :locals => { :item => f.follower }
    else
      render :text => ""
    end
  end
  
  def deny
    f = current_user.follow_requests.select {|f| f.follower_id == @account.id}.first
    f.destroy if f
    render :nothing => true
  end
  
  def block
    current_user.block(@account)
    render :nothing => true
  end
  
  def unblock
    current_user.unblock(@account) if current_user.blocks?(@account)
    render :nothing => true
  end
  
  
  private
  def xhr_login_required
    unless current_user
      return render(:json => {:status => 'redirect', :url => login_path})
    end
  end
  
  def find_account_by_slug
    account_slug = AccountSlug.find_by_slug(params[:user_slug])
    @account = account_slug.account
  end
  
  def set_dashboard_menu
    @dashboard_menu = :settings
  end
end
