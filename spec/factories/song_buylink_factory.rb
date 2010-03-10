Factory.define :buylink_provider do |factory|
  factory.name "Provider"
  factory.store_image 'sample.jpg'
end

Factory.define :buylink_providers_site do |factory|
  factory.association :country
  factory.association :buylink_provider
  factory.site { Site.find_by_name('Cyloop') }  
end

Factory.define :album_buylink do |factory|
  factory.association :buylink_provider
  factory.association :album
end

Factory.define :song_buylink do |factory|
  factory.association :song
  factory.association :buylink_provider
  factory.url "http://test.host"
end