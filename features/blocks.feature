Feature: Blocks
  In order to prevent certain users from contacting me,
  As a user,
  I want to be able to create and delete blocks

  Scenario: Block a user
    Given I am logged in
    When I block a user named "Jason"
    Then I should have 1 block
    And I should see "Jason has been blocked"

#  Scenario: Unblock a user
#    Given I am logged in
#    When I block a user named "Jason"
#    And I unblock a user named "Jason"
#    Then I should have 0 blocks
#    And I should see "Jason has been unblocked"

  Scenario: Stop being followed by user when they are blocked
    Given I am logged in
    When I block a user named "Jason"
    Then I should not be followed by "Jason"

  Scenario: Stop following user when they are blocked
    Given I am logged in
    And I am following "Jason"
    When I block a user named "Jason"
    And I go to my following index page
    Then I should not see "Jason"

  Scenario: Stop blocking user when they are followed
    Given I am logged in
    And I block a user named "Jason"
    And I am following "Jason"
    When I go to my following index page
    Then I should see "Jason"
    And I should not be blocking "Jason"

  Scenario: Can't follow user when being blocked
    Given I am logged in
    And I am blocked by "Jason"
    When I go to Jason's page
    And I click "Follow"
    Then I should see "Followee has blocked you"
    #Then I should see "You are being blocked by this user, so you cannot follow!"
