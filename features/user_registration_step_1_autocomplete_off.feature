# # http://www.pivotaltracker.com/story/show/471324
Feature: No autofill for registration
  So that users don't get annoyed when their browser fills info for them
  As a user
  I would like my browser to not autofill forms on registration


  Scenario: slug should have autocomplete set to off
    When I go to the user registration page
    Then the input field for "user[slug]" of type "text" should have autocomplete turned "off"

  Scenario: password should have autocomplete set to off
    When I go to the user registration page
    Then the input field for "user[password]" of type "password" should have autocomplete turned "off"
