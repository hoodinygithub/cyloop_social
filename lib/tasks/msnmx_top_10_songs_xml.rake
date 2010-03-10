namespace :db do
  namespace :output do
    desc "Output Top 10 artists for MSNMX as XML for Prodigy MSN homepage."
    task :msnmx_top_10_xml => :environment do
      include Timebox
      
      output_path = ENV.has_key?('xml_output_path') ? ENV['xml_output_path'] : '/shared/common/system/db/xml/feed_top_songs_MSN.xml'
      
      timebox "XML File Created..." do        
        write_msnmx_xml(output_path)
      end    
      
    end
  
    def write_msnmx_xml(path)
      artists = Site.find(10).summary_top_artists.limited_to(10)
      file = File.open(path, 'w')

      top_song = nil
      xml = Builder::XmlMarkup.new(:target => file, :indent => 2)

      xml.instruct!
      
      xml.CONTENT do
        artists.each do |s|              
          top_artist = s.artist
          xml.CONTENTITEM do
            xml.DATA do
              xml.TEXT top_artist.name
              xml.URL "http://prodigy.msn.cyloop.com/#{top_artist.slug}"
              xml.FORMAT 0
            end
          end
        end
      end        
    end
  end
end
