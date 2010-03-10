# http://www.pivotaltracker.com/story/show/537937
Feature: Translation per site
  So that users can understand what they're seeing
  As a user
  I want to see the right language for each sitee\

  Scenario: Current site Cyloop
    Then the current locale should be "en"
    
  Scenario: Current site MSN Mexico
    Given the current site is "MSN Mexico"
    And the default locale for site "MSN Mexico" is "es"
    Then the current locale should be "es"
    
  Scenario: Current site MSN Brazil
    Given the current site is "MSN Brazil"
    And the default locale for site "MSN Brazil" is "pt_BR"
    Then the current locale should be "pt_BR"