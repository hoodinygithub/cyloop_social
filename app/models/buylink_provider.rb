# == Schema Information
#
# Table name: buylink_providers
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  store_image :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class BuylinkProvider < ActiveRecord::Base
  has_many :song_buylinks
  has_many :songs, :through => :song_buylinks
end
