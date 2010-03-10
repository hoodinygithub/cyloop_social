# Feature: Upload a photo when updating your settings
#   
#   So that users will be motivated to keep their profile updated
#   As a user
#   I would like to change my avatar from the account settings page
#   
#   Scenario: Upload photo from account settings page
#     Given I am logged in
#     And I have activated my account
#     And I have a city
#     And I go to the my settings page
#     When I attach the "image/jpg" file at "new-sample-image.jpg" to "Image"
#     And I click "Save"
#     When I go to my dashboard page
#     Then I should see an image with the source "new-sample-image.jpg"
