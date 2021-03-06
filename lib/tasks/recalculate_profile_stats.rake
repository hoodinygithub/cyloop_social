namespace :db do
  namespace :populate do
    desc "Update accounts cached counts column with summarized data from station_artists, profile_visits and followings"
    task :profile_stats => :environment do
      include Timebox
      
      connection = ActiveRecord::Base.connection
      return unless connection.respond_to? :execute
      
      connection.execute 'DROP TABLE IF EXISTS `_cached_song_count_updates`'
      connection.execute 'DROP TABLE IF EXISTS `_cached_following_count_updates`'
      connection.execute 'DROP TABLE IF EXISTS `_cached_visit_count_updates`'
      
      # timebox "Create temp table for song count updates..." do
      #   query = <<-EOF
      #   CREATE TABLE `_cached_song_count_updates` (
      #     `id` int(11),
      #     `song_play_count` int(11) DEFAULT 0,
      #     `total_listen_count` int(11) DEFAULT 0,
      #     PRIMARY KEY(`id`)          
      #   ) ENGINE=InnoDB DEFAULT CHARSET=utf8
      #   EOF
      #   connection.execute query
      # end

      timebox "Create temp table for followings count updates..." do
        query = <<-EOF
        CREATE TABLE `_cached_following_count_updates` (
          `id` int(11),
          `followee_count` int(11) DEFAULT 0,
          `follower_count` int(11) DEFAULT 0,
          PRIMARY KEY(`id`)          
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8
        EOF
        connection.execute query
      end

      timebox "Create temp table for visit count updates..." do
        query = <<-EOF
        CREATE TABLE `_cached_visit_count_updates` (
          `id` int(11),
          `visit_count` int(11) DEFAULT 0,
          PRIMARY KEY(`id`)          
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8
        EOF
        connection.execute query
      end

      timebox "Update album counts for artists..." do
        ActiveRecord::Base.transaction do
          connection.execute "UPDATE accounts a SET a.total_albums = 0 WHERE a.type = 'Artist'"
          connection.execute <<-EOF
          UPDATE accounts a 
          INNER JOIN (
            SELECT owner_id, count(*) AS total_albums
            FROM albums 
            WHERE deleted_at IS NULL 
            GROUP BY 1
          ) AS q ON a.id = q.owner_id 
          SET a.total_albums = q.total_albums
          EOF
        end
      end

      timebox "Update mix counts for artists..." do
        ActiveRecord::Base.transaction do
          connection.execute "UPDATE accounts a SET a.total_playlists = 0 WHERE a.type = 'Artist'"
          connection.execute <<-EOF
          UPDATE accounts a 
          INNER JOIN (
            SELECT pi.artist_id, count(*) AS total_playlists
            FROM playlist_items pi 
            INNER JOIN playlists p ON pi.playlist_id = p.id 
            INNER JOIN accounts a ON p.owner_id = a.id 
            INNER JOIN stations ss ON p.id = ss.playable_id AND ss.playable_type = 'Playlist' 
            INNER JOIN songs s ON s.id = pi.song_id AND s.deleted_at IS NULL
            WHERE p.deleted_at IS NULL AND p.locked_at IS NULL 
            AND a.deleted_at IS NULL AND a.network_id = 1
            GROUP BY 1
          ) AS q ON a.id = q.artist_id 
          SET a.total_playlists = q.total_playlists
          EOF
        end
      end

      timebox "Update user_station counts for artists..." do
        ActiveRecord::Base.transaction do
          connection.execute "UPDATE accounts a SET a.total_user_stations = 0 WHERE a.type = 'Artist'"

          connection.execute <<-EOF
          UPDATE accounts a 
          INNER JOIN (
            SELECT abs.artist_id, count(*) AS total_user_stations 
            FROM user_stations us 
            INNER JOIN abstract_stations abs ON us.abstract_station_id = abs.id 
            WHERE us.deleted_at IS NULL AND abs.deleted_at IS NULL
            GROUP BY 1
          ) AS q ON a.id = q.artist_id 
          SET a.total_user_stations = q.total_user_stations
          EOF
          
        end
      end

      timebox "Update mix counts for users..." do
        ActiveRecord::Base.transaction do
          connection.execute "UPDATE accounts a SET a.total_playlists = 0 WHERE a.type = 'User' AND a.network_id = 1"
          connection.execute <<-EOF
          UPDATE accounts a 
          INNER JOIN (
            SELECT p.owner_id, count(*) AS total_playlists
            FROM playlists p 
            INNER JOIN accounts a ON p.owner_id = a.id 
            INNER JOIN stations s ON p.id = s.playable_id AND s.playable_type = 'Playlist' 
            WHERE a.deleted_at IS NULL 
            AND p.deleted_at IS NULL 
            AND p.locked_at IS NULL 
            AND a.network_id = 1
            GROUP BY 1
          ) AS q ON a.id = q.owner_id 
          SET a.total_playlists = q.total_playlists
          EOF
        end
      end
 
      timebox "Update user_station counts for users..." do
        ActiveRecord::Base.transaction do
          connection.execute "UPDATE accounts a SET a.total_user_stations = 0 WHERE a.type = 'User' AND a.network_id = 1"
          connection.execute <<-EOF
          UPDATE accounts a 
          INNER JOIN (
            SELECT owner_id, count(*) AS total_user_stations 
            FROM user_stations 
            WHERE deleted_at IS NULL 
            GROUP BY 1
          ) AS q ON a.id = q.owner_id 
          SET a.total_user_stations = q.total_user_stations
          EOF
        end
      end

      # timebox "Calculate and insert user song play counts into temp table..." do
      #   query = <<-EOF
      #   INSERT INTO `_cached_song_count_updates`(`id`, `song_play_count`, `total_listen_count`)
      #   SELECT s.listener_id, sum(s.total_listens), 0 FROM `song_listens` s
      #   INNER JOIN `accounts` a on s.listener_id = a.id
      #   INNER JOIN `songs` sg on s.song_id = sg.id
      #   WHERE a.type = 'User' AND sg.deleted_at IS NULL
      #   GROUP BY 1
      #   EOF
      #   connection.execute query
      # end

      # timebox "Calculate and insert artist song listen counts into temp table..." do
      #   query = <<-EOF
      #   INSERT INTO `_cached_song_count_updates`(`id`, `song_play_count`, `total_listen_count`)
      #   SELECT s.artist_id, 0, sum(s.total_listens) FROM `song_listens` s
      #   INNER JOIN `accounts` a on s.artist_id = a.id
      #   INNER JOIN `songs` sg on s.song_id = sg.id
      #   WHERE a.type = 'Artist' AND sg.deleted_at IS NULL
      #   GROUP BY 1
      #   EOF
      #   connection.execute query
      # end


      timebox "Calculate and insert followings counts into temp table..." do
        query = <<-EOF
        INSERT INTO `_cached_following_count_updates`(`id`, `follower_count`, `followee_count`)
        SELECT a.id, (SELECT count(*) FROM followings INNER JOIN accounts a2 ON follower_id = a2.id WHERE followee_id = a.id and approved_at IS NOT NULL AND a2.deleted_at IS NULL) AS follower_count, (SELECT count(*) FROM followings INNER JOIN accounts a2 ON followee_id = a2.id WHERE follower_id = a.id and approved_at IS NOT NULL AND a2.deleted_at IS NULL) AS followee_count FROM `accounts` a
        WHERE a.type = 'User' 
        EOF
        connection.execute query
      end

      timebox "Calculate and insert visit counts into temp table..." do
        query = <<-EOF
        INSERT INTO `_cached_visit_count_updates`(`id`, `visit_count`)
        SELECT owner_id, sum(total_visits) AS visit_count FROM `profile_visits` 
        GROUP BY 1
        EOF
        connection.execute query
      end

      # timebox "Update song counts in accounts..." do
      #   query = <<-EOF
      #   UPDATE `accounts` a
      #   INNER JOIN `_cached_song_count_updates` t ON a.id = t.id 
      #   SET a.song_play_count = t.song_play_count, a.total_listen_count = t.total_listen_count
      #   EOF
      #   connection.execute query
      # end

      timebox "Update followings counts in accounts..." do
        query = <<-EOF
        UPDATE `accounts` a
        INNER JOIN `_cached_following_count_updates` t ON a.id = t.id 
        SET a.follower_count = t.follower_count, a.followee_count = t.followee_count
        EOF
        connection.execute query
      end

      timebox "Update visit counts in accounts..." do
        query = <<-EOF
        UPDATE `accounts` a
        INNER JOIN `_cached_visit_count_updates` t ON a.id = t.id 
        SET a.visit_count = t.visit_count
        EOF
        connection.execute query
      end

      timebox "Cleanup..." do
        connection.execute 'DROP TABLE IF EXISTS `_cached_song_count_updates`'
        connection.execute 'DROP TABLE IF EXISTS `_cached_following_count_updates`'
        connection.execute 'DROP TABLE IF EXISTS `_cached_visit_count_updates`'
      end
    end
  end
end
