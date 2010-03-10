class FeedManager::CpFeedItem < FeedManager::Abstract

  def link
    read_attribute("cp:link/cp:url") rescue ""
  end

  def text
    read_attribute("cp:abstract") rescue ""
  end

  def image
    read_attribute("cp:image/cp:src").strip rescue ""
  end

  def artist
    read_attribute("cp:link/cp:text") rescue ""
  end
end

