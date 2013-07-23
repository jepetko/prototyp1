
Feature: List all customers by an authorized user
  As authorized user
  I am able to see all customers

  Background: Existing User
  Given an existing user with these credentials:
  | email       | name        | password      | password_confirmation |
  | usr@dom.com | the_usr     | usr123456     | usr123456             |

  Scenario: Create a new customer
    When I click "New customer"
    And fill the fields with these values
    | name      | street      | zip           | city                | country         |
    | ABC       | Funstreet   | 1010          | Vienna              | AUT             |
    | DEF       | Crystreet   | 1020          | Vienna              | AUT             |
    | GHI       | Laughplace  | 1030          | Vienna              | AUT             |
    Then I should see the message "Customer created successfully."

  Scenario: List customers
    When I click "All customers"
    Then I should see the customer "ABC"
    And the number of customers should be "3"



