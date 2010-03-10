class FeedManager::VideoItem < FeedManager::Abstract;

  def image
    read_attribute_only(:url) rescue ""
  end

  def title
    read_attribute(:title) rescue ""
  end

  def description
    read_attribute(:description) rescue ""
  end

  def link
    read_attribute(:link) rescue ""
  end

  def song
    self.title.split(':').last.gsub("'", '')
  end

  def artist
    self.title.split(':').first
  end

end

