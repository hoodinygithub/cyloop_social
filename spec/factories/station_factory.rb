Factory.define :station do |factory|
  # factory.name "Station"
  # factory.association :artist
  # factory.amg_id "P    34260"
  factory.available true
end

Factory.define :abstract_station do |factory|
  factory.name "Station"
  factory.association :artist, :factory => :artist
  factory.amg_id "P    34260"
  # factory.available true
end

Factory.define :top_station, :class => TopAbstractStation do |factory|
  factory.association :abstract_station, :factory => :abstract_station
  factory.station_count 1
end
