Feature: POL216 Silvester mag een AW34 versturen namens alle zorgaanbieders (agb's) als silvester namens een zorgkantoor (uzovi) acteert

  Scenario: Silvester acterend voor een zorgkantoor verstuurt een AW34 namens een zorgaanbieder
   Given My claims are
            """
            {
                "instantie_naam": "Vecozo",
                "scopes": [
                    "organisaties/zorgkantoor/meldingen/melding:create"
                ],
                "uzovi": "5151",
                "instantie_type": "Zorgkantoor",
                "act": {
                    "sub": "20001000001131"
                }
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
                    "ontvangerID": "5151",
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
