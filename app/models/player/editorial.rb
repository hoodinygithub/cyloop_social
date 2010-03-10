class Player::Editorial < Player::Base

  column :site_id,     :integer
  column :account_id,  :integer
  column :station_id,  :integer
  column :playlist_id, :integer
  column :station_url, :string
  column :name       , :string
  column :logo_path,   :string
  column :ip,          :string

  belongs_to :station, :class_name => 'Player::Station'

  def station_url
    "/sites_stations/#{self.id}.xml"
  end

  def to_xml(options = {})
    options[:root] = 'editorial_station'
    options[:include] = :station
    options[:except] = [:station_id, :ip]
    super(options)
  end

  def logo_path
    value = read_attribute(:logo_path)
    value.blank? ? '/images/msn_butterfly.png' : value
  end

  class << self
    def from_one(object, options = {})
      returning(super(object, options)) do |editorial|
        editorial.station = Player::Station.from(object.station, :ip => editorial.ip)
        editorial.station.includes = object.playlist.artists.rand_list(3) if object.playlist
      end
    end
  end

end
