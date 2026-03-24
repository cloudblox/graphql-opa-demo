Feature: get Bemiddelingspeficatie from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL105-BRA0006
    Scenario: get a bemiddelingspecificatie as uitvoerendZorgkantoor
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
                "BemiddelingspecificatieId": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "UitvoerendZorgkantoor": "5151"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL105/POL105.graphql" to "bemiddelingsregister"
        Then the response code should be 200

