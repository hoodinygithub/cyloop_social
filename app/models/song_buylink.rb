# == Schema Information
#
# Table name: song_buylinks
#
#  id                  :integer(4)      not null, primary key
#  song_id             :integer(4)
#  buylink_provider_id :integer(4)
#  url                 :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class SongBuylink < ActiveRecord::Base
  belongs_to :buylink_provider
  belongs_to :song
end
