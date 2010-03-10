# # http://www.pivotaltracker.com/story/show/378562
# Feature: Consumer Private - Settings page - Follower Notifications Checkbox
#   In order to control whether cyloop bothers me with notifications of followers
#   As a logged in Consumer
#   I would like a checkbox that says "Alert me when someone follows me"
# 
#   Acceptance criteria:
#   - In private view, show Settings has a checkbox for enabling/disabling email notification of new followers
#   - The checkbox (and email notification of followers should default to true/checked)
# 
#   Scenario: Notifications on by default
#     Given I am logged in
#     When I go to my settings page
#     Then the "Alert me when someone follows me" checkbox should be checked
# 
#   Scenario: Stop receiving notifications
#     Given I am logged in
#     When I go to my settings page
#     And I uncheck "Alert me when someone follows me"
#     And I press "Save"
#     Then I should not be receiving following notifications
#   
#   Scenario: Restart receiving notifications
#     Given I am logged in
#     And I am not receiving following notifications
#     When I go to my settings page
#     And I check "Alert me when someone follows me"
#     And I press "Save"
#     Then I should be receiving following notifications