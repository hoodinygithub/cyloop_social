# http://www.pivotaltracker.com/story/show/526887
Feature: Flag Sample Songs
  In order to differentiate between full play and sample songs,
  as a user,
  I would like to see 30 second songs flagged

  Acceptance Criteria:
  - if song length <30 then display visual indicator for the following modules:
  * What do you want to listen to module
  * Song activity feeds
  * Album detail page

  Background:
    Given the countries:
    | name           | code |
    | United States  | US   |
    | United Kingdom | UK   |
    | Spain          | ES   |
    Given the current country is "US"

  # Scenario: Show duration when song is playable in the user's country
  # Given the following artists 
# | name  | slug  |
# | Feist | feist |
  # And Feist has the following songs on the album "The Reminder"
# | song           | artist | position | duration | album_name   | available_countries |
# | My Moon My Man | Feist  | 1        | 120      | The Reminder | US,UK,ES            |
# | The Water      | Feist  | 2        | 60       | The Reminder | US,UK,ES            |
# | I Feel It All  | Feist  | 3        | 120      | The Reminder | US,UK,ES            |
  # When I go to the album page for "The Reminder" by "Feist"
  # And I should see a duration of "2:00" for the song "My Moon My Man" by "Feist"
  # And I should see a duration of "1:00" for the song "The Water" by "Feist"
  # And I should see a duration of "2:00" for the song "I Feel It All" by "Feist"

  # Scenario: Show 30 second sample image as duration when song is not playable in the user's country
  # Given the following artists
# | name  | slug  |
# | Feist | feist |
  # And Feist has the following songs on the album "The Reminder"
# | song             | artist | position | duration | album_name   | available_countries |
# | So Sorry         | Feist  | 1        | 120      | The Reminder | UK,ES               |
# | 1,2,3,4          | Feist  | 2        | 120      | The Reminder | UK,ES               |
# | Brandy Alexander | Feist  | 3        | 120      | The Reminder | US                  |
  # When I go to the album page for "The Reminder" by "Feist"
  # Then I should see a sample flag for the song "So Sorry" by "Feist"  
  # And I should see a sample flag for the song "1,2,3,4" by "Feist"
  # And I should see a duration of "2:00" for the song "Brandy Alexander" by "Feist"
  
  # Scenario: Show 30 second sample image as duration when song has no available countries but is not null
  # Given the following artists
# | name    | slug    |
# | Madonna | madonna |
  # And Madonna has the following songs on the album "Madonna"
# | song       | artist  | position | duration | album_name | available_countries |
# | Borderline | Madonna | 1        | 120      | Madonna    | US,ES               |
# | Lucky Star | Madonna | 2        | 120      | Madonna    | US,ES               |
# | Everybody  | Madonna | 3        | 120      | Madonna    | empty               |
  # When I go to the album page for "Madonna" by "Madonna"
  # Then I should see a duration of "2:00" for the song "Borderline" by "Madonna"  
  # And I should see a duration of "2:00" for the song "Lucky Star" by "Madonna"
  # And I should see a sample flag for the song "Everybody" by "Madonna"
  
  # Scenario: Show duration for manual uploads (available_countries is null)
  # Given the following artists
# | name    | slug    |
# | Madonna | madonna |
  # And Madonna has the following songs on the album "Greatest Hits"
# | song          | artist  | position | duration | album_name    | available_countries |
# | Like a Prayer | Madonna | 1        | 120      | Greatest Hits | ES                  |
# | Vogue         | Madonna | 2        | 120      | Greatest Hits | ES                  |
# | Oh Father     | Madonna | 3        | 120      | Greatest Hits |                     |
  # When I go to the album page for "Greatest Hits" by "Madonna"
  # Then I should see a sample flag for the song "Like a Prayer" by "Madonna"  
  # And I should see a sample flag for the song "Vogue" by "Madonna"
  # And I should see a duration of "2:00" for the song "Oh Father" by "Madonna"
  # 
