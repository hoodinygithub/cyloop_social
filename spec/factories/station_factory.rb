Factory.define :station do |factory|
  factory.name "Station"
  factory.association :artist
  factory.amg_id "P    34260"
  factory.available true
end

Factory.define :top_station, :class => TopStation do |factory|
  factory.association :station
  factory.station_count 1
end
