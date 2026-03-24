Feature: Get a wlzindicatie as Zorgaanbieder
  and the zorgaanbieder is instelling of bemiddeling Fail

  Scenario: Get a WlzIndicatie and none of the bemiddelingsregisters has the wlzIndicatieID by the agb code
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
    Given My http request mocks are "indicatieregister/wlzindicatie/POL104_no_result.json"
    When I send the graphql request "wlzindicatie/POL104/POL104.graphql" to "indicatieregister"
    Then the response code should be 401
    And the response body should contain the error message "Subject is not listed as `instelling` of a bemiddeling with the specified `wlzindicatieID`"

  Scenario: Get a WlzIndicatie and none of the bemiddelingsregisters has the wlzIndicatieID by the agb code
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
        "wlzIndicatieID": ""
      }
      """
    Given My http request mocks are "indicatieregister/wlzindicatie/POL104_one_result.json"
    When I send the graphql request "wlzindicatie/POL104/POL104.graphql" to "indicatieregister"
    Then the response code should be 401
    And the response body should contain the error message "A where 'wlzindicatieID' is required."

  Scenario: Get a WlzIndicatie and none of the bemiddelingsregisters has the wlzIndicatieID by the agb code
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
      }
      """
    Given My http request mocks are "indicatieregister/wlzindicatie/POL104_one_result.json"
    When I send the graphql request "wlzindicatie/POL104/POL104_no_indicatie_id.graphql" to "indicatieregister"
    Then the response code should be 401
    And the response body should contain the error message "A where 'wlzindicatieID' is required."

  Scenario: PIP request to the bemiddelingsregister should not fail as other organisation
    Given My claims are
      """
      {
        "scopes": [
          "registers/wlzbemiddelingsregister/bemiddeling:read"
        ],
        "kvk": "28065868"
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
    Then the response code should be 401
    And the response body should contain the error message "The 'uzovi' claim is not present in your token but required for the bemiddeling query."
    