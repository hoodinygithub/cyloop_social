# == Schema Information
#
# Table name: playlists
#
#  id             :integer(4)      not null, primary key
#  owner_id       :integer(4)
#  name           :string(255)
#  comments_count :integer(4)      default(0)
#  songs_count    :integer(4)      default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  total_time     :integer(4)      default(0)
#

class Playlist < ActiveRecord::Base

  belongs_to :owner, :class_name => 'User'

  has_many :songs, :through => :items, :order => "playlist_items.position ASC"
  has_many :items, :class_name => 'PlaylistItem', :order => "playlist_items.position ASC", :include => :song
  has_one :editorial_station, :foreign_key => 'mix_id'
  has_one :station, :as => :playable
  
  validates_presence_of :name
  
  def artists_contained(options = {})
    options[:limit] ||= 4
    options[:random] = true unless options.has_key?(:random)
    artists = songs.find(:all, :group => :artist_id, :limit => options[:limit]).collect { |s| s.artist }
    artists = artists.sort_by {rand} if options[:random]
    artists
  end

  def artists
    @artists ||= Artist.find_by_sql( [ ARTISTS_FROM_PLAYLIST, self.id ] ).uniq
  end

  def station_queue(params={})
    "/playlists/#{id}.xml"
  end

  def avatar
    owner && owner.avatar || User.new.avatar
  end

  def gender
    owner.gender
  end
  
  def total_time
    @total_time ||= items.sum(:duration).to_i
  end
 
  ARTISTS_FROM_PLAYLIST = %Q!
    SELECT a.* FROM accounts a
    INNER JOIN songs s ON a.id = s.artist_id
    INNER JOIN playlist_items p ON p.song_id = s.id
    WHERE p.playlist_id = ?
  !

end
