Feature: Add company avatar
  As authorized user
  I am able to add a company avatar for not yet existing customer

  Background: Existing User
    Given an existing user with email "someone@domain.com" and password "pwd123456"

  @browser
  Scenario Outline: Create company avatar
      When I open a browser instance "<browser>"
      And I sign in
      And I click "New customer"
      And I click the plus button
      And choose a file "logo_1.png"
      Then the chosen file "logo_1.png" will appear in the page
      And I am able to click the button "Upload"
      And the logo will appear in the page
      And I can see the size of the image "3.5 KB"

      Examples:
      | browser   |
      | chrome    |
      #| firefox   |