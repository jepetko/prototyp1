@browser
Feature: Add invalid contact to a customer
  As an authenticated user
  I am able to add a contact to a customer

  Background: Existing User
    Given an existing and logged-in user with name "the_usr", email "usr@dom.com" and password "usr123456"
    Given a bunch of customers

  Scenario Outline: Go to Add contact form
    And I sign in in browser
    And I click "Customer" in browser
    And I click "All customers" in browser
    And I pick the first customer in order to click "Edit"
    And I click "Contacts" in browser in order to add a new contact
    And I click "New contact" in browser
    Then I must see a form where I can put contact data

    When I put <name>, <phone>, <note>
    And I click "Save contact" in browser
    Then a warning appears above the phone input field
    And the list of contacts is empty

  Examples:
        | name                  | phone             | note              |
        | Tom                   |                   | Little bit stupid |
        | Jerry                 | °dflkdg^dlf       | Pretty smart guy  |
