require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do

  describe 'on home calls' do

    describe 'with CA_EN' do

      integrate_views

      def do_get
        get :home
      end

      before do
        TopSong.delete_all
        TopArtist.delete_all
        controller.stub!( :site_code ).and_return('msncaen')

        @artists = []
        5.times do |index|
          @artists << Factory(:artist, :name => "Artist #{index}" )
        end

        @artists.each_with_index do |artist,index|
          TopArtist.create!( :artist_id => artist.id, :total_listens => (index + 1) * 10, :site_id => current_site.id )
        end

        @top_artists = current_site.summary_top_artists.limited_to(5)

        @songs = []
        5.times do |index|
          @songs << Factory(:song, :title => "Song #{index}", :artist => @artists[index - 1])
        end

        @songs.each_with_index do |song,index|
          TopSong.create!( :song_id => song.id, :total_listens => (index + 1) * 10, :site_id => current_site.id )
        end

        @top_songs = current_site.summary_top_songs.limited_to(5)

        [ :single_msn_feed, :featured_feed, :drupal_feed, :video_feed, :reviews_msn_feed, :photos_msn_feed, :blog_feed ].each do |method|
          controller.instance_eval %Q!
            def #{method} (url, size, full = true)
              TestFeedProxy.instance.#{method}( size )
            end
          !
        end

      end

      it 'asserting various behaviours as loading the feeds is very expensive, do not do this on other specs please' do
        do_get
        #assert that the process was correct
        response.should be_success

        assert_that_news_feeds_are_available
        assert_that_featured_content_is_available_and_there_are_five_items
        assert_top_songs_are_available
        assert_top_artists_are_available
        # Invasion and Detour was removed from home page
        #assert_invasion_and_detour_are_available
        assert_feed_videos_are_available
        assert_reviews_are_available
        assert_blogs_are_available
        assert_photos_are_available
        assert_msn_video_is_available

      end

      def current_site
        controller.send(:current_site)
      end

      def assert_that_news_feeds_are_available
        #assert that the feed items are there with the correct links and images
        assigns[:feed_news].each do |e|
          response.should have_tag( 'img[src=?]', e.image )
          response.should have_tag( 'a[href=?]', e.link )
        end
      end

      def assert_that_featured_content_is_available_and_there_are_five_items
        #asset that the featured content is there, they're five items and they have the correct links
        assigns[:feed_featured].size.should == 5
        assigns[:feed_featured].each do |e|
          response.should have_tag( 'a[href=?]', e.link )
        end
      end

      def assert_top_songs_are_available
        assigns[:top_songs].should == @top_songs
        @top_songs.each do |top_song|
          song = top_song.song
          path = queue_song_path(:slug => song.artist, :id => song.album, :song_id => song)
          response.should have_tag( 'div.top_songs.clearfix ul li div.title a[href=?]', path, song.title )
          response.should have_tag( 'div.top_songs.clearfix ul li div.meta a[href=?]', path, song.artist.name )
          response.should have_tag( 'div.top_songs.clearfix ul li span.count', "#{top_song.total_listens.to_s}\n                    \n                      Plays" )
        end
      end

      def assert_top_artists_are_available
        assigns[:top_artists].should == @top_artists
        @top_artists.each do |top_artist|
          artist = top_artist.artist
          response.should have_tag( 'div.top_artists.clearfix ul li div.title a[href=?]', user_path(artist), artist.name )
          response.should have_tag( 'div.top_artists.clearfix ul li span.count', "#{top_artist.total_listens.to_s}\n                    \n                      Plays" )
        end
      end

      def assert_invasion_and_detour_are_available
        response.should have_tag( 'li.clearfix.detour   a[href=?] img[src=?][alt=?]', "/detour", 'http://cm-msncanada.cyloop.com/cms/files/imagecache/310x112/DETOUR_petshopboys.jpg', 'Detour_petshopboys')
        response.should have_tag( 'li.clearfix.invasion a[href=?] img[src=?][alt=?]', "/detour", 'http://cm-msncanada.cyloop.com/cms/files/imagecache/310x112/DETOUR_petshopboys.jpg', 'Detour_petshopboys')
      end

      def assert_feed_videos_are_available
        assigns[:feed_videos].should == TestFeedProxy.instance.video_feed( 7 )
        assigns[:feed_videos].each do |video|
          link = video.link.gsub('&', '&amp;')
          response.should have_tag( 'a[href=?].song', link, video.song.strip )
          response.should have_tag( 'a[href=?].artist', link, video.artist.strip )
          response.should have_tag( 'a[href=?] img[src=?][alt=?]', link, video.image.gsub('&', '&amp;'), video.title.gsub('&', '&amp;') )
        end
      end

      def assert_reviews_are_available
        assigns[:feed_reviews].should == TestFeedProxy.instance.reviews_msn_feed(3)
        assigns[:feed_reviews].each do |review|
          response.should have_tag( 'a[href=?] img[src=?][alt=?]', review.link, review.image, review.title )
          response.should have_tag( 'a[href=?]', review.link, review.title )
        end
      end

      def assert_blogs_are_available
        assigns[:feed_blog].should == TestFeedProxy.instance.blog_feed(1)
        assigns[:feed_blog].each do |blog|
          response.should have_tag( 'li.blog span a[href=?] img[src=?][alt=?]', blog.link, blog.image, blog.title )
          response.should have_tag( 'li.blog a[href=?]', blog.link, blog.title )
        end
      end

      def assert_photos_are_available
        assigns[:feed_photos].should == TestFeedProxy.instance.photos_msn_feed( 10 )
        assigns[:feed_photos].each do |photo|
          response.should have_tag( 'div.infiniteCarousel div.wrapper ul li span a[href=?] img[src=?][alt=?]', photo.link, photo.image, photo.title )
          response.should have_tag( 'div.infiniteCarousel div.wrapper ul li div a[href=?]', photo.link, photo.title )
        end
      end

      def assert_msn_video_is_available
        response.should have_tag( 'div.module.msn_video script[src=?]', 'http://images.video.msn.com/flash/script/embed.js' )
        response.should have_tag( 'div.module.msn_video div#Player1Container' )
      end

      def assert_entertainment_is_available
        assigns[:feed_promo].should == TestFeedProxy.instance.drupal_feed( 1 ).first
        ad = assigns[:feed_promo]
        response.should have_tag( 'div.module.small_ad a[href=?] img[src=?][alt=?]', ad.url, ad.image("300x120", controller.send( :msn_site_code )), ad.title )
      end

    end

  end

end
