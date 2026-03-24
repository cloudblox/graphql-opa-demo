Feature: get Bemiddelingspeficatie from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL105 - BRA0006
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with different uzovi
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
                "BemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "UitvoerendZorgkantoor": "5252"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL105/POL105.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'uitvoerendZorgkantoor' equals is required and set to your uzovi"

    #POL105 - BRA0006
    Scenario: get a bemiddelingspecificatie as zorgaanbieder without an uzovi
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
                "BemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL105/POL105_without_uitvoerendzorgkantoor.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A 'instelling' or 'uitvoerendZorgkantoor' equals is required and must be set to your agb or uzovi respectively."

    #POL105 - BRA0006
    Scenario: get a bemiddelingspecificatie as zorgaanbieder without a bemiddelingspecificatie id in query
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
                "UitvoerendZorgkantoor": "5151"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL105/POL105.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'bemiddelingspecificatieID' equals is required."

        
    #POL105 - BRA0006
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with an <illegal_entity> in the query
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
        When I send the graphql request "bemiddelingspecificatie/POL105/POL105_with_<illegal_entity>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'overdracht' and 'overdrachtSpecificatie' may not be queried as part of this query."
        
        Examples:
        | illegal_entity         |
        | overdracht             |
        | overdrachtspecificatie |

    #POL105 - BRA0006
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with an empty bemiddelingspecificatie id
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
                "UitvoerendZorgkantoor": "5151"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL105/POL105_without_bemspecID.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'bemiddelingspecificatieID' equals is required."

    #POL105-BRA0006
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with <subquery_type> in the client without toewijzingsdata
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
                "BemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "UitvoerendZorgkantoor": "5151"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL105/POL105_with_<subquery_type>_without_valid_dates.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Bemiddelingspecificatie query: A where 'toewijzingIngangsdatum' equals is required when querying a subentity."

        Examples:
        | subquery_type           |
        | all_subentities         |
        | contactgegevens         |
        | contactpersoon          |
        | regiehouder             |
        | bemiddelingspecificatie |
