Feature: Add company avatar
  As authorized user
  I am able to add a company avatar for not yet existing customer

  Background: Existing User
    Given an existing user with name "the_usr", email "usr@dom.com" and password "usr123456"

    Scenario: Create company avatar
      When I click the plus button
      And choose a file "logo_1.png"
      Then the chosen file "logo_1.png" will appear in the page
      And I am able to click the button "Upload"
      And the logo will appear in the page
      And I can see the size of the image "XXKB"