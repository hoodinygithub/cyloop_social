class UserStationArtist < ActiveRecord::Base
  belongs_to :user_station
  belongs_to :artist
  belongs_to :album

  delegate :name, :to => :artist

  named_scope :limited_to, lambda { |*num| { :limit => num.flatten.first || 10 } }  
end
