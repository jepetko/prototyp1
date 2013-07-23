Feature: Show customer
  As Authorized User
  I am able to see a customer

  Background: Existing User
    Given an existing user with name "the_usr", email "usr@dom.com" and password "usr123456"
    And following customers:
    | name      |
    | ABC       |
    | DEF       |
    | GHI       |

    Scenario Outline: Show customer
      When I click "All customers"
      And I click at "Show" button of the customer with name <name>
      Then I should see a single customer with name <name>

      Examples:
        | name      |
        | ABC       |
        | DEF       |
        | GHI       |

