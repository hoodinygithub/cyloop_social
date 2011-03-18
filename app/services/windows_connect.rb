%w(rest_client cgi json).each { |lib| require lib }

class WindowsConnect
  settings = YAML.load_file("#{RAILS_ROOT}/config/windows_connect.yml")[RAILS_ENV]

  CLIENT_ID = settings['client_id']
  SECRET = settings['secret']

  TOKEN_URL = "https://consent.live.com/AccessToken.aspx"
  TOKEN_PARAMS = { :wrap_client_id => CLIENT_ID, :wrap_client_secret => SECRET }

  API_PROFILES_URL = "https://apis.live.net/V4.1/cid-%s/Profiles"
  API_PROFILES_URL_HEADERS = {"Accept" => "application/json"}

  #
  # Parse Windows Connect verification into a User
  #
  def self.parse_verification_code(p_wrap_verification_code, p_callback, p_cookies, p_wrap_client_state, p_exp)
    access_token_params = get_access_token(p_wrap_verification_code, p_callback, nil)

    if access_token_params.nil?
      clear_cookie_session(p_cookies)
      return nil
    end

    access_token = access_token_params[:access_token]
    cid = access_token_params[:uid]
    expires = access_token_params[:expires]

    # M$ docs are unclear about cookies

    # http://msdn.microsoft.com/en-us/library/gg251990.aspx
    p_cookies["c_clientId"] = CLIENT_ID
    p_cookies["c_clientState"] = p_wrap_client_state
    p_cookies["c_scope"] = p_exp
    p_cookies["c_accessToken"] = access_token
    p_cookies["c_expiry"] = expires
    p_cookies["c_uid"] = cid
    p_cookies["lca"] = "done"

    # http://msdn.microsoft.com/en-us/library/ff752581.aspx
    p_cookies["wl_clientID"] = CLIENT_ID
    p_cookies["wl_clientState"] = p_wrap_client_state
    p_cookies["wl_scope"] = p_exp
    p_cookies["wl_accessToken"] = access_token
    p_cookies["wl_accessTokenExpireTime"] = expires
    p_cookies["wl_cid"] = cid
    p_cookies["wl_complete"] = "done"

    user = get_profile_user(cid, access_token)

    populate_pwid(user, p_wrap_verification_code, p_callback, p_cookies)
  end

  def self.clear_cookie_session(p_cookies)
    # http://msdn.microsoft.com/en-us/library/gg251990.aspx
    p_cookies.delete "c_clientId"
    p_cookies.delete "c_clientState"
    p_cookies.delete "c_scope"
    p_cookies.delete "c_accessToken"
    p_cookies.delete "c_expiry"
    p_cookies.delete "c_uid"
    p_cookies.delete "lca"

    # http://msdn.microsoft.com/en-us/library/ff752581.aspx
    p_cookies.delete "wl_clientID"
    p_cookies.delete "wl_clientState"
    p_cookies.delete "wl_scope"
    p_cookies.delete "wl_accessToken"
    p_cookies.delete "wl_accessTokenExpireTime"
    p_cookies.delete "wl_cid"
    p_cookies.delete "wl_complete"

    # Undocumented, but found in the wild.
    p_cookies.delete "wl_internalState"
  end

  private

  # 
  # GET request
  #
  def self.remote_get(p_url, p_headers)
    Rails.logger.info "GET " + p_url
    Rails.logger.info p_headers.inspect
    response = 
      begin
        RestClient.get p_url, p_headers
      rescue => e
        Rails.logger.error e.to_s
        nil
      end
    Rails.logger.info response.to_s
    response
  end

  #
  # POST request
  #
  def self.remote_post(p_url, p_params)
    Rails.logger.info "POST " + p_url
    Rails.logger.info p_params.inspect
    response = RestClient.post p_url, p_params
    Rails.logger.info response.to_s
    response
  end  

  #
  # Get the access token, user id, and other stuff.
  #
  def self.get_access_token(p_wrap_verification_code, p_callback, p_idtype) 
    params = TOKEN_PARAMS.merge :wrap_verification_code => p_wrap_verification_code, :wrap_callback => p_callback
    # default idtype=CID
    params.merge! :idtype => p_idtype if p_idtype
    response = remote_post(TOKEN_URL, params)

    return nil if response.nil?

    if response.code == 200
      response_params = CGI::parse(response.to_s)

      access_token = response_params['wrap_access_token'][0].to_s
      cid = response_params['uid'][0].to_s
      expires = response_params['wrap_access_token_expires_in'][0].to_s
      wrap_refresh_token = response_params['wrap_refresh_token']
      skey = response_params['skey']

      Rails.logger.info 'access_token: ' + access_token
      Rails.logger.info 'cid: ' + cid
      #Rails.logger.info 'expires: ' + expires
      #Rails.logger.info 'refresh token: ' + wrap_refresh_token
      #Rails.logger.info 'secret key: ' + skey

      { :access_token => access_token, :uid => cid, :expires => expires, :wrap_refresh_token => wrap_refresh_token, :skey => skey }
    else
      Rails.logger.error response.inspect
      nil
    end
  end

  #
  # Get and parse the profile from the REST JSON API
  #
  def self.get_profile_user(p_cid, p_access_token)
    auth_headers = API_PROFILES_URL_HEADERS.merge "Authorization" => p_access_token
    response = remote_get((API_PROFILES_URL % p_cid.to_s), auth_headers)

    return nil if response.nil?

    # Supports multiple profiles per user.  Select the 1st one.
    response_profile = JSON::parse(response)['Entries'][0]

    # Gender: 0 = undefined, 1 = female, 2 = male
    # http://msdn.microsoft.com/en-us/library/ff747447.aspx
    gender = case response_profile['Gender']
             when 1 then 'Female'
             when 2 then 'Male'
             else nil
             end
    Rails.logger.info "gender: #{gender}"
    # Supports multiple email "Types".  0 = none, 1 = home, 2 = work, 3 = ?.  Just picking the 1st one I find.
    email = response_profile['Emails'] ? response_profile['Emails'][0]['Address'] : nil
    Rails.logger.info "email: #{email}"

    name = response_profile['FirstName'].to_s + ' ' + response_profile['LastName'].to_s
    Rails.logger.info "name: #{name}"

    # BirthDay and BirthYear are not available.  Only BirthMonth.
    # http://msdn.microsoft.com/en-us/windowslive/gg465294.aspx
    birthYear = response_profile['BirthYear'].nil? ? Date.today.year : response_profile['BirthYear']
    birthMonth = response_profile['BirthMonth'].nil? ? Date.today.month : response_profile['BirthMonth']
    birthDay = response_profile['BirthDay'].nil? ? Date.today.day : response_profile['BirthDay']
    dob = Date.new(birthYear, birthMonth, birthDay)
    Rails.logger.info "dob: #{dob}"

    # Sometimes I get an empty Profile object.
    return nil if email.nil?

    user = User.new(
      :name => name,
      :email => email,
      :born_on => dob,
      :gender => gender,
      :slug => email.split("@")[0],
      :sso_windows => p_cid
    )
    Rails.logger.info user.inspect

    user
  end

  #
  # Populate the user.msn_live_id, if necessary.
  # Necessary if the lookup by sso_windows would fail and we'll have to search again by msn_live_id afterwards.
  #
  def self.populate_pwid(p_user, p_wrap_verification_code, p_callback, p_cookies)
    # This check is redundant.  It happens again later when we handle the user.
    # The query results should be cached for the 2nd lookup.
    #
    # We peek ahead now to determine whether we need to make another trip to the API to get the PWID.
    # As more users transition to CID, the 2nd API call becomes less frequent, and this method becomes faster.
    cid_user = User.find_with_exclusive_scope(:first, :conditions=>{:sso_windows => p_user.sso_windows, :deleted_at => nil})
    if cid_user
      # User found by CID.
      return cid_user
    else
      # Need the old PWID
      access_token_params = get_access_token(p_wrap_verification_code, p_callback, 'PWID')

      access_token = access_token_params[:access_token]
      pwid = access_token_params[:uid]
      expires = access_token_params[:expires]

      # http://msdn.microsoft.com/en-us/library/gg251990.aspx
      p_cookies["c_accessToken"] = access_token
      p_cookies["c_expiry"] = expires

      # http://msdn.microsoft.com/en-us/library/ff752581.aspx
      p_cookies["wl_accessToken"] = access_token
      p_cookies["wl_accessTokenExpireTime"] = expires

      Rails.logger.info access_token
      Rails.logger.info pwid
      Rails.logger.info expires

      p_user.msn_live_id = pwid
      p_user
    end
  end

end
