# http://www.pivotaltracker.com/story/show/406497
Feature: Consumer Public Profile Page - Sidebar - Top Artists
  As a user of the site, visiting a Consumers page,
  I would like to see the list of Top Artists they are listening to

  Acceptance Criteria:
  - Module header "TOP ARTISTS"
  - Rank numbers 1-5
  - Artist Name - hyperlinked to their profile
  - If no date, then supress module

#  Scenario: Sidebar - Top Artists
#    Given I am logged in
#    And the following user
#      |name           |slug       |short_bio        |born_on        |websites                  |
#      |Jason Calleiro |jcalleiro  |Waaa I'm a slore |1980-06-03     |www.facebook.com/jcalleiro|
#    And user jcalleiro listened to "Echoes" by "Pink Floyd" 3 times
#    And user jcalleiro listened to "Time" by "Pink Floyd" 2 times
#    And user jcalleiro listened to "Who Let the Dogs Out?" by "Baha Men" 4 times
#    And user jcalleiro listened to "Te Quiero" by "Flex" 6 times
#    When I go to Jason Calleiro's page
#    Then I should see the following top artists 
#      |artist name|listens|
#      |Flex       |6      |
#      |Pink Floyd |5      |
#      |Baha Men   |4      |
