# http://www.pivotaltracker.com/story/show/385905
@artist_public
Feature: Artist Public Profile Page - Page Header - Create Station module
  As a user of the site, visiting an artists page,
  I would like to be able to create a radio station based on this artist and see a list of 5 similar artists

  Acceptance Criteria:
  - a button that reads "Launch [artist name] Radio" that will direct me to the Radio page 
    with artist as the station seed
  - a random list of 5 similar artists, each hyperlinked to their respective profile page

  Scenario: I want to see a create station module on an artist page
    Given An artist "Mana" with a station
    And I am on Mana's page
    Then I should see "Launch Radio"
    And I should see "Includes: Mana" stripped
