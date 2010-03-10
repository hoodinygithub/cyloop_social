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

class TopStation < ActiveRecord::Base
  include Summary::Predicates
  belongs_to :site
  belongs_to :station, :foreign_key => :station_id
end
