# # http://www.pivotaltracker.com/story/show/374357
# Feature: Handle Confirmation Link
#   In order to know that a new user has a valid email
#   As a shareholder
#   I want to track users that clicked the confirmation link
# 
#   Scenario: Successful confirmation message
#     Given a filled out user registration step 2 form
#     When I press "Save"
#     And I follow the link in the email
#     Then I should see "Your email has been confirmed!"
