class UsersController < ApplicationController

  include Application::MsnRedirection

  before_filter :login_required, :only => [:follow, :unfollow, :edit, :update, :destroy, :feedback, :confirm_cancellation, :remove_avatar]
  before_filter :set_return_to, :only => [:msn_login_redirect, :msn_registration_redirect]
  before_filter :set_dashboard_menu, :only => [:edit, :update]

  layout 'base'

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
    # # TODO: re-enable after fixing multiple cookie mongrel issue
    # cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
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
    user.valid?
    render :json => Array(user.errors.on(field)).to_json
  end

  def confirm_cancellation
  end

  def feedback
  end

  def destroy
    @user = current_user
    @delete_account_errors = {}
    delete_info_accepted = params[:delete_info_accepted]
    password_valid = cyloop_login? ? @user.authenticated?(params[:delete_password]) : true
    if delete_info_accepted and password_valid
      @user.cancel_account!
      cookies.delete(:auth_token) if cookies.include?(:auth_token)
      if wlid_web_login?
        redirect_to(msn_logout_url)
      else
        redirect_back_or_default('/')
      end
    else
      @delete_account_errors[:delete_password] = I18n.t('account_settings.password_required')
      render :action => :edit
    end
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
  
  private
  def set_dashboard_menu
    @dashboard_menu = :settings
  end
end
