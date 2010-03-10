

class TestFeedManager < FeedManager

  def initialize(contents)
    self.body = contents
  end

  def body=( contents )
    @body = Nokogiri::XML.parse( contents )
  end

  def get
    @body
  end

end

class TestFeedProxy

  include Singleton

  def read_feed_file( filename )
    IO.read(File.join( RAILS_ROOT, 'spec', 'files', "#{filename}.xml" ))
  end

  [ :single_msn_feed, :featured_feed, :drupal_feed, :video_feed, :reviews_msn_feed, :photos_msn_feed, :blog_feed ].each do |m|
    class_eval %Q!
      def #{m}( size )
        @_#{m} ||= TestFeedManager.new( read_feed_file( '#{m}' ) ).get_#{m}
        @_#{m}[0, size]
      end
    !
  end

end