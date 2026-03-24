Feature: Zorgkantoor - initieel verantwoordelijk
  Na de ontvangst van de notificatie NIEUWE_INDICATIE_ZORGKANTOOR 
  op basis van de (ontvangen) wlzIndicatieID en eigen identificatie, 
  de bijbehorende WlzIndicatie raadplegen inclusief Clientgegevens

  Scenario: WlzIndicatie should succeed with soon to be deprecated scope
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzindicatieregister/indicaties:read"
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