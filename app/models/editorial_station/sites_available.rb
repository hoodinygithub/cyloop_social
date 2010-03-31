module EditorialStation::SitesAvailable
  
  def self.included(base)
    base.class_eval do
      serialize :sites_available, Array
    end
  end

  def sites_available
    read_attribute(:sites_available) || write_attribute(:sites_available, [])
  end
end