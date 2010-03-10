# #http://www.pivotaltracker.com/story/show/1237180
# Feature: Prevent XSS attacks
# 
#   In order to prevent XSS attacks
#   As a user
#   I want to have all bad input cleared out from my form submissions
# 
#   Scenario: Inserting bad data on user shot bio
#     Given the following user
# | name       | slug   | short_bio          | born_on    | websites       |
# | Bad Hacker | hacker | I am a mean hacker | 1980-06-03 | www.defcon.org |
#       And the user is fully registered
#       And I sign in as Bad Hacker
#       And I have activated my account
#      When I go to edit my settings page
#       And I should see "I am a mean hacker"
#       And I fill in "user[short_bio]" with "This is my short bio and you should <a href='http://somewhere.bad/'>Click here</a>"
#       And I fill in "user[city_name]" with "Miami"
#       And I press "Save"
#       And I should see "Your settings have been saved"
#       And I go to Bad Hacker's page
#      Then "<a href='http://somewhere.bad/'>Click here</a>" should not match against the HTML
#       And I should see "This is my short bio and you should Click here"
