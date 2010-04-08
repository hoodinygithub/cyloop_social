module ArtistsHelper
  def artist_id_attribute(item)
    if item.is_a? RecEngine::Station
      "artist_id='#{item.artist_id}'"
    elsif item.is_a? Artist
      "artist_id='#{item.id}'"
    end
  end

  def artist_url(item)
    if item.is_a? RecEngine::Station or item.is_a? RecEngine::Artist
      item.profile_url
    elsif item.is_a? Artist
      artist_path(item.slug)
    end
  end
  
  def artist_name(item)
    if item.is_a? RecEngine::Station
      item.artist_name
    elsif item.is_a? UserStation or item.is_a? Artist
      item.name
    end
  end
end
