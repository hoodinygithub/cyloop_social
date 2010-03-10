def record_listen(user, song, source)
  job = ListenJob.new(:user_id => user.id, :song_id => song.id, :source => 'RADIO', :remote_ip => '127.0.0.1')
  job.stub!(:post).and_return(true)
  status, msg = job.log_listen
  puts "Message -> #{msg}" unless msg.blank?
  msg.should be_blank
  status.should == true
end

def listen_to_song( _user, artist_name, album_name, song_title, listens = 1 )
  artist = Artist.find_by_name(artist_name) || Artist.generate!(:name => artist_name, :amg_id => "P    12345")
  label = Label.generate!
  artist.label_id = label.id 
  artist.save!
  Bio.generate! :account_id => artist.id
  genre = Genre.first || Genre.generate!
  album = Album.find_by_name(album_name) || Album.generate!( :name => album_name )
  album.owner = artist
  album.album_artists << AlbumArtist.create!(:album_id => album.id, :artist_id => artist.id)
  album.save!
  song = Song.find_by_title(song_title) || Song.generate!(:title => song_title, :album_id => album.id)
  song.artist = artist
  song.position = rand(100)
  song.duration ||= 1
  song.album_id = album.id
  song.save!
  SongGenre.create!(:song_id => song.id, :genre_id => genre.id)
  listens.to_i.times do
    _user.song_listens.create!( :song => song, :total_listens => 1, :site => @current_site, :album_id => album.id)
    record_listen(_user, song, 'RADIO')
  end
end

Given /^I have played (\d+) songs/ do |count|
  album = Album.generate!
  song = Song.generate!
  genre = Genre.generate!
  SongGenre.create!(:song_id => song.id, :genre_id => genre.id)
  count.to_i.times {|listen|
    @current_user.song_listens.create! :song => song, :total_listens => count.to_i, :site => @current_site
    record_listen(@current_user, song, 'RADIO')
  }
end

Given /^user "(.+)" has had (\d+) songs played$/ do |slug_name, count|
  user = Account.find_by_slug(slug_name)
  song = Song.generate!
  genre = Genre.generate!
  SongGenre.create!(:song_id => song.id, :genre_id => genre.id)  
  count.to_i.times {|listen|
    user.song_listens.create! :song => song, :total_listens => count.to_i, :site => @current_site    
    record_listen(user, song, 'RADIO')
  }
end

Given /^an artist "(.+)" has the following songs$/ do |artist_name, table|
  artist = Factory.create(:artist, :name => artist_name)
  table.hashes.each do |hash|    
    album = Album.create!(:name => hash['album_name'], :owner_id => artist.id)
    song = Song.create!(:title => hash['title'], :artist => artist, :duration => hash['duration'], :album => album, :position => 1)
    artist.songs << song
  end
end


Given /^I have listened to the song "(.*)" on "(.*)" by "(.*)" (\d+) times?$/ do |song_title, album_name, artist_name, listens|
  listen_to_song( @current_user, artist_name, album_name, song_title, listens )
end


#TODO: Refactor tests to use album name
Given /^I have listened to "(.*)" by "(.*)" (\d+) times?$/ do |song_title, artist_name, listens|
  listen_to_song( @current_user, artist_name, 'Album', song_title, listens )
end

Given /^user (.+) listened to "(.*)" by "(.*)" (\d+) times?$/ do |user_name, song_title, artist_name, listens|
  listen_to_song( Account.find_by_slug(user_name), artist_name, 'Album', song_title, listens )
end

Given /^profile (.+) friend "(.+)" has listened to "(.+)" by "(.+)" (\d+) times?$/ do |user_name, friend_name, song_title, artist_name, listens|
  user = Account.find_by_slug(user_name)
  friend = User.generate!(:name => friend_name)
  user.follow(friend)

  listen_to_song( friend, artist_name, 'Album', song_title, listens )
end

Given /^my friend "(.*)" has listened to "(.*)" by "(.*)" (\d+) times?$/ do |friend_name, song_title, artist_name, listens|
  friend = User.generate!(:name => friend_name)
  @current_user.follow(friend)
  listen_to_song( friend, artist_name, 'Album', song_title, listens )
end

When /^I click on "(.*)" for the artist "(.*)"$/ do |button, artist_name|
  artist = Artist.find_by_name(artist_name)
  response.body.should have_selector("#artist_#{artist.id}") { |li|
    Webrat::Locators::ButtonLocator.new(webrat_session, li, "Create Station").locate!.click
  }
end

When /^I click the link for the artist "(.*)" for the song named "(.*)"$/ do |artist_name, song_name|
  artist = Artist.find_or_create_by_name artist_name
  song = Song.find_or_create_by_title song_name
  within "#song_#{song.id}" do |li|
   li.click_link artist.name
  end
end

When /^I click the link for the artist "(.*)" for the album titled "(.*)"$/ do |artist_name, song_name|
  artist = Artist.find_or_create_by_name artist_name
  song = Song.find_or_create_by_title song_name
  within "#song_#{song.id} span span" do |a|
   a.click_link song.album.name
  end
end

Then /^I should have a station for the artist "(.*)"$/ do |artist_name|
  artist = Artist.find_by_name(artist_name)
  response.body.should have_selector("h4") { |h4| 
    h4.inner_html.should include(artist.name)
  }
end

Then /^I should see the following songs$/ do |songs|
  songs.raw.each_with_index do |song_name, index|
    song_name = song_name[0]
    response.body.should have_selector("li.song:nth-child(#{index + 1})") { |li|
      li.inner_html.should =~ /#{song_name}/
    } 
  end
end


Then /^I should see the following artists$/ do |artists|
  artists.raw.each_with_index do |artist_name, index|
    artist_name = artist_name[0]
    response.body.should have_selector("li.artist:nth-child(#{index + 1})") { |li|
      li.inner_html.should include(artist_name  )
    } 
  end
end

