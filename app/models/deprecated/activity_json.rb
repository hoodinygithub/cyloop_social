require 'json'
class Cyloop
  class Deprecated
    class ActivityJson
      attr_accessor :options, :output

      def initialize(*args)
        @options = args.extract_options!
        @output = []
      end

      def read_file
        @options[:contents] = IO.read(@options[:file])
      end

      def parse_data
        if @options[:file] =~ /listen_activity/
          @options[:contents].each_line do |line|
            user_id, activity_type, item_id, time = line.split('|')
            song = Song.find(item_id, :select => 'id, file_name, label, title, artist_id, album_id')
            album = Album.find(album_id, :select => 'avatar')
            artist = Artist.find(song.artist_id, :select => 'id, slug, name')
            user = Account.find(user_id, :select => 'id, name, slug')
            @output.push([song, album, artist, user].to_json)
          end
        end
      end
    end
  end
end