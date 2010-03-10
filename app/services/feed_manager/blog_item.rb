class FeedManager::BlogItem < FeedManager::Abstract

  def image
     self.node.children.collect{|c|c.content}.join("") =~ /<img.*src="([^"]+)"/
     $1
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


end
