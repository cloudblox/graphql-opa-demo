Feature: get a full Bemiddeling from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL106: BRA0006 - BRA0009
    Scenario: get a full bemiddeling as zorgkantoor <name>
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
                "ToewijzingEinddatum": <toewijzingEinddatum>,
                "VaststellingMoment": "<vaststellingmoment>",
                "DagVaststellingMoment": "<dagvaststellingmoment>"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL106/<query>.graphql" to "bemiddelingsregister"
        Then the response code should be 200

        Examples:
            | name                                        | toewijzingIngangsdatum | toewijzingEinddatum   | vaststellingmoment  | dagvaststellingmoment | query                         |
            | min day                                     | 2024-02-21             | "2025-07-15"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL106                        |
            | max date                                    | 2024-02-21             | "2025-07-15"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL106                        |
            | variable day check                          | 2025-01-01             | "2026-12-31"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL106                        |
            | with null enddate                           | 2024-04-17             | null                  | 2024-02-21T03:07:34Z | 2024-02-21            | POL106_with_no_enddate_filter |
            | without and operator                        | 2024-04-17             | "2026-12-31"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL106_without_and_operator   |
            | with vaststellingmoment before ingangsdatum | 2024-04-17             | "2026-12-31"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL106                        |