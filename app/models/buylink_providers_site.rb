class BuylinkProvidersSite < ActiveRecord::Base
  has_many :song_buylinks, :foreign_key => "buylink_provider_id"

  belongs_to :buylink_provider
  belongs_to :site
  belongs_to :country
end
