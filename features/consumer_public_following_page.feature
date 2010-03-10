# http://www.pivotaltracker.com/story/show/408429
Feature: Consumer Public - Following page - Following
  As a user of the site, visiting a Consumers page,
  I would like to a list of all the people being followed by this consumer

  Acceptance Criteria:
  - Header reads "FOLLOWING"
  - Right aligned: Value: Count of people this consumer is following
  - Sub-header reads "Filter by: Following/Followers.
  - Following view is selected by default
  - Max 10 records sorted by follw date descending
  - Paginate

  - line item contents include:
  - Profile photo (60x60) of the person being followed
  - Profile Username
  - City, State

  If logged in, visitor can elect to Follow anyone from the Following/Follower views.  If visitor is already following a person, then state should read "Following" otherwise read "Follow"

  Actions:
  -Follow button changes state to Following and vice versa
  -Dynamic test to determine if visitor is currently following any of the same people

  Scenario: I want to unfollow a user that the profile I am visiting is following
    Given I am logged in
    And I am following these users
      |name   |slug     |started following  |
      |John   |jdoe     |2007-08-31         |
    And the following user
      |name           |slug       |short_bio        |born_on        |websites                  |
      |Jason Calleiro |jcalleiro  |Waaa I'm a slore |1980-06-03     |www.facebook.com/jcalleiro|
    And user jcalleiro is following these users
      |name   |slug     |started following  |
      |John   |jdoe     |2007-08-31         |
    When I go to Jason Calleiro's following index page
    And for "John" I click "Following"
    Then I should not be following "John"

  Scenario: I want to follow a user that the profile I am visiting is following
    Given I am logged in
    And the following user
      |name           |slug       |short_bio        |born_on        |websites                  |
      |Jason Calleiro |jcalleiro  |Waaa I'm a slore |1980-06-03     |www.facebook.com/jcalleiro|
    And user jcalleiro is following these users
      |name       |slug     |started following  |
      |John Doe   |jdoe     |2007-08-31         |
    When I go to Jason Calleiro's following index page
    And for "John Doe" I click "Follow"
    Then I should be following "John Doe"
