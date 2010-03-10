# http://www.pivotaltracker.com/story/show/386012
@artist_public
Feature: Artist Public - Home page - Recent Listeners module
  As a user of the site, visiting an artists page,
  I would like to see a list of recent listeners so that I can check them out

  Acceptance Criteria:
  - Module header reads "RECENT LISTENERS"

  line item contents include:
  - profile photo (60x60) - hyperlinked to listener profile
  - Profile username - hyperlinked to listener profile
  - Profile city, state
  - Song title of what they listened to
  - valid song play is  >= 30 seconds
  - Followers count: total count of people following the listener

  Scenario: I wish to see recent listeners on an artist profile
    Given the following artists
      |name       |slug       |
      |Mana       |mana       |
    And artist mana has the following song listens
      |listener |song                  |artist       |length in seconds|total listens  |
      |Scott    |I am the highway      |Mana         |120              |10             |
      |Jason    |I am on the pay train |Mana         |120              |5              |
      |David    |Pooper train          |Mana         |120              |20             |
    When I go to Mana's recent listener javascript page
    Then I should see the following recent listens in this order
      |Scott      |
      |Jason      |
      |David      |