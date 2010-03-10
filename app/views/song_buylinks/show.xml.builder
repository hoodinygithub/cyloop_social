xml.buylinks do
  @buylinks.each do |buylink|
    xml.buylink do 
      xml.type buylink.buylink_provider.name
      xml.url buylink.url
      xml.store_image "/images/" + buylink.store_image
    end
  end
end
