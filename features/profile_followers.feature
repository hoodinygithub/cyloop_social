# http://www.pivotaltracker.com/story/show/375919
Feature: Consumer Private - Following page - Followers

  In order to view and/or manage people who are following me,
  As a logged in Consumer, 
  I would like to view the Followers pane.

  Acceptance criteria:

  Displays a list of people that request to follow me or are following me
  Display: 
  Picture of person that is following me or requested to follow me
  City, State (Region), Country
  Block button - disallow person to follow you
  Follow/Leave button - to reciprocate following
  Click on Username or photo to redirect to their profile
  
  # https://hoodiny.hoptoadapp.com/errors/456201
  Scenario: Requires login
    Given I log out
    When I go to my followers page
    Then I should be on the login page  
  
  Scenario: My list of followers
    Given I am logged in
    And I have 3 followers
    When I go to my followers page
    Then I should see 3 followers
    
  Scenario: Follow a follower
    Given I am logged in
    And I have activated my account
    And there is a user named "Rick"
    And I have a follower named "Rick"
    When I go to my followers page
    And for user "Rick" I click the button "Follow"
    Then I should be following "Rick"
    
  Scenario: Unfollow a follower
    Given I am logged in
    And there is a user named "Rick"
    And I have a follower named "Rick"
    And I am following "Rick"
    When I go to my followers page
    And for user "Rick" I click the button "Following"
    Then I should not be following "Rick"
    
  Scenario: Block a follower
    Given I am logged in
    And there is a user named "Rick"
    And I have a follower named "Rick"
    When I block a user named "Rick"
    Then I should be blocking "Rick"
    And I should not be followed by "Rick"
    
  Scenario: Clicking username redirects to user profile
    Given I am logged in
    And there is a user named "Rick"
    And I have a follower named "Rick"
    When I go to my followers page 
    And for user "Rick" I click the username
    Then I should be on Rick's page

  Scenario: Clicking photo redirects to user profile
    Given I am logged in
    And there is a user named "Rick"
    And I have a follower named "Rick"
    When I go to my followers page 
    And for user "Rick" I click the photo
    Then I should be on Rick's page
