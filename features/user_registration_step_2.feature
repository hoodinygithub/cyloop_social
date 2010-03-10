# # # http://www.pivotaltracker.com/story/show/371713
# Feature: User Registration Step 2
#   In order for the rec engine to have better information to recommend music with
#   As a newly registered user
#   I want to enter demographic information
# 
#   Scenario: gender drop down
#     Given I have advanced to step 2 of user registration
#     Then I should see a "Gender" label
#     And I should see "Male"
#     And I should see "Female"
# 
#   Scenario: birth date field
#     Given I have advanced to step 2 of user registration
#     Then I should see a "Birth date" label
# 
#   Scenario: save with valid attributes
#     Given a filled out user registration step 2 form
#     When I click "Send"
#     Then I should be on the artist recommendations page
# 
#   Scenario: city is required
#     Given a filled out user registration step 2 form
#     But I omit "user[city_name]"
#     When I click "Send"
#     Then I should see "City can't be blank"
# 
#   Scenario: city should be valid
#     Given a filled out user registration step 2 form
#     But I fill in "user[city_name]" with "slkdjfalkdjflkasjdf"
#     When I click "Send"
#     Then I should see "City can't be blank"
#   
#   Scenario: date of birth is required
#     Given a filled out user registration step 2 form
#     But I omit "user[born_on]"
#     When I click "Send"
#     Then I should see "Birth date can't be blank"
# 
#   Scenario: date of birth should be valid
#     Given a filled out user registration step 2 form
#     But I fill in "user[born_on]" with "lajdsfklajsdlkfjasdf"
#     When I click "Send"
#     Then I should see "Birth date can't be blank"
# 
#   Scenario: date of birth should not be in the future
#     Given a filled out user registration step 2 form
#     But I fill in "user[born_on]" with "2020/12/12"
#     When I click "Send"
#     Then I should see "Birth date can't be in the future" 