class FeedManager::FeaturedItem < FeedManager::Abstract
  #reader :link, :text, :title, :enclosure, :description
  
  def image(size, site)
    read_attribute_only(:url) rescue ""
  end
  
  def text
    read_attribute(:description) rescue ""
  end
  
  def artist(with_source=false)
    read_attribute(:title) rescue ""    
  end 
  
  def link
    read_attribute(:link) rescue ""
  end
  
  def url
   read_attribute(:link) rescue ""
  end

  protected

    def image_path(size, site)
      "http://cm-msn#{site}.cyloop.com/cms/files/imagecache/#{size}/"
    end

end
