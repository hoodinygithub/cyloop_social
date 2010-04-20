require 'open-uri'
require 'timeout'

class FeedManager

  class ResponseError < RuntimeError
  end

  def initialize(site, feed, full = false)
    @site = site.to_s
    @feed = feed
    @BASE_URI = 'public/feeds'
    @url = (full) ? feed : build_uri()
  end

  def build_uri
    File.join(Rails.root,@BASE_URI,@site,"#{@feed}.xml")
  end

  def get
    begin
      Timeout::timeout(6) do
        body = open(@url.to_s).read
        Nokogiri::XML.parse(body)
      end
    rescue Timeout::Error => e
      if Rails.env.staging? || Rails.env.production?
        HoptoadNotifier.notify(
          :error_class => e.class.name,
          :error_message => "Feed Loading error - #{e.message}",
          :backtrace => e.backtrace,
          :request => { :params => { :url => @url.to_s } })
      end
      []
    end
  end

  def get_items(key, kind, limit = nil)
    begin
      items = if key.blank?
        get.xpath("//channel/item")
      else
        get.xpath("/rss/channel/item[category='#{key}']")
      end
      items = limit.nil? ? items.to_a : items.to_a[0,limit]
      items.map { |x| kind.new(x) }
    rescue => e
      HoptoadNotifier.notify(
        :error_class => e.class.name,
        :error_message => "Feed Loading error - #{e.message}",
        :backtrace => e.backtrace,
        :request => { :params => { :key => key, :kind => kind, :limit => limit, :url => @url.to_s } })
      []
    end
  end
  
  def get_cp_items
    items = get
    if items.blank?
      []
    else
      items.xpath("//cp:linkimageabstract")
    end
  end
  
  def get_mixed_msn_feed(limit = nil, key = nil)
    get_items(key, FeedManager::FeedItem, limit)
  end
  
  def get_single_msn_feed(limit = nil)
    get_items(nil, FeedManager::FeedItem, limit)
  end
  
  def get_reviews_msn_feed(limit = nil)
    get_items(nil, FeedManager::ReviewItem, limit)
  end
  
  def get_photos_msn_feed(limit = nil)
    get_items(nil, FeedManager::PhotoItem, limit)
  end
  
  def get_single_msn_cp_feed(limit = nil)
    get_cp_items.to_a[0,limit].map { |i| FeedManager::CpFeedItem.new(i) }
  end
  
  def get_drupal_feed(limit = nil, key=nil)
    get_items(key, FeedManager::DrupalItem, limit)
  end
  
  def get_video_feed(limit = nil, key=nil)
    get_items(key, FeedManager::VideoItem, limit)
  end
  
  def get_blog_feed(limit = nil, key=nil)
    get_items(key, FeedManager::BlogItem, limit)
  end
  
  def get_featured_feed(limit = nil, key=nil)
    get_items(key, FeedManager::FeaturedItem, limit)
  end
end
