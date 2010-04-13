# == Schema Information
#
# Table name: countries
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  code         :string(2)
#  latitude     :integer(4)
#  longitude    :integer(4)
#  enable_radio :boolean(1)      default(FALSE), not null
#

class Country < ActiveRecord::Base
  has_many :regions
  has_many :cities, :through => :regions
  
  def self.geoip
    require 'geoip'
    @geoip ||= GeoIP.new(File.join(Rails.root, 'db', 'geoip', 'GeoIP.dat'))
  end

  def self.find_by_addr(addr, options = {})
    host, addr, id, code, tla, name, continent = *geoip.country(addr)
    find_by_code(code, options)
  end

  def radio_enabled?
    enable_radio
  end

  def to_s
    name
  end
end
