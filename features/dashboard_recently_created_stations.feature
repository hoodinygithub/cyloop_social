# http://www.pivotaltracker.com/story/show/372276
Feature: Recently Created Stations
  As a user viewing my dashboard page,
  I would like to see recently created stations,
  So that I can stay up to date with new music listening opportunities

  Acceptance Criteria:
  - Five stations should be displayed
  - Stations for the list should be based on the latest stations created in the system

  Scenario: Should display recently created radio stations
    Given I am logged in
    And I have the following stations
      | name                         | created_at |
      | Fecal Flower                 | 1969-04-20 |
      | Glasseater                   | 1995-06-06 |
      | The David Salazar Experience | 1942-07-04 |
      | The TPope Five               | 2010-12-25 |
      | Rick The Bonus Jonas         | 1990-01-01 |
      | Ariel's Mermaids             | 2009-02-10 |
      | Hashrockets In Flight        | 2006-01-02 |
    When I go to my dashboard page
    Then I should see the following stations in order
      | Ariel's Mermaids      |
      | Hashrockets In Flight |
      | Glasseater            |
      | Rick The Bonus Jonas  |
