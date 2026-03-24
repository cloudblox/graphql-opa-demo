Feature: get Bemiddelingspeficatie from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL102-BRA0001
    Scenario: get a bemiddelingspecificatie as zorgaanbieder
        Given My claims are
            """
            {
                "scopes": [
                    "registers/wlzbemiddelingsregister/bemiddeling:read"
                ],
                "agb": "66600011"
            }
            """
        Given My variables are
            """
            {
                "BemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "Instelling": "66600011"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL102/POL102.graphql" to "bemiddelingsregister"
        Then the response code should be 200

    #POL102
    Scenario: get a bemiddelingspecificatie as zorgaanbieder zonder bemiddeling
        Given My claims are
            """
            {
                "scopes": [
                    "registers/wlzbemiddelingsregister/bemiddeling:read"
                ],
                "agb": "66600011"
            }
            """
        Given My variables are
            """
            {
                "BemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "Instelling": "66600011"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL102/POL102_without_bemiddeling.graphql" to "bemiddelingsregister"
        Then the response code should be 200

