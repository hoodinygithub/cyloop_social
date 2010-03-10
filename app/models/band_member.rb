# == Schema Information
#
# Table name: band_members
#
#  id         :integer(4)      not null, primary key
#  artist_id  :integer(4)
#  name       :string(255)
#  instrument :string(255)
#  bio        :text
#  created_at :datetime
#  updated_at :datetime
#

class BandMember < ActiveRecord::Base
  belongs_to :artist
  index :artist_id
end
