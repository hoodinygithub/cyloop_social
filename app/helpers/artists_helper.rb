module ArtistsHelper
  def artist_id_attribute(item)
    if item.is_a? RecEngine::Station
      "artist_id='#{item.artist_id}'"
    elsif item.is_a? Artist
      "artist_id='#{item.id}'"
    end
  end

  def artist_url(item)
    item.profile_url       if item.is_a? RecEngine::Station
    artist_path(item.slug) if item.is_a? Artist
  end
  
  def artist_name(item)
    if item.is_a? RecEngine::Station
      item.artist_name
    elsif item.is_a? UserStation or item.is_a? Artist
      item.name
    end
  end
end
