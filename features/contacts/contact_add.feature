@selenium
Feature: Add contact to a customer
  As an authenticated user
  I am able to add a contact to a customer

  Background: Existing User
    Given an existing and logged-in user with name "the_usr", email "usr@dom.com" and password "usr123456"
    Given a bunch of customers

    Scenario: Go to Add contact form
      When I sign in with valid credentials
      And I click "Customer"
      And I click "All customers"
      And I pick the customer at position "1" in order to click "Edit"
      And I click "Contacts"
      And I click "New contact"
      Then I must see a form where I can put contact data



