module RecEngineHelper
  class RecEngineTest
    def initialize
      query = {:ip_address => remote_ip, :language => I18n.locale, :site => "msncaen"}
      @rec_engine = RecEngine.new(query)
    end

    def remote_ip
      '67.63.37.2'
    end
    
    def recommended_artists(limit = 15)
      @recommended_artists ||= @rec_engine.get_recommended_artists(:number_of_records => limit)
    rescue SocketError
      logger.error "RecEngine timed out"
      []
    end
    
  end

  def recommended_artists(limit = 15)
    RecEngineTest.new().recommended_artists
  end
end