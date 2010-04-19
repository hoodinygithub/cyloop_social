class EditorialStationsSite < ActiveRecord::Base
  belongs_to :site
  belongs_to :editorial_station
end
