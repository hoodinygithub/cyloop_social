# == Schema Information
#
# Table name: players
#
#  id         :integer(4)      not null, primary key
#  player_key :string(255)
#  license    :string(255)
#  max_plays  :integer(4)
#  site_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Player < ActiveRecord::Base
  belongs_to :site
  has_many :campaigns

  def active_campaign
    self.campaigns.active.first
  end
end
