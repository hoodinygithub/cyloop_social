Then 'I should see a list of stations' do
  response.body.should have_tag("ul.stations")
  response.body.should have_tag("li.user_station")
end

Given /I have (\d+) stations/ do |stations_count|
  stations_count.to_i.times do
    UserStation.create!(:owner => @current_user, :station => Station.generate!)
  end
end

Given /I have a station named "(.+)"/ do |station|
  @current_user.stations.create!(:name => station,
                                 :owner => @current_user,
                                 :station => Station.generate!)
end

When /^I click edit for station "(.+)"$/ do |station_name|
  station = @current_user.stations.find_by_name(station_name)
  response.body.should have_tag("a[href=?]", edit_my_station_path(station))
  click_link("edit")
end

Then /^I should have (\d+) stations/ do |ct|
  @current_user.stations(true).count.should == ct.to_i
end

When /^I delete a station/ do
  click_button("Delete")
end

When /^I change the station name to "(.+)"/ do |new_name|
  raise field_labled("station[name]").inspect
end

Given 'I have the following stations' do |table|
  table.hashes.each do |hash|
    station = @current_user.stations.create!(:name => hash['name'],
                                             :created_at => hash['created_at'],
                                             :owner => @current_user,
                                             :station => Station.generate!)
  end
end

Then 'I should see the following stations in order' do |table|
  table.raw.each_with_index do |row, index|
    station_name = row[0]
    response.body.should have_selector("div[class='module recent_stations clearfix']") do |div|
      div.should contain(station_name)
    end
  end
end

Then /^I should be on the radio page with a queued station$/ do
  UserStation.destroy_all
  request.request_uri.should include(radio_path(:station_id => @current_user.stations.first)) 
end

Then /^the station "(.+)" should be queued$/ do |station_name|
  station = Station.find_by_name(station_name)
  response.body.should contain(/(QUEUE:"#{station.id}")/)
end
