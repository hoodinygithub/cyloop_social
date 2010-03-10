# http://www.pivotaltracker.com/story/show/397984
Feature: Create Station Station: Search Drop Down
  as a user,

  I  want to be able to easily select artist from the search menu
  so that i can easily begin creating radio stations.

  Acceptance Criteria:
  - when I begin to type a word display drop down menu with a list of relative artist.
  - I can select an artist by clicking on the artist name with the mouse.
  - I can select an artist by using the up and down scroll keys and clicking enter when the desired artist name is selected.
  - If I type the first few letters in the text box and DO NOT select/highlight an artist and I click "SEARCH" it should default to the first artist on the drop down list.
  - Clicking on "Search Radio" will redirect users to the Radio page with the seeded artist in queue.
  - Default text for text box: "Type Artist Name"

  Scenario: Anonymous user submits full band name to "Create Station"
    Given An artist "Pink Floyd" with a station
    And I am on the home page
    When I fill in "station_name" with "Pink Floyd"
    And I press "Create Station"
    Then the station "Pink Floyd" should be queued

  # http://www.pivotaltracker.com/story/show/644931  
  # Scenario: Anonymous user submits partial band name to "Create Station"
  #   Given An artist "Pink Floyd" with a station
  #   And I am on the home page
  #   When I typehead in "station_name" with "Pin"
  #   And I fill in "station_name" with the first typehead result
    # And I press "Create Station"
    # Then the station "Pink Floyd" should be queued

  Scenario: Logged in user submits full band name to "Create Station"
    Given I am logged in
    And An artist "Metallica" with a station
    And I am on the home page
    When I fill in "station_name" with "Metallica"
    And I press "Create Station"
    Then the station "Metallica" should be queued

  # http://www.pivotaltracker.com/story/show/644931    
  # Scenario: Logged in user submits partial band name to "Create Station"
  #   Given I am logged in
  #   And An artist "Pink Floyd" with a station
  #   And I am on the home page
  #   When I fill in "station_name" with "Pin"
  #   And I press "Create Station"
  #   Then the station "Pink Floyd" should be queued

  Scenario: User submits band name that doesn't exist
    Given I am on the home page
    When I fill in "station_name" with "aldkfjalkdjflkadjf"
    And I press "Create Station"
    Then I should be on the radio page
    And I should see "Could not find artist: aldkfjalkdjflkadjf"
