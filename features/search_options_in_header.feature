# http://www.pivotaltracker.com/story/show/403703
Feature: Header: Search
  In order to quickly search for media,
  As A user,
  I want the ability to search for content on the header.


  Acceptance criteria:

  - Display search text box with " Search Artists" as place holder text.
  - Change place holder text accordingly when user selects from the filter drop down.
  - Artist should be the default filter.
  - As user hovers over the text field display a drop down menu:
  * Search Artist: Redirects user to search result page with the artist tab selected and the results based on artist search.
  * Search Song: Redirects user to the search result page with the Song tab selected and the results based on a song search criteria.
  Search People: Redirects user to the search result page with the People tab selected and the results for people search.
  - There will be no predictive search on this header.
  - As user starts to type remove the place holder text
  - highlight the selected filter on the drop down.
  - User must press the Enter key or click the Search "Button" to activate the search.

  Error handling:
  - if no text is entered in the text field and the user presses enter, redirect them to the search result page with artist set at as the filter.

  Scenario: Search Artists
    Given I am on the home page
    Then I should see "Search Artists"

  Scenario: Search Songs
    Given I am on the home page
    Then I should see "Search Songs"

  Scenario: Search Albums
    Given I am on the home page
    Then I should see "Search Albums"

  Scenario: Search People
    Given I am on the home page
    Then I should see "Search People"

  Scenario: Search Web
    Given the current site is "MSN Brazil"
    And the default locale for site "MSN Brazil" is "pt_BR"
    And I am on the login page
    # Then "Procurar na web" should match against the HTML

  Scenario: Don't search web if on Cyloop
    Given I am on the home page
    Then I should not see "Search Web"
