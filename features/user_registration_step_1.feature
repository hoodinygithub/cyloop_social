# http://www.pivotaltracker.com/story/show/371607
# Feature: User Registration Step 1
#    As a visitor
#    I should be able to sign up for the service to register an account with cyloop
#    
#    Scenario: allow user registration for step 1
#      And a filled out user registration form
#      When I press "Send"
#      Then I should see "LOOK WHO’S ON CYLOOP!"
#  
#    Scenario: email is required
#      Given a filled out user registration form
#      But I omit "Email"
#      When I press "Send"
#      Then I should see "Email can't be blank"
#     
#    Scenario: email is valid
#      Given a filled out user registration form
#      But I fill in "Email" with "no thanks"
#      When I press "Send"
#      Then I should see "Email is invalid"
#      
#    Scenario: email is unique
#      Given I have a user with email "user@cyloop.com"
#      And a filled out user registration form
#      But I fill in "Email" with "user@cyloop.com"
#      When I press "Send"
#      Then I should see "Email has already been taken"
#      
#    Scenario: email used by a deleted account should be valid
#      Given I have a deleted user with email "user@cyloop.com"
#      And a filled out user registration form
#      But I fill in "Email" with "user@cyloop.com"
#      When I press "Send"
#      Then I should see "Step 2"      
#    
#    Scenario: name is required
#      Given a filled out user registration form
#      But I omit "Name"
#      When I press "Send"
#      Then I should see "Name can't be blank"
#     
#    Scenario: password is required
#      Given a filled out user registration form
#      But I omit "Password"
#      When I press "Send"
#      Then I should see "Password can't be blank"
#     
#    Scenario: Opt out check box
#      When I go to the user registration page
#      Then I should see "I don’t wish to receive emails from Cyloop or its partners."
#    
#    Scenario: redirect after successful sign up
#       Given a filled out user registration form
#       When I press "Send"
#       Then I should see "Step 2"
