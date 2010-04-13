# == Schema Information
#
# Table name: user_station_artists
#
#  id              :integer(4)      not null, primary key
#  user_station_id :integer(4)
#  artist_id       :integer(4)
#  album_id        :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

class UserStationArtist < ActiveRecord::Base
  include Db::Predicates::LimitedTo
  belongs_to :user_station
  belongs_to :artist
  belongs_to :album

  delegate :name, :to => :artist

end
