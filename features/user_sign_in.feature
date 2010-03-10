# http://www.pivotaltracker.com/story/show/415309
Feature: Login Page
  As a user
  I want to be taken to a login page that allows me to securely enter my email and password information
  So that it doesn't get hacked

  Scenario: successful login
    Given the following user
      |email            |password|
      |scott@hoodiny.com|password|
    And I am on the login page
    When I fill in "Email" with "scott@hoodiny.com"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should be on my dashboard page

  Scenario: failed login
    Given the following user
      |email            |password|
      |scott@hoodiny.com|password|
    And I am on the login page
    When I fill in "Email" with "scott@hoodiny.com"
    And I fill in "Password" with "incorrect password"
    And I press "Login"
    Then I should not be on my dashboard page
    And I should see "Invalid email and/or password"
  
  Scenario: Login of deleted user account
    Given the following user
      |email            |password|deleted_at      |
      |scott@hoodiny.com|password|2009-06-23 15:15| 
    And I am on the login page
    When I fill in "Email" with "scott@hoodiny.com"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should not be on my dashboard page
    And I should see "Invalid email and/or password"    

  Scenario: sign up link
    Given I am on the login page
    When I click "Listener Account"
    Then I should be on the new user page
