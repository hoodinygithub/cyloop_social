# http://www.pivotaltracker.com/story/show/406285
Feature: Consumer Public Profile Page - Sidebar - Information
  As a user of the site, visiting a Consumers page,
  I would like to see additional information of the person I am visiting

  Acceptance Criteria:
  - Module title:  "INFORMATION"
  - Name: [username]
  - Location: [City, State]
  - Age: [age]
  - Websites: [list of websites]
  - Bio: [max 200 characters]

  Scenario: I want to see the consumers information
    Given the following user
      |name           |slug       |city_name                    |short_bio        |born_on        |websites                  |
      |Jason Calleiro |jcalleiro  |Miami, Florida, United States|Waaa I'm a slore |1980-06-03     |www.facebook.com/jcalleiro|
    When I go to Jason Calleiro's page
    Then I should see "Name: Jason Calleiro"
    And I should see "Location: Miami, Florida, United States"
    And I should see "Age: 29"
    And I should see "www.facebook.com/jcalleiro"
    And I should see "Bio: Waaa I'm a slore"
