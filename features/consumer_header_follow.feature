# http://www.pivotaltracker.com/story/show/406204
Feature: Consumer Public Profile Page - Header - Follow 
  As a user of the site, visiting a Consumers page,
  I would like to be able to follow this persons activities

  Acceptance Criteria:
  - must be logged in to invoke this feature
  - should be a link or button that allows me to follow the user/artist
  - I should see "Following" after following the user
  - I should not already be following the user

  Exceptions:
  - Do not show Follow button if logged in user is an Artist
  - If anon, invoke /Login page/ once logged in redirect user back to this page.

  Scenario: Following an artist as a user
    Given I am logged in
    And the following artists
      |name|slug       |
      |Mana|mana       |
    When I go to Mana's page
    And I click "Follow"
    Then I should be following "Mana"

  Scenario: Following a user as a user
    Given I am logged in
    And the following users
      |name |
      |David|
    When I go to David's page
    And I click "Follow"
    Then I should be following "David"

  Scenario: Already following a user
    Given I am logged in
    And I am following these artists
      |name   |slug    |started following |
      |Mana   |mana    |01-02-2008        |
    When I go to Mana's page
    Then I should see a "Following" button

  Scenario: An anonymous user trying to follow an artist
    Given the following artists
      |name|slug    |
      |Mana|mana    |
    When I go to Mana's page
    And I click "Follow"
    Then I should be prompted to log in
