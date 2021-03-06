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

class User < Account

  include Account::Authentication
  include Account::ProfileColors  
  include Account::FolloweeCache
  include Account::SingleShortBio
  include Account::RegistrationStates
  include Searchable::ByNameAndSlug

  index [:type]

  after_update :update_followings_with_name
  
  default_scope :conditions => { :network_id => 1 }  
  has_one :bio, :autosave => true, :foreign_key => :account_id
  validates_associated :bio

  has_many :stations,
           :foreign_key => :owner_id,
           :select => "user_stations.*",
           :class_name => "UserStation",
           :include => [:abstract_station, :station],
           :conditions => 'abstract_stations.deleted_at IS NULL AND user_stations.deleted_at IS NULL' do
    def top(limit)
      all(:order => 'user_stations.total_plays DESC', :limit => limit)
    end
    def latest(limit)
      all(:order => 'user_stations.created_at DESC', :limit => limit)
    end
  end
  
  has_many :comments, :foreign_key => :user_id, :conditions => "commentable_type = 'Playlist'" do
    def latest(limit=6)
      all(:limit => limit, :order => 'comments.created_at DESC')
    end 
  end
        
  
  
  has_many :playlists, :foreign_key => :owner_id do
    def top(limit = 4)
      all(:include => :station, :conditions => 'playlists.locked_at IS NULL', :order => 'playlists.total_plays DESC', :limit => limit)
    end

    def latest(limit = 6)
      all(:include => :station, :conditions => 'playlists.locked_at IS NULL', :order => 'playlists.updated_at DESC', :limit => limit)
    end

    def locked(args = {})
      opts = { :include => :station, :conditions => 'playlists.locked_at IS NOT NULL' }
      opts.merge!(args) unless args.empty?
      all(opts)
    end

    def unlocked(args = {})
      opts = { :include => :station, :conditions => 'playlists.locked_at IS NULL' }
      opts.merge!(args) unless args.empty?
      all(opts)
    end
  end
  

  has_many :taggings, :through => :playlists
  has_many :song_listens, :foreign_key => :listener_id

  has_many :followings, :foreign_key => 'follower_id'
  has_many :followees, :through => :followings, :conditions => "followings.approved_at IS NOT NULL AND accounts.network_id = 1", :source => :followee do
    def with_limit(limit=10)
      find(:all, :limit => limit)
    end
    include SongListen::Most

    def song_listens
      SongListen.for_followees_of(proxy_owner)
    end
  end

  has_many :blocks_as_blockee, :class_name => 'Block', :foreign_key => 'blockee_id'
  has_many :blockers, :through => :blocks_as_blockee, :source => :blocker
  has_many :blockees, :through => :blocks, :source => :blockee
  has_many :blocks, :foreign_key => 'blocker_id'
  has_many :messages

  belongs_to :entry_point, :class_name => 'Site', :foreign_key => 'entry_point_id'
  belongs_to :network

  validates_presence_of :entry_point_id
  validates_presence_of :born_on

  validates_inclusion_of :gender, :in => ['Male', 'Female'], :message => :gender

  validate :check_born_on_in_future, :unless => Proc.new { |user| user.born_on.blank? }
  validate :check_age_is_at_least_13, :unless => Proc.new { |user| user.born_on.blank? }

  def <=>(b)
    id <=> b.id
  end

  def top_stations(limit=10)
    stations.top(limit)
  end
  
  def latest_stations(limit=10)
    stations.latest(limit)
  end

  def stations_paginate(page=1, per_page=10, order = :latest)
    sort_types = { :latest => 'user_stations.created_at DESC', :top => 'user_stations.total_plays DESC', :alphabetical => 'user_stations.name'  }
    stations.paginate :page => page, :per_page => per_page, :order => sort_types[order]
  end

  def follow(followee)
    followee_id = followee.kind_of?(Account) ? followee.id : followee
    following = followings.create(:followee_id => followee_id)
  end

  def unfollow(followee_id)
    followee_id = followee_id.id if followee_id.kind_of? Account
    if following = followings.find_by_followee_id(followee_id)
      following.destroy
    end
  end

  def follows?(followee_id)
    followee_id = followee_id.id if followee_id.kind_of? Account
    # followings.approved.exists?(:followee_id => followee_id)
    cached_followee_ids.include?(followee_id)
  end

  def awaiting_follow_approval?(followee_id)
    followee_id = followee_id.id if followee_id.kind_of? Account
    # followings.pending.exists?(:followee_id => followee_id)
    cached_pending_followee_ids.include?(followee_id)
  end

  def tag_counts_from_playlists(limit=60)
    options = { :select => "DISTINCT tags.*",
                :joins => "INNER JOIN #{Tagging.table_name} ON #{Tag.table_name}.id = #{Tagging.table_name}.tag_id INNER JOIN #{Playlist.table_name} ON #{Tagging.table_name}.taggable_id = #{Playlist.table_name}.id AND #{Tagging.table_name}.taggable_type = 'Playlist'",
                :order => "taggings.created_at DESC",
                :conditions => "playlists.owner_id = #{self.id} AND (playlists.deleted_at IS NULL AND playlists.locked_at IS NULL)",
                :limit => limit }

    Tag.all(options)
    # options = { :limit => limit, 
    #             :joins => "INNER JOIN #{Playlist.table_name} ON #{Tagging.table_name}.taggable_id = #{Playlist.table_name}.id AND #{Tagging.table_name}.taggable_type = 'Playlist'",
    #             :order => "taggings.created_at DESC",
    #             :conditions => "playlists.owner_id = #{self.id}" }
    # Tag.counts(options)
  end

  def tags_from_playlists
    taggings.map(&:tag)
  end

  def update_cached_tag_list
    update_attribute(:cached_tag_list, TagList.new(tags_from_playlists.map(&:name)).to_s)
  end

  #TODO MUST BE REVISITED WHEN IMPLEMENTING LOCALES

  def create_user_station(options={})
    user_station = nil
    transaction do
      user_station = UserStation.create(options.merge({:owner => self}))
      user_station.create_station
      self.increment!(:total_user_stations)
    end
    user_station.station if user_station
  end

  def block(blockee_id)
    blockee_id = blockee_id.id if blockee_id.kind_of? User
    Block.create! :blocker_id => id, :blockee_id => blockee_id
  end
  
  def unblock(blockee_id)
    blockee_id = blockee_id.id if blockee_id.kind_of? User
    blocked = Block.first(:conditions => {:blocker_id => id, :blockee_id => blockee_id})
    blocked.destroy if blocked
  end

  def unblock(blockee_id)
    blockee_id = blockee_id.id if blockee_id.kind_of? User
    blocked = Block.first(:conditions => {:blocker_id => id, :blockee_id => blockee_id})
    blocked.destroy if blocked
  end

  def blocks?(blockee_id)
    blockee_id = blockee_id.id if blockee_id.kind_of? User
    blocks.map(&:blockee_id).include?(blockee_id)
  end

  def blocked_by?(blocker_id)
    blocker_id = blocker_id.id if blocker_id.kind_of? User
    blockers.map(&:id).include?(blocker_id)
  end

  def user?
    true
  end
  
  def part_of_network?
    ApplicationController.current_site.networks.include? self.network
  end

  def private?
    self.private_profile
  end

  def default_locale
    result = begin
      YAML.load( self.read_attribute(:default_locale) )
    rescue
      self.read_attribute(:default_locale)
    end
    result || (self.entry_point && self.entry_point.default_locale)
  end

  def cached_followee_ids
    Rails.cache.fetch("#{cache_key}/followee_ids") do
      followings.approved.find(:all, :select => 'followee_id').map{|f| f.followee_id}
    end
  end

  def cached_pending_followee_ids
    Rails.cache.fetch("#{cache_key}/pending_followee_ids") do
      followings.pending.find(:all, :select => 'followee_id').map{|f| f.followee_id}
    end
  end

  after_destroy :remove_customizations
  def remove_customizations
    CustomizationWriter.new(self).remove_css if File.exists?(CustomizationWriter.css_path(self.id))
  end

  def remove_avatar
    self.avatar_file_name    = nil
    self.avatar_content_type = nil
    self.avatar_file_size    = nil
    self.avatar_updated_at   = nil
    self.save
  end

  def custom_errors
    on_convention = [I18n.t("activerecord.errors.messages.blank"), 
                     I18n.t("activerecord.errors.messages.confirmation")]
    errors_hash = self.errors.inject({}) { |h,(k,v)| h[k] = on_convention.include?(v) ? "#{self.class.human_attribute_name(k)} #{v}" : v; h }
    errors_hash.to_a
  end

  protected
  def check_born_on_in_future
    errors.add(:born_on, :cant_be_in_future) if born_on > Date.today
  end

  def check_age_is_at_least_13
    errors.add(:born_on, I18n.t("registration.must_be_13_years_older")) if underage?
  end

  def update_followings_with_name
    followings.update_all(:follower_name => self.name)
    followings_as_followee.update_all(:followee_name => self.name)
  end
    
end

