class Player::EditorialItem < Player::Base

  column :station_id,  :integer
  column :station_url, :string
  column :name       , :string
  column :ip       , :string

  attr_accessor :includes
  
  def station_url
    "/sites_stations/#{self.id}.xml"
  end

  def to_xml(options = {})
    options[:root] = 'station'
    super(options) do |xml|
      unless self.includes.blank?
        xml << Player::Artist.from( self.includes.map ).to_xml( :skip_instruct => true, :root => 'related-artists', :skip_types => true )
      end
    end
  end

  class << self
    def from_one(object, options = {})
      returning(super(object, options)) do |editorial|
        editorial.includes = object.includes.map{ |s| s.artist }
      end
    end
  end

end
