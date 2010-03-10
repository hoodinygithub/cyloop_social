namespace :db do
  namespace :output do
    desc "Output Top 10 songs for MSNMX as XML for Prodigy MSN homepage."
    task :top_modules_feed_rss => :environment do
      include Timebox

      feeds = ['top_songs','top_artists','top_stations']

      output_path = ENV.has_key?('xml_output_path') ? ENV['xml_output_path'] : '/shared/common/system/db/xml'

      Site.all.each do |site|
        feeds.each do |feed|
          timebox "XML File Created..." do
            `if [ -d #{output_path}/#{site.code} ]; then echo ''; else mkdir #{output_path}/#{site.code}; fi`
            write_rss_feed(feed, site, output_path)
          end
        end
      end
    end

    def write_rss_feed(feed, site, path)
      return if site.nil?
      items = []
      case feed
      when /top_songs/ then items = site.summary_top_songs.limited_to(10)
      when /top_artists/ then items = site.summary_top_artists.limited_to(10)
      when /top_stations/ then items = site.summary_top_stations.limited_to(10)
      end

      return if items.empty?


      file = File.open("#{path}/#{site.code}/feed_#{feed}_#{site.code}.xml", 'w')

      top_song = nil
      xml = Builder::XmlMarkup.new(:target => file, :indent => 2)

      xml.instruct! :xml, :version => "1.0"
      xml.rss :version => "2.0" do
        xml.channel do
          xml.title "#{site.name} #{feed} feed"
          xml.description ""
          xml.link "http://#{site.domain}"

          items.each do |s|
            title = ''
            link = ''
            img = ''

            case feed
            when /top_songs/ then
              title = "#{s.song.artist} - #{s.song.title}"
              link = "http://#{site.domain}/#{s.song.artist.slug}/albums/#{s.song.album.to_param}/#{s.song.to_param}"
              img = s.song.album.avatar_file_name.nil? ? "http://assets.cyloop.com/storage?fileName=/.elhood.com-2/usr/#{s.song.artist_id}/image/thumbnail/x46b.jpg" : s.song.album.avatar_file_name.sub(/hires/,'thumbnail')
            when /top_artists/ then
              title = "#{s.artist.name}"
              link = "http://#{site.domain}/#{s.artist.slug}"
              img = s.artist.avatar_file_name.nil? ? "http://assets.cyloop.com/storage?fileName=/.elhood.com-2/usr/#{s.artist_id}/image/thumbnail/x46b.jpg" : s.artist.avatar_file_name.sub(/hires/,'thumbnail')
            when /top_stations/ then
              title = "#{s.station.name}"
              link = "http://#{site.domain}/radio?station_id=#{s.station_id}"
              if s.station.artist.nil?
                img = "http://assets.cyloop.com/storage?fileName=/.elhood.com-2/usr/#{s.station.id}/image/thumbnail/x46b.jpg"
              elsif s.station.artist.avatar_file_name.nil?
                img = "http://assets.cyloop.com/storage?fileName=/.elhood.com-2/usr/#{s.station.artist_id}/image/thumbnail/x46b.jpg"
              else
                img = s.station.artist.avatar_file_name.sub(/hires/,'thumbnail')
              end
            end

            xml.item do
              xml.title title
              xml.description ''
              xml.pubDate Time.now.to_s(:rfc822)
              xml.link link
              xml.enclosure :url => img, :type => "image/jpeg", :length => 1
            end
          end
        end
      end
    end
  end
end