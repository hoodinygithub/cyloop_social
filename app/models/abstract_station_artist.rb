class AbstractStationArtist < ActiveRecord::Base
  include Db::Predicates::LimitedTo

  belongs_to :abstract_station
  belongs_to :artist
  belongs_to :album

  delegate :name, :to => :artist

end

