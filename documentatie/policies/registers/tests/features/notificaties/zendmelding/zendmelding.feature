Feature: Zend een melding naar een zorgkantoor of zorgaanbieder

    Om een gebeurtenis aan een deelnemer kenbaar te maken
    Moet ik als bron partij
    Een melding beschikbaar kunnen stellen

    Scenario: Zend iWLZ foutmelding als zorgkantoor naar zorgkantoor
        Given My claims are
            """
            {
                "scopes": [
                    "organisaties/zorgkantoor/meldingen/melding:create"
                ],
                "uzovi": "5000",
                "instantie_type": "Zorgkantoor"
            }
            """
        Given My variables are
            """
            {
                "meldingInput": {
                    "timestamp": "2024-06-01T00:00:00Z",
                    "afzenderIDType": "UZOVI",
                    "afzenderID": "5000",
                    "eventType": "iWLZFOUTMELDING",
                    "ontvangerIDType": "UZOVI",
                    "ontvangerID": "5001",
                    "ontvangerKenmerk": "Zorgkantoor",
                    "subjectList": [
                        {
                            "recordID": "1",
                            "subject": "bemiddeling"
                        }
                    ]
                }
            }
            """
        When I send the graphql request "zendmelding.graphql" to "notificaties"
        Then the response code should be 200

    Scenario: Zend iWLZ foutmelding als zorgaanbieder naar zorgkantoor
        Given My claims are
            """
            {
                "scopes": [
                    "organisaties/zorgkantoor/meldingen/melding:create"
                ],
                "agb": "06999994",
                "instantie_type": "Zorgaanbieder"
            }
            """
        Given My variables are
            """
            {
                "meldingInput": {
                    "timestamp": "2024-06-01T00:00:00Z",
                    "afzenderIDType": "AGB",
                    "afzenderID": "06999994",
                    "eventType": "iWLZFOUTMELDING",
                    "ontvangerIDType": "UZOVI",
                    "ontvangerID": "5001",
                    "ontvangerKenmerk": "Zorgkantoor",
                    "subjectList": [
                        {
                            "recordID": "1",
                            "subject": "bemiddeling"
                        }
                    ]
                }
            }
            """
        When I send the graphql request "zendmelding.graphql" to "notificaties"
        Then the response code should be 200


    Scenario: Zend iWLZ foutmelding als Vecozo naar zorgkantoor
        Given My claims are
            """
            {
                "instantie_naam": "Vecozo",
                "scopes": [
                    "organisaties/zorgkantoor/meldingen/melding:create"
                ],
                "kvk": "18065868",
                "instantie_type": "Onderneming"
            }
            """
        Given My variables are
            """
            {
                "meldingInput": {
                "timestamp": "2024-06-01T00:00:00Z",
                "afzenderIDType": "KVK",
                "afzenderID": "18065868",
                "eventType": "iWLZFOUTMELDING",
                "ontvangerIDType": "UZOVI",
                "ontvangerID": "5000",
                "ontvangerKenmerk": "Zorgkantoor",
                    "subjectList": [
                        {
                            "recordID": "1",
                            "subject": "bemiddeling"
                        }
                    ]
                }
            }
            """
        When I send the graphql request "zendmelding.graphql" to "notificaties"
        Then the response code should be 200
