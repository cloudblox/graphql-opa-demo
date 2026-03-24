Feature: Zorgkantoor - initieel verantwoordelijk
  Na de ontvangst van de notificatie NIEUWE_INDICATIE_ZORGKANTOOR 
  op basis van de (ontvangen) wlzIndicatieID en eigen identificatie, 
  de bijbehorende WlzIndicatie raadplegen inclusief Clientgegevens

  Scenario: WlzIndicatie should succeed with valid scope
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzindicatieregister/indicaties/indicatie:read"
        ],
        "uzovi": "5151",
        "instantie_type": "Zorgkantoor"
      }
      """
    Given My variables are
      """
      {
        "wlzIndicatieID": "AC0DA41F-19CC-4A42-992B-493996F5D9A0",
        "initieelVerantwoordelijkZorgkantoor" : "5151"
      }
      """
    When I send the graphql request "wlzindicatie/POL108/POL108.graphql" to "indicatieregister"
    Then the response code should be 200

    Scenario: WlzIndicatie should not succeed when the scope is incorrect
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzindicatie/register/indicaties/indicatie:read"
        ],
        "uzovi": "5151",
        "instantie_type": "Zorgkantoor"
      }
      """
    Given My variables are
      """
      {
        "wlzIndicatieID": "AC0DA41F-19CC-4A42-992B-493996F5D9A0",
        "initieelVerantwoordelijkZorgkantoor" : "5151"
      }
      """
    When I send the graphql request "wlzindicatie/POL108/POL108.graphql" to "indicatieregister"
    Then the response code should be 400
    And the response body should contain the error message "WlzIndicatie query: scope not allowed"

  Scenario: WlzIndicatie should fail when initieelVerantwoordelijkZorgkantoor is not equal to claims uzovi
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzindicatieregister/indicaties/indicatie:read"
        ],
        "uzovi": "5001",
        "instantie_type": "Zorgkantoor"
      }
      """
    Given My variables are
      """
      {
        "wlzIndicatieID": "AC0DA41F-19CC-4A42-992B-493996F5D9A0",
	      "initieelVerantwoordelijkZorgkantoor" : "5151"
      }
      """
    When I send the graphql request "wlzindicatie/POL108/POL108.graphql" to "indicatieregister"
    Then the response code should be 401
    And the response body should contain the error message "Actor's uzovi does not equal `initieelVerantwoordelijkZorgkantoor`"

  Scenario: WlzIndicatie should fail when wlzIndicatieID is not set
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzindicatieregister/indicaties/indicatie:read"
        ],
        "uzovi": "5151",
        "instantie_type": "Zorgkantoor"
      }
      """
    Given My variables are
      """
      {
        "wlzIndicatieID": "",
	      "initieelVerantwoordelijkZorgkantoor" : "5151"
      }
      """
    When I send the graphql request "wlzindicatie/POL108/POL108.graphql" to "indicatieregister"
    Then the response code should be 401
    And the response body should contain the error message "A where 'wlzindicatieID' is required."
