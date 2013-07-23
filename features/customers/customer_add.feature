
Feature: List all customers by an authorized user
  As authorized user
  I am able to see all customers

  Background: Existing User
  Given an existing user with name "the_usr", email "usr@dom.com" and password "usr123456"

  Scenario Outline: Create a new customer
    When I click "New customer"
    And fill the fields with <name>, <street>, <zip>, <city> and <country> and click subsequently "Create Customer"
    Then I should see the message "Customer has been created successfully."

    Examples:
      | name      | street      | zip           | city                | country         |
      | ABC       | Funstreet   | 1010          | Vienna              | Austria         |
      | DEF       | Crystreet   | 1020          | Vienna              | Austria         |
      | GHI       | Laughplace  | 1030          | Vienna              | Austria         |


