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

  has_many :summary_top_abstract_stations, :order => 'station_count DESC', :class_name => 'TopAbstractStation', :include => :station
  has_many :top_abstract_stations, :through => :summary_top_abstract_stations, :class_name => 'AbstractStation', :foreign_key => 'abstract_station_id', :source => :abstract_station, :order => 'top_abstract_stations.station_count DESC'
  has_many :summary_top_user_stations, :order => 'total_requests DESC', :class_name => 'TopUserStation', :include => :user_station
  has_many :top_user_stations, :through => :summary_top_user_stations, :class_name => 'UserStation', :foreign_key => 'user_station_id', :source => :user_station, :order => 'top_user_stations.total_requests DESC'

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
