Given /^An artist "(.+)" with songs$/ do |artist_name, table|
  @artist = Artist.generate!(:name => artist_name)
  @album = Album.generate!(:name => "artist_album")
  @station = Station.create!(:artist_id => @artist.id, :amg_id => "P    12345", :name => @artist.name, :includes_cache => [@artist.id, @artist.id, @artist.id], :available => true)
  table.hashes.each_with_index do |hash, index|
    song = Song.create!(:title => hash['title'], :artist => @artist, :duration => hash['duration'], :album_id => @album.id, :position => index + 1)
    @artist.songs << song
  end
end

Given /^An artist "(.+)" with a station$/ do |artist_name|
  @artist = Artist.generate!(:name => artist_name)
  Bio.generate! :account_id => @artist.id
  @station = Station.create!(:artist_id => @artist.id, :amg_id => "P    12345", :name => @artist.name, :includes_cache => [@artist.id, @artist.id, @artist.id], :available => true)
  @station.stub!(:includes).and_return([@artist, @artist, @artist])
  @station.includes.size.should == 3
  @artist.stub!(:station).and_return(@station)
end

Then /I want to raise "(.+)"/  do |name|
  raise Artist.find_by_name(name).songs.inspect
end

Then /^I should see "(.+)" and their songs$/ do |artist_name, table|
  table.raw.each_with_index do |row, index|
    response.body.should have_selector("#artist_result") do |div|
      div.inner_text.should include(row[0])
    end
  end
end

Given /^artist (.+) has the following songs on album "(.*)"$/ do |user_slug, album_name, table|
  artist = Account.find_by_slug(user_slug)
  label = Label.generate!
  artist.label_id = label.id 
  artist.save!
  genre = Genre.generate!
  album = Album.generate!(:name => album_name, :avatar_file_name => "#{album_name}.jpg", :released_on => "2007-07-23 20:24:04", :label => Factory(:label, :name => 'WML'))
  album.owner = artist
  album.album_artists << AlbumArtist.create!(:album_id => album.id, :artist_id => artist.id)
  album.save.should be_true
  table.hashes.each_with_index do |hash, index|
    user = User.generate!
    song = artist.songs.find_or_create_by_title_and_duration_and_album_id_and_position(hash["song"], hash["length in seconds"] || 0, album.id, index + 1)
    SongGenre.create!(:song_id => song.id, :genre_id => genre.id)
    user.song_listens.create! :song => song, :total_listens => hash["total listens"].to_i, :site => @current_site, :album_id => album.id
  end
end

Given /^artist (.+) has the following song listens$/ do |user_slug, table|
  artist = Account.find_by_slug(user_slug)
  album = Factory(:album, :owner_id => artist.id)
  album.album_artists << AlbumArtist.create!(:album_id => album.id, :artist_id => artist.id)
  table.hashes.each_with_index do |hash, index|
    user = User.generate!(:name => hash["listener"])
    song = artist.songs.find_or_create_by_title_and_duration_and_album_id_and_position(hash["song"], hash["length in seconds"] || 0, album.id, index + 1)
    user.song_listens.create! :song => song, :total_listens => hash["total listens"].to_i, :site => @current_site, :album_id => album.id
  end
end

Then /^I should see the following recent listens in this order$/ do |table|
  listeners = ""
  table.raw.each do |row|
    listener = row[0]
    listeners += ".*" + listener
  end
  response.body.should match(/#{listeners}/)
end

Then /^I should see the following albums$/ do |table|
  count, albums = 0, []
  table.raw.each {|row| albums << row }
  for index in 1..count
    response.body.should have_selector("li.album:nth-child(#{index}) h4 a") do |a|
      a.inner_html.should include(albums.join("|"))
    end
  end
end

Then /^there should be (\d+) similar artists$/ do |count|
  response.body.should have_tag('.smiliar_artists_each', :count => count.to_i)
end

Then /^there should be (\d+) similar artists in the generated javascript$/ do |count|
  output = response.body.gsub('\"', '"').gsub("\\\'", "'").gsub('\n', "\n").gsub('<\/', '</')
  output.should have_tag('.smiliar_artists_each', :count => count.to_i)
end

Then 'I should see the following album images' do |table|
  table.raw.each do |row|
    src = row[0]
    response.should have_tag('img[src*=?]', src)
  end
end

Then /^I should see album image detail "(.*)"$/ do |src|
  response.body.should have_tag('img.avatar.album[src*=?]', src)
end

When /^I try go to error biography page$/ do
  @user = User.first
  visit user_biography_index_url(:slug => @user.slug)
end

When /^I try go to albums page$/ do
  @user = User.first
  visit artist_albums_url(:slug => @user.slug)
end

When /^I try go to a not exist user albums page$/ do
  visit artist_albums_url(:slug => "anyuser")
end