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
#  private_profile                  :boolean(1)
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
#  has_custom_profile               :boolean(1)
#  ip_address                       :string(255)
#  country_id                       :integer(4)
#

class Account < ActiveRecord::Base
  include Authentication
  include Sluggable
  include AvatarImporter
  include BackgroundImporter
  include Commentable
  include Account::AccountActivity
  include SongListen::Most
  include ProfileVisit::Most

  index [:type]

  define_index do
    where "deleted_at IS NULL"
    indexes :name, :sortable => true
    set_property :min_prefix_len => 1
    set_property :enable_star => 1
    set_property :allow_star => 1
    has visit_count, created_at
  end

  default_scope :conditions => { :deleted_at => nil }

  serialize :default_locale, Symbol

  after_create :add_slug_to_accounts_slugs

  has_and_belongs_to_many :sites, :join_table => 'accounts_excluded_sites'

  # Paperclip Plugin http://dev.thoughtbot.com/paperclip/
  has_attached_file :avatar, :styles => { :original => '600x600>', :album => "300x300#", :medium => "86x86#", :small => "60x60#", :tiny => "30x30#"}
  validates_attachment_size :avatar, :less_than => 2.megabytes
  validates_attachment_content_type :avatar,
    :content_type => ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png", "image/jpg"]

  has_attached_file :background, :styles => {:original => '1200x1200>'}
  validates_attachment_size :background, :less_than => 1.megabytes
  validates_attachment_content_type :background,
    :content_type => ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png", "image/jpg"]

  # cache-money
  index :slug

  has_many :profile_visits, :class_name => 'ProfileVisit', :foreign_key => 'owner_id'
  has_many :visitors, :through => :profile_visits, :source => :visitor, :order => "updated_at DESC", :limit => 15 do
    def with_limit(limit=10)
      find(:all, :limit => limit)
    end
  end

  has_many :followings_as_followee, :class_name => 'Following', :foreign_key => 'followee_id'
  has_many :followers, :through => :followings_as_followee, :conditions => "followings.approved_at IS NOT NULL", :source => :follower, :order => "followings.updated_at DESC" do
    def with_limit(limit=10)
      find(:all, :limit => limit)
    end

    def alphabetical
      find(:all, :order => 'accounts.name ASC')
    end
  end

  has_many :account_slugs, :dependent => :destroy
  belongs_to :site, :foreign_key => :entry_point_id

  def follow_requests
    followings_as_followee.pending
  end

  validates_presence_of :name
  validates_length_of :name, :maximum => 100, :allow_blank => true

  validates_uniqueness_of :twitter_id, :allow_nil => true
  validates_uniqueness_of :twitter_username, :case_sensitive => false, :allow_nil => true, :allow_blank => true
  validates_format_of :twitter_username,
    :with => /\A[^_-]/,
    :allow_blank => true,
    :allow_nil => true,
    :message => :cannot_start_with_punctuation
  validates_format_of :twitter_username,
    :with => /[^_-]\z/,
    :allow_blank => true,
    :allow_nil => true,
    :message => :cannot_end_with_punctuation
  validates_format_of :twitter_username,
    :with => /\A[A-Za-z0-9_-]+\z/,
    :allow_blank => true,
    :allow_nil => true,
    :message => :can_only_contain_letters_numbers_and_hyphens

  def available_at_current_site?( current_site_id = ApplicationController.current_site.id )
    !(self.sites.count( :conditions => { :id => current_site_id } ) > 0)
  end

  def first_name
    self.name.split(' ')[0] rescue self.name
  end

  def age
    unless born_on.blank?
      ((Date.today - born_on) / 365.25).to_i
    end
  end

  def underage?(age = 13)
    !born_on.nil? && age.years.ago < born_on
  end

  def biography(locale = :en)
    bio = self.bios.find_by_locale("--- :" + locale.to_s)
    bio.long.gsub(/\n/, "<br/>") rescue nil
  end

  belongs_to :city
  belongs_to :country

  before_validation :find_country_by_ip_address
  def find_country_by_ip_address
    self.country = Country.find_by_addr(ip_address) unless ip_address.nil? && !country.nil?
  end

  def city_name
    city.try(:location)
  end

  def city_name=(name)
    unless name.blank?
      self.city = City.search(name).first
    else
      self.city = nil
    end
  end

  alias :location :city_name

  def user?
    false
  end

  def artist?
    false
  end

  def registered?
    status.to_s == "registered"
  end

  undef type
  validates_presence_of :type
  validates_exclusion_of :type, :in => %w(Account)

  def to_s
    name
  end

  def slug_cache_key
    slug.gsub(' ', '-')
  end
  ### Twitter stuff ###
  def followee_cache_not_deleted
    @followee_cache_not_deleted ||= Account.find(:all, :select => 'id', :conditions => ["id in (?) and deleted_at is null", self.followee_cache]).collect{|a| a.id}
  end

  def visited_by(visitor, site)
    ProfileVisit.record(self, site, visitor)
  end

  def visible?
    available_at_current_site?
  end

  after_save :delete_customization_key
  def delete_customization_key
    Rails.cache.delete("profiles/#{slug_cache_key}/customizations")
  end

  def current_customizations
    Rails.cache.fetch("profiles/#{slug_cache_key}/customizations") do
      CustomizationWriter.new(self).prepare_template
    end
  end

  def delete_follower_cache
    Rails.cache.delete("#{cache_key}/followee_ids")
    Rails.cache.delete("#{cache_key}/pending_followee_ids")
  end

  def determine_account_ids(group)
    accounts = case group
    when :just_following
      self.followee_cache_not_deleted
    when :just_me
      [self.id]
    when :all
      self.is_a?(Artist) ? [self.id].concat(self.follower_ids) : [self.id].concat(self.followee_cache_not_deleted)
    end
    accounts
  end
  
  def activity_status(args = {})
    activity_status = Activity::Status.new(self)
  end

  def activity_feed(*args)
    options = args.extract_options!
    options[:kind] ||= :all
    options[:page] ||= 1
    options[:group] ||= :all
    options[:group] = :all if self.is_a?(Artist)
    raise ArgumentError unless [:all, :listen, :twitter, :station, :playlist, :status].include?(options[:kind])
    raise ArgumentError unless [:all, :just_me, :just_following].include?(options[:group])
    Activity::Feed.query :for => options[:kind],
                                :page => options[:page].to_i,
                                :account_ids => determine_account_ids(options[:group]),
                                :before_timestamp => options[:before_timestamp],
                                :after_timestamp => options[:after_timestamp],
                                :artist => self.is_a?(Artist) ? self.id : false
  end

  def transformed_activity_feed(*args)
    options = args.extract_options!
    feed = self.activity_feed(options)
    @transformed_activity_feed = Array.new
    feed.each do |item|
      hash = Hash.new
      item.keys.each do |key|
        if key =~ /_/ && !((key == 'screen_name') || (item['type'] == 'twitter' && (key == 'account_id' || key == 'avatar_file_name')))
          main_item, attribute = key.split('_', 2)
          hash[main_item] ||= Hash.new
          if key == 'item_artists_contained' && !item[key].blank?
            hash[main_item][attribute] = JSON.parse(item[key])
          elsif key == 'owner_avatar_file_name' && item[key].blank?
            hash[main_item][attribute] = "/avatars/missing/#{item['gender'].downcase}.gif"
          else
            hash[main_item][attribute] = (attribute == 'id') ? item[key].to_i : item[key]
          end
        else
          hash[key] = (key == 'id') ? item[key].to_i : item[key]
        end
        @transformed_activity_feed.push(hash)
      end
      hash = nil
    end
    @transformed_activity_feed.uniq
  end

  def city_db
    self.class.city_db
  end

  has_many :chats
  has_many :profile_chats, :class_name => "Chat", :foreign_key => "profile_id"
  attr_accessor :next_chat
  def has_chat?(current_site)
    self.next_chat = profile_chats.find(:first, :order => "chat_date asc", :conditions => "status <> 'disabled'")
    !next_chat.nil? && next_chat.markets.include?(current_site.id.to_s)
  end

  class << self

    def find_by_name_without_scope( name )
      with_exclusive_scope do
        find_by_name!( name )
      end
    end

    def find_deleted_by_slug( slug )
      with_exclusive_scope do
        find_by_slug( slug )
      end
    end

    def city_db
      @city_db ||= GeoIPCity::Database.new('/opt/GeoIP/share/GeoIP/GeoLiteCity.dat')
    end

  end

  def delete_slugs
    self.account_slugs.delete_all
  end

  def add_slug_to_accounts_slugs
    if self.account_slugs.count == 0
      self.account_slugs.create( :slug => self.slug )
    end
  end

end

# Cache money sucks
require_dependency 'user'
require_dependency 'artist'

