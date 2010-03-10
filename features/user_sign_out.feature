# http://www.pivotaltracker.com/story/show/415309
Feature: Login Page
  So that users can sign out of their accounts
  As a user
  I want to be able to log out

  Scenario: successful login
    Given I am logged in
    And I am on my dashboard page
    When I click "Log Out"
    Then I should be on the home page
