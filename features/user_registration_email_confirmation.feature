# # http://www.pivotaltracker.com/story/show/371645
# Feature: Email Confirmation Link (SMTP)
#   as a newly registered user,
#   i will receive an email with the registration confirmation,
#   so that i can verify that my email is not fake.
# 
#   Scenario: finished step 2 of registration
#     Given a filled out user registration step 2 form
#     When I press "Save"
#     Then "test@example.com" should receive 1 email
