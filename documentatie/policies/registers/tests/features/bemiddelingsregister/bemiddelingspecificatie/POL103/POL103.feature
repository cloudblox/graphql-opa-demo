Feature: get a full Bemiddeling from bemiddelingsregister
    In order to get a Bemiddelingspecificatie
    As a client
    I need to be able to request a Bemiddelingspecificatie by ID

    #POL103: BRA0001 - BRA0005
    Scenario: get a full bemiddeling as zorgaanbieder <name>
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
                "ToewijzingEinddatum": <toewijzingEinddatum>,
                "VaststellingMoment": "<vaststellingmoment>",
                "DagVaststellingMoment": "<dagvaststellingmoment>"
            }
            """
        When I send the graphql request "bemiddelingspecificatie/POL103/<query>.graphql" to "bemiddelingsregister"
        Then the response code should be 200

        Examples:
            | name                                        | toewijzingIngangsdatum | toewijzingEinddatum   | vaststellingmoment   | dagvaststellingmoment | query                       |
            | min day                                     | 2024-02-21             | "2025-07-15"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL103                      |
            | max date                                    | 2024-02-21             | "2025-07-15"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL103                      |
            | variable day check                          | 2025-01-01             | "2026-12-31"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL103                      |
            | with null enddate                           | 2024-04-17             | null                  | 2024-02-21T03:07:34Z | 2024-02-21            | POL103_with_null_enddate    |
            | without and operator                        | 2024-04-17             | "2026-12-31"          | 2024-02-21T03:07:34Z | 2024-02-21            | POL103_without_and_operator |
            | with vaststellingmoment before ingangsdatum | 2024-04-17             | "2026-12-31"          | 2024-02-21T15:07:34Z | 2024-02-21            | POL103                      |