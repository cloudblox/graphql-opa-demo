Feature: get Client from bemiddelingsregister
  In order to get a Client
  As a client
  I need to request a Client by out

  Scenario: get a Client without some bemiddeling verantwoordelijkZorgkantoor
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzbemiddelingsregister/bemiddeling:read"
        ],
        "uzovi": "5151"
      }
      """
    When I send the graphql request "client/POL110/POL110_without_some_bemiddeling_verantwoordelijk_zorgkantoor.graphql" to "bemiddelingsregister"
    Then the response code should be 400
    And the response body should contain the error message "A where 'verantwoordelijkZorgkantoor' equals is required."

  Scenario: get a client with different verantwoordelijkZorgkantoor
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
    When I send the graphql request "client/POL110/POL110.graphql" to "bemiddelingsregister"
    Then the response code should be 400
    And the response body should contain the error message "A where 'verantwoordelijkZorgkantoor' equals is required and must be set to your uzovi."

  Scenario: get a client with missing claim
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
    When I send the graphql request "client/POL110/POL110.graphql" to "bemiddelingsregister"
    Then the response code should be 401
    And the response body should contain the error message "The 'uzovi' claim is not present in your token but required for the bemiddeling query."