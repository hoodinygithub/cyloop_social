class RecEngine::Station < RecEngine::Abstract
  # Example artist amg id: "P   440673"

  integer_reader :id
  reader :artist_name, :image, :profile_url, :amgID
         # :sim_name1, :sim_url1, :sim_name2, :sim_url2, 
         # :sim_name3, :sim_url3, :sim_name4, :sim_url4, 
         # :sim_name5, :sim_url5
  
  def slug
    profile_url.sub(/^\//, '')
  end
  alias to_param slug

  def normalize_amg_id
    a = amgID =~ /(\w{1})\s+(\d+)/
    new_amg_id = ""
    unless a.nil?
      new_amg_id << $1.to_s
      (9 - $2.length).times { new_amg_id << ' ' }
      new_amg_id << $2.to_s
    end
    new_amg_id
  end

  def station
    s = AbstractStation.find_by_amg_id(normalize_amg_id, :include => [{:playable => :artist}])
    s.station unless s.nil?
  end

  def avatar
    require 'ostruct'
    OpenStruct.new(:url => "#{ENV['ASSETS_URL']}#{image}")
  end

  def to_s
    nick_name
  end
  
  def includes
    result = []
    5.times do |num|
      result.push({:name => read_attribute("sim_name#{num+1}"), :url => read_attribute("sim_url#{num+1}")}) unless read_attribute("sim_name#{num+1}").nil?
    end
    result
  end
  
  def artist_id
    artist = Artist.find_by_slug(profile_url[1..-1])
    (artist.nil?) ? nil : artist.id
  end
  
  def station_url
    station = Station.find_by_artist_id(artist_id)
    (station.nil?) ? nil : "/radio/#{station.id}.xml"
  end
end
