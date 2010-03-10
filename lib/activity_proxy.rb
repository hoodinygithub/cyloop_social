class ActivityProxy < BlankSlate
  
  class NewWriter
    def initialize(user, item, timestamp=Time.now.to_i.to_s, type = 'listen')
      @timestamp = timestamp
      @type = type
      @user = user
      @item = item 
    end
    
    def to_h
      hash = HashWithIndifferentAccess.new
      user, item = HashWithIndifferentAccess.new, HashWithIndifferentAccess.new
      hash[:timestamp] = @timestamp
      hash[:type] = @type
      hash[:gender] = (@user.artist?) ? "artist" : @user.gender
      hash[:account_id] = @user.id
      [:id, :name, :slug].each{|k| hash["user_#{k}"] = @user[k] }
      
      case @type
      when "listen" then
        artist, album = HashWithIndifferentAccess.new, HashWithIndifferentAccess.new
        [:id, :title, :file_name, :genre_name].each{|k| hash["item_#{k}"] = @item[k] }
        [:id, :name, :slug, :label_name].each{|k| hash["artist_#{k}"] = @item.artist[k] rescue nil }
        hash["album_id"] = @item.album_id
        hash["album_avatar_file_name"] = @item.try(:album).try(:avatar_with_default).try(:instance).try(:avatar_file_name)
      when "playlist" then
        owner = HashWithIndifferentAccess.new
        [:id, :name, :created_at, :songs_count, :total_time].each { |k| hash["item_#{k}"] = @item[k] }
        hash["item_artists_contained"] = @item.artists_contained(:random => true, :limit => 4).map { |k| {:artist => k.try(:name), :slug => k.try(:slug) } }.to_json rescue ''
        [:id, :name, :slug, :avatar_file_name].each { |k| hash["owner_#{k}"] = @item.owner[k] }
      when "station" then
        station = Station.find(@item.id)
        [:id, :name, :created_at].map { |k| hash["item_#{k}"] = @item[k] }
        hash["item_avatar_file_name"] = station.artist.try(:avatar_file_name)
        hash["item_artists_contained"] = station.includes.map { |k| {:artist => k.name, :slug => k.slug} }.to_json
      end

      # hash[:item] = item
      hash.stringify_keys
    end
  end

  class Writer

    def initialize(user, item, timestamp=Time.now.to_i.to_s, type = 'listen')
      @timestamp = timestamp
      @type = type
      @user = user
      @item = item 
    end

    def to_hash
      hash = HashWithIndifferentAccess.new
      user, item = HashWithIndifferentAccess.new, HashWithIndifferentAccess.new
      hash[:timestamp] = @timestamp
      hash[:type] = @type
      hash[:gender] = (@user.artist?) ? "artist" : @user.gender

      [:id, :name, :slug].map { |k| user[k] = @user[k] }
      hash[:user] = user

      case @type
      when "listen" then
        artist, album = HashWithIndifferentAccess.new, HashWithIndifferentAccess.new
        [:id, :title, :file_name, :genre_name].map { |k| item[k] = @item[k] }
        [:id, :name, :slug, :label_name].map { |k| artist[k] = @item.artist[k] rescue nil }
        hash[:artist] = artist
        [:id].map { |k| album[k] = @item.album[k] }
        album[:avatar_file_name] = @item.album.avatar_with_default.instance.avatar_file_name
        hash[:album] = album
      when "playlist" then
        owner = HashWithIndifferentAccess.new
        [:id, :name, :created_at, :songs_count, :total_time].map { |k| item[k] = @item[k] }
        item[:artists_contained] = @item.artists_contained(:random => true, :limit => 4).map { |k| {:artist => k.name, :slug => k.slug } }
        [:id, :name, :slug, :avatar_file_name].map { |k| owner[k] = @item.owner[k] }
        hash[:owner] = owner
      when "station" then
        station = Station.find(@item.id)
        [:id, :name, :created_at].map { |k| item[k] = @item[k] }
        item[:avatar_file_name] = station.artist.avatar_file_name
        item[:artists_contained] = station.includes.map { |k| {:artist => k.name, :slug => k.slug} }
      end

      hash[:item] = item
      hash
    end

    def serialize
      to_hash.to_json rescue nil
    end

    def get_json
      JSON.parse(serialize)
    end
  end
  
  class Reader
    def initialize(line)
      @activity_line = line
    end
    
    def line
      @activity_line.split("|>")[0]
    end
    
    def feed_type
      yason["type"]
    end
    
    def seconds
      yason["timestamp"].to_i
    end
    
    def yason
      JSON.parse(line)
    end
    
    def valid_yason
      (valid?) ? yason : nil
    end
    
    def valid?
      !@activity_line.index("|>").nil?
    end
  
  end
end
