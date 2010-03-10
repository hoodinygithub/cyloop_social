# # http://www.pivotaltracker.com/story/show/392205
# Feature: Home Top Stations Module
#   In order to discover new stations that I will probably like
#   As a user viewing the home page
#   I would like to see top stations,
#   
#   Acceptance Criteria:
#   - Top 5 stations should be shown by amount of times station was created
#   - Data set should be site specific
#   
#   Line item display:
#   - Artist thumbnail (60X60): Hyperlinks to artist profile page
#   - Station Name (followed by the word "Station") : Hyperlinks to Radio page with seeded artist in queue.
#   - Includes: display three (3) artist names included in the station playlist. (names hyperlink to artist profile)
#   
#   Scenario: Top Stations
#     Given 10 stations have been created
#     When I go to the home page
#     Then I should see 5 top stations
#   
#   Scenario: Displays 3 included artists
#     Given 10 stations have been created
#     When I go to the home page
#     Then I should see 5 top stations
#     And 3 included artists under each top station
# 
# #Given /^An artist "(.+)" with a station$/ do |artist_name|
# #  @artist = Artist.generate!(:name => artist_name)
# #  @station = Station.create!(:artist_id => @artist.id, :amg_id => "P    12345", :name => @artist.name)
# #end