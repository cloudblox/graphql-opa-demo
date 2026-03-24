Feature: get an overdracht from bemiddelingsregister
    In order to get an overdracht
    As a VerantwoordelijkZorgkantoor
    I need to be able to request an overdracht by ID

    #POL114-BRA0010
    Scenario: get a complete overdracht as verantwoordelijkZorgkantoor without a VerantwoordelijkZorgkantoor
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
                "overdrachtID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "OverdrachtDatum": "2023-04-17",
                "OverdrachtDatumMinus1Dag": "2023-04-16"
            }
            """
        When I send the graphql request "overdracht/POL114/POL114.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: A where "verantwoordelijkZorgkantoor" is required."

    #POL114-BRA0010
    Scenario: get a complete overdracht as verantwoordelijkZorgkantoor with an incorrect VerantwoordelijkZorgkantoor
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
                "overdrachtID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "VerantwoordelijkZorgkantoor": "5252",
                "OverdrachtDatum": "2023-04-17",
                "OverdrachtDatumMinus1Dag": "2023-04-16"
            }
            """
        When I send the graphql request "overdracht/POL114/POL114.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: A where "verantwoordelijkZorgkantoor" equals is required and must be set to your "uzovi"."

    #POL114-BRA0010
    Scenario: get a complete overdracht as verantwoordelijkZorgkantoor without an overdrachtID
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
                "VerantwoordelijkZorgkantoor": "5151",
                "OverdrachtDatum": "2023-04-17",
                "OverdrachtDatumMinus1Dag": "2023-04-16"
            }
            """
        When I send the graphql request "overdracht/POL114/POL114.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: A where 'overdrachtID' equals is required and must have a value."

    #POL114-BRA0010
    Scenario: get a complete overdracht as verantwoordelijkZorgkantoor with subentities which aren't filtered on the overdrachtDatum
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
                "overdrachtID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "VerantwoordelijkZorgkantoor": "5151",
                "OverdrachtDatum": "2023-04-17",
                "OverdrachtDatumMinus1Dag": "2023-04-16"
            }
            """
        When I send the graphql request "overdracht/POL114/POL114<query>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: Subentities must be filtered using the `overdrachtDatum` and the day before the `overdrachtDatum`."

        Examples:
        | query                                            |
        | _with_subentities_without_overdrachtdatum_filter |
        | _subentities_bemspec_without_filter              |
        
    #POL114-BRA0010
    Scenario: get a complete overdracht as verantwoordelijkZorgkantoor with subentities with the wrong overdrachtdatum
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
                "overdrachtID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "VerantwoordelijkZorgkantoor": "5151",
                "OverdrachtDatum": "2023-04-17",
                "NepDatum": "2020-01-01",
                "OverdrachtDatumMinus1Dag": "2023-04-16"
            }
            """
        When I send the graphql request "overdracht/POL114/POL114_subentities_with_wrong_overdrachtdatum.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: Subentities must be filtered using the `overdrachtDatum` and the day before the `overdrachtDatum`."