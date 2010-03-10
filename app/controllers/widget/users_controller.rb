
class Widget::UsersController < Widget::WidgetController

  def status
    respond_to do |format|
      format.xml { render :show }
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
        format.xml  { render :xml => Player::Message.new( :message => t('messenger_player.registration.success') ) }
      end
    else
      respond_to do |format|
        format.xml  { render_xml_errors( @user.errors ) }
      end
    end
  end

end