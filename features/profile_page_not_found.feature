# # http://www.pivotaltracker.com/story/show/379649
# Feature: Profile page not found
#   So that visitors to the site are not confused,
#   As a visitor following a broken link or manually entering a bad profile URL,
#   I would like to see a friendly error message page telling me that the profile was not found.
# 
#   Scenario: Visiting a public user profile page that doesn't exist
#     When I go to an unexistent user profile
#     Then I should see "Profile Not Found"
