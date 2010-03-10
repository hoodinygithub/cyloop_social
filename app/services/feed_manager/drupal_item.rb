class FeedManager::DrupalItem < FeedManager::Abstract
  #reader :link, :text, :title, :enclosure, :description

  def image(size, site)
    image_path(size, site) + read_image_attribute("description/image").to_s rescue ""
  end

  def img_ca
    read_attribute_only(:url)
  end

  def text
    read_attribute('description/body')
  end

  def artist(with_source=false)
    title  = read_attribute('title')
    if with_source
      source = read_attribute('description/source')
      unless source.blank?
        return "#{title} - #{source}"
      end
    end
    title
  end

  def link
    read_attribute('description/link')
  end

  def url
    read_attribute('link')
  end

  protected

    def image_path(size, site)
      "http://cm-msn#{site}.cyloop.com/cms/files/imagecache/#{size}/"
    end

end

