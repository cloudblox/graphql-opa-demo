Feature: Get a wlzindicatie as verantwoordelijk Zorgkantoor	
  and the zorgaanbieder is instelling of bemiddeling Fail

  Scenario: Get a WlzIndicatie and none of the bemiddelingsregisters has the wlzIndicatieID by the agb code
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
    Given My http request mocks are "indicatieregister/wlzindicatie/POL113_no_result.json"
    When I send the graphql request "wlzindicatie/POL113/POL113.graphql" to "indicatieregister"
    Then the response code should be 401
    And the response body should contain the error message "Subject is not listed as `verantwoordelijkzorgkantoor` or `uitvoerendzorgkantoor` of a `bemiddeling` with the specified `wlzindicatieID`"

  Scenario: Get a WlzIndicatie and none of the bemiddelingsregisters has the wlzIndicatieID by the agb code
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
        "wlzIndicatieID": ""
      }
      """
    Given My http request mocks are "indicatieregister/wlzindicatie/POL113_one_result.json"
    When I send the graphql request "wlzindicatie/POL113/POL113.graphql" to "indicatieregister"
    Then the response code should be 401
    And the response body should contain the error message "A where 'wlzindicatieID' is required."

  Scenario: Get a WlzIndicatie and none of the bemiddelingsregisters has the wlzIndicatieID by the agb code
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
      }
      """
    Given My http request mocks are "indicatieregister/wlzindicatie/POL113_one_result.json"
    When I send the graphql request "wlzindicatie/POL113/POL113_no_indicatie_id.graphql" to "indicatieregister"
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
        "zorgkantoor": "5151"
      }
      """
    When I send the graphql request "pip/POL113/POL113_pip_request.graphql" to "bemiddelingsregister"
    Then the response code should be 401
    And the response body should contain the error message "The 'uzovi' claim is not present in your token but required for the bemiddeling query."
    