# http://www.pivotaltracker.com/story/show/440076
Feature: Consumer Private - Settings page - Accounts view
  In order to manage my account information,
  As a logged in consumer viewing my Settings page - Account view,
  I would like to have the abilty to view and edit my profile details.

  Acceptance Requirements:
  - View: "Account" selected by default
  - Fields include:
  --Name; max 100 chars
  --Web URL; max 50, alpha-numeric only
  --Time zone; select box
  --Short Bio; max 200 chars
  --Email address; max 100 chars
  --Websites (0:5)
  --Gender; select box male/female
  --Birthdate; mm/dd/yyyy use localized formatting
  --City; type ahead
  --Language; English, Spanish, Portuguese
  --Privacy Option; checkbox, default false
  --Cyloop and Partner marketing emails (opt in/out); check box, default true

  All fields are required with the exception of Bio and Websites
  - Must check for data absence/presence
  - Must check for data formatting

  Action:
  -Email update.  If current != new and value passes formatting checks, then send out auto email confirmation


  See design for details.

    Scenario: login required
      When I go to the my settings page
      Then I should be on the new session page

    Scenario: name is required
      Given I am logged in
      And a filled out user settings form
      But I omit "Name"
      When I press "Save"
      Then I should see "Name can't be blank"
      
    Scenario: name should be limited to 100 chars
      Given I am logged in
      And a filled out user settings form
      But I fill in "Name" with "ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJA"
      When I press "Save"
      Then I should see "Name is too long (maximum is 100 characters)"

    Scenario: email is valid
      Given I am logged in
      And a filled out user settings form
      But I fill in "Email" with "no thanks"
      When I press "Save"
      Then I should see "Email is invalid"

    # Scenario: email is required
    #   Given I am logged in
    #   And a filled out user settings form
    #   But I omit "Email"
    #   When I press "Save"
    #   Then I should see "Email can't be blank"
      
    Scenario: e-mail address should be limited to 100 characters
      Given I am logged in
      And a filled out user settings form
      But I fill in "Email" with "asdfadfadfasdfadfadfadfadfasdfasdfasdfadfadfadf@asdfasdfasdfasdfasdfadfasdfasdfasdfasdfasdfasdfasdfasdfa.com"
      When I press "Save"
      Then I should see "Email is too long (maximum is 100 characters)"

    Scenario: gender is an option
      Given I am logged in
      And I am on my settings page
      When I select "Male" from "user[gender]"

    Scenario: birth date is required
      Given I am logged in
      And a filled out user settings form
      But I omit "Birth date"
      When I press "Save"
      Then I should see "Birth date can't be blank"

    Scenario: bio works
      Given I am logged in
      And a filled out user settings form
      And I fill in "user[short_bio]" with "This is my bio."
      When I press "Save"
      Then I should see "This is my bio"
      And I should not see "prohibited this user from being saved"

    # Scenario: short bio should be limited to 200 characters
    #   Given I am logged in
    #   And a filled out user settings form
    #   But I fill in "user[short_bio]" with "sflasjdkfljaskldjflkajdflkasjdflkasjdflasjdfklajdlfkjadklfjaskldfjalksdfjalskdjfalksdjflaskdfjalsdjfaiwefjaoijfoiajsdlasndvoaiwjeoadjlasfoqejfoqwjfoqijdvoiqjfoqwjefoqjdoiqjoiqjwfoqnwdovqjwofijqweoifjqwoifjqwoidjvqow"
    #   When I press "Save"
    #   Then I should see "Bio short is too long (maximum is 200 characters)"
    
    Scenario: birthday is not in the future
      Given I am logged in
      And a filled out user settings form
      And I fill in "Birth date" with "2012/12/21"
      When I press "Save"
      Then I should see "Birth date can't be in the future"

    # Scenario: user is at least 13 years old
    #   Given I am logged in
    #   And a filled out user settings form
    #   And I fill in "Birth date" with a date within the last 13 years
    #   When I press "Save"
    #   Then I should see "You must be 13 years or older to use this website"

    # Scenario: city is required
    #   Given I am logged in
    #   And a filled out user settings form
    #   But I omit "City"
    #   When I press "Save"
    #   Then I should see "City can't be blank"

    # Scenario: websites save
    #   Given I am logged in
    #   And I am on my settings page
    #   And I fill in "user_websites_" with "http://myspace.com/digx"
    #   When I press "Save"
    #   And I go to my settings page
    #   Then I should have website "http://myspace.com/digx"