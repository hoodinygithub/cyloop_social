module AuthenticatedSystem
  class NotAnUser < ActiveRecord::RecordNotFound; end
  class NotAnArtist < ActiveRecord::RecordNotFound; end

  extend ActiveSupport::Memoizable

  protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    !current_user.nil?
  end

  def current_user
    if defined?( @current_user )
      @current_user
    else
      @current_user = login_from_session || login_from_cookie
    end
  end

  alias current_account current_user

  def profile_owner?
    current_user == profile_account
  end
    
  def profile_account
    @profile_account ||= unless params[:slug].blank?
      account_slug = AccountSlug.find_by_slug( params[:slug] )
      account = nil
      account = account_slug.account if account_slug and account_slug.account and ( (account_slug.account.is_a?(User) and account_slug.account.part_of_network?) or account_slug.account.is_a?(Artist)) rescue nil
      raise ActiveRecord::RecordNotFound.new( "No record was found for slug #{params[:slug]} where network_id = 1" ) unless account
      account
    else
      current_user
    end
  end

  def profile_user
    if profile_account.kind_of?(User)
      profile_account
    else
      raise AuthenticatedSystem::NotAnUser, "Not an user"
    end
  end

  def profile_artist
    if profile_account.kind_of?(Artist)
      profile_account
    else
      raise AuthenticatedSystem::NotAnArtist, "Not an artist"
    end
  end

  def artist_song(song_id)
    Song.find(song_id)
  end

  # Store the given user id in the session.
  def current_user=(new_user)
    if new_user
      session[:user_id] = new_user.id
      @current_user = new_user
    end
  end

  # Check if the user is authorized
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the user
  # has the correct rights.
  #
  # Example:
  #
  #  # only allow nonbobs
  #  def authorized?
  #    current_user.login != "bob"
  #  end
  def authorized?
    logged_in?
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    authorized? || access_denied
  end

  def profile_ownership_required
    access_denied unless logged_in? && current_user == profile_user
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to new_session_path
      end
      format.xml { render :xml => Player::Error.new( :code => 403, :error => t('messenger_player.authentication_required') ) }
    end
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_account, :current_user, :logged_in?
    base.send :helper_method, :profile_account, :profile_user, :profile_artist
    base.send :helper_method, :artist_song
  end

  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    self.current_user = Account.find_by_id(session[:user_id]) if session[:user_id]
  end

  # Called from #current_user.  Now, attempt to login by basic authentication information.
  def login_from_basic_auth
    authenticate_with_http_basic do |username, password|
      self.current_user = Account.authenticate(username, password)
    end
  end

  # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
  def login_from_cookie
    user = cookies[:auth_token] && Account.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
      self.current_user = user
    end
  end
end
