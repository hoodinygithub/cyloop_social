module SongCollection

  def total_time
    songs.inject(0.seconds) { |seconds, song| seconds += song.duration || 0 }
  end
  
end
