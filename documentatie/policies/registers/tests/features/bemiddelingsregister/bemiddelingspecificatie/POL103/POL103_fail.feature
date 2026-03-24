Feature: get a full Bemiddeling from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL103: BRA0001 - BRA0005
    Scenario: get a full bemiddeling as zorgaanbieder without a required <missing_field> in the main query
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
                "BemiddelingspecificatieID": "<bemiddelingspecificatieID>",
                "Instelling": "<instelling>",
                "ToewijzingIngangsdatum": "<toewijzingIngangsdatum>",
                "ToewijzingEinddatum": "2025-07-15",
                "DagVaststellingMoment": "2024-02-21",
                "VaststellingMoment": "<vaststellingMoment>"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/POL103_without_<missing_field>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "<error_message>"

    Examples:
        | missing_field            | bemiddelingspecificatieID                    | instelling | toewijzingIngangsdatum | vaststellingMoment   | error_message                                                                                                   |
        | bemspecID                |                                              | 66600011   | 2024-02-21             | 2024-02-21T03:07:34Z | A where 'bemiddelingspecificatieID' equals is required                                                          |
        | vaststellingmoment       | c37239b0-9e3d-4c00-88fd-01f37e590fc0         | 66600011   | 2024-02-21             |                      | A where 'vaststellingMoment' equals is required when querying a subentity                                       |
        | instelling               | c37239b0-9e3d-4c00-88fd-01f37e590fc0         |            | 2024-02-21             | 2024-02-21T03:07:34Z | A 'instelling' or 'uitvoerendZorgkantoor' equals is required and must be set to your agb or uzovi respectively. |
        | ingangsdatum             | c37239b0-9e3d-4c00-88fd-01f37e590fc0         | 66600011   |                        | 2024-02-21T03:07:34Z | A where 'toewijzingIngangsdatum' equals is required                                                             |

    #POL103: BRA0001 - BRA0005
    Scenario: get a full bemiddeling as zorgaanbieder with an empty bemiddelingspecificatieID
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
                "Instelling": "66600011",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "DagVaststellingMoment": "2024-02-21",
                "VaststellingMoment": "2024-02-21T03:07:34Z"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/POL103.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A where 'bemiddelingspecificatieID' equals is required"
        
    #POL103 - BRA0005
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
                "Instelling": "66600011",
                "bemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "DagVaststellingMoment": "2024-02-21",
                "VaststellingMoment": "2024-02-21T03:07:34Z"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/POL103_with_<illegal_entity>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'overdracht' and 'overdrachtSpecificatie' may not be queried as part of this query."
        
        Examples:
        | illegal_entity         |
        | overdracht             |
        | overdrachtspecificatie |

    #POL103: BRA0001 - BRA0005
    Scenario: get a full bemiddeling as zorgaanbieder with illegal pgbPercentage query
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
                "Instelling": "66600011",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "DagVaststellingMoment": "2024-02-21",
                "VaststellingMoment": "2024-02-21T03:07:34Z"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/POL103_with_pgbpercentage_in_bemiddeling.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "You may only query your own 'pgbPercentage'."

    #POL103: BRA0001 - BRA0005
    Scenario: get a bemiddelingspecificatie as zorgaanbieder with a <subquery> the wrong enddate
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
                "Instelling": "66600011",
                "ToewijzingIngangsdatum": "<toewijzingIngangsdatum>",
                "ToewijzingEinddatum": "<toewijzingEinddatum>",
                "DagVaststellingMoment": "<dagvaststellingmoment>",
                "VaststellingMoment": "<vaststellingmoment>"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/POL103_with_invalid_enddate_<subquery>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "A <subquery_error> may only be queried until <timeframe> after the 'ToewijzingEinddatum'."

        Examples:
            | name               | toewijzingIngangsdatum | vaststellingmoment   | dagvaststellingmoment | toewijzingEinddatum | subquery                | timeframe                | subquery_error                             |
            | min day            | 2020-02-21             | 2020-02-21T03:07:34Z | 2020-02-21            | 2021-04-17          | contactgegevens         | 2 years                  | 'contactgegevens' or 'contactpersoon'      |
            | max date           | 2020-02-21             | 2020-02-21T03:07:34Z | 2020-02-21            | 2022-04-17          | contactpersoon          | 2 years                  | 'contactgegevens' or 'contactpersoon'      |
            | min day            | 2022-02-21             | 2020-02-21T03:07:34Z | 2020-02-21            | 2023-04-17          | bemiddelingspecificatie | the next year's may 31st | 'regiehouder' or 'bemiddelingspecificatie' |
            | max date           | 2022-02-21             | 2020-02-21T03:07:34Z | 2020-02-21            | 2023-04-17          | regiehouder             | the next year's may 31st | 'regiehouder' or 'bemiddelingspecificatie' |



    #POL103: BRA0001 - BRA0005
    Scenario: Get a full bemiddeling with an <subentity> without a toewijzingsdatum filter
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
                "Instelling": "66600011",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "DagVaststellingMoment": "2024-02-21",
                "VaststellingMoment": "2024-02-21T03:07:34Z"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/POL103_incorrect_toewijzigingingangsdatum_<subentity>.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'vaststellingMoment', 'toewijzingIngangsdatum', and `toewijzingEinddatum` are required and must be used to filter the subentities."

    Examples:
        | subentity               |
        | bemiddelingspecificatie |
        | regiehouder             |
        | contactgegevens         |
        | contactpersoon          |

    #POL103: BRA0001 - BRA0005
    Scenario: Get a full bemiddeling without einddatum filters without a null einddatum
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
                "Instelling": "66600011",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "DagVaststellingMoment": "2024-02-21",
                "VaststellingMoment": "2024-02-21T03:07:34Z"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/POL103_with_null_enddate.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'vaststellingMoment', 'toewijzingIngangsdatum', and `toewijzingEinddatum` are required and must be used to filter the subentities."

    #POL103: BRA0001 - BRA0005
    Scenario: Get a full bemiddeling with a fake date for the subentity datumfilter
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
                "Instelling": "66600011",
                "ToewijzingIngangsdatum": "2024-02-21",
                "ToewijzingEinddatum": "2025-07-15",
                "VaststellingMoment": "2024-02-21T03:07:34Z",
                "DagVaststellingMoment": "2024-02-21",
                "FakeDate": "2027-09-12"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/POL103_with_fake_date.graphql" to "bemiddelingsregister"
        Then the response code should be 400
        And the response body should contain the error message "'vaststellingMoment', 'toewijzingIngangsdatum', and `toewijzingEinddatum` are required and must be used to filter the subentities."