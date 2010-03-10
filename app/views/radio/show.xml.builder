xml.player :autoStart => 'yes', :canRate => '' do
  @songs.each do |song|
    xml.song do
      xml.idsong song.id
      xml.title song.title
      xml.band song.artist
      xml.genre song.genre
      xml.album song.album
      xml.duration song.duration
      xml.category song.category
      xml.subcategory song.subcategory
      xml.yearsong song.song_year
      xml.musiclabel song.label
      xml.partnerlabel song.partner_label
      xml.userType song.user_type
      xml.lyrics song.lyrics
      xml.songfile song.song_file
      xml.candownload song.can_download
      xml.alreadyInCollection song.already_in_collection
      xml.tocada song.total_plays
      xml.rating song.rating
      xml.fotofile song.image
      xml.rating_total song.total_rating
      xml.idband song.artist_id
      xml.profile song.folder_name_url
      xml.idpl song.collection
      xml.idAMG song.artist_amg_id
    end
  end
end
