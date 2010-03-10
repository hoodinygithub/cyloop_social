# == Schema Information
#
# Table name: stations
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
#

class Station < ActiveRecord::Base
  index :artist_id
  include Station::IncludesCache
  include Searchable::ByName
  extend ActiveSupport::Memoizable

  named_scope :available, :conditions => { :available => true }

  def self.included(base)
    base.class_eval do
      serialize :includes_cache, Array
    end
  end

  has_many :user_stations
  belongs_to :artist, :include => :label
  validates_presence_of :amg_id
  validates_inclusion_of :available, :in => [true, false]
  validates_uniqueness_of :artist_id, :scope => :id
  delegate :avatar, :to => :artist, :allow_nil => true

  def top_station
    TopStation.first( :conditions => { :station_id => self.id, :site_id => Application::Sites::CURRENT_SITE.id } )
  end

  memoize :top_station

  def self.create_station(artist)
    if artist.kind_of? Artist
      new(:name => artist.name, :artist => artist, :amg_id => artist.amg_id)
    end
  end

  def includes(num_of_records=3)
   update_includes_cache(:amgID => read_attribute(:amg_id), :number_of_records => num_of_records) if includes_cache.empty?
   # @includes ||= includes_cache.map {|artist| Artist.find(artist)}
   @includes ||= Artist.find_all_by_id(includes_cache)
  end

  def to_s
    name
  end

end
