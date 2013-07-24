Feature: List customers
  As authorized user
  I am able to list all customers

  Background: Existing User
    Given an existing and logged-in user with name "the_usr", email "usr@dom.com" and password "usr123456"
    And following records in the database:
      | name      |
      | ABC       |
      | DEF       |
      | GHI       |

    Scenario: List customers
      When I click "All customers"
      Then I must see "3" customers
