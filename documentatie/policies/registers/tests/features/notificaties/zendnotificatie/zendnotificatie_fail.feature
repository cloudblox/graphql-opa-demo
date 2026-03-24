Feature: Verzoek tot muteren of het beschikbaar stellen van nieuwe informatie naar aanleiding van een gebeurtenis van een deelnemer aan een bron

	Om een gebeurtenis aan een deelnemer kenbaar te maken
	Moet ik als bron partij
	Een notificatie beschikbaar kunnen stellen

	Scenario: Zend als zorgkantoor een "<eventType>" notificatie naar een <ontvangerIDType>
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/<ontvangerIDScope>/notificaties/notificatie:create"
				],
				"uzovi": "5000",
				"instantie_type": "Zorgkantoor"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "UZOVI",
					"afzenderID": "5000",
					"eventType": "<eventType>",
					"ontvangerIDType": "<ontvangerIDType>",
					"ontvangerID": "",
					"ontvangerKenmerk": "",
					"subjectList": [
						{
							"recordID": "1",
							"subject": "bemiddeling"
						}
					]
				}
			}
			"""
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 400

		Examples:
			| eventType                                         | ontvangerIDType | ontvangerIDScope |
			| NIEUWE_INDICATIE_ZORGKANTOOR                      | UZOVI           | zorgkantoor      |
			| VERVALLEN_INDICATIE_ZORGKANTOOR                   | UZOVI           | zorgkantoor      |


	Scenario: Zend als 'Stiching Ciz' een "<eventType>" notificatie naar een <ontvangerIDType>
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/zorgkantoor/notificaties/notificatie:create"
				],
				"kvk": "62253778",
				"instantie_type": "Onderneming",
				"instantie_naam": "Stichting Ciz"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "KVK",
					"afzenderID": "62253778",
					"eventType": "<eventType>",
					"ontvangerIDType": "<ontvangerIDType>",
					"ontvangerID": "",
					"ontvangerKenmerk": "",
					"subjectList": [
						{
							"recordID": "1",
							"subject": "bemiddeling"
						}
					]
				}
			}
			"""
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 400

		Examples:
			| eventType                                          | ontvangerIDType |
			| NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR         | UZOVI           |
			| GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR     | UZOVI           |
			| OVERDRACHT_ZORGKANTOOR                             | UZOVI           |
			| GEWIJZIGDE_OVERDRACHT_ZORGKANTOOR	                 | UZOVI           |
			| NIEUWE_OVERDRACHT_ZORGKANTOOR                      | UZOVI           |
			| VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR    | UZOVI           |
			| VERWIJDERDE_OVERDRACHT_ZORGKANTOOR                 | UZOVI           |
			| NIEUWE_INDICATIE_ZORGKANTOOR                       | AGB             |
			| VERVALLEN_INDICATIE_ZORGKANTOOR                    | AGB             |
			| BEEINDIGDE_ROL_COORDINATORZORGTHUIS_ZORGAANBIEDER  | AGB             |
			| BEEINDIGDE_ROL_DOSSIERHOUDER_ZORGAANBIEDER         | AGB             |
			| GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER   | AGB             |
			| GEWIJZIGDE_ZORGSAMENSTELLING_ZORGAANBIEDER         | AGB             |
			| NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER       | AGB             |
			| ROL_COORDINATORZORGTHUIS_ZORGAANBIEDER             | AGB             |
			| ROL_DOSSIERHOUDER_ZORGAANBIEDER                    | AGB             |
			| GEWIJZIGDE_REGIEHOUDER_ZORGAANBIEDER               | AGB             |
			| NIEUWE_REGIEHOUDER_ZORGAANBIEDER                   | AGB             |
			| VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER  | AGB             |
			| VERWIJDERDE_REGIEHOUDER_ZORGAANBIEDER              | AGB             |
			| INFORMATIEVE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER | AGB             |


	Scenario: Wanneer een zorgkantoor met organisaties/zorgkantoor scope een notificatie verstuurd met event type "<eventType>" naar een "<ontvangerIDType>", dan wordt het request afgekeurd
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/zorgkantoor/notificaties/notificatie:create"
				],
				"uzovi": "5000",
				"instantie_type": "Zorgkantoor"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "UZOVI",
					"afzenderID": "5000",
					"eventType": "<eventType>",
					"ontvangerIDType": "<ontvangerIDType>",
					"ontvangerID": "",
					"ontvangerKenmerk": "",
					"subjectList": [
						{
							"recordID": "1",
							"subject": "bemiddeling"
						}
					]
				}
			}
			"""
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 400
		And the response body should contain the error message "ontvanger_type is not valid."

		Examples:
			| eventType                                          | ontvangerIDType |
			| BEEINDIGDE_ROL_COORDINATORZORGTHUIS_ZORGAANBIEDER  | UZOVI           |
			| BEEINDIGDE_ROL_DOSSIERHOUDER_ZORGAANBIEDER         | UZOVI           |
			| GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER   | UZOVI           |
			| GEWIJZIGDE_ZORGSAMENSTELLING_ZORGAANBIEDER         | UZOVI           |
			| NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER       | UZOVI           |
			| ROL_COORDINATORZORGTHUIS_ZORGAANBIEDER             | UZOVI           |
			| ROL_DOSSIERHOUDER_ZORGAANBIEDER                    | UZOVI           |
			| GEWIJZIGDE_REGIEHOUDER_ZORGAANBIEDER               | UZOVI           |
			| NIEUWE_REGIEHOUDER_ZORGAANBIEDER                   | UZOVI           |
			| VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER  | UZOVI           |
			| VERWIJDERDE_REGIEHOUDER_ZORGAANBIEDER              | UZOVI           |
			| INFORMATIEVE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER | UZOVI		   |
			| MUTATIE_CLIENT									 | UZOVI		   |


	Scenario: Wanneer een zorgkantoor met organisaties/zorgaanbieder scope een notificatie verstuurd met event type "<eventType>" naar een "<ontvangerIDType>", dan wordt het request afgekeurd
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/zorgaanbieder/notificaties/notificatie:create"
				],
				"uzovi": "5000",
				"instantie_type": "Zorgkantoor"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "UZOVI",
					"afzenderID": "5000",
					"eventType": "<eventType>",
					"ontvangerIDType": "<ontvangerIDType>",
					"ontvangerID": "",
					"ontvangerKenmerk": "",
					"subjectList": [
						{
							"recordID": "1",
							"subject": "bemiddeling"
						}
					]
				}
			}
			"""
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 400
		And the response body should contain the error message "ontvanger_type is not valid."

		Examples:
			| eventType                                         | ontvangerIDType |
			| GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR    | AGB             |
			| NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR        | AGB             |
			| NIEUWE_INDICATIE_ZORGKANTOOR                      | AGB             |
			| OVERDRACHT_ZORGKANTOOR                            | AGB             |
			| VERVALLEN_INDICATIE_ZORGKANTOOR                   | AGB             |
			| GEWIJZIGDE_OVERDRACHT_ZORGKANTOOR                 | AGB             |
			| NIEUWE_OVERDRACHT_ZORGKANTOOR                     | AGB             |
			| VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR   | AGB             |
			| VERWIJDERDE_OVERDRACHT_ZORGKANTOOR                | AGB             |
			| MUTATIE_CLIENT									| AGB			  |

			
	Scenario: Wanneer een zorgkantoor een notificatie verstuurd met een onbekend event type, dan wordt het request afgekeurd
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/zorgaanbieder/notificaties/notificatie:create"
				],
				"uzovi": "5000",
				"instantie_type": "Zorgkantoor"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "UZOVI",
					"afzenderID": "5000",
					"eventType": "ONBEKENDE_EVENT_TYPE",
					"ontvangerIDType": "AGB",
					"ontvangerID": "12345678",
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
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 400
		And the response body should contain the error message "event_type is not valid."

	Scenario: Wanneer een zorgaanbieder een notificatie verstuurd, dan wordt het request afgekeurd
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/zorgkantoor/notificaties/notificatie:create"
				],
				"agb": "06999994",
				"instantie_type": "Zorgaanbieder"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "AGB",
					"afzenderID": "06999994",
					"eventType": "GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR",
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
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 400
		And the response body should contain the error message "afzender_type is not valid."

	Scenario: Wanneer er notificatieInput meegegeven wordt en een notificatieInput2 moet de filters correct werken
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/zorgkantoor/notificaties/notificatie:create"
				],
				"kvk": "62253778",
				"instantie_type": "Onderneming",
				"instantie_naam": "Stichting Ciz"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "KVK",
					"afzenderID": "62253778",
					"eventType": "VERVALLEN_INDICATIE_ZORGKANTOOR",
					"ontvangerIDType": "UZOVI",
					"ontvangerID": "",
					"ontvangerKenmerk": "",
					"subjectList": [
						{
							"recordID": "1",
							"subject": "bemiddeling"
						}
					]
				},
				"notificatieInput2": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "KVK",
					"afzenderID": "61253778",
					"eventType": "VERVALLEN_INDICATIE_ZORGKANTOOR",
					"ontvangerIDType": "UZOVI",
					"ontvangerID": "",
					"ontvangerKenmerk": "",
					"subjectList": [
						{
							"recordID": "1",
							"subject": "bemiddeling"
						}
					]
				}
			}
			"""
		When I send the graphql request "zendnotificatie_notificatieinput2.graphql" to "notificaties"
		Then the response code should be 400
		And the response body should contain the error message "afzender_id is not valid"

	Scenario: Zend als 'Stiching MedMij' een "<eventType>" notificatie naar een <ontvangerIDType>
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/onderneming/notificaties/notificatie:create"
				],
				"kvk": "71559884",
				"instantie_type": "Onderneming",
				"instantie_naam": "Stichting MedMij"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "KVK",
					"afzenderID": "71559884",
					"eventType": "<eventType>",
					"ontvangerIDType": "<ontvangerIDType>",
					"ontvangerID": "",
					"ontvangerKenmerk": "",
					"subjectList": [
						{
							"recordID": "1",
							"subject": "bemiddeling"
						}
					]
				}
			}
			"""
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 400

		Examples:
			| eventType                                         | ontvangerIDType |
			| GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR    | UZOVI           |
			| NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR        | UZOVI           |
			| NIEUWE_INDICATIE_ZORGKANTOOR                      | UZOVI           |
			| OVERDRACHT_ZORGKANTOOR                            | UZOVI           |
			| VERVALLEN_INDICATIE_ZORGKANTOOR                   | UZOVI           |
			| VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR   | UZOVI           |
			| VERWIJDERDE_OVERDRACHT_ZORGKANTOOR                | UZOVI           |
			| GEWIJZIGDE_OVERDRACHT_ZORGKANTOOR                 | UZOVI           |
			| NIEUWE_OVERDRACHT_ZORGKANTOOR                     | UZOVI           |
			| BEEINDIGDE_ROL_COORDINATORZORGTHUIS_ZORGAANBIEDER | AGB             |
			| BEEINDIGDE_ROL_DOSSIERHOUDER_ZORGAANBIEDER        | AGB             |
			| GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER  | AGB             |
			| GEWIJZIGDE_ZORGSAMENSTELLING_ZORGAANBIEDER        | AGB             |
			| NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER      | AGB             |
			| ROL_COORDINATORZORGTHUIS_ZORGAANBIEDER            | AGB             |
			| GEWIJZIGDE_REGIEHOUDER_ZORGAANBIEDER              | AGB             |
			| NIEUWE_REGIEHOUDER_ZORGAANBIEDER                  | AGB             |
			| VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER | AGB             |
			| VERWIJDERDE_REGIEHOUDER_ZORGAANBIEDER             | AGB             |
			| MUTATIE_CLIENT									| AGB			  |

	Scenario: Wanneer een zorgkantoor een MUTATIE_CLIENT stuurt naar een andere organisatie dan Vecozo, dan wordt het request afgekeurd
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/onderneming/notificaties/notificatie:create"
				],
				"uzovi": "5000",
				"instantie_type": "Zorgkantoor"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "UZOVI",
					"afzenderID": "5000",
					"eventType": "MUTATIE_CLIENT",
					"ontvangerIDType": "KVK",
					"ontvangerID": "02065142",
					"ontvangerKenmerk": "",
					"subjectList": [
						{
							"recordID": "1",
							"subject": "bemiddeling"
						}
					]
				}
			}
			"""
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 400
		And the response body should contain the error message "ontvanger_type is not valid."