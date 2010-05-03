# == Schema Information
#
# Table name: player_bases
#
#  name          :string
#  station_id    :integer
#  station_url   :string
#  amg_id        :string
#  ip            :string
#  user_id       :integer
#  artist_id     :integer
#  station_count :integer
#  name          :string
#  station_id    :integer
#  station_url   :string
#  amg_id        :string
#  ip            :string
#  user_id       :integer
#  artist_id     :integer
#  station_count :integer
#

class Player::Station < Player::Base

  column :name, :string
  column :station_id, :integer
  column :station_url, :string
  column :amg_id, :string
  column :ip, :string
  column :user_id, :integer
  column :artist_id, :integer
  column :station_count, :integer
  column :tracking_id, :integer

  attr_accessor :includes

  belongs_to :artist, :class_name => 'Player::Artist'

  def station_url
    if self.user_id
      "#{RecEngine::BASE_URI}?request=getRecEnginePlayList&artistID=#{self.amg_id}&userID=#{self.user_id}&ipAddress=#{self.ip}"
    else
      "#{RecEngine::BASE_URI}?request=getRecEnginePlayList&artistID=#{self.amg_id}&ipAddress=#{self.ip}"
    end
  end

  def to_xml(options = {})
    options[:root] = 'user-station' unless options[:root]
    options[:include] = :artist
    options[:except] = :artist_id
    super(options) do |xml|
      unless self.includes.blank?
        xml << Player::Artist.from( self.includes ).to_xml( :skip_instruct => true, :root => 'related-artists', :skip_types => true )
      end
      unless self.artist
        xml.artist do
          xml.method_missing( 'avatar-file-name', '/avatars/missing/artist.gif' )
        end
      end
    end
  end

  class << self

    def from_one( object, options = {} )
      options[:amg_id] = object.abstract_station.amg_id if object.kind_of?(UserStation)
      returning( super(object, options) ) do |station|
        station.includes = object.includes(4)
        station.artist = Player::Artist.from( object.artist ) unless object.artist_id.nil?
        station.station_count = object.top_station.station_count if object.top_station
        station.station_id = object.station.id
      end
    end

  end

end
