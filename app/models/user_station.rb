# == Schema Information
#
# Table name: user_stations
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  owner_id       :integer(4)
#  comments_count :integer(4)      default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  site_id        :integer(4)
#  station_id     :integer(4)
#  referrer_id    :integer(4)
#

class UserStation < ActiveRecord::Base
  include Summary::TotalListensProxy

  module Most
    def most_created_stations(limit = 5)
      stations.most_created(limit)
    end
  end

  belongs_to :station
  delegate :artist, :artist_id, :amg_id, :top_station, :includes, :to => :station, :allow_nil => true
  belongs_to :site
  belongs_to :owner, :class_name => 'User'

  validates_presence_of :owner
  validates_uniqueness_of :station_id, :scope => :owner_id, :message => "has already been created for you"
  
  before_save :set_name_to_station_name
  
  def self.most_created(limit = nil)
    count(:include => :station, :group => :station_id, :limit => limit, :order => "count_all DESC").map do |id, count|
      #Artist.find(id)
      TotalListensProxy.new(Station.find_by_id(id), count) 
    end
  end

  delegate :avatar, :to => :artist, :allow_nil => true

  def to_s
    name
  end

  protected

  def set_name_to_station_name
    self.name ||= "#{station.name}"
  end

end
