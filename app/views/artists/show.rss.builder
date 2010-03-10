xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Cyloop"
    xml.link "http://www.cyloop.com"

    @songs.each do |song|
      xml.item do
        xml.title "#{song["item"]["title"]} - #{profile_account.name}"
        xml.description "#{song["item"]["title"]} - #{profile_account.name}"
        xml.link "#{root_url}#{profile_account.slug}/albums/#{song["album"]["id"]}/#{song["item"]["id"]}-#{song["item"]["title"]}"
        xml.guid "#{root_url}#{profile_account.slug}/albums/#{song["album"]["id"]}/#{song["item"]["id"]}-#{song["item"]["title"]}"
      end
    end
  end
end
