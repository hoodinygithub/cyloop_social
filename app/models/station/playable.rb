module Station::Playable
  def self.included(base)
    base.has_one :station, :as => :playable
  end

  def track_a_play_for(user)
    if user
      self.station.record_a_listen_for user
    end
    increment!(:total_plays)
  end
end