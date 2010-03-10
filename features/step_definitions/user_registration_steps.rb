Given 'a filled out user registration form' do
  Given 'I go to the user registration page'
  Given 'I fill in "user[email]" with "test@example.com"'
  Given 'I fill in "user[name]" with "Test"'
  Given 'I fill in "user[slug]" with "test123"'
  Given 'I fill in "user[password]" with "password"'
  Given 'I select "Male" from "user[gender]"'
  Given 'I select "March 14, 1977" as the "user[born_on]" date'
  Given 'I fill in "user[city_name]" with "Miami, Florida, United States"'
  Given 'I check "user[terms_and_privacy]"'
end

Given /^there is a city called "(.*)" in "(.*)" in "(.*)"$/ do |city_name, region_name, country_name|
  country = Country.find_or_create_by_name country_name
  region = country.regions.find_or_create_by_name region_name
  city = region.cities.find_or_create_by_name_and_location(city_name, "#{city_name}, #{region_name}, #{country_name}")
end

# Given /^I have some site stats$/ do
# 
# end

Given /^I want to see (\d+) recommended artists$/ do |number_of_artists|
  stub_recommended_artists number_of_artists
end

Then /^I should see (\d+) recommended artists to follow$/ do |count|
  response.body.should have_tag("[class='artist']", :count => count.to_i)
end

def stub_recommended_artists(how_many=6)
  @recommended_artists = Array.new
  number_of_artists = how_many.to_i + 1
  number_of_artists.times { @recommended_artists.push(Factory(:artist)) }
  DashboardsController.expects(:recommended_artists).with(:number_of_artists).returns(@recommended_artists)
end
