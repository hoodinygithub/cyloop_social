class UserStationArtist < ActiveRecord::Base
  include Db::Predicates::LimitedTo
  belongs_to :user_station
  belongs_to :artist
  belongs_to :album

  delegate :name, :to => :artist

end
