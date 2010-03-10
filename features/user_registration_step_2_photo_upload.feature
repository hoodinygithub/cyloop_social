# # # http://www.pivotaltracker.com/story/show/374411
# Feature: Step 2 Photo Upload
#   So that I'm not represented by a corny cyloop default placeholder photo,
#   As a newly-registered user,
#   I want to be able to upload my own photo.
# 
#   Acceptance Criteria
#   - User clicks Change Add Photo button
#   - User browsers file to select an image
#   - User clicks save and image is added to the DB.
#   - Page moves on to the final step.
# 
#   Scenario: a user photo is uploaded and set in the database
#     Given a filled out user registration step 2 form
#     When I attach the "image/jpg" file at "sample-image.jpg" to "Image"
#     And I click "Send"
#     And I go to my dashboard page
#     Then I should see an image with the source "sample-image.jpg"
# 
# 
