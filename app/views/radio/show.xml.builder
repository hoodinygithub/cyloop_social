xml.player :autoStart => 'yes', :canRate => '', :numResults => @songs.size do
  if @station.is_a? EditorialStation    
    @songs.sort_by { rand }.each do |song|
      if song && song.artist
        xml.song do
          xml.idsong song.id
          xml.album_id song.album.id
          xml.idpl @station.id
          xml.idband song.artist.id
          xml.songfile "http://media.cyloop.com/storage/storage?fileName=/.elhood.com-2/usr/#{song.artist.id}/audio/#{song.file_name}"
          xml.fotofile AvatarsHelper.avatar_path( song.album, :album )
          xml.title song.title
          xml.band song.artist.name
          xml.genre(song.artist.genre ? song.artist.genre.name : '' )
          xml.album song.album.name
          xml.duration song.duration
          #xml.subcategory
          xml.yearsong song.album.year
          xml.musiclabel song.label
          xml.partner_label (song.album.label.nil?) ? "" : song.album.label.name 
          #xml.lyrics
          #xml.alreadyInCollection 0
          #xml.rating_total 0
          xml.profile "/#{song.artist.slug}"
          #xml.userType artist.type
          xml.idAMG song.artist.amg_id
        end
      end
    end
  else
    @songs.each do |song|
      xml.song do
        xml.idsong song.id
        xml.title song.title
        xml.band song.artist
        xml.genre song.genre
        xml.album song.album
        xml.duration song.duration
        #xml.category song.category
        #xml.subcategory song.subcategory
        xml.yearsong song.song_year
        xml.musiclabel song.label
        xml.partnerlabel song.partner_label
        #xml.userType song.user_type
        #xml.lyrics song.lyrics
        xml.songfile song.song_file
        #xml.candownload song.can_download
        #xml.alreadyInCollection song.already_in_collection
        #xml.tocada song.total_plays
        #xml.rating song.rating
        xml.fotofile song.image
        #xml.rating_total song.total_rating
        xml.idband song.artist_id
        xml.profile song.folder_name_url
        xml.idpl #song.collection
        xml.idAMG song.artist_amg_id
      end
    end
  end
end