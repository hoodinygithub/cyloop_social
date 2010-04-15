module AlbumsHelper

  def album_contains(item, limit=3)
    album_artists = item.album_artists.limited_to(limit)

    content = ""

    album_artists.in_groups_of(2).each do |artists_groups|
      puts artist_groups
      artists_groups.each do |album_artist|
        links << content_tag(:li, link_to(album_artist.artist.name, artist_path(album_artist.artist)))
      end
      content << content_tag(:ol, links) 
    end

    "#{t('basics.contains')}:
    <div class=\"album_wrapper\">
      #{content}
    </div>"
  end

end
