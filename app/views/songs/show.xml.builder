xml.player do
  xml.song do
    xml.idsong @song.id
    xml.title @song.title
    xml.artist @song.artist
    xml.album @song.album.name
    xml.image @song.album.avatar_url_path
  end
end
