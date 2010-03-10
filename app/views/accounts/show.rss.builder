xml.instruct!
xml.rss :version => '2.0', 'xmlns:activity' => 'http://activitystrea.ms/spec/1.0/' do
  xml.channel do
    xml.title( "#{profile_account}'s Feed" )
    xml.link( artist_url( profile_account.slug ) )
    unless @activities.blank?

      xml.pubDate( Time.at(@activities.first["timestamp"].to_i).utc.strftime("%a, %d %b %Y %H:%M:%S %z") )

      @activities.each do |activity|
        time = Time.at(activity["timestamp"].to_i)
        time_ago = " " << t("basics.created_at", :when => distance_of_time_in_words_to_now( time ))
        contents = case activity['type']
        when 'listen'
          song = activity['record']
          { :link => queue_song_path(:slug => activity["artist"]["slug"], :id => song.album, :song_id => song),
            :title => t('activity.listened_to', :song => song, :artist => activity['artist']['name'] ),
            :description => t('activity.listened_to',
              :song => link_to(song, queue_song_path(:slug => activity["artist"]["slug"], :id => song.album, :song_id => song) ),
              :artist => link_to(activity['artist']['name'], artist_url( activity['artist']['slug'] ) ) ) << time_ago
          }
        when 'station'
          user_station = activity['record']
          { :link => radio_url( :id => user_station.id ),
            :title => t('activity.created_station', :station => activity["item"]["name"] ),
            :description => %W!
              #{t('activity.created_station', :station => link_to( activity["item"]["name"], radio_url( :id => user_station.id ) )  )}
              #{time_ago}. &nbsp;
              #{t('basics.contains')}: &nbsp;
              #{activity["item"]["artists_contained"].map { |k| link_to(k['artist'], artist_url(:slug => k["slug"]))}.join(', ')}
            !
          }
        when 'playlist'
          playlist = activity['record']
          { :link => user_playlist_url( :id => playlist, :slug => activity['owner']['slug'] ),
            :title => t('activity.created_playlist', :playlist => activity["item"]["name"] ),
            :description => %W!
              #{t('activity.created_playlist', :playlist => link_to( activity["item"]["name"], user_playlist_url( :id => playlist, :slug => activity['owner']['slug'] ) ) )}
              #{time_ago}. &nbsp;
              #{t('basics.contains')}: &nbsp;
              #{activity["item"]["artists_contained"].map { |k| link_to(k['artist'], artist_url(:slug => k["slug"]))}.join(', ')}
            !
          }
        end

        xml.item do

          author = profile_account

          if profile_account.artist?
            contents[:title] = "#{activity["user"]["name"]} #{contents[:title]}"
            contents[:description] = "#{link_to(activity["user"]["name"], user_path(activity["user"]["slug"]))} #{contents[:description]}"
            author = activity["user"]["name"]
          end

          xml.author( author )
          xml.guid( contents[:link], :isPermalink => 'true' )
          xml.link( contents[:link] )
          xml.pubDate( time.utc.strftime("%a, %d %b %Y %H:%M:%S %z") )
          xml.title( contents[:title] << time_ago )
          xml.description( contents[:description] )
          xml.tag!( 'activity:verb', 'http://activitystrea.ms/schema/1.0/post' )
          xml.tag!( 'activity:object-type', 'http://activitystrea.ms/schema/1.0/note')
        end

      end

    end
  end
end