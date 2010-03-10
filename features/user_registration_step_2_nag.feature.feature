# # # http://www.pivotaltracker.com/story/show/449406
# Feature: User should be nagged if step 2 skipped
# 
#   So that users will get recommendations that will make it worth their time coming back to the site
#   As a user who has gotten passed step 1 but skipped step 2
#   I would like to be required to do step 2 before getting registered user permissions on the site
# 
#   Scenario: get redirected to step 2 if skipped in original registration
#     Given I have advanced to step 2 of user registration
#     When I log out
#     And I log in with email "test@example.com" and password "password"
#     Then I should be on the edit demographics page
# 
#   Scenario: get redirected to dashboard if step 2 completed
#     Given I have advanced to step 3 of user registration
#     When I log out
#     And I log in with email "test@example.com" and password "password"
#     Then I should be on the artist recommendations page
