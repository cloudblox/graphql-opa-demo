Feature: get Bemiddelingspeficatie from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL102 - BRA0001
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with different instelling
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
                "bemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "instelling": "999999"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL102/POL102.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'instelling' equals is required and set to your agb"

    #POL102 - BRA0001
    Scenario: get a bemiddelingspecificatie as zorgaanbieder without an instelling
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
                "bemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL102/POL102_without_instelling.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A 'instelling' or 'uitvoerendZorgkantoor' equals is required and must be set to your agb or uzovi respectively."

    #POL102 - BRA0001
    Scenario: get a bemiddelingspecificatie as zorgaanbieder without a bemiddelingspecificatie id in query
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
                "Instelling": "66600011"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL102/POL102.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'bemiddelingspecificatieID' equals is required."

    #POL102 - BRA0001
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with an empty bemiddelingspecificatie id
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
                "Instelling": "66600011"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL102/POL102_without_bemspecID.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'bemiddelingspecificatieID' equals is required."

    #POL102 - BRA0001
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with an <illegal_entity> in the query
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
        When I send the graphql request "bemiddelingspecificatie/POL102/POL102_with_<illegal_entity>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "<error_msg>"
        
        Examples:
        | illegal_entity         | error_msg                                                     |
        | overdracht             | 'overdracht' and 'overdrachtSpecificatie' may not be queried as part of this query. |      
        | overdrachtspecificatie | 'overdracht' and 'overdrachtSpecificatie' may not be queried as part of this query. |
        | bemiddeling_via_client | You may only query your own 'bemiddeling'.            |

    #POL102-BRA0001
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with <subquery_type> in the client without toewijzingsdata
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
        When I send the graphql request "bemiddelingspecificatie/POL102/POL102_with_<subquery_type>_without_valid_dates.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Bemiddelingspecificatie query: A where 'toewijzingIngangsdatum' equals is required when querying a subentity."

        Examples:
        | subquery_type           |
        | all_subentities         |
        | contactgegevens         |
        | contactpersoon          |
        | regiehouder             |
        | bemiddelingspecificatie |
