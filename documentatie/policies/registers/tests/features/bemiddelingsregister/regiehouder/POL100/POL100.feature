Feature: get regiehouder from bemiddelingsregister
    In order to get a regiehouder
    As a client
    I need to be able to request a regiehouder by ID

    #POL100-BRA0012
    Scenario: get a bemiddelingspecificatie as zorgaanbieder
        Given My claims are
            """
            {
                "scopes": [
                    "registers/wlzbemiddelingsregister/bemiddeling:read"
                ],
                "agb": "51510101"
            }
            """
        Given My variables are
            """
            {
                "regiehouderID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "Instelling": "51510101"
            }
            """
        When I send the graphql request "regiehouder/POL100/POL100.graphql" to "bemiddelingsregister"
        Then the response code should be 200

