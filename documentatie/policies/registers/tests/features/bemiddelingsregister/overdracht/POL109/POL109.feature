Feature: get overdracht from bemiddelingsregister
    In order to get an overdracht
    As a VerantwoordelijkZorgkantoor
    I need to be able to request an overdracht by ID

    #POL109-BRA0010
    Scenario: get an overdracht as uitvoerendZorgkantoor
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
        When I send the graphql request "overdracht/POL109/POL109.graphql" to "bemiddelingsregister"
        Then the response code should be 200
