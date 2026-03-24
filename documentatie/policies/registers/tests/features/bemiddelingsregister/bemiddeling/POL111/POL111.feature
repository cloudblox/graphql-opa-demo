Feature: get Bemiddeling from bemiddelingsregister
  In order to get a Bemiddeling
  As a client
  I need to request a Bemiddeling by out

  Scenario: get a Bemiddeling
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
    When I send the graphql request "bemiddeling/POL111/POL111.graphql" to "bemiddelingsregister"
    Then the response code should be 200
