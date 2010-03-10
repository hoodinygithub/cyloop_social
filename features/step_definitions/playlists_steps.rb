Given /^I have a playlist named "(.*)"$/ do |playlist_name|
  @current_user.playlists.create! :name => playlist_name
end

Given /^I have the following playlists$/ do |table|
  table.hashes.each do |hash|
    @current_user.playlists.create! :name => hash["name"],
                                   :created_at => hash["created_at"]
  end
end

Given /^(.+) has the following playlists$/ do |user_name, table|
  user = Account.find_by_slug(user_name)
  table.hashes.each do |hash|
    user.playlists.create :name => hash["name"], :created_at => (hash["created_at"] =~ /now/)? DateTime.now : hash["created_at"]
  end
end

When /^I click edit for playlist "(.+)"$/ do |playlist_name|
  playlist = @current_user.playlists.find_by_name(playlist_name)
  response.body.should have_tag("a[href=?]", edit_my_playlist_path(playlist))
  click_link("edit")
end

When /^I go to "(.*)" details page from "(.*)" playlist/ do |song_title, playlist_name|
  @song = Song.find_by_title(song_title)
  @playlist = Playlist.find_by_name(playlist_name)
  @playlist_item = PlaylistItem.find_by_playlist_id_and_song_id(@playlist.id, @song.id)
  visit artist_song_playlist_item_url(:slug => @song.artist.slug, :song_id => @song.id, :id => @playlist_item)
end

Then /^I should be on details page from artist "(.*)" and song "(.*)"$/ do |artist_name, song_title|
  @artist = Artist.find_by_name(artist_name)
  @song = Song.find_by_title(song_title)  
  expected_path = artist_song_path(:slug => @artist.slug, :id => @song.id)
  URI.parse(current_url).path.should include(expected_path)  
end

Given /^user (.+) has the following songs on playlist "(.*)"$/ do |user_slug, playlist_name, table|
  user = Account.find_by_slug(user_slug)
  @playlist = user.playlists.find_or_create_by_name(playlist_name)
  table.hashes.each do |hash|
    artist = Artist.find_by_name(hash["artist"]) || Artist.generate!(:name => hash["artist"])
    label = Label.generate!
    artist.label_id = label.id 
    artist.save!
    genre = Genre.generate!
    album = Factory(:album, :owner => artist)
    song = artist.songs.find_or_create_by_title_and_duration_and_album_id(hash["song"], hash["length in seconds"] || 0, album.id)
    SongGenre.create!(:song_id => song.id, :genre_id => genre.id)
    @playlist.items.create!(:song => song)
  end
end

Given /^I have the following songs on playlist "(.*)"$/ do |playlist_name, table|
  @playlist = @current_user.playlists.find_or_create_by_name(playlist_name)
  @playlist.items.destroy_all
  table.hashes.each do |hash|
    artist = Artist.find_by_name(hash["artist"]) || Artist.generate!(:name => hash["artist"])
    label = Label.generate!
    album = hash.has_key?('album') ? Factory(:album, :name => hash['album']) : Album.generate!
    artist.label_id = label.id 
    artist.save!
    genre = Genre.generate!

    song = artist.songs.find_or_create_by_title_and_duration_and_album_id(hash["song"], hash["length in seconds"] || nil, album.id)
    SongGenre.create!(:song_id => song.id, :genre_id => genre.id)
    @playlist.items.create!(:song => song)
  end
end

When /^I change the position of song "(.*)" to "(\d+)" in playlist "(.*)"$/ do |song_name, new_position, playlist_name|
  playlist = Playlist.find_by_name(playlist_name)
  put my_playlist_item_path(playlist, playlist.items.find_by_song_id(Song.find_by_title(song_name).id), :position => new_position)
end

Then /^I should see the following playlists in this order$/ do |table|
  puts "table size #{table.raw.flatten.size}"
  
  response.body.should have_selector("ul.playlists") do |ul|
    ul.inner_html.should have_selector("li") do |li|
      li.each_with_index do |element, i|
        puts "(#{i}) => #{element.inner_text} <br /><br />"
      end
    end
    true
  end
  
  table.raw.flatten.each_with_index do |row, index|
  end
  
  # table.raw.each_with_index do |row, index|
  #   playlist_name = row[0]
  #   response.body.should have_selector(".playlists li:nth-child(#{index+1})") do |li|
  #     li.inner_text.should include(playlist_name)
  #   end
  # end
end

Then /^I should see the following albums in this order$/ do |table|
  table.raw.each_with_index do |row, index|
    album_name = row[0]
    response.body.should have_selector("li.album:nth-child(#{index + 1})") { |li|
      li.inner_html.should include(album_name)
    }
  end
end

Then /^I should see a view "(.+)" filter$/ do |filter|
  response.body.should have_selector(".filters .filter span") { |span|
    span.inner_text.should include(filter)
  }
end

Then /^I should see the following songs in this order$/ do |table|
  table.raw.each_with_index do |row, index|
    song_name = row[0]
    response.body.should have_selector("#songs li:nth-child(#{index+1})") { |li|
      li.inner_text.should include(song_name)
    }
  end
end

Then /^I should see the following artists contained in "(.*)"$/ do |playlist_name, table|
  playlist = Playlist.find_by_name(playlist_name)
  response.body.should have_selector("#playlist_#{playlist.id}") { |li|
    table.raw.each_with_index do |row, index|
      li.inner_text.should include(row[0])
    end
  }
end

Then /^I should see the following songs in the playlist$/ do |table|
  table.hashes.each_with_index do |row, index|  
    response.body.should have_selector("#songs li:nth-child(#{index+1})") { |li|
      li.should have_selector(".artist_name") { |span|
        span.inner_text.should include(row["artist"]) }
      li.should have_selector(".song") { |span|
        span.inner_text.should include(row["song"]) }
    }
  end
end

Then /^I should see the "(\d+)" as the count for songs in the playlist "(.*)"$/ do |count, playlist_name|
  playlist = Playlist.find_by_name(playlist_name)
  response.body.should have_selector("#playlist_#{playlist.id} .songs .count") { |li|
    li.inner_text.should include("#{count}")
  }
end

Then /^I should see the "([\d:]+)" as the total length for the playlist "(.*)"$/ do |length, playlist_name|
  playlist = Playlist.find_by_name(playlist_name)
  response.body.should have_selector("#playlist_#{playlist.id} .time .count") { |li|
    li.inner_text.should include("#{length}")
  }
end


Then /^I should not see playlist named "(.+)"$/ do |playlist_name|
  response.body.should_not have_text(/#{playlist_name}/)
end

Then /^I should have autoplay enabled and be on my playlist page$/ do 
  url = URI.parse(current_url)
  "#{url.path}?#{url.query}".should == path_to("my playlist") + "?autoplay=true"
end

Then /^I want to remove "(.+)" from my playlist "(.+)"$/ do |song_title, playlist_name|
  song = Song.find_by_title(song_title)
  playlist = Playlist.find_by_name(playlist_name)
  playlist_item = PlaylistItem.find_by_playlist_id_and_song_id(playlist.id, song.id)
  visit(my_playlist_item_url(:playlist_id => playlist.id, :id => playlist_item.id), :delete)
end
