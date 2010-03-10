# http://www.pivotaltracker.com/story/show/371625
Feature: Step 1 - Terms of use link
  as a user, you can click on the "terms and conditions" link on the sign up page and a pop up appears with that links to the Terms of Use page.

  Validation:
  you must click on the link.

  Scenario: Viewing terms of use
    Given I am on the user registration page
    When I follow "terms and conditions"
    Then I should see "Terms and conditions"