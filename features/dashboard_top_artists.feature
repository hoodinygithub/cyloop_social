# http://www.pivotaltracker.com/story/show/372594
Feature: Consumer Private - Sidebar - Top Artists
  So that users can listen to their favorite artists over and over,
  As a logged-in user viewing my dashboard page
  I would like to see my Top Artists

  Acceptance Criteria:
  - Display Ten (10) in descending order by most listens by user

  Line Item Display:
  - numeric place on list from 1-10
  - artist name (links to artist page)
  - Historical total play count

#  Scenario: Artists displayed in order of top listened
#    Given I am logged in
#    And I have listened to "Echoes" by "Pink Floyd" 3 times
#    And I have listened to "Time" by "Pink Floyd" 2 times
#    And I have listened to "Who Let the Dogs Out?" by "Baha Men" 4 times
#    And I have listened to "Te Quiero" by "Flex" 6 times
#    When I go to my dashboard page
#    Then I should see the following top artists
#      |artist name|listens|
#      |Flex       |6      |
#      |Pink Floyd |5      |
#      |Baha Men   |4      |
#
#  Scenario: Artists are linked to their profiles
#    Given I am logged in
#    And I have listened to "Echoes" by "Pink Floyd" 300 times
#    When I go to my dashboard page
#    And I click on the top artist "Pink Floyd"
#    Then I should be on Pink Floyd's page
#  
#  Scenario: Top Artists limited to 10
#    Given I am logged in
#    And I have listened to "Jackie's Strength" by "Tori Amos" 5 times
#    And I have listened to "Criminal" by "Fiona Apple" 3 times
#    And I have listened to "The Art Teacher" by "Rufus Wainwright" 1 time
#    And I have listened to "Samson" by "Regina Spektor" 2 times
#    And I have listened to "Heratics" by "Andrew Bird" 2 times
#    And I have listened to "Closer to Fine" by "Indigo Girls" 1 time
#    And I have listened to "B.M.F.A" by "Martha Wainwright" 3 times
#    And I have listened to "Chasing Pavements" by "Adele" 4 times
#    And I have listened to "Bird Gerhl" by "Antony and the Johnsons" 7 times
#    And I have listened to "Both Hands" by "Ani DiFranco" 2 times
#    And I have listened to "Ironic" by "Alanis Morrisette" 4 times
#    When I go to my dashboard page
#    Then I should see 10 top artists
    
