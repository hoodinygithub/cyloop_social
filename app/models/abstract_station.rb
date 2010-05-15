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
  include Station::Playable
  #include Db::Predicates::LimitedTo
  extend ActiveSupport::Memoizable

  define_index do
    where "deleted_at IS NULL AND total_artists > 0"
    indexes :name, :sortable => true
    indexes :created_at, :sortable => true
    set_property :min_prefix_len => 1
    set_property :enable_star => 1
    set_property :allow_star => 1
  end

  named_scope :available, :conditions => { :available => true }

  def self.included(base)
    base.class_eval do
      serialize :includes_cache, Array
    end
  end

  def self.search(*args)
    if RAILS_ENV =~ /test/ # bad bad bad
      options = args.extract_options!
      starts_with(args[0]).paginate :page => (options[:page] || 1)
    else
      args[0] = "#{args[0]}*"
      super(*args).compact        
    end
  end
  

  has_many :user_stations
  has_many :abstract_station_artists, :include => [:artist, :album]
  has_many :artists, :through => :abstract_station_artists

  belongs_to :artist, :include => :label
  validates_presence_of :amg_id
  validates_inclusion_of :available, :in => [true, false]
  validates_uniqueness_of :artist_id, :scope => :id
  delegate :avatar, :to => :artist, :allow_nil => true

  #this is not correct. TODO: Fix
  def top_station
    TopAbstractStation.first( :conditions => { :abstract_station_id => self.id, :site_id => Application::Sites::CURRENT_SITE.id } )
  end

  memoize :top_station

  def self.create_station(artist)
    if artist.kind_of? Artist
      new(:name => artist.name, :artist => artist, :amg_id => artist.amg_id)
    end
  end

  def includes(limit=3)
    refresh_included_artists if total_artists < 1

    Rails.cache.fetch("#{cache_key}/includes/#{limit}", :expires_delta => EXPIRATION_TIMES['abstract_station_includes']) do
      abstract_station_artists.all(:limit => limit)
    end
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


  def owner_is?(user)
    false
  end
  
  def station_queue(params={})
    params[:ip_address] ||= '67.63.37.2'
    CGI::escape("#{RecEngine::BASE_URI}?request=getRecEnginePlayList&artistID=#{amg_id}&ipAddress=#{params[:ip_address]}")
  end

  def to_s
    name
  end
    
end
