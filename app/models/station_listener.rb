class StationListener < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'listener_id'
  belongs_to :station

end
