xml.buylinks do
  @buylinks.each do |buylink|
    xml.buylink do 
      xml.type buylink.buylink_provider.name
      xml.url buylink.url
      xml.store_image "/images/" + buylink.buylink_provider.store_image
    end
  end
end
