Feature: get overdracht from bemiddelingsregister
    In order to get an overdracht
    As a VerantwoordelijkZorgkantoor
    I need to be able to request an overdracht by ID

    #POL114-BRA0010
    Scenario: get an overdracht as verantwoordelijkZorgkantoor with subentities
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
        When I send the graphql request "overdracht/POL114/POL114.graphql" to "bemiddelingsregister"
        Then the response code should be 200
