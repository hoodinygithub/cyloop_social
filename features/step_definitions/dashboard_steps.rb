When /^I click on the top artist "(.*)"$/ do |top_artist|
  within '.top_artists_profile' do |scope|
    scope.click_link top_artist
  end 
end

When /^I click on my "(\d+)" "(.*)" stats count$/ do |count, stats_name|
  within '#stats' do |scope| 
    scope.click_link "stats_#{stats_name.gsub(/\s/, '_')}_count"
  end 
end

Then /^I should see the following top artists$/ do |top_artists|
  top_artists.hashes.each_with_index do |artist_with_listens, index|
    response.body.should have_selector(".top_artists_profile li:nth-child(#{index + 1})") do |li|
      li.search('.artist').first.inner_html.should include(artist_with_listens['artist name'])
      li.search('.listens').first.inner_html.should include(artist_with_listens['listens'])
    end
  end
end

Then /^I should see (\d+) top artists$/ do |count|
  response.body.should have_tag('.top_artists_profile li', :count => count.to_i)
end

When /^I go to (\w+)'s page to see the songs$/ do |slug|
  # assigns(:profile_account).reload
  # artist = Artist.find_by_slug(slug.downcase)
  site = Site.find_by_name(ENV['SITE'])
  Rails.cache.delete("#{site.cache_key}/#{slug}/most_listened_songs")
  visit "/#{slug}"
end

Then /^I should see the following top songs in this order$/ do |table|
  # puts response.body =~ /pooper/i
  # puts assigns(:profile_account).most_listened_songs.inspect
  # table.raw.each_with_index do |row, index|
  #   song_name = row[0]
  #   response.body.should have_selector("li.song span a") { |li|
  #     # puts "li.inner_html: #{li.inner_html}, song_name: #{song_name}"
  #     li.inner_html.include?(song_name).should be_true
  #   }
  # end
  
  table.raw.each_with_index do |row, index|
    song_name = row[0]
    response.body.should have_selector("li.song:nth-child(#{index + 1}) span a") { |li|
      li.inner_html.should include(song_name)
    }
  end
  
end
