# == Schema Information
#
# Table name: top_user_stations
#
#  id              :integer(4)      not null, primary key
#  site_id         :integer(4)
#  user_station_id :integer(4)
#  total_requests  :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

class TopUserStation < ActiveRecord::Base
  include Db::Predicates::LimitedTo
  include Summary::Predicates
  belongs_to :site
  belongs_to :user_station
end
