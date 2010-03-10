namespace :db do
  desc "Update accounts cached counts column with summarized data from song_listens, profile_visits and followings"
  task :update_playlist_song_counter => :environment do
    include Timebox
    
    connection = ActiveRecord::Base.connection
    return unless connection.respond_to? :execute

    timebox "Updating playlist songs counter..." do
      query = <<-EOF
      UPDATE `playlists` SET songs_count = (
        SELECT 
          count(`playlist_items`.id) FROM `playlist_items` INNER JOIN `songs` ON `songs`.id = `playlist_items`.song_id 
        WHERE `playlist_items`.playlist_id = `playlists`.id and `songs`.deleted_at IS NULL
      )
      EOF
      connection.execute query
    end
  end
end
