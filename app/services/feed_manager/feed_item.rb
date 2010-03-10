class FeedManager::FeedItem < FeedManager::Abstract
  reader :link, :title, :description, :url

  def text
    read_title_src_from(:description) rescue ""
  end

  def artist
    read_artist_src_from(:description) rescue ""
  end

  def image_from_description
    "http://msn.skolbeats.com.br/#{read_image_src_from(:description)}"
  end

  def image
    read_attribute_only(:url) rescue ""
  end

  def alt
    read_attribute(:title) rescue ""
  end

  def description
    read_attribute(:description) rescue ""
  end

end

