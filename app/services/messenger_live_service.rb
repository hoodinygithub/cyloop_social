
class MessengerLiveService

  def self.current_login( host = nil )
    if @configs.blank?
      @configs = YAML.load_file( File.join( Rails.root, 'config', 'messenger_live.yml' ) )
      @configs.each do |key,value|
        value.stringify_keys!
      end
    end

    @configs[ host ].blank? ? nil : WindowsMsnLiveLogin.from_hash( @configs[ host ] )
  end

end

WindowsMsnLiveLogin.class_eval do

  alias :app_verifier :getAppVerifier
  alias :process_consent_token :processConsentToken
  
end

WindowsMsnLiveLogin::ConsentToken.class_eval do

  alias :valid? :isValid?

end
