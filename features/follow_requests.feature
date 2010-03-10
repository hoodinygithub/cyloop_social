# http://www.pivotaltracker.com/story/show/415227
Feature: Consumer Private - Messages - Follow Requests view
  In order to view and/or manage my Messages
  As a logged in Consumer, would like to view all my Follow Requests.


  Acceptance criteria:
  - In private view, show Messages tab with sub-link/button highlighted to reflect that I am viewing my Follow Requests.
  - Follow Requestsview should only show if my Profile is set to Private


  Alerts should include:
  - Other Consumers who request to want to follow me

  Line Items should display:
  - Profile photo 60x60
  - [Consumername] would like to follow you
  - Day of week Month Date @ time

  - Approve button: will create the follow tie and dynamically remove the 2 buttons and text will read: "[Consumername] will now receive your updates."

  - Deny button: dynamically remove the 2 buttons and text will read: "[Consumername] will not be allowed to receive your updates."

  - Delete button will destroy the alert record



  see design for rendering details


  Scenario: Approving
    Given the following users
      |name |private_profile|
      |Mario|true           |
      |Luigi|false          |
    When I sign in as Luigi
    And I go to Mario's page
    And I press "Follow"
    And I sign in as Mario
    And I go to my follow requests page
    And I press "Approve"
    Then I should see "Luigi will now receive your updates"
    When I sign in as Luigi
    And I go to Mario's page
    Then I should see a "Following" button

  Scenario: Denying
    Given the following users
      |name |private_profile|
      |Mario|true           |
      |Luigi|false          |
    When I sign in as Luigi
    And I go to Mario's page
    And I press "Follow"
    And I sign in as Mario
    And I go to my follow requests page
    And I press "Deny"
    Then I should see "Luigi will not be allowed to receive your updates"
    When I sign in as Luigi
    And I go to Mario's page
    Then I should see a "Follow" button
