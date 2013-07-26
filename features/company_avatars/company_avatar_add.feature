@browser
Feature: Add company avatar
  As authorized user
  I am able to add a company avatar for not yet existing customer

  Background: Existing User
    Given an existing user with email "someone@domain.com" and password "pwd123456"

  Scenario: Create company avatar
      And I sign in in browser
      And I click "Customer" in browser
      And I click "New customer" in browser
      And I click "Avatar" in browser
      And choose a file "logo_1.png"
      Then the chosen file "logo_1.png" will appear in the page
      And I am able to click the button "Upload"
      And the logo will appear in the page
      And I can see the size of the image "3.5 KB"