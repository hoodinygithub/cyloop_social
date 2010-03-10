# http://www.pivotaltracker.com/story/show/392060
# Feature: Home Top Songs Module
#   In order to discover new music that I will probably like
#   As a user viewing my home page
#   I would like to see top songs,
#   
#   Acceptance Criteria:
#   - Top 5 artist thumbnails should be shown most plays descending
#   - Data set should be site specific.
#   - Song play should be over 30 seconds.
#   - Song plays include on demand and radio plays.
#   
#   Line Item Display:
#   - Artist Photo: (60X60) Hyperlinks to artist profile in a new window.
#   - Song Title: Hyperlinks to artist profile with song in queue.
#   - Artist name: Hyperlinks to profile with song in queue.
#   
#   Scenario: Top songs
#     Given 10 songs have been listened to
#     When I go to the home page
#     Then I should see 5 top songs
#   
#   Scenario: Duplicate artists
#     Given I am logged in
#     And I have listened to "Echoes" by "Pink Floyd" 3 times
#     And I have listened to "Time" by "Pink Floyd" 2 times
#     And I have listened to "Who Let the Dogs Out?" by "Baha Men" 4 times
#     When I log out
#     And I go to the home page
#     Then I should see "Echoes"
#     And I should see "Who Let the Dogs Out?"
#     And I should not see "Time"
