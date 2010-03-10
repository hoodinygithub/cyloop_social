# http://www.pivotaltracker.com/story/show/441781
Feature: Color Customization Layer- Background Image 
  In order to customize the background image on my profile,
  As a logged in user,
  I want a customization layer surfaced.

  Acceptance Criteria:
  - Invoke image upload layer when you click on Background image box.
  - Alignment field: Drop down (Upper left, Upper center, Upper right, Center, Lower left, lower right, lower center),
  - Repeat Image: Drop down (full repeat, no repeat, Horizontal repeat, Vertical repeat)
  - Fixed (yes/no)
  - Default Settings: Alignment: ( upper left) repeat image: (no repeat) Fixed:  (yes)


  Action Buttons:
  - Save: Save changes
  - Restore Defaults: Changes this field to its default state.

  Scenario: upload background image
    Given I am logged in
    And I have activated my account
    And I have a city
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I click "Save"
    Then "sample-image.jpg" should match against the generated css
  
  Scenario: default for alignment field
    Given I am logged in
    When I go to my customizations page
    Then I should see the option "Upper Left" as the first item for field "user[background_align]"

  Scenario: default for repeat image
    Given I am logged in
    When I go to my customizations page
    Then I should see the option "No Repeat" as the first item for field "user[background_repeat]"

  # This is not accurate in the behavior. Not sure i fthe spec is accurate.
  # Scenario: default for fixed
  #   Given I am logged in
  #   And I have activated my account
  #   And I have a city
  #   When I go to my customizations page
  #   Then the radio button "Yes" for "user[background_fixed]" should be chosen
      
  Scenario: restore to defaults affects background settings
    Given I am logged in
    And I have activated my account
    And I have a city
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Lower Center" from "user[background_align]"
    And I select "Vertical Repeat" from "user[background_repeat]"
    And I select "Yes" from "user[background_fixed]"
    And I click "Save"
    When I go to my customizations page
    And I click "Restore Defaults"
    Then "background-position:\s*bottom center" should not match against the generated css
    And "background-repeat:\s*repeat-y" should not match against the generated css
    And "background-attachment:\s*fixed" should not match against the generated css
  
  Scenario: alignment field - upper left
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Upper Left" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*top left" should match against the generated css 
  
  Scenario: alignment field - upper center
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Upper Center" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*top center" should match against the generated css
  
  Scenario: alignment field - upper right
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Upper Right" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*top right" should match against the generated css

  Scenario: alignment field - left
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Left" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*center left" should match against the generated css

  Scenario: alignment field - center
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Center" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*center center" should match against the generated css

  Scenario: alignment field - right
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Right" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*center right" should match against the generated css
  
  Scenario: alignment field - lower left
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Lower Left" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*bottom left" should match against the generated css
  
  Scenario: alignment field - lower center
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Lower Center" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*bottom center" should match against the generated css
  
  Scenario: alignment field - lower right
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Lower Right" from "user[background_align]"
    And I click "Save"
    Then "background-position:\s*bottom right" should match against the generated css
  
  Scenario: repeat image - full repeat
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Full Repeat" from "user[background_repeat]"
    And I click "Save"
    Then "background-repeat:\s*auto" should match against the generated css
  
  Scenario: repeat image - no repeat
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "No Repeat" from "user[background_repeat]"
    And I click "Save"
    Then "background-repeat:\s*no-repeat" should match against the generated css
  
  Scenario: repeat image - horizontal repeat
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Horizontal Repeat" from "user[background_repeat]"
    And I click "Save"
    Then "background-repeat:\s*repeat-x" should match against the generated css
  
  Scenario: repeat image - vertical repeat
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Vertical Repeat" from "user[background_repeat]"
    And I click "Save"
    Then "background-repeat:\s*repeat-y" should match against the generated css
  
  Scenario: fixed - yes
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "Yes" from "user[background_fixed]"
    And I click "Save"
    Then "background-attachment:\s*fixed" should match against the generated css
  
  Scenario: fixed - no
    Given I am logged in
    And I go to my customizations page
    When I attach the "image/jpg" file at "sample-image.jpg" to "Background Image"
    And I select "No" from "user[background_fixed]"
    And I click "Save"
    Then "background-attachment:\s*scroll" should match against the generated css
