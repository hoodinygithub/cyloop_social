# http://www.pivotaltracker.com/story/show/370017
Feature: Dashboard - What Do You Want - Listen Control
  As a user viewing my dashboard page,
  I would like to search for a song to add to my Activity feed
  So that I can quickly grow my feed with what I want to listen to.

  Acceptance Requirements
  - input field to select artist name.
  - box appears show a list of all artist with the songs for that artist under them.
  - If results return more than one artist it will show them broken up in the list by the artist name.
  - if song is a 30 seconds sample display 30 second icon next to song name.

  Scenario: What do you want to - Listen Control
    Given An artist "Melocos" with songs
      |title    |duration     |
      |Song 1   |00:00:00     |
      |Song 2   |00:00:00     |
      |Song 3   |00:00:00     |
    And I am logged in
    And I am on my dashboard page
    When I fill in "name" with "Melocos"
    And I press "Go!"
    Then I should see "Melocos" and their songs
      |Song 1|
      |Song 2|
      |Song 3|
