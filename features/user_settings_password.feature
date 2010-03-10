# # http://www.pivotaltracker.com/story/show/378560
# Feature: Consumer Private - Settings page - Password view
#   In order to view and/or manage my password settings
#   As a logged in Consumer
#   Would like to update my account settings via an uber convenient page
# 
#   Acceptance criteria:
#   - In private view, show Settings -> Password tab with editing capabilities
# 
#   Scenario: User wants to change their password
#     Given I am logged in
#     And I go to my settings page
#     And my password is "test"
#     When I fill in "Current Password" with "test"
#     And I fill in "New Password" with "test2"
#     And I fill in "Confirm Password" with "test2"
#     And I click "Save"    
#     Then I should see "Your settings have been saved"
#     
#   Scenario: User enters incorrect current password
#     Given I am logged in
#     And I go to my settings page
#     And my password is "test"
#     When I fill in "Current Password" with "test2"
#     And I fill in "New Password" with "test3"
#     And I fill in "Confirm Password" with "test3"
#     And I click "Save"
#     Then I should see "Current password is incorrect"
# 
#   Scenario: User enters mismatched new password
#     Given I am logged in
#     And I go to my settings page
#     And my password is "test"
#     When I fill in "Current Password" with "test"
#     And I fill in "New Password" with "test2"
#     And I fill in "Confirm Password" with "test3"
#     And I click "Save"
#     Then I should see "Password doesn't match confirmation"
# 
#   Scenario: User enters current password, but no new password
#     Given I am logged in
#     And I go to my settings page
#     When I fill in "Current Password" with "password"
#     And I click "Save"
#     Then I should see "Password can't be blank"
