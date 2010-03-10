module Song::AvailableCountries
  def self.included(base)
    base.class_eval do
      serialize :available_countries, Array
    end
  end

  def available_countries
    read_attribute(:available_countries) || write_attribute(:available_countries, nil)
  end
end
