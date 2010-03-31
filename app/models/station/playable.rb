module Station::Playable
  def self.included(base)
    base.has_one :station, :as => :playable
  end
end