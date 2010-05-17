# == Schema Information
#
# Table name: accounts
#
#  id                               :integer(4)      not null, primary key
#  email                            :string(255)
#  name                             :string(255)
#  crypted_password                 :string(40)
#  salt                             :string(40)
#  created_at                       :datetime
#  updated_at                       :datetime
#  remember_token                   :string(255)
#  remember_token_expires_at        :datetime
#  gender                           :string(255)
#  born_on                          :date
#  marketing_opt_out                :boolean(1)
#  confirmation_code                :string(255)
#  slug                             :string(255)
#  type                             :string(255)
#  followee_cache                   :text
#  avatar_file_name                 :string(255)
#  avatar_content_type              :string(255)
#  avatar_file_size                 :integer(4)
#  avatar_updated_at                :datetime
#  amg_id                           :string(10)
#  city_id                          :integer(4)
#  receives_following_notifications :boolean(1)      default(TRUE)
#  websites                         :text
#  entry_point_id                   :integer(4)
#  color_header_bg                  :string(6)
#  color_main_font                  :string(6)
#  color_links                      :string(6)
#  color_bg                         :string(6)
#  private_profile                  :boolean(1)      default(FALSE)
#  cell_index                       :integer(4)
#  background_file_name             :string(255)
#  background_content_type          :string(255)
#  background_file_size             :integer(4)
#  background_updated_at            :datetime
#  background_align                 :string(255)
#  background_repeat                :string(255)
#  background_fixed                 :boolean(1)
#  deleted_at                       :datetime
#  created_by_id                    :integer(4)
#  status                           :string(255)
#  genre_id                         :integer(4)
#  default_locale                   :string(255)
#  label_id                         :integer(4)
#  song_play_count                  :integer(4)      default(0)
#  followee_count                   :integer(4)      default(0)
#  follower_count                   :integer(4)      default(0)
#  influences                       :text
#  label_type                       :string(255)
#  management_email                 :string(255)
#  reset_code                       :string(255)
#  visit_count                      :integer(4)      default(0)
#  total_listen_count               :integer(4)      default(0)
#  music_label                      :string(255)
#  msn_live_id                      :string(255)
#  twitter_username                 :string(255)
#  twitter_id                       :integer(4)
#  songs_count                      :integer(4)      default(0)
#  has_custom_profile               :boolean(1)      default(FALSE)
#  ip_address                       :string(255)
#  country_id                       :integer(4)
#  total_user_stations              :integer(4)      default(0), not null
#


class Artist < Account

  index [:slug, :type]
  include SongListen::Most
  include Searchable::ByName

  has_one :station, :class_name => 'AbstractStation', :foreign_key => 'artist_id', :conditions => 'abstract_stations.deleted_at IS NULL'
  has_many :abstract_station_artists
  has_many :abstract_stations, :through => :abstract_station_artists

  # has_many :user_station_artists
  # has_many :abstract_stations, :through => :abstract_station_artists
  # has_many :stations, 
  #          :class_name => 'UserStation',
  #          :through => :user_station_artists, 
  #          :select => 'user_stations.*',
  #          :include => [:abstract_station, :owner],
  #          :source => :user_station, 
  #          :conditions => 'user_stations.deleted_at IS NULL AND abstract_stations.deleted_at IS NULL AND accounts.deleted_at IS NULL', 
  #          :foreign_key => 'artist_id', 
  #          :uniq => true

  has_many :song_listens
  has_many :listeners, :class_name => 'User', :through => :artist_listens
  has_many :songs
  has_many :top_songs

  has_many :album_artists
  has_many :artist_albums, :through => :album_artists, :source => :album, :uniq => true

  has_many :band_members

  named_scope :ordered_by_slug, :order => "slug asc"

  belongs_to :locale
  belongs_to :genre
  belongs_to :label

  has_many :bios, :autosave => true, :foreign_key => :account_id
  #validates_associated :bios

  # def get_user_stations_ids_sql
  #   <<-EOF
  #   SELECT `user_stations`.*
  #   FROM `user_stations` 
  #   INNER JOIN abstract_stations ON user_stations.abstract_station_id = abstract_stations.id 
  #   INNER JOIN abstract_station_artists ON abstract_stations.id = abstract_station_artists.abstract_station_id
  #   WHERE abstract_station_artists.artist_id = #{self.id}
  #   LIMIT 100
  #   EOF
  # end
  # 
  # def stations_sql
  #   ids = UserStation.find_by_sql(get_user_stations_ids_sql).map(&:id).join(',')
  #   "SELECT `user_stations`.* FROM `user_stations`  WHERE id IN (#{ids})"
  # end
  # 
  # def stations
  #   Rails.cache.fetch("#{cache_key}/stations/all", :expires_delta => EXPIRATION_TIMES['artist_stations_all']) do
  #     UserStation.find_by_sql(stations_sql)
  #   end
  # end
  # 
  # def top_stations(limit=10)
  #   Rails.cache.fetch("#{cache_key}/stations/top/#{limit}", :expires_delta => EXPIRATION_TIMES['artist_stations_top']) do
  #     UserStation.find_by_sql(stations_sql << " ORDER BY user_stations.total_plays DESC LIMIT #{limit}")
  #   end
  # end
  # 
  # def latest_stations(limit=10)
  #   Rails.cache.fetch("#{cache_key}/stations/latest/#{limit}", :expires_delta => EXPIRATION_TIMES['artist_stations_latest']) do
  #     UserStation.find_by_sql(stations_sql << " ORDER BY user_stations.created_at DESC LIMIT #{limit}")
  #   end
  # end
  # 

  def top_stations(limit=10)
    station.user_stations.all(:limit => limit, :order => 'user_stations.total_plays DESC')
  end

  def latest_stations(limit=10)
    station.user_stations.all(:limit => limit, :order => 'user_stations.created_at DESC')
  end

  def stations
     station.user_stations
  end
  
  def stations_paginate(page=1, per_page=10, order = :latest)
    sort_types = { :latest => ' user_stations.created_at DESC', :top => ' user_stations.total_plays DESC', :alphabetical => ' user_stations.name'  }
     station.user_stations.paginate :page => page, :per_page => per_page, :order => sort_types[order]
    
    #sort_types = { :latest => ' ORDER BY user_stations.created_at DESC', :top => ' ORDER BY user_stations.total_plays DESC', :alphabetical => ' ORDER BY user_stations.name'  }
    #Rails.cache.fetch("#{cache_key}/stations/pagination/#{order.to_s}/#{page}/#{per_page}", :expires_delta => EXPIRATION_TIMES['artist_stations_pagination']) do
    #  UserStation.paginate_by_sql(stations_sql << sort_types[order] , :page => page, :per_page => per_page, :total_entries => self.total_user_stations)
    #end
  end
  
  def recent_listens(limit = 5)
    song_listens.recent_listens(limit).map { |a| Account.find(a.listener_id) }.compact
  end

  def recent_listeners(limit = 5)
    listens = song_listens.find(:all, :limit => limit,
      :order => ['updated_at desc'],
      :select => 'distinct(listener_id)',
      :conditions => ['album_id is not null AND listener_id is not null']).map{|a| a.listener_id}.compact
    select_columns = "id, gender, follower_count, name, city_id, slug, type, avatar_content_type, avatar_file_name, avatar_updated_at, avatar_file_size"
    Account.find_all_by_id(listens, :select => select_columns, :include => :city)
  end

  def image
    avatar(:medium)
  end

  def profile_url
    slug
  end

  def nick_name
    name
  end

  def latest_albums(limit=3)
    @latest_albums ||= artist_albums.find(:all, :limit => limit + 3).uniq_by { |a| a.name }[0..limit-1]
  end

  def albums(limit = 20)
    artist_albums.find(:all, :limit => limit)
  end

  def genre_name
    self.genre.name rescue nil
  end

  def label_name
    self.label.name rescue nil
  end

  def artist?
    true
  end

  def exists?(id)
    Artist.find(id)
  end

  def increment_total_user_stations
    increment!(:total_user_stations)
  end

  def has_station?
    !station.nil?
  end

  def similar(limit = 4)
    Rails.cache.fetch("#{self.cache_key}/similar/#{limit}", :expires_delta => EXPIRATION_TIMES['artist_similar']) do
      return [] if self.amg_id.blank?

      slugs = RecEngine.new.get_similar_artists(:artistID => self.amg_id, :number_of_records => limit).map do |i|
        if Rails.env.test? && Artist.find_by_slug(i.slug).nil?
          slug = i.slug.gsub(/[^A-Za-z0-9\-]/, '')
          Factory.create(:artist, :slug => slug)
        end
        i.slug
      end
      slugs.compact!
      Artist.find_all_by_slug(slugs)
    end
  rescue SocketError
    logger.error "RecEngine timed out getting Similar Artists for " + self.name.to_s
    []
  end

  class << self

    def find_with_exclusive_scope( *args )
      with_exclusive_scope do
        find(*args)
      end
    end

    def artists_by_recommended( recommended_artists, limit )
      artist_ids = connection.select_values(
        sanitize_sql([
            RECOMMENDED_ARTISTS_QUERY,
            recommended_artists.map {|a| a.id }
          ] ) )
      all( :conditions => {:id => artist_ids.slice( 0, limit)} )
    end

  end

  RECOMMENDED_ARTISTS_QUERY ="SELECT accounts.id
    FROM accounts
    WHERE accounts.id IN (?)
      AND accounts.deleted_at IS NULL
  "

end

