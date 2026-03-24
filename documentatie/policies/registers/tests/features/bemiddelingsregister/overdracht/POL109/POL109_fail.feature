Feature: get overdracht from bemiddelingsregister
    In order to get an overdracht
    As a VerantwoordelijkZorgkantoor
    I need to be able to request an overdracht by ID

    #POL109-BRA0010
    Scenario: get an overdracht as uitvoerendZorgkantoor without a VerantwoordelijkZorgkantoor
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
                "overdrachtID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0"
            }
            """
        When I send the graphql request "overdracht/POL109/POL109.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: A where 'verantwoordelijkZorgkantoor' equals is required and must be set to your uzovi."

    #POL109-BRA0010
    Scenario: get an overdracht as uitvoerendZorgkantoor with an incorrect VerantwoordelijkZorgkantoor
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
                "VerantwoordelijkZorgkantoor": "5252"
            }
            """
        When I send the graphql request "overdracht/POL109/POL109.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: A where 'verantwoordelijkZorgkantoor' equals is required and must be set to your uzovi."

    #POL109-BRA0010
    Scenario: get an overdracht as uitvoerendZorgkantoor without an overdrachtID
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
                "VerantwoordelijkZorgkantoor": "5151"
            }
            """
        When I send the graphql request "overdracht/POL109/POL109.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: A where 'overdrachtID' equals is required and must have a value."

    #POL109-BRA0010
    Scenario: get an overdracht as uitvoerendZorgkantoor with subentities without an OverdrachtDatum
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
                "VerantwoordelijkZorgkantoor": "5151"
            }
            """
        When I send the graphql request "overdracht/POL109/POL109<query>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Overdracht query: A where 'overdrachtDatum' equals is required when querying a subentity of an 'overdracht'."

        Examples:
        | query                                        |
        | _with_subentities_without_overdrachtdatum    |
        | _subentities_bemspec_without_overdrachtdatum |
