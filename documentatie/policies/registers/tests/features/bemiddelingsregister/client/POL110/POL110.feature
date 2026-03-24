Feature: get Client from bemiddelingsregister
  In order to get a Client
  As a client
  I need to request a Client by out

  Scenario: get a Client
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
        "verantwoordelijkZorgkantoor": "5151"
      }
      """
    When I send the graphql request "client/POL110/POL110.graphql" to "bemiddelingsregister"
    Then the response code should be 200

