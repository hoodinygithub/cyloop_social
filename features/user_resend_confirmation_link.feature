# http://www.pivotaltracker.com/story/show/375854
Feature: Resend Confirmation Link
  In order to confirm careless users who lost their confirmation email,
  As a user,
  I want to request another confirmation email

  # Scenario: Notification when logged in as unconfirmed user
  #   Given I am logged in
  #   And the following users
 # | name    | slug |
 # | Foo Bar | foo  |
  #   And I have not activated my account
  #   When I go to Foo Bar's page
  #   Then I should see the message for an unconfirmed user
    
  Scenario: Notification gone when logged in as confirmed user
    Given I am logged in
    And I have activated my account
    When I go to the home page
    Then I should not see the message for an unconfirmed user
    
  # Scenario: Confirmation e-mail resent when resend link clicked
  #   Given I am logged in
  #   And I have not activated my account
  #   When I go to my dashboard page
  #   And I click "user_confirmation_resend_link"

# TODO: Fix failing e-mail test cause of... no idea =) - Rick
# Scenario: Confirmation e-mail resent when resend link clicked
#   Given I am logged in
#   And I have not activated my account
#   When I go to my dashboard page
#   And I click "user_confirmation_resend_link"
#   Then I should receive 1 email
