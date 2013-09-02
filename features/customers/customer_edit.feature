Feature: Edit customer
  As authorized user
  I am able to see all customers

  Background: Existing User
    Given an existing and logged-in user with name "the_usr", email "usr@dom.com" and password "usr123456"
    And customer with "Company A", "Siebenbrunnengasse 44", "1050", "Wien", "Austria" and "POINT(48.186089 16.355124)"

  Scenario: Passing wrong values
    When I try to edit "Company A"
    And I remove the values and try to save
    Then I should see the message "can't be blank"

  Scenario Outline: Passing correct values
    When I try to edit "Company A"
    And I fill the fields with <name>, <street>, <zip>, <city>, <country> and <latlon>
    And I click "Update Customer"
    Then I should see the message "Customer has been updated"

  Examples:
    | name      | street      | zip           | city                | country         | latlon          |
    | Company B | Funstreet   | 1010          | Vienna              | Austria         | POINT(1 1)      |
    | Compnay C | Crystreet   | 1020          | Vienna              | Austria         | POINT(2 2)      |
    | Compnay D | Laughplace  | 1030          | Vienna              | Austria         | POINT(3 3)      |
