# http://www.pivotaltracker.com/story/show/369526
Feature: Create Your First Radio Station
  As a visitor to the Radio page,
  and I haven't created any stations yet
  I would like to create my own radio station (ala Last.fm)
  So that I can listen to the music I like

  Acceptance criteria:
  - need a form section on the Radio page with a textfield and Create Station button
  - starting with the first keystroke, the user should be presented with a drop down list of available artist names
  - Upon the desired artist being available in the dropdown list, the user should be able to select it by using the up/down arrows keys or mouse
  - Upon selection of an artist, the page is reloaded
  - the Radio page should now display the flash player and begin playing the newly created station
  - populate the page with the artist info and other modules (separate story)
  (same functionality that now exists on the radio player)

  Scenario: Anonymous user submits full band name
    Given An artist "Pink Floyd" with a station
    And I am on the radio page
    When I fill in "station_name" with "Pink Floyd"
    And I press "Create Station"
    Then the station "Pink Floyd" should be queued
  
  # http://www.pivotaltracker.com/story/show/644931    
  # Scenario: Anonymous user submits partial band name
  #   Given An artist "Pink Floyd" with a station
  #   And I am on the radio page
  #   When I fill in "station_name" with "Pin"
  #   And I press "Create Station"
  #   Then the station "Pink Floyd" should be queued

  Scenario: Logged in user submits full band name
    Given I am logged in
    And An artist "Pink Floyd" with a station
    And I am on the radio page
    When I fill in "station_name" with "Pink Floyd"
    And I press "Create Station"
    Then the station "Pink Floyd" should be queued

  #http://www.pivotaltracker.com/story/show/644931    
  # Scenario: Logged in user submits partial band name
  #   Given I am logged in
  #   And An artist "Pink Floyd" with a station
  #   And I am on the radio page
  #   When I fill in "station_name" with "Pin"
  #   And I press "Create Station"
  #   Then the station "Pink Floyd" should be queued

  Scenario: User submits band name that doesn't exist
    Given I go to the radio page
    When I fill in "station_name" with "aldkfjalkdjflkadjf"
    And I press "Create Station"
    Then I should be on the radio page
    And I should see "Could not find artist: aldkfjalkdjflkadjf"
