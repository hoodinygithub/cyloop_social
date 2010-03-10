Given /^(\d+) songs have been listened to$/ do |count|
  count.to_i.times do |i|
    artist = Artist.generate!
    artist.slug = "mana#{i}"
    artist.save!
    album = Album.generate!
    album.owner_id = artist 
    album.save!
    song = Song.generate!
    song.album_id = album.id
    song.position = i
    song.save!
    listen = SongListen.create(:song => song, :listener_id => User.generate!.id, :total_listens => i + 1, :site => @current_site, :album_id => album.id)
  end
end

Then /^I should see (\d+) top songs$/ do |count|
  response.body.should have_tag('#top_songs li', :count => count.to_i)
end

Given /^(\d+) stations have been created$/ do |count|
  count.to_i.times do
    station = Station.generate!
    aID = station.artist_id
    station.update_attribute(:includes_cache, [aID,aID,aID])
    UserStation.create!(:name => 'station', :owner => User.generate!, :station => station, :site => @current_site)
  end
end

Then /^I should see (\d+) top stations$/ do |count|
  response.body.should have_tag('#top_stations li', :count => count.to_i)
end

Then /^(\d+) included artists under each top station$/ do |count|
  response.body.should have_tag("#top_stations li:nth-child(1) .including a", :count => count.to_i)
end
