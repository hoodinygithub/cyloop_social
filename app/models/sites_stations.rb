class SitesStation < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :site
  belongs_to :station
  belongs_to :account

  validates_presence_of :station_id
end
