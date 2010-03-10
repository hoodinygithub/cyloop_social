Factory.define :city do |factory|
  factory.name "Miami"
  factory.location "Miami, Florida, United States"
  factory.association :region
end
