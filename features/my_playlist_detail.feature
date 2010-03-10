# http://www.pivotaltracker.com/story/show/441836
Feature: Consumer Private - Playlist page - detail view
  In order to view and/or manage my playlists
  As a user
  I want to access my Playlist detail page

  -Share: phase 2
  -Comments: phase 2
  -Rating: phase 2

  Scenario: Heading
    Given I am logged in
    And I have the following songs on playlist "SOBE hits"
      |song             |artist       |length in seconds|
      |I am the highway |Audio Slave  |120              |
      |Echoes           |Pink Floyd   |367              |
    When I go to my playlists page
    And I click "Play"
    Then I should see "SOBE hits"
    And I should see "Created less than a minute ago"
    And I should see "2 Songs"
    And I should see "Total Time: 08:07"

  # Scenario: Song
  #   Given I am logged in
  #   And I have activated my account
  #   And I have the following songs on playlist "SOBE hits"
  #     |song             |artist       |length in seconds|album        |
  #     |I am the highway |Audio Slave  |120              |Highway Album|
  #   When I go to my playlists page
  #   And I click "Play"
  #   Then I should see "I am the highway"
  #   And I should see "By Audio Slave"
  #   And I should see a medium avatar for "Audio Slave - Highway Album"
  #   And I should see "Length: 2:00"
  #   And I should see a "Delete" button

  # Scenario: Remove a Playlist Item
  #   Given I am logged in
  #   And I have activated my account
  #   And I have the following songs on playlist "SOBE hits"
  #     |song             |artist       |length in seconds|album        |
  #     |I am the highway |Audio Slave  |120              |Highway Album|
  #   When I go to my playlists page
  #   And I follow "SOBE hits"
  #   And I press "Delete"
  #   Then I should see "0 Songs"
    
  Scenario: Remove a Playlist Item when the duration is NULL
    Given I am logged in  
    And I have activated my account
    And I have the following songs on playlist "Metal"
      | song            | artist    | length in seconds | album     |
      | Refuse Resist   | Sepultura | 120               | Chaos A.D |
      | Territory       | Sepultura | 120               | Chaos A.D |
      | Slave New World | Sepultura |                   | Chaos A.D |
    When I go to my playlists page
    And I follow "Metal"
    Then I should see "3 Songs"
    And I should see "Total Time: 04:00"
    Then I want to remove "Slave New World" from my playlist "Metal"
    Then I should see "2 Songs"
    And I should see "Total Time: 04:00"
        
  Scenario: Playlist Item Detail
    Given I am logged in
    And I have activated my account  
    And I have the following songs on playlist "SOBE hits"
      |song             |artist       |length in seconds|album        |
      |I am the highway |Audio Slave  |120              |Highway Album|
    When I go to "I am the highway" details page from "SOBE Hits" playlist
    Then I should be on details page from artist "Audio Slave" and song "I am the highway"
  
  
  