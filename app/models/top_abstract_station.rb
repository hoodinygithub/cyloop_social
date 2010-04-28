# == Schema Information
#
# Table name: top_stations
#
#  id            :integer(4)      not null, primary key
#  created_at    :datetime
#  updated_at    :datetime
#  site_id       :integer(4)
#  station_id    :integer(4)
#  station_count :integer(4)
#

class TopAbstractStation < ActiveRecord::Base
  include Summary::Predicates
  include Db::Predicates::LimitedTo
  belongs_to :site
  belongs_to :abstract_station
end
