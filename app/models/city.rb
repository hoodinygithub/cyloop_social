# == Schema Information
#
# Table name: cities
#
#  id        :integer(4)      not null, primary key
#  region_id :integer(4)
#  name      :string(255)
#  location  :string(255)
#

class City < ActiveRecord::Base
  belongs_to :region
  delegate :country, :to => :region
  named_scope :starts_with, lambda {|prefix| {:include => {:region => :country}, :conditions => ["location LIKE ?", "#{prefix}%"]}}

  # def geo_lite_city
  #   self.class.geo_lite_city
  # end  
  # 
  # def self.geo_lite_city
  #   @geo_lite_city ||= GeoIPCity::Database.new(File.join(Rails.root, 'db', 'geoip', 'GeoLiteCity.dat'))    
  # end
  
  # def self.find_by_addr(addr)
  #   result = geo_lite_city.look_up(addr)
  #   unless result.nil?
  #     country = Country.find_by_code(result[:country_code])
  #     unless country.nil?
  #       City.search("#{result[:city]}, #{country.name}").first
  #     end
  #   end
  # end

  define_index do
    indexes :location
    indexes :name, :sortable => true
    set_property :min_prefix_len => 1
    set_property :enable_star => 1
  end
  
  def to_s
    "#{name}, #{region}"
  end
end
