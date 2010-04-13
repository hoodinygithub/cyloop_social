xml.player :autoStart => 'yes', :canRate => '', :numResults => @playlist.items.size do
  playlist_id = @playlist.id
  songs = @playlist.songs.sort_by { rand }
  songs.each do |song|
    if song && song.artist && song.artist && song.album
      xml.song do
        xml.idsong song.id
        xml.album_id song.album.id
        xml.idpl playlist_id
        xml.idband song.artist.id
        xml.songfile "http://media.cyloop.com/storage/storage?fileName=/.elhood.com-2/usr/#{song.artist.id}/audio/#{song.file_name}"
        xml.fotofile AvatarsHelper.avatar_path( song.album, :album )
        xml.title song.title
        xml.band song.artist.name
        xml.genre(song.artist.genre ? song.artist.genre.name : '' )
        xml.album song.album.name
        xml.duration song.duration
        xml.subcategory
        xml.yearsong song.album.year
        xml.musiclabel song.music_label
        xml.partner_label (song.album.label.nil?) ? "" : song.album.label.name 
        xml.lyrics
        xml.alreadyInCollection 0
        xml.rating_total 0
        xml.profile "/#{song.artist.slug}"
        xml.userType song.artist.type
        xml.idAMG song.artist.amg_id
      end
    end
  end
end
