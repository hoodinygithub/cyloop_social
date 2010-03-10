# http://www.pivotaltracker.com/story/show/385958
@artist_public
Feature: Artist Public - Home page - Information module
  As a user of the site, visiting an artists page,
  I would like to see meta information related to the artist

  Acceptance Criteria:
  - Module header reads "INFORMATION"

  contents include:
  --Genre: [artist genres] (1)
  --Location: [artist city, state]
  --Website: [list of artist websites] (0:5)
  --Influences: (0:5)

  If no data is present for label, then supress the label.

  Note: This module is displayed on most public Artist profile tabs

  Scenario: On the artist charts page I want to see the artists songs
    Given the following artists 
      |name           |slug       |
      |Mana           |mana       |
    When I go to Mana's page
    Then I should see "Poopoo"
    And I should see "Miami, Florida, United States"
    And I should see "www.cyloop.com"
