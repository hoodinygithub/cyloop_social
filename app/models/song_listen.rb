# == Schema Information
#
# Table name: song_listens
#
#  id            :integer(4)      not null, primary key
#  listener_id   :integer(4)
#  song_id       :integer(4)
#  total_listens :integer(4)      default(0)
#  created_at    :datetime
#  updated_at    :datetime
#  artist_id     :integer(4)
#  site_id       :integer(4)
#  album_id      :integer(4)
#


class SongListen < ActiveRecord::Base
  include Summary::TotalListensProxy

  module Most
    def most_listened_artists(limit = 10, includes = :artist, conditions = 'accounts.deleted_at IS NULL')
      #conditions = 'accounts.deleted_at IS NULL AND accounts.songs_count > 0'
      Rails.cache.fetch("#{self.cache_key}/most_listened_artists/#{limit}", :expires_delta => EXPIRATION_TIMES['song_listen_most_listened']) do
        song_listens.most_listened(:artists, limit, includes, conditions)
      end
    end

    def most_listened_albums(limit = 10, includes = :album, conditions = 'albums.deleted_at IS NULL')
      #conditions = 'albums.deleted_at IS NULL AND albums.songs_count > 0'
      Rails.cache.fetch("#{self.cache_key}/most_listened_albumss/#{limit}", :expires_delta => EXPIRATION_TIMES['song_listen_most_listened']) do
        song_listens.most_listened(:albums, limit, includes, conditions)
      end
    end

    def most_listened_songs(limit = 10, includes = :song, conditions = 'songs.deleted_at IS NULL')
      # Rails.cache.fetch("#{self.cache_key}/most_listened_songs/#{limit}", :expires_in => EXPIRATION_TIMES['song_listen_most_listened']) do
      #   song_ids = song_listens.find(:all, :limit => limit, :order => 'total_listens desc', :select => 'song_id').map{|s| s.song_id}
      #   Song.find_all_by_id(song_ids)
      # end
      Rails.cache.fetch("#{self.cache_key}/most_listened_songs/#{limit}", :expires_delta => EXPIRATION_TIMES['song_listen_most_listened']) do
        song_listens.most_listened(:songs, limit, includes, conditions)
      end
    end

    def top_songs(limit = 5)
      fetch_limit = limit && limit * 5
      songs = most_listened_songs(fetch_limit).uniq_by {|s| s.artist_id}
      limit ? songs.first(limit) : songs
    end
  end
  
  belongs_to :song
  belongs_to :artist
  belongs_to :album
  belongs_to :site
  belongs_to :listener, :class_name => "User"

  before_validation do |model|
    model.artist_id ||= model.song.artist_id if model.song
    model.album_id ||= model.song.album_id if model.song
  end
  
  validates_presence_of :site, :song, :artist, :total_listens, :album_id
  named_scope :recent_listens, lambda { |count| {:select => "id, listener_id, MAX(updated_at) AS updated_at",:conditions => ["listener_id IS NOT NULL AND listener_id != 4 AND listener_id != 0"], :group => "listener_id", :order => "updated_at DESC", :limit => count}}
  named_scope :for_followees_of, lambda { |id| {:conditions => ["listener_id IN (select followings.followee_id from followings where followings.approved_at IS NOT NULL AND followings.follower_id IN (?))", id.kind_of?(Account) ? id.id : id]} }

  def self.most_listened(collection, limit = nil, includes = nil, conditions = nil)
    max_listens = nil

    sum(
      :total_listens,
      :conditions => conditions,
      #:conditions => "song_listens.song_id IN (SELECT id FROM songs) and song_listens.album_id IS NOT NULL",
      :group => collection.to_s.singularize,
      :include => includes,
      :limit => limit,
      :order => "sum_total_listens DESC"
    ).map do |object, total_listens|
      max_listens ||= total_listens
      TotalListensProxy.new(object, total_listens, max_listens)
    end
  end

  def self.record(song, site, listener)
    song_id = nil
    if song.kind_of?(Song)
      song_id = song.id
    else
      song_id = song
      song = Song.find(song_id)
    end

    site_id = site.kind_of?(Site) ? site.id : site
    listener_id = listener.kind_of?(Account) ? listener.id : listener

    if song
      listen = SongListen.find_or_create_by_song_id_and_site_id_and_listener_id(song_id, site_id, listener_id)
      listen.album_id = song.album_id
      listen.artist_id = song.artist_id
      listen.increment!(:total_listens)
      listen.listener.increment!( :song_play_count )
      Rails.logger.error( "=== Incrementing counter for song #{song} and listener #{listener}" )
    end

  end
end

