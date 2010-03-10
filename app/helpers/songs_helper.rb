module SongsHelper

  def show_duration(song)
    return "<span class=\"duration_time\">#{seconds_to_duration(song.duration)}</span>" if song && (song.available_countries.nil? || song.can_play_full?(current_country))
    show_sample_flag(song).to_s 
  end
  
  def show_sample_flag(s)
    song = s.is_a?(Song) ? s : Song.find(s) rescue nil
    if song && !song.available_countries.nil? && (song.available_countries.empty? || !song.can_play_full?(current_country))
        link_to '', sample_flag_desc_path(), :class => "facebox sample_flag"
    end
  end

  def has_buylink?( item )
    item && item.buylink_count == 1 && site_includes(:msnbr)
  end

  def add_to_playlist_button(song)
    link = if logged_in?
      link_to '', new_artist_song_playlist_item_path(song.artist, song), :class => "facebox add", :title => t('actions.add_song_to_playlist')
    else
      link_to '', add_song_registration_layers_path(:return_to => new_artist_song_playlist_item_path(song.artist, song)), :class => "facebox add", :title => t('actions.add_song_to_playlist')    
    end
    content_tag(:div, link, :class => "add")
  end

end