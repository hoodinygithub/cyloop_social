# == Schema Information
#
# Table name: abstract_stations
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  amg_id         :string(10)
#  artist_id      :integer(4)
#  includes_cache :text
#  available      :boolean(1)      default(TRUE)
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  total_plays    :integer(4)      default(0), not null
#  total_artists  :integer(4)      default(0), not null
#

class AbstractStation < ActiveRecord::Base
  index :artist_id
  include Searchable::ByName
  include Station::Playable
  include Db::Predicates::LimitedTo
  extend ActiveSupport::Memoizable

  named_scope :available, :conditions => { :available => true }

  def self.included(base)
    base.class_eval do
      serialize :includes_cache, Array
    end
  end

  has_many :user_stations
  has_many :abstract_station_artists
  has_many :artists, :through => :abstract_station_artists

  belongs_to :artist, :include => :label
  validates_presence_of :amg_id
  validates_inclusion_of :available, :in => [true, false]
  validates_uniqueness_of :artist_id, :scope => :id
  delegate :avatar, :to => :artist, :allow_nil => true

  #this is not correct. TODO: Fix
  def top_station
    TopStation.first( :conditions => { :station_id => self.id, :site_id => Application::Sites::CURRENT_SITE.id } )
  end

  memoize :top_station

  def self.create_station(artist)
    if artist.kind_of? Artist
      new(:name => artist.name, :artist => artist, :amg_id => artist.amg_id)
    end
  end

  def includes(limit=3)
   #update_includes_cache(:amgID => read_attribute(:amg_id), :number_of_records => num_of_records) if includes_cache.empty?
   # @includes ||= includes_cache.map {|artist| Artist.find(artist)}
   
   #@includes ||= Artist.find_all_by_id(includes_cache)
   refresh_included_artists unless total_artists > 0
   abstract_station_artists.limited_to(limit)
  end

  def refresh_included_artists(params={})
    params[:ip_address] ||= '67.63.37.2'
    options = params.merge(:artistID => amg_id)
    
    new_artists = []
    new_artists = RecEngine.new(options).get_rec_engine_playlist_artists unless amg_id.nil?
    unless new_artists.empty? 
      new_artists.each { |x| abstract_station_artists << AbstractStationArtist.find_or_create_by_artist_id_and_abstract_station_id(:artist_id => x.artist_id, :abstract_station_id => self.id, :album_id => x.album_id) } 
    end
    update_attribute(:total_artists, new_artists.size)
  end

  def station_queue(params={})
    params[:ip_address] ||= '67.63.37.2'
    {:id => station.id, :queue => CGI::escape("#{RecEngine::BASE_URI}?request=getRecEnginePlayList&artistID=#{amg_id}&ipAddress=#{params[:ip_address]}")}
  end

  def to_s
    name
  end

end
