Given /^(.*) has the following songs on the album "(.*)"$/ do |artist_name, album_name, table|
  artist = Artist.find_or_create_by_name(artist_name)
#  raise Country.find_by_name_and_code("United States", "US").inspect
  album = Album.generate! :name => album_name, :owner => artist
  album.album_artists << AlbumArtist.create!(:album_id => album.id, :artist_id => artist.id)
  table.hashes.each do |hash|
    if hash["available_countries"] == "empty"
      countries = []
    elsif hash["available_countries"].nil?
      countries = nil
    else
      countries = hash["available_countries"].split(",").map{|code| Country.find_by_code(code)}.map(&:id) rescue []
    end
    song = Song.create!(:title => hash["song"], :artist => artist, :duration => hash["duration"], :available_countries => countries, :album => album, :position => hash["position"])
    artist.songs << song
  end
  artist.save
  artist.reload
end

When /^I go to the album page for "(.*)" by "(.*)"$/ do |album_title, artist_name| 
  artist = Artist.find_by_name(artist_name)
  album = Album.find_by_name_and_owner_id(album_title, artist.id)
  visit artist_album_path(artist, album)
end

Then /^I should see a sample flag for the song "(.*)" by "(.*)"$/ do |song_title, artist_name|
  s = Song.find_by_title_and_artist_id(song_title, Artist.find_by_name(artist_name).id)
  #puts "country: #{assigns(:current_country).inspect}\nsong: #{s.inspect}\n\n"
  
  response.body.should have_selector("div[class='info']") do |div|
    div.inner_html.should have_selector("div[class='title']") do |title|
      title.inner_text.should =~ /#{song_title}/
    end
    div.inner_html.should have_selector("div[class='meta clearfix']") do |clearfix|
      clearfix.inner_html.should =~ /a.*class=.*sample_flag/
    end
  end
end

Then /^I should see a duration of "(.*)" for the song "(.*)" by "([^\"]*)"$/ do |duration, song_title, artist|
  s = Song.find_by_title(song_title)
  #puts "country: #{assigns(:current_country).inspect}\nsong: #{s.inspect}\n\n"
  #response.body.inspect
  response.body.should have_selector("span[class='duration_time']") do |span|
    span.inner_text.should =~ /#{duration}/
  end
  
end
