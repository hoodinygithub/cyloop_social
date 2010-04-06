module Station::Playable
  def self.included(base)
    base.has_one :station, :as => :playable
  end

  def track_a_play
    increment!(:total_plays)
  end
end