module AlbumsHelper

  def album_contains(item, limit=11, show_more = true)

    more_flag = show_more ? item.album_artists.size > limit : false
    album_artists = item.album_artists.limited_to(limit)
    album_artist_groups = album_artists.in_groups_of(6)

    content = ""
    counter = 1

    album_artist_groups.each do |album_artist_group|
      links = []
      album_artist_group.collect do |album_artist|
        links << content_tag(:li, link_to(album_artist.artist.name, artist_path(album_artist.artist))) if album_artist
      end
      links << content_tag(:li, t('basics.and_more')) if more_flag && album_artist_group == album_artist_groups.last
      list  = content_tag(:ol, links, :start => counter)
      counter += album_artist_group.count
      content << content_tag(:div, list, :class => "column_wrapper")
    end

    "#{content}"
  end

end
