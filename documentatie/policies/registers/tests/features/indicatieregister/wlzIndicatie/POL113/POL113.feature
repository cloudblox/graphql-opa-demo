Feature: Get a wlzindicatie as verantwoordelijk Zorgkantoor	
  and the zorgaanbieder komt voor in een Bemiddeling van de Indicatie	

  Scenario: Get a WlzIndicatie and zorgaanbieder is instelling in bemiddeling
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
        "wlzIndicatieID": "ba7da7be-9952-4914-a384-5d997cb39132"
      }
      """
    Given My http request mocks are "indicatieregister/wlzindicatie/POL113_one_result.json"
    When I send the graphql request "wlzindicatie/POL113/POL113.graphql" to "indicatieregister"
    Then the response code should be 200

  Scenario: PIP request to the bemiddelingsregister should not fail as VECOZO
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzbemiddelingsregister/bemiddeling:read"
        ],
        "instantie_type": "Onderneming",
        "instantie_naam": "VECOZO"
      }
      """
    Given My variables are
      """
      {
        "wlzIndicatieID": "ba7da7be-9952-4914-a384-5d997cb39132",
        "zorgkantoor": "5151"
      }
      """
    When I send the graphql request "pip/POL113/POL113_pip_request.graphql" to "bemiddelingsregister"
    Then the response code should be 200

    