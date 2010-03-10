# http://www.pivotaltracker.com/story/show/378388
Feature: Profile Charts - Songs view
  In order to view my top songs
  As a logged-in consumer, on my charts page, I would like to see my top songs

  Acceptance Criteria:
  -- Order by plays descending
  -- Bar chart representing  total song plays with count
  -- Song title and Artist name hyperlinked "[Songname] by [Artist]"
  -- Play icon redirects consumer to Artists page with song queued

#  Scenario: User listens to songs
#    Given I am logged in
#    And I have activated my account
#    And I have listened to "Echoes" by "Pink Floyd" 2 times
#    And I have listened to "Time" by "Pink Floyd" 1 times
#    And I have listened to "Who Let the Dogs Out?" by "Baha Men" 3 times
#    When I go to my charts songs page
#    Then I should see the following songs
#      |Who Let the Dogs Out?|
#      |Echoes               |
#      |Time                 |
#
#  Scenario: User clicks on artist name 
#    Given I am logged in
#    And an artist "Mana" has the following songs
#      |title                    |duration     |album_name      |
#      |Arde el cielo            |00:00:00     |Arde el Cielo   |
#      |Como dueles en los labios|00:00:00     |Sueños Liquidos |  
#    And I have listened to the song "Arde el cielo" on "Arde el cielo" by "Mana" 2 times
#    And I have listened to the song "Como dueles en los labios" on "Sueños Liquidos" by "Mana" 1 times
#    When I go to my charts songs page
#    And I click the link for the artist "Mana" for the album titled "Arde el cielo"
#    Then I should be on the "Arde el cielo" album page for "Mana"
    
