Feature: get Regiehouder from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL100 - BRA0012
    Scenario: get a regiehouder as zorgaanbieder with different instelling
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
                "Instelling": "999999"
            }
            """
        When I send the graphql request "regiehouder/POL100/POL100.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'instelling' equals is required and set to your agb."

    #POL100 - BRA0012
    Scenario: get a regiehouder as zorgaanbieder without an instelling
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
                "regiehouderID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0"
            }
            """
        When I send the graphql request "regiehouder/POL100/POL100_without_instelling.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'instelling' equals is required."

    #POL100 - BRA0012
    Scenario: get a regiehouder as zorgaanbieder without a regiehouder id in query
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
                "Instelling": "51510101"
            }
            """
        When I send the graphql request "regiehouder/POL100/POL100.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'regiehouderID' equals is required."

    #POL100 - BRA0012
    Scenario: get a regiehouder as zorgaanbieder with an empty regiehouder id
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
                "Instelling": "51510101"
            }
            """
        When I send the graphql request "regiehouder/POL100/POL100_without_regiehouderID.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'regiehouderID' equals is required."
        
    #POL100-BRA0012
    Scenario: get a bemiddeling as zorgaanbieder with an <illegal_entity> in the query
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
        When I send the graphql request "regiehouder/POL100/POL100_with_<illegal_entity>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'overdracht' and 'overdrachtSpecificatie' may not be queried as part of this query."
        
        Examples:
        | illegal_entity         |
        | overdracht             |

    #POL100-BRA0001
    Scenario: get a regiehouder as zorgaanbieder with <subquery_type> in the client without toewijzingsdata
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
        When I send the graphql request "regiehouder/POL100/POL100_with_<subquery_type>_without_valid_dates.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "other 'bemiddelingspecificaties', 'regiehouder', contactpersoon' and 'contactgegevens' must be queried with a 'bemiddelingspecificatie' query."

        Examples:
        | subquery_type           |
        | all_subentities         |
        | contactgegevens         |
        | contactpersoon          |
        | regiehouder             |
        | regiehouder             |
