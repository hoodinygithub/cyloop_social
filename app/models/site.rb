# == Schema Information
#
# Table name: sites
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  default_locale      :string(255)
#  code                :string(255)
#  msn_live_account_id :string(255)
#  login_type_id       :integer(4)
#  domain              :string(255)
#

class Site < ActiveRecord::Base
  def self._load(*args)
    find(*args) rescue nil
  end
  
  index :name
  serialize :default_locale, Symbol

  include SongListen::Most
  include ProfileVisit::Most

  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :default_locale
  validates_presence_of :code

  has_many :profile_visits
  has_many :sites_stations, :class_name => "SitesStation"
  has_many :buylink_providers_sites, :class_name => "BuylinkProvidersSite"

  has_many :players, :class_name => "Player"

  has_many :summary_top_songs, :order => 'total_listens DESC', :class_name => 'TopSong', :include => :song
  has_many :summary_top_albums, :order => 'total_listens DESC', :class_name => 'TopAlbum', :include => :album

  has_many :summary_top_artists, :order => 'total_listens DESC', :class_name => 'TopArtist', :include => :artist
  has_many :top_artists, :through => :summary_top_artists, :class_name => 'Artist', :foreign_key => 'artist_id', :source => :artist, :order => 'top_artists.total_listens DESC'
  
  has_many :summary_top_abstract_stations, :order => 'station_count DESC', :class_name => 'TopAbstractStation', :include => { :abstract_station => [:station, :artist] }
  #has_many :top_abstract_stations, :through => :summary_top_abstract_stations, :class_name => 'AbstractStation', :foreign_key => 'abstract_station_id', :source => :abstract_station, :order => 'top_abstract_stations.station_count DESC'
  has_many :summary_top_user_stations, :order => 'total_requests DESC', :class_name => 'TopUserStation', :include => { :user_station => :station }
  #has_many :top_user_stations, :through => :summary_top_user_stations, :class_name => 'UserStation', :foreign_key => 'user_station_id', :source => :user_station, :order => 'top_user_stations.total_requests DESC', :group => 'user_stations.abstract_station_id'

  has_many :summary_top_djs, :order => 'total_requests DESC', :class_name => 'TopDj', :include => :dj
  has_many :top_djs, :through => :summary_top_djs, :class_name => 'User', :foreign_key => 'dj_id', :source => :user, :order => 'top_djs.total_requests DESC', :conditions => 'accounts.network_id = 1 AND accounts.deleted_at IS NULL'

  has_many :summary_top_playlists, :order => 'total_requests DESC', :class_name => 'TopPlaylist', :include => :playlist
  #has_many :top_playlists, :through => :summary_top_playlists, :class_name => 'Playlist', :foreign_key => 'playlist_id', :source => :playlist, :order => 'top_playlists.total_requests DESC', :conditions => 'playlists.deleted_at IS NULL'

  has_many :user_stations, :include => :owner, :conditions => 'accounts.network_id = 1' do
    def latest(limit=8)
      all(:order => 'user_stations.created_at DESC', :limit => limit)
    end
  end

  has_many :playlists, :include => :owner, :conditions => 'accounts.deleted_at IS NULL AND accounts.network_id = 1 AND playlists.deleted_at IS NULL AND playlists.locked_at IS NULL' do
    def latest(limit=8)
      all(:order => 'playlists.updated_at DESC', :limit => limit)
    end
  end

  has_many :editorial_stations_sites, :include => {:editorial_station => :mix}, :conditions => "editorial_stations.deleted_at IS NULL AND playlists.deleted_at IS NULL AND playlists.locked_at IS NULL"
  has_many :stations, :through => :editorial_stations_sites, :include => :mix, :class_name => 'EditorialStation', :source => :editorial_station

  has_many :users, :foreign_key => 'entry_point_id'
  has_one :site_statistic
  has_many :campaigns
  has_many :network_sites
  has_many :networks, :through => :network_sites
  
  belongs_to :login_type
  
  # Things I hate in life: this method
  def default_locale
    @attributes['default_locale'].gsub('--- :', '').strip.to_sym
  rescue 
    :en # quick patch to ease migration hell WHY WHY WHY
  end

  # this is needed because even though mx, latino and latam have different locales
  # they share the same bios in spanish.
  def bio_locale    
    #if @attributes['default_locale'].gsub('--- :', '') == 'pt_BR'
    #  :pt_BR
    #else
    #  :es
    #end
    #default_locale.to_s[0..1].to_sym
    default_locale == :pt_BR ? :pt_BR : default_locale.to_s[0..1].to_sym
  end

  def is_msn?
    (code =~ /msn(.*)/).nil? ? false : true
  end

  def tag_counts_from_playlists(limit=60)
    options = { :select => "DISTINCT tags.*",
                :joins => "INNER JOIN #{Tagging.table_name} ON #{Tag.table_name}.id = #{Tagging.table_name}.tag_id INNER JOIN #{Playlist.table_name} ON #{Tagging.table_name}.taggable_id = #{Playlist.table_name}.id AND #{Tagging.table_name}.taggable_type = 'Playlist'",
                :order => "taggings.created_at DESC",
                :conditions => "playlists.site_id = #{self.id} AND (playlists.deleted_at IS NULL AND playlists.locked_at IS NULL)",
                :limit => limit }
    
    Tag.all(options)
            
    # options = { :limit => limit, 
    #             :joins => "INNER JOIN #{Playlist.table_name} ON #{Tagging.table_name}.taggable_id = #{Playlist.table_name}.id AND #{Tagging.table_name}.taggable_type = 'Playlist'",
    #             :order => "taggings.created_at DESC",
    #             :conditions => "playlists.site_id = #{self.id}" }
    # Tag.counts(options)    
  end

  def top_abstract_stations(limit=6)
    summary_top_abstract_stations.all(:limit => limit).map(&:abstract_station)
  end

  def top_user_stations(limit=6)
    summary_top_user_stations.all(:limit => limit, :group => 'user_stations.abstract_station_id', :include => { :user_station => :owner }, :conditions => 'accounts.network_id = 1').map(&:user_station)
  end

  def top_playlists(limit=8)
    summary_top_playlists.all(:limit => limit, :include => { :playlist => :owner }, :conditions => 'playlists.deleted_at IS NULL AND playlists.locked_at IS NULL AND accounts.network_id = 1 AND accounts.deleted_at IS NULL').map(&:playlist)
  end

  # def top_user_stations_grouped(limit=6)
  #   summary_top_user_stations.all(:joins => :user_station, :limit => limit, :group => 'user_stations.abstract_station_id').map(&:user_station)
  # end
  
  def calendar_locale
    locale = default_locale
    case locale
    when :pt_BR
      "pt-BR"
    when :fr_CA
      "fr"
    when :en_CA
      ""
    when :en
      ""
    else
      "es"
    end
  end

  def cache_key
    "#{self.class.model_name.cache_key}/#{id}/#{self.updated_at.try(:to_s, :number)}/#{code}/#{default_locale}"
  end

end
