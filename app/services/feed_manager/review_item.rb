class FeedManager::ReviewItem < FeedManager::Abstract

  def title
    read_attribute("title") rescue ""
  end

  def link
    read_attribute("link") rescue ""
  end

  def image
    read_attribute_only(:url) rescue ""
  end

  def url
    read_attribute("url") rescue ""
  end

  def description
    read_attribute("description").strip rescue ""
  end

end

