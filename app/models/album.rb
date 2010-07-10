# == Schema Information
#
# Table name: albums
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  owner_id            :integer(4)
#  songs_count         :integer(4)
#  year                :integer(4)
#  upc                 :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer(4)
#  avatar_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  grid                :string(255)
#  released_on         :date
#  copyright           :string(255)
#  source              :string(255)     default("Manual")
#  label_id            :integer(4)
#  deleted_at          :datetime
#  total_time          :integer(4)      default(0)
#  buylink_count       :integer(4)      default(0)
#  music_label         :string(255)
#

class Album < ActiveRecord::Base
  include AvatarImporter

  index [:owner_id, :deleted_at, :songs_count, :year]
  index :owner_id
  index [:deleted_at, :songs_count]

  define_index do
    where "albums.deleted_at IS NULL AND accounts.deleted_at IS NULL"
    indexes :name, :sortable => true
    set_property :min_prefix_len => 1
    set_property :enable_star => 1
    set_property :allow_star => 1
    has year, created_at
    has owner(:id), :as => :owner_id
    has owner(:name), :as => :artist_name
    has album_artists(:artist_id), :as => :artist_ids
  end

  default_scope :conditions => 'deleted_at IS NULL', :order => 'year DESC'

  has_many :album_artists
  has_many :artists, :through => :album_artists
  has_many :album_buylinks

  belongs_to :owner, :class_name => 'Artist'
  belongs_to :label
  has_many :songs
  has_many :top_songs
  has_many :song_listens
  named_scope :number_of, lambda {|count| {:limit => count}}

  validates_presence_of :owner

  has_attached_file :avatar, :styles => { :album => "300x300#", :medium => "86x86#", :small => "60x60#" }
  validates_attachment_content_type :avatar,
    :content_type => ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"]

  def total_listens
    song_listens.sum(:total_listens)
  end

  def avatar_with_default
    if avatar_file_name.blank? && owner && !owner.avatar_file_name.blank?
      owner.avatar
    else
      avatar_without_default
    end
  end

  alias_method_chain :avatar, :default

  def label_name
    label && label.name
  end

  def localized_release_date
    unless released_on.nil?
      return (I18n.l(released_on, :format => :long) rescue released_on)
    end
    I18n.t('basics.unknown')
  end

  def to_param
    "#{id}-#{PermalinkFu.escape(name)}"
  end

  def to_s
    name
  end

  def includes(limit=3)
   artists.limited_to(limit)
  end

end

