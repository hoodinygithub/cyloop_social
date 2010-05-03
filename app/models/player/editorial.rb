# == Schema Information
#
# Table name: player_bases
#
#  site_id     :integer
#  account_id  :integer
#  station_id  :integer
#  playlist_id :integer
#  station_url :string
#  name        :string
#  logo_path   :string
#  ip          :string
#  site_id     :integer
#  account_id  :integer
#  station_id  :integer
#  playlist_id :integer
#  station_url :string
#  name        :string
#  logo_path   :string
#  ip          :string
#

class Player::Editorial < Player::Base

  column :site_id,     :integer
  column :account_id,  :integer
  column :station_id,  :integer
  column :playlist_id, :integer
  column :station_url, :string
  column :name       , :string
  column :logo_path,   :string
  column :ip,          :string

  # column :site_id,     :integer
  # column :account_id,  :integer
  # column :station_id,  :integer
  # column :playlist_id, :integer
  # column :station_url, :string
  # column :name       , :string
  # column :logo_path,   :string
  # column :ip,          :string

  attr_accessor :includes
  attr_accessor :editorial_station

  def station_url
    "/sites_stations/#{self.id}.xml"
  end

  def profile_id
    false
  end

  def to_xml(options = {})
    options[:root] = 'editorial_station'
    #options[:include] = :editorial_station
    options[:except] = [:station_id, :ip, :artist, :name]
    super(options) do |xml|
      xml << Player::EditorialItem.from(self.editorial_station, :ip => self.ip ).to_xml( :skip_instruct => true, :root => 'station', :skip_types => true )
    end
  end

  def logo_path
    value = read_attribute(:logo_path)
    value.blank? ? '/images/msn_butterfly.png' : value
  end

  class << self
    def from_one(object, options = {})
      returning(super(object, options)) do |editorial|
        editorial.editorial_station = object.editorial_station
        editorial.site_id = object.site_id
        editorial.playlist_id = object.editorial_station.mix_id
        editorial.account_id = object.profile_id if object.profile_id
        editorial.station_id = object.editorial_station.station.id
        #editorial.station.name = object.editorial_station.name
        editorial.id = object.editorial_station.id
        editorial.station_id = object.editorial_station.station.id
        #editorial.site_id = object.site_id
      end
    end
  end

end
