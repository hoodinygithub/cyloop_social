@artist_public
Feature: Artist Public - Biography page 
  As a user of the site, visiting an artists page,
  I would like to see a biography of the artist

  Acceptance Criteria:
  - Header reads "Biography"
    
    
  Scenario: On the artist home page I want to see the artists biography
    Given the following artists 
      | name | slug |
      | Mana | mana |
    When I go to Mana's page
    And I follow "Biography"
    Then I should be on Mana's biography