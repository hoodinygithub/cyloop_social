require 'open-uri'
require 'timeout'

class RecEngine
  class ResponseError < RuntimeError
  end

  if Rails.env.uat?
    BASE_URI = "http://rectest.cyloop.com:8080/recEngine/rest"
  else
    BASE_URI = "http://rec.cyloop.com/recEngine/rest"
  end

  def initialize(default_params = {})
    default_params ||= {}
    @_params = default_params.with_indifferent_access
  end

  def self.camelize_key(key)
    key.to_s.camelize(:lower).sub(/Id$/,'ID')
  end

  def self.camelize_params(params)
    params.inject({}) do |h, (k,v)|
      h.update(camelize_key(k) => v)
    end
  end

  def build_uri(action, params = {})
    params = self.class.camelize_params(@_params.merge(:request => self.class.camelize_key(action)).merge(params))
    query = params.map {|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join("&")
    "#{BASE_URI}?#{query}"
  end

  def get(action, params = {})
    begin
      Timeout::timeout(6) do
        body = open(build_uri(action, params)).read
        Nokogiri::XML.parse(body)
      end
    rescue => e
      puts e.inspect
      puts e.backtrace.join( "\n" )
      Nokogiri::XML.parse([])
    end
  end

  def get_items(action, params = {})
    begin
      get(action, params).search("/recommendation/method/items/item")
    rescue Timeout::Error 
      #logger.error "Coult not reach the server\n - #{$!}"
      return []
    end
  end

  def get_rec_engine_play_list(params = {})
    #Explicitly removing caching on radio per Demian - 2009-09-29
    #Rails.cache.fetch("rec_engine/play_list/#{all_params_to_cache_key(params)}", :expires_in => EXPIRATION_TIMES['rec_engine_play_list']) do

    get_items(:get_rec_engine_play_list, params).map {|x| RecEngine::Song.new(x)}
    #end
  end

  def get_rec_engine_playlist_artists(params = {})
    Rails.cache.fetch("rec_engine/get_rec_engine_playlist_artists/#{all_params_to_cache_key(params)}", :expires_delta => EXPIRATION_TIMES['get_rec_engine_playlist_artists']) do
      get_items(:get_rec_engine_play_list, params).map {|x| RecEngine::ArtistFromPlaylist.new(x) }.uniq_by { |y| y.artist_id }
    end
  end

  def get_recommended_artists(params = {})
    #get_artists(SimilarArtist
    Rails.cache.fetch("rec_engine/get_recommended_artists/#{all_params_to_cache_key(params)}", :expires_delta => EXPIRATION_TIMES['rec_engine_recommended_artists']) do
      get_items(:get_recommended_artists, params).map {|x| RecEngine::Artist.new(x)}
    end
  end
  
  def get_recommended_stations(params = {})
    Rails.cache.fetch("rec_engine/get_recommended_stations/#{all_params_to_cache_key(params)}", :expires_delta => EXPIRATION_TIMES['rec_engine_recommended_stations']) do
      get_items(:get_recommended_stations, params).map {|x| RecEngine::Station.new(x)} rescue []
    end
  end
  
  def get_similar_artists(params = {})
    Rails.cache.fetch("rec_engine/get_similar_artists/#{all_params_to_cache_key(params)}", :expires_delta => EXPIRATION_TIMES['rec_engine_similar_artists']) do
      get_items(:get_similar_artists, params).map {|x| RecEngine::SimilarArtist.new(x)}
    end
  end

  def get_recommended_songs(params = {})
    get_items(:get_recommended_songs, params).map {|x| RecEngine::Song.new(x)}
  end
  
  private
  def all_params_to_cache_key(args)
    args.delete(:ip_address) if args.has_key?(:ip_address)
    if (@_params.nil? || @_params.keys.size == 0)
      return args.to_cache_key
    else
      return args.merge(@_params).to_cache_key
    end
  end

end

require_dependency 'rec_engine/artist'
require_dependency 'rec_engine/station'
require_dependency 'rec_engine/song'
require_dependency 'rec_engine/similar_artist'
