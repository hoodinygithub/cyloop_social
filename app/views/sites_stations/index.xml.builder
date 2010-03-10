xml.stations do 
  @station_playlists.each do |station_playlist|
    xml.station do
      xml.type "msn"
      xml.idpl station_playlist.station_id
      xml.name station_playlist.playlist.name
      xml.station_url "#{sites_station_path(station_playlist.id)}.xml"
    end
  end
end
