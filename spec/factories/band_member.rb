Factory.define :band_member do |factory|
  factory.name "Axl Rose"
  factory.instrument "Vocals"
  factory.bio "A rock legend."
  factory.association :artist, :factory => :artist
end
