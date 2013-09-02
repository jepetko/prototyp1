Feature: Create customer
  As authorized user
  I am able to see all customers

  Background: Existing User
  Given an existing and logged-in user with name "the_usr", email "usr@dom.com" and password "usr123456"

  Scenario Outline: Create a new customer
    When I click "New customer"
    And I fill the fields with <name>, <street>, <zip>, <city>, <country> and <latlon>
    And I click "Create Customer"
    Then I should see the message "Customer has been created successfully."

    Examples:
      | name      | street      | zip           | city                | country         | latlon          |
      | ABC       | Funstreet   | 1010          | Vienna              | Austria         | POINT(1 1)      |
      | DEF       | Crystreet   | 1020          | Vienna              | Austria         | POINT(2 2)      |
      | GHI       | Laughplace  | 1030          | Vienna              | Austria         | POINT(3 3)      |


