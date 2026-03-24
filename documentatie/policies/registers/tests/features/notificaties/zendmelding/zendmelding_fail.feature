Feature: Zend verkeerd een melding naar een zorgkantoor of zorgaanbieder

    Om een gebeurtenis aan een deelnemer kenbaar te maken
    Moet ik als bron partij
    Een melding beschikbaar kunnen stellen

   Scenario: Zend iWLZ foutmelding als zorgkantoor naar zorgaanbieder met een scope voor een zorgkantoor
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
                    "ontvangerIDType": "AGB",
                    "ontvangerID": "06999994",
                    "ontvangerKenmerk": "Zorgaanbieder",
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
        Then the response code should be 400
        And the response body should contain the error message "Scope for `ontvangerIDType` not valid."

    Scenario: Zend iWLZ foutmelding als Vecozo naar zorgaanbieder met een scope voor een zorgkantoor
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
                "ontvangerIDType": "AGB",
                "ontvangerID": "06999994",
                "ontvangerKenmerk": "Zorgaanbieder",
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
        Then the response code should be 400
        And the response body should contain the error message "Scope for `ontvangerIDType` not valid."

    Scenario: Zend iWLZ foutmelding als Vecozo naar onderneming met een scope voor een zorgkantoor
        Given My claims are
            """
            {
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
                "ontvangerIDType": "KVK",
                "ontvangerID": "62253778",
                "ontvangerKenmerk": "Onderneming",
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
        Then the response code should be 400
        And the response body should contain the error message "Scope for `ontvangerIDType` not valid."

    Scenario: Zend iWLZ foutmelding als zorgkantoor naar zorgaanbieder met een scope die mogelijk gebruikt kan worden voor meldingen
        Given My claims are
            """
            {
                "scopes": [
                    "organisaties/zorgaanbieder/meldingen/melding:create"
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
                    "ontvangerIDType": "AGB",
                    "ontvangerID": "06999994",
                    "ontvangerKenmerk": "Zorgaanbieder",
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
        Then the response code should be 400
        And the response body should contain the error message "ontvanger is not valid."


    Scenario: Zend iWLZ foutmelding als Vecozo naar zorgaanbieder met een scope die mogelijk gebruikt kan worden voor meldingen
        Given My claims are
            """
            {
                "instantie_naam": "Vecozo",
                "scopes": [
                    "organisaties/zorgaanbieder/meldingen/melding:create"
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
                "ontvangerIDType": "AGB",
                "ontvangerID": "06999994",
                "ontvangerKenmerk": "Zorgaanbieder",
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
        Then the response code should be 400
        And the response body should contain the error message "ontvanger is not valid."


    Scenario: Zend iWLZ foutmelding als Vecozo naar onderneming met een scope die mogelijk gebruikt kan worden voor meldingen
        Given My claims are
            """
            {
                "scopes": [
                    "organisaties/onderneming/meldingen/melding:create"
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
                "ontvangerIDType": "KVK",
                "ontvangerID": "62253778",
                "ontvangerKenmerk": "Onderneming",
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
        Then the response code should be 400
        And the response body should contain the error message "ontvanger is not valid."


    Scenario: Zend Unknown foutmelding als onderneming naar zorgkantoor
        Given My claims are
            """
            {
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
                "eventType": "FOUTMELDING",
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
        Then the response code should be 400
        And the response body should contain the error message "event_type is not valid."


    Scenario: Zend iWLZ foutmelding als onbekende onderneming naar zorgkantoor
        Given My claims are
            """
            {
                "instantie_naam": "JBR",
                "scopes": [
                    "organisaties/zorgkantoor/meldingen/melding:create"
                ],
                "kvk": "12345678",
                "instantie_type": "Onderneming"
            }
            """
        Given My variables are
            """
            {
                "meldingInput": {
                "timestamp": "2024-06-01T00:00:00Z",
                "afzenderIDType": "KVK",
                "afzenderID": "12345678",
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
        Then the response code should be 400
        And the response body should contain the error message "afzender_type is not valid."

    Scenario: Zend iWLZ foutmelding als zorgkantoor naar zorgkantoor met een tweede MeldingInput als input
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
                },
                "meldingInput2": {
                    "timestamp": "2024-06-01T00:00:00Z",
                    "afzenderIDType": "UZOVI",
                    "afzenderID": "5002",
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
        When I send the graphql request "zendmelding_meldinginput2.graphql" to "notificaties"
        Then the response code should be 400
        And the response body should contain the error message "afzender_id is not valid."