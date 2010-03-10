#######################################################################
# FILE:        windowslivelogin.rb
#
# DESCRIPTION: Sample implementation of Web Authentication and
#              Delegated Authentication protocol in Ruby. Also
#              includes trusted sign-in and application verification
#              sample implementations.
#
# VERSION:     1.1
#
# Copyright (c) 2008 Microsoft Corporation.  All Rights Reserved.
#######################################################################

require 'cgi'
require 'uri'
require 'base64'
#require 'openssl'
require 'digest/sha2'
require 'net/https'
require 'rexml/document'

class WindowsLiveLogin

  #####################################################################
  # Stub implementation for logging errors. If you want to enable
  # debugging output using the default mechanism, specify true.
  # By default, debug information will be printed to the standard
  # error output and should be visible in the web server logs.
  #####################################################################
  def setDebug(flag)
    @debug = flag
  end

  #####################################################################
  # Stub implementation for logging errors. By default, this function
  # does nothing if the debug flag has not been set with setDebug.
  # Otherwise, it tries to log the error message.
  #####################################################################
  def debug(error)
    return unless @debug
    return if error.nil? or error.empty?
    warn("Windows Live ID Authentication SDK #{error}")
    nil
  end

  #####################################################################
  # Stub implementation for handling a fatal error.
  #####################################################################
  def fatal(error)
    debug(error)
    raise(error)
  end

  #####################################################################
  # Initialize the WindowsLiveLogin module from YAML file.
  #
  # development:
  #   appid: 0000000044018ADD
  #   secret: Zgz2AOyvRUVPhcRk4WnixgvDhZPjkzHP
  #   securityalgorithm: wsignin1.0
  #   debug: true
  #
  #####################################################################
  def self.init()
    o = self.new
    settings = YAML.load(ERB.new(File.read("#{RAILS_ROOT}/config/windows_live_login.yml")).result)[RAILS_ENV]
    o.setDebug(settings['debug'] == true)
    o.force_delauth_nonprovisioned =
      (settings['force_delauth_nonprovisioned'] == 'true')

    o.appid = settings['appid']
    o.secret = settings['secret']
    o.oldsecret = settings['oldsecret']
    o.oldsecretexpiry = settings['oldsecretexpiry']
    o.securityalgorithm = settings['securityalgorithm']
    o.policyurl = settings['policyurl']
    o.returnurl = settings['returnurl']
    o.login_port = settings['login_port']
    o.baseurl = settings['baseurl']
    o.secureurl = settings['secureurl']
    o.consenturl = settings['consenturl']
    o
  end

  #####################################################################
  # Sets the application ID. Use this method if you did not specify
  # an application ID at initialization.
  #####################################################################
  def appid=(appid)
    if (appid.nil? or appid.empty?)
      return if force_delauth_nonprovisioned
      fatal("Error: appid: Null application ID.")
    end
    if (not appid =~ /^\w+$/)
      fatal("Error: appid: Application ID must be alpha-numeric: " + appid)
    end
    @appid = appid
  end

  #####################################################################
  # Returns the application ID.
  #####################################################################
  def appid
    if (@appid.nil? or @appid.empty?)
      fatal("Error: appid: App ID was not set. Aborting.")
    end
    @appid
  end

  #####################################################################
  # Sets and Returns the login port used to access sinatra app.
  #####################################################################
  #####################################################################
  # Sets the application ID. Use this method if you did not specify
  # an application ID at initialization.
  #####################################################################
  def login_port=(login_port)
    @login_port = login_port
  end
  def login_port
    @login_port
  end

  #####################################################################
  # Sets your secret key. Use this method if you did not specify
  # a secret key at initialization.
  #####################################################################
  def secret=(secret)
    if (secret.nil? or secret.empty?)
      return if force_delauth_nonprovisioned
      fatal("Error: secret=: Secret must be non-null.")
    end
    if (secret.size < 16)
      fatal("Error: secret=: Secret must be at least 16 characters.")
    end
    @signkey = derive(secret, "SIGNATURE")
    @cryptkey = derive(secret, "ENCRYPTION")
  end

  #####################################################################
  # Sets your old secret key.
  #
  # Use this property to set your old secret key if you are in the
  # process of transitioning to a new secret key. You may need this
  # property because the Windows Live ID servers can take up to
  # 24 hours to propagate a new secret key after you have updated
  # your application settings.
  #
  # If an old secret key is specified here and has not expired
  # (as determined by the oldsecretexpiry setting), it will be used
  # as a fallback if token decryption fails with the new secret
  # key.
  #####################################################################
  def oldsecret=(secret)
    return if (secret.nil? or secret.empty?)
    if (secret.size < 16)
      fatal("Error: oldsecret=: Secret must be at least 16 characters.")
    end
    @oldsignkey = derive(secret, "SIGNATURE")
    @oldcryptkey = derive(secret, "ENCRYPTION")
  end

  #####################################################################
  # Sets the expiry time for your old secret key.
  #
  # After this time has passed, the old secret key will no longer be
  # used even if token decryption fails with the new secret key.
  #
  # The old secret expiry time is represented as the number of seconds
  # elapsed since January 1, 1970.
  #####################################################################
  def oldsecretexpiry=(timestamp)
    return if (timestamp.nil? or timestamp.empty?)
    timestamp = timestamp.to_i
    fatal("Error: oldsecretexpiry=: Invalid timestamp: #{timestamp}") if (timestamp <= 0)
    @oldsecretexpiry = Time.at timestamp
  end

  #####################################################################
  # Gets the old secret key expiry time.
  #####################################################################
  attr_accessor :oldsecretexpiry

  #####################################################################
  # Sets or gets the version of the security algorithm being used.
  #####################################################################
  attr_accessor :securityalgorithm

  def securityalgorithm
    if(@securityalgorithm.nil? or @securityalgorithm.empty?)
      "wsignin1.0"
    else
      @securityalgorithm
    end
  end

  #####################################################################
  # Sets a flag that indicates whether Delegated Authentication
  # is non-provisioned (i.e. does not use an application ID or secret
  # key).
  #####################################################################
  attr_accessor :force_delauth_nonprovisioned

  #####################################################################
  # Sets the privacy policy URL, to which the Windows Live ID consent
  # service redirects users to view the privacy policy of your Web
  # site for Delegated Authentication.
  #####################################################################
  def policyurl=(policyurl)
    if ((policyurl.nil? or policyurl.empty?) and force_delauth_nonprovisioned)
      fatal("Error: policyurl=: Invalid policy URL specified.")
    end
    @policyurl = policyurl
  end

  #####################################################################
  # Gets the privacy policy URL for your site.
  #####################################################################
  def policyurl
    if (@policyurl.nil? or @policyurl.empty?)
      debug("Warning: In the initial release of Del Auth, a Policy URL must be configured in the SDK for both provisioned and non-provisioned scenarios.")
      raise("Error: policyurl: Policy URL must be set in a Del Auth non-provisioned scenario. Aborting.") if force_delauth_nonprovisioned
    end
    @policyurl
  end

  #####################################################################
  # Sets the return URL--the URL on your site to which the consent
  # service redirects users (along with the action, consent token,
  # and application context) after they have successfully provided
  # consent information for Delegated Authentication. This value will
  # override the return URL specified during registration.
  #####################################################################
  def returnurl=(returnurl)
    if ((returnurl.nil? or returnurl.empty?) and force_delauth_nonprovisioned)
      fatal("Error: returnurl=: Invalid return URL specified.")
    end
    @returnurl = returnurl
  end


  #####################################################################
  # Returns the return URL of your site.
  #####################################################################
  def returnurl
    if ((@returnurl.nil? or @returnurl.empty?) and force_delauth_nonprovisioned)
      fatal("Error: returnurl: Return URL must be set in a Del Auth non-provisioned scenario. Aborting.")
    end
    @returnurl
  end

  #####################################################################
  # Sets or gets the base URL to use for the Windows Live Login server. You
  # should not have to change this property. Furthermore, we recommend
  # that you use the Sign In control instead of the URL methods
  # provided here.
  #####################################################################
  attr_accessor :baseurl

  def baseurl
    if(@baseurl.nil? or @baseurl.empty?)
      "http://login.live.com/"
    else
      @baseurl
    end
  end

  #####################################################################
  # Sets or gets the secure (HTTPS) URL to use for the Windows Live Login
  # server. You should not have to change this property.
  #####################################################################
  attr_accessor :secureurl

  def secureurl
    if(@secureurl.nil? or @secureurl.empty?)
      "https://login.live.com/"
    else
      @secureurl
    end
  end

  #####################################################################
  # Sets or gets the Consent Base URL to use for the Windows Live Consent
  # server. You should not have to use or change this property directly.
  #####################################################################
  attr_accessor :consenturl

  def consenturl
    if(@consenturl.nil? or @consenturl.empty?)
      "https://consent.live.com/"
    else
      @consenturl
    end
  end
end

#######################################################################
# Implementation of the basic methods needed for Web Authentication.
#######################################################################
class WindowsLiveLogin
  #####################################################################
  # Returns the sign-in URL to use for the Windows Live Login server.
  # We recommend that you use the Sign In control instead.
  #
  # If you specify it, 'context' will be returned as-is in the sign-in
  # response for site-specific use.
  #####################################################################
  def getLoginUrl(context=nil, market=nil)
    url = baseurl + "wlogin.srf?appid=#{appid}"
    url += "&alg=#{securityalgorithm}"
    url += "&appctx=#{CGI.escape(context)}" if context
    url += "&mkt=#{CGI.escape(market)}" if market
    url
  end

  #####################################################################
  # Returns the sign-out URL to use for the Windows Live Login server.
  # We recommend that you use the Sign In control instead.
  #####################################################################
  # def getLogoutUrl(context=nil)
  #   url = baseurl + "logout.srf?appid=#{appid}"
  #   url += "&appctx=#{CGI.escape(context)}" if context
  #   url
  # end
  def getLogoutUrl(context=nil)
    port = (login_port.blank?) ? "" : ":#{login_port}"
    url = "http://login.cyloop.com#{port}/logout?appid=#{appid}"
    url += "&appctx=#{CGI.escape(context)}" if context
    url
  end

  #####################################################################
  # Returns an appropriate content type and body response that the
  # application handler can return to signify a successful sign-out
  # from the application.
  #
  # When a user signs out of Windows Live or a Windows Live
  # application, a best-effort attempt is made at signing the user out
  # from all other Windows Live applications the user might be signed
  # in to. This is done by calling the handler page for each
  # application with 'action' set to 'clearcookie' in the query
  # string. The application handler is then responsible for clearing
  # any cookies or data associated with the sign-in. After successfully
  # signing the user out, the handler should return a GIF (any GIF)
  # image as response to the 'action=clearcookie' query.
  #####################################################################
  def getClearCookieResponse()
    type = "image/gif"
    content = "R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAEALAAAAAABAAEAAAIBTAA7"
    content = Base64.decode64(content)
    return type, content
  end
end

#######################################################################
# Common methods.
#######################################################################
class WindowsLiveLogin

  #####################################################################
  # Processes the sign-in response from the Windows Live sign-in server.
  #
  # 'params' contains the POST table returned by Rails.
  #
  # This method returns a msn_live_user_id; otherwise
  # it returns nil.
  #####################################################################
  def processLogin(params)
    token = CGI.escape(params[:stoken])
    processToken(token)
  end

  #####################################################################
  # Decodes and validates a Web Authentication token. Returns a User
  # object on success. If a context is passed in, it will be returned
  # as the context field in the User object.
  #####################################################################
  def processToken(token, context=nil)
    if token.nil? or token.empty?
      debug("Error: processToken: Null/empty token.")
      return
    end
    stoken = decodeToken token
    stoken = parse stoken

    unless stoken
      debug("Error: processToken: Failed to decode/validate token: #{token}")
      return
    end
    sappid = stoken['appid']
    unless sappid == appid
      debug("Error: processToken: Application ID in token did not match ours: #{sappid}, #{appid}")
      return
    end
    begin
      user_id = stoken['uid']
      return user_id
    rescue Exception => e
      debug("Error: processToken: Contents of token considered invalid: #{e}")
      return
    end
  end

  #####################################################################
  # Decodes the given token string; returns undef on failure.
  #
  # First, the string is URL-unescaped and base64 decoded.
  # Second, the IV is extracted from the first 16 bytes of the string.
  # Finally, the string is decrypted using the encryption key.
  #####################################################################
  def decodeToken(token, cryptkey=@cryptkey)
    if (cryptkey.nil? or cryptkey.empty?)
      fatal("Error: decodeToken: Secret key was not set. Aborting.")
    end
    token =  u64(token)
    if (token.nil? or (token.size <= 16) or !(token.size % 16).zero?)
      debug("Error: decodeToken: Attempted to decode invalid token.")
      return
    end
    iv = token[0..15]
    crypted = token[16..-1]
    begin
      aes128cbc = OpenSSL::Cipher::AES128.new("CBC")
      aes128cbc.decrypt
      aes128cbc.iv = iv
      aes128cbc.key = cryptkey
      decrypted = aes128cbc.update(crypted) + aes128cbc.final
    rescue Exception => e
      debug("Error: decodeToken: Decryption failed: #{token}, #{e}")
      return
    end
    decrypted
  end
end

#######################################################################
# Helper methods.
#######################################################################
class WindowsLiveLogin

  #######################################################################
  # Function to parse the settings file.
  #######################################################################
  def parseSettings(settingsFile)
    settings = {}
    begin
      file = File.new("#{RAILS_ROOT}/config/#{settingsFile}.xml")
      doc = REXML::Document.new file
      root = doc.root
      root.each_element{|e|
        settings[e.name] = e.text
      }
    rescue Exception => e
      fatal("Error: parseSettings: Error while reading #{settingsFile}: #{e}")
    end
    return settings
  end

  #####################################################################
  # Derives the key, given the secret key and prefix as described in the
  # Web Authentication SDK documentation.
  #####################################################################
  def derive(secret, prefix)
    begin
      fatal("Nil/empty secret.") if (secret.nil? or secret.empty?)
      key = prefix + secret
      key = Digest::SHA256.digest(key)
      return key[0..15]
    rescue Exception => e
      debug("Error: derive: #{e}")
      return
    end
  end

  #####################################################################
  # Parses query string and return a table
  # {String=>String}
  #
  # If a table is passed in from CGI.params, we convert it from
  # {String=>[]} to {String=>String}. I believe Rails uses symbols
  # instead of strings in general, so we convert from symbols to
  # strings here also.
  #####################################################################
  def parse(input)
    if (input.nil? or input.empty?)
      debug("Error: parse: Nil/empty input.")
      return
    end

    pairs = {}
    if (input.class == String)
      input = input.split('&')
      input.each{|pair|
        k, v = pair.split('=')
        pairs[k] = v
      }
    else
      input.each{|k, v|
        v = v[0] if (v.class == Array)
        pairs[k.to_s] = v.to_s
      }
    end
    return pairs
  end

  #####################################################################
  # Generates a time stamp suitable for the application verifier token.
  #####################################################################
  def timestamp
    Time.now.to_i.to_s
  end

  #####################################################################
  # Base64-encodes and URL-escapes a string.
  #####################################################################
  def e64(s)
    return unless s
    CGI.escape Base64.encode64(s)
  end

  #####################################################################
  # URL-unescapes and Base64-decodes a string.
  #####################################################################
  def u64(s)
    return unless s
    Base64.decode64 CGI.unescape(s)
  end

  #####################################################################
  # Fetches the contents given a URL.
  #####################################################################
  def fetch(url)
      url = URI.parse url
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")
      http.request_get url.request_uri
  end
end
