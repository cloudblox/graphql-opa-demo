Feature: Get a wlzindicatie as Zorgaanbieder
  and the zorgaanbieder komt voor in een Bemiddeling van de Indicatie	

  Scenario: Get a WlzIndicatie and zorgaanbieder is instelling in bemiddeling
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzindicatieregister/indicaties/indicatie:read"
        ],
        "agb": "51510101",
        "instantie_type": "Zorgaanbieder"
      }
      """
    Given My variables are
      """
      {
        "wlzIndicatieID": "ba7da7be-9952-4914-a384-5d997cb39132"
      }
      """
    Given My http request mocks are "indicatieregister/wlzindicatie/POL104_one_result.json"
    When I send the graphql request "wlzindicatie/POL104/POL104.graphql" to "indicatieregister"
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
        "instelling": "51510101"
      }
      """
    When I send the graphql request "pip/POL104/POL104_pip_request.graphql" to "bemiddelingsregister"
    Then the response code should be 200

    