# http://www.pivotaltracker.com/story/show/398391
#Feature: Add to My Playlist Layer
#  In order to organize songs I like
#  As a user
#  I want to add a song to multiple existing playlist and/or a new playlist
#
#  Scenario: layer heading
#    Given I am logged in
#    And I have listened to "Time" by "Pink Floyd" 1 time
#    And I am on my charts songs page
#    When I click "Add Song to Playlist"
#    Then I should see a "Add to my Playlist" heading
#
#  Scenario: artist metadata
#    Given I am logged in
#    And I have listened to "Time" by "Pink Floyd" 1 time
#    And I am on my charts songs page
#    When I click "Add Song to Playlist"
#    Then I should see "Time By: Pink Floyd" stripped
#
#  Scenario: existing playlist
#    Given I am logged in
#    And I have listened to "Time" by "Pink Floyd" 1 time
#    And I have a playlist named "Date"
#    And I am on my charts songs page
#    When I follow "Add Song to Playlist"
#    And I check "Date"
#    And I click "Add song"
#    And I go to my playlists page
#    And I follow "Date"
#    Then I should see "Time"
#
#  Scenario: new playlist
#    Given I am logged in
#    And I have listened to "Time" by "Pink Floyd" 1 time
#    And I am on my charts songs page
#    When I follow "Add Song to Playlist"
#    And I check "Add into a new playlist"
#    And I fill in "Playlist name" with "Timeless"
#    And I click "Add song"
#    And I go to my playlists page
#    Then I should see "Timeless"
#
#  Scenario: failure to select a playlist
#    Given I am logged in
#    And I have listened to "Time" by "Pink Floyd" 1 time
#    And I am on my charts songs page
#    When I follow "Add Song to Playlist"
#    And I click "Add song"
#    Then I should see "In order to add this song, you must click on a checkbox beside the playlist you wish to add it to"
#
#  Scenario: cancelling
#    Given I am logged in
#    And I have activated my account
#    And I have listened to "Time" by "Pink Floyd" 1 time
#    And I have a playlist named "Date"
#    And I am on my charts songs page
#    When I follow "Add Song to Playlist"
#    And I check "Date"
#    And I click "Cancel"
#    And I go to my playlists page
#    And I follow "Date"
#    Then I should not see "Timey"
