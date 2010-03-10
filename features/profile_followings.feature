# http://www.pivotaltracker.com/story/show/376705
Feature: Consumer Private - Following page - Following
  In order to view and/or manage people who are following me or that I am following,
  As a logged in Consumer, would like to view my Following

  Acceptance criteria:

  - In private view, show Following tab with sub-link/button highlighted to reflect the view I am in

  List of people or artists that I am following, orders by date of follow selected, descending

  Display:
  Picture of person I am following
  City, State (Region), Country
  Leave Button - removes person from your following list

  Click on Username or photo to redirect to their profile

  Scenario: List of people I am following
    Given I am logged in
    And I am following 3 users
    When I go to my following index page
    Then I should see 3 followees
    
  Scenario: List of people I am following is in descending order by following creation
    Given I am logged in
    And I have activated my account
    And I am following these users
      |name   |slug       |started following  |
      |John   |jcalleiro  |2009-08-31         |
      |Ronald |rjeremy    |2008-08-31         |
      |Steve  |snedlin    |2007-08-31         |
    When I go to my following index page
    Then I should see these followees in order
      |John  |
      |Ronald|
      |Steve |
