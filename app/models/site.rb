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

  has_many :song_listens
  has_many :profile_visits
  has_many :sites_stations, :class_name => "SitesStation"
  has_many :buylink_providers_sites, :class_name => "BuylinkProvidersSite"
  has_many :players, :class_name => "Player"
  has_many :stations, :class_name => 'UserStation'
  has_many :summary_top_songs, :order => 'total_listens DESC', :class_name => 'TopSong', :include => :song
  has_many :summary_top_albums, :order => 'total_listens DESC', :class_name => 'TopAlbum', :include => :album
  has_many :summary_top_artists, :order => 'total_listens DESC', :class_name => 'TopArtist', :include => :artist
  has_many :summary_top_stations, :order => 'station_count DESC', :class_name => 'TopStation', :include => :station
  has_many :users, :foreign_key => 'entry_point_id'
  has_one :site_statistic
  has_many :campaigns
  
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