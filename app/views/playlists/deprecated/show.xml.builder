xml.player :autoStart => 'yes', :canRate => '' do
  songs = @playlist.items.sort_by { rand }
  songs.each do |item|
    if item.song && item.song.album
      xml.song do
        xml.idsong item.song_id
        xml.idpl item.playlist_id
        xml.idband item.artist.id
        xml.songfile "http://media.cyloop.com/storage/storage?fileName=/.elhood.com-2/usr/#{item.song.artist.id}/audio/#{item.song.file_name}"
        xml.fotofile AvatarsHelper.avatar_path( item.song.album, :album )
        xml.title item.song.title
        xml.band item.artist.name
        xml.genre(item.artist.genre ? item.artist.genre.name : '' )
        xml.album item.song.album.name
        xml.duration item.song.duration
        xml.subcategory
        xml.yearsong item.song.album.year
        xml.musiclabel item.song.label
        xml.lyrics
        xml.alreadyInCollection 0
        xml.rating_total 0
        xml.profile "/#{item.artist.slug}"
        xml.userType item.artist.type
        xml.idAMG item.artist.amg_id
      end
    end
  end
end
