xml.playlists do 
  @playlists.each do |playlist|
    xml.list do
      xml.type "2"
      xml.idpl playlist.id
      xml.nom playlist.name
      xml.url playlist_path(playlist)
    end
  end
end
