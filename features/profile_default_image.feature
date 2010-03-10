# # http://www.pivotaltracker.com/story/show/606087
# Feature: Default Picture
#   if i dont feel like uploading a picture of myself
#   as a user
#   I would like to see a default picture.
# 
#   Acceptance Criteria:
#   - if female user signs up display feminine default picture- see attached
#   - if male user signs up display masculine default picture- see attached
#   - if artist has no default picture display Artist default picture.
# 
#   Scenario: User has an image, don't display default
#     Given a filled out user registration step 2 form
#     When I attach the "image/jpg" file at "sample-image.jpg" to "Image"
#     And I click "Send"
#     And I go to my dashboard page
#     Then I should see an image with the source "sample-image.jpg"
#   
#   Scenario: User does not have image, and is a male
#     Given I have advanced to step 3 of user registration
#     When I go to my dashboard page
#     Then I should see an image with the source "/avatars/missing/male.gif"
#   
#   Scenario: User does not have image, and is a female
#     Given a filled out user registration step 2 form
#     But I select "Female" from "user[gender]"
#     When I click "Send"
#     And I go to my dashboard page
#     Then I should see an image with the source "/avatars/missing/female.gif"
#   
#   Scenario: Artist does not have image
#     Given An artist "Pink Floyd" with a station
#     When I go to Pink Floyd's page
#     Then I should see an image with the source "/avatars/missing/artist.gif"
# 
