Feature: List customers by unauthorized user
  As unauthorized user
  I am not able to see any customers

  Scenario: Redirect to Log-In
    When I call the URL "/customers"
    Then I will be redirected to the Log-In page