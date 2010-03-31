require 'ostruct'

class RecEngine::Artist < RecEngine::Abstract
  # Example artist amg id: "P   440673"

  integer_reader :id
  reader :main_genre, :source, :nick_name, :image, :profile_url
  
  def slug
    profile_url.sub(/^\//, '')
  end

  def station
    AbstractStation.find_by_artist_id(id)
  end
  
  alias to_param slug

  def avatar
    @avatar ||= OpenStruct.new(:url => "#{ENV['ASSETS_URL']}#{image}")
  end

  def to_s
    nick_name
  end
  
end
