# # http://www.pivotaltracker.com/story/show/374441
# Feature: Step 3 Toggle Artists to Follow
#   So that the system knows who I want to follow,
#   As a newly-registered user who had the patience to get to step 3,
#   I want the system to process my Artist follow submission
# 
#   Acceptance Criteria:
#   - Clicking on the thumbnail or the " follow" button live-toggles artist following via an AJAX call.
#   - Follow button will change to "Following" once toggled. User should be given the option to un-follow by clicking the button again (IOW it's a toggle button)
# 
#   Scenario: I want to follow the first artist that is recommended
#     Given I am logged in
#     And the following artists
#       |id   |name |slug|
#       |1234 |Mana |mana|
#     When I go to the artist recommendations page
#     And I click "Follow"
#     Then I should be following "Mana"
#     And followee "Mana" should be highlighted
# 
#   Scenario: I want to unfollow an artist that I'm following
#     Given I am logged in
#     And I am following these artists
#       |name   |slug    |started following|
#       |Mana   |Mana    |01-02-2008       |
#     When I am on the artist recommendations page
#     And I click "Following"
#     Then I should not be following "Mana"
#     And followee "Mana" should not be highlighted
