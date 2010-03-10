# # # http://www.pivotaltracker.com/story/show/371619
# Feature: Step 1 - Realtime Slug availability check
#   In order to easily share and recognize my profile's URL
#   As a user
#   I want a customizable URL for my profile page
# 
#   Client side validation should be performed that shows the URL as red when
#   taken and green when available.
# 
#   Scenario: Invalid characters in slug
#     Given a filled out user registration form
#     When I fill in "Choose your Profile Name" with "something with spaces"
#     And I press "Send"
#     Then I should see "URL can only contain letters, numbers, and hyphens"
#     
#   Scenario: Cannot start with punctuation
#     Given a filled out user registration form
#     When I fill in "Choose your Profile Name" with "-punctuation"
#     And I press "Send"
#     Then I should see "URL cannot start with punctuation"
#     
#   Scenario: Cannot end with punctuation
#     Given a filled out user registration form
#     When I fill in "Choose your Profile Name" with "punctuation-"
#     And I press "Send"
#     Then I should see "URL cannot end with punctuation"
# 
#   Scenario: Taken slug
#     Given the following users
#       |slug      |
#       |taken-slug|
#     And a filled out user registration form
#     When I fill in "Choose your Profile Name" with "taken-slug"
#     And I press "Send"
#     Then I should see "URL has already been taken"
# 
#   Scenario: Taken slug by a deleted account
#     Given the following users
#       |slug      |deleted_at|
#       |taken-slug|2009-07-13|
#     And a filled out user registration form
#     When I fill in "Choose your Profile Name" with "taken-slug"
#     And I press "Send"
#     Then I should see "Step 2: Additional Information"
#     And I should be on edit demographics page
#   
#   
#   