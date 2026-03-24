Feature: get Bemiddeling from bemiddelingsregister
  In order to get a Bemiddeling
  As a client
  I need to request a Bemiddeling by out

  Scenario: get a bemiddeling without verantwoordelijkZorgkantoor
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzbemiddelingsregister/bemiddeling:read"
        ],
        "uzovi": "5151"
      }
      """
    When I send the graphql request "bemiddeling/POL111/POL111_without_verantwoordelijk_zorgkantoor.graphql" to "bemiddelingsregister"
    Then the response code should be 400
    And the response body should contain the error message "'verantwoordelijkZorgkantoor' equals is required."

  Scenario: get a bemiddeling with missing claim
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzbemiddelingsregister/bemiddeling:read"
        ]
      }
      """
    Given My variables are
      """
      {
        "verantwoordelijkZorgkantoor": "5151"
      }
      """
    When I send the graphql request "bemiddeling/POL111/POL111.graphql" to "bemiddelingsregister"
    Then the response code should be 401
    And the response body should contain the error message "The 'uzovi' claim is not present in your token but required for the bemiddeling query."

  Scenario: get a bemiddeling with different verantwoordelijkZorgkantoor
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzbemiddelingsregister/bemiddeling:read"
        ],
        "uzovi": "5151"
      }
      """
    Given My variables are
      """
      {
        "verantwoordelijkZorgkantoor": "5252"
      }
      """
    When I send the graphql request "bemiddeling/POL111/POL111.graphql" to "bemiddelingsregister"
    Then the response code should be 400
    And the response body should contain the error message "A where 'verantwoordelijkZorgkantoor' equals is required and must be set to your uzovi."
