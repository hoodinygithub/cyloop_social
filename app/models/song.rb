# == Schema Information
#
# Table name: songs
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  artist_id           :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  duration            :integer(4)
#  copyright           :string(255)
#  label               :string(255)
#  distributor         :string(255)
#  file_name           :string(255)
#  album_id            :integer(4)
#  position            :integer(4)
#  deleted_at          :datetime
#  source              :string(255)     default("Ingest")
#  music_label         :string(255)
#  available_countries :text
#  label_id            :integer(4)
#  grid                :string(255)
#  isrc                :string(255)
#  buylink_count       :integer(4)      default(0)
#

class Song < ActiveRecord::Base 
  include Song::AvailableCountries

  index :id

  default_scope :conditions => { :deleted_at => nil }, :order => 'position'

  after_save :increment_album_total_time, :if => :album_id?
  before_destroy :decrement_album_total_time, :if => :album_id?
  
  belongs_to :artist
  belongs_to :album, :counter_cache => true

  has_one :top_song
  has_many :items, :class_name => 'PlaylistItem'
  has_many :playlists, :through => :items
  has_many :song_listens
  has_many :song_genres
  has_many :buylinks, :class_name => 'SongBuylink'
  has_many :genres, :through => :song_genres

  validates_presence_of :artist, :title

  validates_uniqueness_of :position, :scope => :album_id, :if => :album_id?
  validates_presence_of :position, :if => :album_id?

  define_index do
    where "deleted_at IS NULL"
    indexes :title
    set_property :min_prefix_len => 1
    set_property :enable_star => 1
  end
  
  def total_listens
    song_listens.sum(:total_listens)
  end

  def increment_album_total_time
    album.update_attribute(:total_time, album.songs.sum(:duration))
  end

  def decrement_album_total_time
    album.update_attribute(:total_time, album.songs.sum(:duration) - duration)
  end

  def path
    "/.elhood.com-2/usr/#{artist_id}/audio/#{file_name}"
  end
  
  def buylinks_by_site(site)
    query = "SELECT sb.*, bp.store_image FROM song_buylinks sb
               INNER JOIN buylink_providers bp ON sb.buylink_provider_id = bp.id
               INNER JOIN buylink_providers_sites bps ON bp.id = bps.buylink_provider_id
             WHERE bps.site_id = ? AND sb.song_id = ?"
    SongBuylink.find_by_sql([query, site.id, id])    
  end

  include Storage

  alias_attribute :length, :duration

  def avatar
    album && album.avatar || artist && artist.avatar || Artist.new.avatar
  end

  def genre_name
    self.genres.first.name rescue nil
  end

  def to_s
    title
  end

  def listened_by(listener, site)
    SongListen.record(self, site, listener)
  end

  def can_play_full?(country)
    available_countries.include?(country.kind_of?(Country) ? country.id : country)
  end
  
  def to_param
    "#{id}-#{PermalinkFu.escape(title)}"
  end

end
