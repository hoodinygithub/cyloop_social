class TopUserStation < ActiveRecord::Base
  include Summary::Predicates
  belongs_to :site
  belongs_to :user_station
end
