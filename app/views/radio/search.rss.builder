xml.instruct! :xml, :version=>"1.0"
xml.rss(:version => "2.0") do
  xml.channel do
    xml.title(@station['name'])
    xml.link(radio_url(:station_id => @station.id, :queue => true))
    xml.image avatar_for(@station.artist, :tiny)
    xml.description "#{t("basics.contains")}: #{@station.includes.map(&:name).join(", ")}"
    xml.language "en-us"
    xml.copyright "cyloop"


    @station.includes.each do |related_artist|
      xml.item do
        xml.title "#{t("basics.contains")}: #{related_artist.name}"
        xml.description "#{link_to(avatar_for(related_artist.artist, :tiny), artist_url(related_artist.artist))} #{related_artist.name}"
        xml.category "Related Artist" 
        xml.link artist_url(related_artist)
        xml.guid artist_url(related_artist)
      end
    end
  end
end
