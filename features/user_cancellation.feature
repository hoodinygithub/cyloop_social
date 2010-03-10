# http://www.pivotaltracker.com/story/show/645772
Feature: User Cancellation
  In order to cancel my account,
  As a logged in consumer,
  I want to have the ability to cancel my account.  

  Acceptance Criteria:
  1 - all text should be set to translation keys
  
  Cancel Account Action
  1 - User clicks the cancel acocunt link on their accounts page
  2 - a layer is invoked with messaging and a confirmation button
  3 - Upon confirmation, set their record to deleted
  4 - redirect them to the homepage in a logged out state
  
  User Impacts
  1 - They are not able to log back in with their credentials
  2 - Public profile is no longer accessible - gets redirected to the /profile_not_found page.
  3 - Remove from all activity feeds (personal and tied to all artists, followees/followers)
  
  *** Email address and slug are freed up for reuse, so we need to refactor the registration/login process to consider this. - Please review impacts with me for this requirement
  
  Background:
    Given I am logged in
    And I have activated my account  

  Scenario: Confirm Cancel My Account Screen
    Given I am on my settings page
    When I follow "Cancel My Account"
    Then I should see "We are sorry you're leaving Cyloop!"
    
  Scenario: Redirect to feedback form
    Given I am on my cancellation confirm page
    When I click "Yes, Cancel My Account"
    Then I should see "Why are you leaving Cyloop?"    
    And I should be on my cancellation feedback page
    
  Scenario: Redirect to settings form
    Given I am on my cancellation confirm page
    When I click "No, Keep My Account"
    Then I should see "Cancel My Account" 
    And I should be on edit my settings page
    
#  Scenario: Cancellation with feedback
#    Given I am on my cancellation feedback page
#    When I click "Send"
#    Then "test@example.com" should receive 1 email
#    And "feedback@cyloop.com" should receive 1 email    
#    And I should be logged out
#    And the account should be marked as deleted
    
  # Scenario: Profile not found
  #   Given I have a deleted user account
  #   When I go to Deleted User's page
  #   Then I should see "Profile Not Found"
  #   And I should be on deleted_user's not found page
  
  # @wip
  # Scenario: Remove relationships from deleted account
  #   Given I have a deleted user account
  #   And I am following these users
 # | name         | slug         | started following | deleted_at |
 # | Deleted User | deleted_user | 2009-05-31        | 2009-05-31 |
 # | John         | jdoe         | 2007-08-31        |            |
  #   When I go to my following index page
  #   Then I should not see "Deleted User"
  #   And I should see "John"
