# == Schema Information
#
# Table name: buylink_providers_sites
#
#  id                  :integer(4)      not null, primary key
#  buylink_provider_id :integer(4)
#  site_id             :integer(4)
#  country_id          :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

class BuylinkProvidersSite < ActiveRecord::Base
  has_many :song_buylinks, :foreign_key => "buylink_provider_id"

  belongs_to :buylink_provider
  belongs_to :site
  belongs_to :country
end
