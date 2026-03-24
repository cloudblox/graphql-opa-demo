Feature: get a full Bemiddeling from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL106: BRA0006 - BRA0009
    Scenario: get a full bemiddeling as zorgkantoor without a required <missing_field> in the main query
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
                "BemiddelingspecificatieID": "<bemiddelingspecificatieID>",
                "UitvoerendZorgkantoor": "<uitvoerendZorgkantoor>",
                "ToewijzingIngangsdatum": "<toewijzingIngangsdatum>",
                "ToewijzingEinddatum": "<toewijzingEinddatum>",
                "DagVaststellingMoment": "<dagvaststellingmoment>",
                "VaststellingMoment": "<vaststellingMoment>"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106_without_<missing_field>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "<error_message>"

    Examples:
        | missing_field            | bemiddelingspecificatieID                    | uitvoerendZorgkantoor | toewijzingIngangsdatum | toewijzingEinddatum | vaststellingMoment   | dagvaststellingmoment | error_message                                                                                                   |
        | bemspecID                |                                              | 5151                  | 2024-02-21             | 2025-07-15          | 2024-02-21T03:07:34Z | 2024-02-21            | A where 'bemiddelingspecificatieID' equals is required                                                          |
        | vaststellingmoment       | c37239b0-9e3d-4c00-88fd-01f37e590fc0         | 5151                  | 2024-02-21             | 2025-07-15          |                      |                       | A where 'vaststellingMoment' equals is required                                                                 |
        | uitvoerendzorgkantoor    | c37239b0-9e3d-4c00-88fd-01f37e590fc0         |                       | 2024-02-21             | 2025-07-15          | 2024-02-21T03:07:34Z | 2024-02-21            | A 'instelling' or 'uitvoerendZorgkantoor' equals is required and must be set to your agb or uzovi respectively. |
        | ingangsdatum             | c37239b0-9e3d-4c00-88fd-01f37e590fc0         | 5151                  |                        | 2025-07-15          | 2024-02-21T03:07:34Z | 2024-02-21            | A where 'toewijzingIngangsdatum' equals is required                                                             |

    #POL106: BRA0006 - BRA0009
    Scenario: get a full bemiddeling as zorgkantoor with an empty bemiddelingspecificatieID
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
                "UitvoerendZorgkantoor": "5151",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "VaststellingMoment": "2024-02-21T03:07:34Z",
                "DagVaststellingMoment": "2024-02-21"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106_without_vaststellingmoment.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'bemiddelingspecificatieID' equals is required"
                
    #POL106 - BRA0006 - BRA0009
    Scenario: get a bemiddelingspecificatie as zorgkantoor with an <illegal_entity> in the query
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
                "UitvoerendZorgkantoor": "5151",
                "BemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "VaststellingMoment": "2024-02-21T03:07:34Z",
                "DagVaststellingMoment": "2024-02-21"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106_with_<illegal_entity>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'overdracht' and 'overdrachtSpecificatie' may not be queried as part of this query."
        
        Examples:
        | illegal_entity         |
        | overdracht             |
        | overdrachtspecificatie |

    #POL106: BRA0006 - BRA0009
    Scenario: get a full bemiddeling as zorgkantoor with an invalid UitvoerendZorgkantoor
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
                "UitvoerendZorgkantoor": "5252",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "VaststellingMoment": "2024-02-21T03:07:34Z",
                "DagVaststellingMoment": "2024-02-21"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "Bemiddelingspecificatie query: A where 'uitvoerendZorgkantoor' equals is required and set to your uzovi."

    #POL106: BRA0006 - BRA0009
    Scenario: get a full bemiddeling as zorgkantoor with illegal pgbPercentage query
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
                "UitvoerendZorgkantoor": "5151",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "VaststellingMoment": "2024-02-21T03:07:34Z",
                "DagVaststellingMoment": "2024-02-21"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106_with_pgbpercentage_in_bemiddeling.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "You may only query your own 'pgbPercentage'."

    #POL106: BRA0006 - BRA0009
    Scenario: get a bemiddeling as zorgkantoor with a <subquery> the wrong enddate
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
                "UitvoerendZorgkantoor": "5151",
                "ToewijzingIngangsdatum": "<toewijzingIngangsdatum>",
                "ToewijzingEinddatum": "<toewijzingEinddatum>",
                "VaststellingMoment": "<vaststellingsmoment>",
                "DagVaststellingMoment": "<dagvaststellingmoment>"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106_with_invalid_enddate_<subquery>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A <subquery_error> may only be queried until <timeframe> after the 'ToewijzingEinddatum'."

        Examples:
            | name               | toewijzingIngangsdatum | toewijzingEinddatum | vaststellingsmoment  | dagvaststellingmoment | subquery                | timeframe                | subquery_error                             |
            | min day            | 2020-02-21             | 2021-04-17          | 2021-04-17T03:07:34Z | 2021-04-17            | contactgegevens         | 2 years                  | 'contactgegevens' or 'contactpersoon'      |
            | max date           | 2020-02-21             | 2022-04-17          | 2022-04-17T03:07:34Z | 2021-04-17            | contactpersoon          | 2 years                  | 'contactgegevens' or 'contactpersoon'      |
            | min day            | 2022-02-21             | 2023-04-17          | 2022-04-17T03:07:34Z | 2021-04-17            | bemiddelingspecificatie | the next year's may 31st | 'regiehouder' or 'bemiddelingspecificatie' |
            | max date           | 2022-02-21             | 2023-04-17          | 2022-04-17T03:07:34Z | 2021-04-17            | regiehouder             | the next year's may 31st | 'regiehouder' or 'bemiddelingspecificatie' |



    #POL106: BRA0006 - BRA0009
    Scenario: Get a full bemiddeling with an <subentity> from before your toewijzingIngangsdatum
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
                "UitvoerendZorgkantoor": "5151",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-04-17",
                "VaststellingMoment": "2024-02-21T03:07:34Z",
                "DagVaststellingMoment": "2024-02-21"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106_incorrect_toewijzigingingangsdatum_<subentity>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'vaststellingMoment', 'toewijzingIngangsdatum', and `toewijzingEinddatum` are required and must be used to filter the subentities."

    Examples:
        | subentity               |
        | bemiddelingspecificatie |
        | regiehouder             |
        | contactgegevens         |
        | contactpersoon          |

        
    #POL106: BRA0006 - BRA0009
    Scenario: Get a full bemiddeling without einddatum filters without a null einddatum
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
                "UitvoerendZorgkantoor": "5151",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-04-17",
                "VaststellingMoment": "2024-02-20T03:07:34Z",
                "DagVaststellingMoment": "2024-02-21"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106_with_no_enddate_filter.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'vaststellingMoment', 'toewijzingIngangsdatum', and `toewijzingEinddatum` are required and must be used to filter the subentities."

    #POL106: BRA0006 - BRA0009
    Scenario: Get a full bemiddeling with a fake date for the subentity datumfilter
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
                "UitvoerendZorgkantoor": "5151",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-04-17",
                "VaststellingMoment": "2024-02-21T03:07:34Z",
                "DagVaststellingMoment": "2024-02-21",
                "FakeDate": "2027-09-12"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106_with_fake_date.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'vaststellingMoment', 'toewijzingIngangsdatum', and `toewijzingEinddatum` are required and must be used to filter the subentities."

    #POL106: BRA0006 - BRA0009
    Scenario: Get a full bemiddeling with an invalid dagvaststellingmoment
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
                "UitvoerendZorgkantoor": "5151",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-04-17",
                "VaststellingMoment": "2024-02-21T03:07:34Z",
                "DagVaststellingMoment": "2024-01-01"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/POL106.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'vaststellingMoment', 'toewijzingIngangsdatum', and `toewijzingEinddatum` are required and must be used to filter the subentities."