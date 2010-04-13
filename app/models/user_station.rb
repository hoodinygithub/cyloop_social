# == Schema Information
#
# Table name: user_stations
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  owner_id            :integer(4)
#  comments_count      :integer(4)      default(0)
#  created_at          :datetime
#  updated_at          :datetime
#  site_id             :integer(4)
#  abstract_station_id :integer(4)
#  referrer_id         :integer(4)
#  total_plays         :integer(4)      default(0), not null
#  total_artists       :integer(4)      default(0), not null
#  deleted_at          :datetime
#

class UserStation < ActiveRecord::Base
  include Db::Predicates::LimitedTo
  include Summary::TotalListensProxy
  include Searchable::ByName
  include Station::Playable

  module Most
    def most_created_stations(limit = 5)
      abstract_stations.most_created(limit)
    end
  end


  belongs_to :abstract_station
  
  delegate :artist, :artist_id, :amg_id, :top_station, :to => :abstract_station, :allow_nil => true
  belongs_to :site
  belongs_to :owner, :class_name => 'User'

  validates_presence_of :owner
  validates_uniqueness_of :abstract_station_id, :scope => :owner_id, :message => "has already been created for you"
  
  before_save :set_name_to_station_name
  has_many :user_station_artists
  has_many :artists, :through => :user_station_artists
  
  def self.most_created(limit = nil)
    # count(:include => :abstract_station, :group => :abstract_station_id, :limit => limit, :order => "count_all DESC").map do |id, count|
    #   #Artist.find(id)
    #   TotalListensProxy.new(AbstractStation.find_by_id(id), count) 
    # end
    count(:include => :abstract_station, :group => :abstract_station_id, :limit => limit, :order => "count_all DESC").map do |id, count|
      #Artist.find(id)
      TotalListensProxy.new(UserStation.find_by_abstract_station_id(id), count) 
    end
  end

  def self.latest_stations(limit = 8)
    all(:limit => limit, :joins => [:owner, :abstract_station], :conditions => 'user_stations.deleted_at IS NULL AND accounts.deleted_at IS NULL AND abstract_stations.available', :order => 'user_stations.created_at DESC', :select => 'user_stations.*' )
  end

  def refresh_included_artists(params={} )
    params[:ip_address] ||= '67.63.37.2'
    options = params.merge(:userID => owner_id, :artistID => amg_id)

    new_artists = []
    new_artists = RecEngine.new(options).get_rec_engine_playlist_artists unless amg_id.nil?
    remove_artists
    unless new_artists.empty? 
      new_artists.each do |x|
        artist = Artist.find(x.artist_id)
        artist.increment_total_user_stations if artist

        user_station_artists << UserStationArtist.find_or_create_by_artist_id_and_user_station_id(:artist_id => x.artist_id, :user_station_id => self.id, :album_id => x.album_id)
      end
    end
    update_attribute(:total_artists, new_artists.size)
  end

  def includes(limit=3)
    refresh_included_artists unless total_artists > 0
    user_station_artists.limited_to(limit)
  end

  def set_deleted
    update_attribute(:deleted_at, Time.now)
  end

  delegate :avatar, :to => :artist, :allow_nil => true

  def to_s
    name
  end

  protected

  def remove_artists
    self.user_station_artists.destroy_all
  end

  def set_name_to_station_name
    self.name ||= "#{abstract_station.name}"
  end

end
