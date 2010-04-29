# == Schema Information
#
# Table name: abstract_station_artists
#
#  id                  :integer(4)      not null, primary key
#  abstract_station_id :integer(4)
#  artist_id           :integer(4)
#  album_id            :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

class AbstractStationArtist < ActiveRecord::Base
  include Db::Predicates::LimitedTo
  belongs_to :abstract_station
  belongs_to :artist
  belongs_to :album

  delegate :name, :to => :artist, :allow_nil => true
end

