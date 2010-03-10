namespace :activity do

  desc "Port tyrant activity to new format"
  task :port_tyrant_format => :environment do
    old_db = Rufus::Tokyo::Tyrant.new(TYRANT_CONFIG[:host], TYRANT_CONFIG[:port])
    new_db = Rufus::Tokyo::TyrantTable.new(TWITTER_CONFIG[:ttserver_host], TWITTER_CONFIG[:ttserver_port])
    old_keys = old_db.keys
    i = 0
    old_keys.select{|k| k =~ /mine$/}.each do |k|
      activity = old_db[k]
      # activity.split(/(\w+)\\000(.*?)/)
      activity.gsub!(/\000/,"\n")
      vars = activity.split(/\n/)
      vars.in_groups_of(2).each do |k,v|
        item = JSON.parse v
        tyrant_key = [item['user_id'], k]
        item_hash = Hash.new
        ["timestamp", "gender", "type"].each do |activity_attribute|
          item_hash[activity_attribute] = item['activity'][activity_attribute]
        end
        ["user_id", "song_id", "artist_id"].each do |root_attribute| 
          item_hash[root_attribute] = item[root_attribute]
        end
        if k == 'listen'
          ["name", "slug", "label_name", "id"].each do |artist_attribute|
            item_hash["artist_#{artist_attribute}"] = item['artist'][artist_attribute]
          end
          ["avatar_file_name", "id"].each do |album_attribute|
            item_hash["album_#{album_attribute}"] = item['activity']['album'][album_attribute]
          end
          ["name", "slug", "id"].each do |user_attribute|
            item_hash["user_#{user_attribute}"] = item['activity']['user'][user_attribute]
          end
          ["title", "id", "file_name", "genre_name"].each do |song_attribute|
            item_hash["song_#{song_attribute}"] = item['activity']['item'][song_attribute]
          end
        end
        if k == 'station'
          st = UserStation.find item['station_id']
          
          ['name', 'id', ]
          ['name', 'slug']
        end
        if k == 'playlist'
          
        end
        new_db[key] = item_hash
      end
      i += 1
      break if i == 1      
    end
  end
  
  desc "Removing all activity files for all users"
  task :clear do
    user = ENV.has_key?('user') ? ENV['user='] : nil
    puts "Removing #{(user.nil?)?'ALL USERS':'USER('+user+')\'s'} activity feeds..."
    if ['staging','production'].include?Rails.env
      `rm -rf #{File.join(Rails.root,'log','activity_feeds',user.to_s)}*`
    else
      `rm -rf #{File.join(Rails.root,'log', Rails.env,'activity_feeds',user.to_s)}*`
    end
    puts "Completed!"
  end

end
