# http://www.pivotaltracker.com/story/show/441509
Feature: Color Customization Layer
  In order to customize the colors on my customizations,
  As a logged in user,
  I want a customization layer surfaced.

  Acceptance Criteria:
  - Invoke color picker when user clicks on any of the following fields: Header Background, Main Font Color, Link Color, Background Color.

  Defaults:
  - Header BG 025D8C - Keep gradient. Refer to comp for header "area"
  - Main Font 666666 - Does not include links
  - Links 025D8C
  - Background ECECEC

  Action Buttons:
  - Save: Save changes
  - Restore Defaults: Changes this field to its default state.

  Background:
    Given I am logged in  

  Scenario: Requires login
    Given I log out
    When I go to my customizations page
    Then I should be on the login page
    
  Scenario: Clicking "Customize Page" takes me to color settings
    Given I am on my customizations page  
    When I go to my dashboard page
    And I click "Customize Page"
    Then I should be on the edit my customizations page

  Scenario: Default colors  
    Then I should have the default colors
    
  Scenario: User chooses a color for header background
    Given I am on my customizations page  
    When I fill in "user[color_header_bg]" with "FF0000"
    And I press "Save"
    And I go to my customizations page
    Then I should see the text field "user[color_header_bg]" filled with "FF0000"    

  Scenario: User chooses an invalid color for header background
    Given I am on my customizations page  
    When I fill file field "user[background]" with "test_doc1.doc" and format "msword"    
    And I press "Save"
    Then I should see "Background image can't be larger than 1 MB"

  Scenario: User chooses a color for main font
    Given I am on my customizations page  
    When I fill in "user[color_main_font]" with "00FF00"
    And I press "Save"
    And I go to my customizations page
    Then I should see the text field "user[color_main_font]" filled with "00FF00"

  Scenario: User chooses a color for links
    Given I am on my customizations page  
    When I fill in "user[color_links]" with "0000FF"
    And I press "Save"
    And I go to my customizations page
    Then I should see the text field "user[color_links]" filled with "0000FF"

  Scenario: User chooses a color for background
    Given I am on my customizations page  
    When I fill in "user[color_bg]" with "FFFF00"
    And I press "Save"
    And I go to my customizations page
    Then I should see the text field "user[color_bg]" filled with "FFFF00"
    
  Scenario: Restore defaults
    Given I have really bad colors
    When I go to my customizations page
    And I click "Restore Defaults"
    Then I should see "Your profile's customization settings have been reset to Cyloop's defaults."
    And I should have the default colors
