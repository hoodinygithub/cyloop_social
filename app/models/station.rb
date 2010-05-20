# == Schema Information
#
# Table name: stations
#
#  id            :integer(4)      not null, primary key
#  available     :boolean(1)      default(TRUE), not null
#  playable_type :string(25)
#  playable_id   :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class Station < ActiveRecord::Base
  named_scope :available, :conditions => { :available => true }
  belongs_to :playable, :polymorphic => true

  has_many :station_listeners
  has_many :listeners, :through => :station_listeners, :source => :user

  delegate :name, :deleted_at, :to => :playable

  def recent_listeners(limit=3)
    listeners.all(:limit => limit, :order => 'station_listeners.updated_at DESC')
  end

  def record_a_listen_for(listener)
    listener = listener.is_a?(User) ? listener.id : listener
    if listener
      s = StationListener.find_or_create_by_station_id_and_listener_id(:station_id => id, :listener_id => listener)
      s.increment!(:total_plays)
    end
  end
  
  def avatars_cache_key
    
  end
    
end
