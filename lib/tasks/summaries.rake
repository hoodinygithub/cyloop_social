namespace :db do
  namespace :populate do
    desc "Calculate stats and populate summary tables"
    task :summaries => :environment do
      include Timebox
      
      connection = ActiveRecord::Base.connection
      return unless connection.respond_to? :execute
      
      tables = ['`top_songs`','`top_albums`','`top_artists`','`top_stations`']
      limit = 50
      #Truncate tables
        
      timebox("Summary tables truncated...") do
        tables.each do |t|
          connection.execute "TRUNCATE TABLE #{t}"
        end
      end
      
      
      #TopSongs
      timebox("Top Songs populated...") do
        Site.all.each do |site|
          site.most_listened_songs(limit).uniq_by do |s|
            s.artist_id
          end.each do |s|
            query = <<-EOF
            INSERT INTO top_songs(song_id, total_listens, site_id, created_at, updated_at)
            SELECT id, #{s.total_listens}, #{site.id}, now(), now() 
            FROM songs WHERE id=#{s.id};
            EOF
            connection.execute query
            #connection.execute "UPDATE top_songs SET total_listens = #{s.total_listens} WHERE id=#{s.id}"
          end      
        end
      end
      #TopAlbums
      timebox("Top Albums populated...") do
        Site.all.each do |site|        
          site.most_listened_albums(limit).uniq_by do |a|
            a.owner_id
          end.each do |a|
            query = <<-EOF
            INSERT INTO top_albums(album_id, total_listens, site_id, created_at, updated_at)
            SELECT id, #{a.total_listens}, #{site.id}, now(), now()
            FROM albums WHERE id=#{a.id};
            EOF
            connection.execute query
            #connection.execute "UPDATE top_albums SET total_listens = #{a.total_listens} WHERE id=#{a.id}"
          end      
        end      
      end
      #TopArtists
      timebox("Top Artists populated...") do
        Site.all.each do |site|
          site.most_listened_artists(limit).each do |a|
            query = <<-EOF
            INSERT INTO top_artists(artist_id, total_listens, site_id, created_at, updated_at)
            SELECT id, #{a.total_listens}, #{site.id}, now(), now()
            FROM accounts WHERE id=#{a.id};
            EOF
            connection.execute query
            #connection.execute "UPDATE top_artists SET total_listens = #{a.total_listens} WHERE id=#{a.id}"
          end      
        end      
      end      
      #TopStations
      timebox("Top Stations populated...") do
        Site.all.each do |site|
          #stations = UserStation.most_created(limit)
          site.stations.most_created(limit).each do |s|
            query = <<-EOF
            INSERT INTO top_stations(station_id, site_id, station_count, created_at, updated_at)
            SELECT id, #{site.id}, #{s.total_listens}, now(), now()
            FROM stations WHERE id=#{s.id};
            EOF
            connection.execute query
            
            #connection.execute "UPDATE top_stations SET `order` = #{total-=1} WHERE id=#{s.id}"
          end
          query = <<-EOF
          DELETE top_stations FROM top_stations
          INNER JOIN stations ON top_stations.station_id = stations.id
          INNER JOIN accounts ON stations.artist_id = accounts.id
          WHERE accounts.deleted_at IS NOT NULL 
          EOF
          connection.execute query      
        end
      end
    end
  end
end
