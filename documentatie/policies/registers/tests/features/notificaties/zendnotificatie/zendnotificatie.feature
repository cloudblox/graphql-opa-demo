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
		Then the response code should be 200

		Examples:
			| eventType                                          | ontvangerIDType | ontvangerIDScope |
			| GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR     | UZOVI           | zorgkantoor      |
			| NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR         | UZOVI           | zorgkantoor      |
			| OVERDRACHT_ZORGKANTOOR                             | UZOVI           | zorgkantoor      |
			| GEWIJZIGDE_OVERDRACHT_ZORGKANTOOR                  | UZOVI           | zorgkantoor      |
			| VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR    | UZOVI           | zorgkantoor      |
			| VERWIJDERDE_OVERDRACHT_ZORGKANTOOR                 | UZOVI           | zorgkantoor      |
			| NIEUWE_OVERDRACHT_ZORGKANTOOR                      | UZOVI           | zorgkantoor   	  |
			| BEEINDIGDE_ROL_COORDINATORZORGTHUIS_ZORGAANBIEDER  | AGB             | zorgaanbieder    |
			| BEEINDIGDE_ROL_DOSSIERHOUDER_ZORGAANBIEDER         | AGB             | zorgaanbieder    |
			| GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER   | AGB             | zorgaanbieder    |
			| GEWIJZIGDE_ZORGSAMENSTELLING_ZORGAANBIEDER         | AGB             | zorgaanbieder    |
			| NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER       | AGB             | zorgaanbieder    |
			| ROL_COORDINATORZORGTHUIS_ZORGAANBIEDER             | AGB             | zorgaanbieder    |
			| ROL_DOSSIERHOUDER_ZORGAANBIEDER                    | AGB             | zorgaanbieder    |
			| GEWIJZIGDE_REGIEHOUDER_ZORGAANBIEDER               | AGB             | zorgaanbieder    |
			| NIEUWE_REGIEHOUDER_ZORGAANBIEDER                   | AGB             | zorgaanbieder    |
			| VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER  | AGB             | zorgaanbieder    |
			| VERWIJDERDE_REGIEHOUDER_ZORGAANBIEDER              | AGB             | zorgaanbieder    |
			| INFORMATIEVE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER | AGB			   | zorgaanbieder    |	

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
		Then the response code should be 200

		Examples:
			| eventType                                         | ontvangerIDType |
			| NIEUWE_INDICATIE_ZORGKANTOOR                      | UZOVI           |
			| VERVALLEN_INDICATIE_ZORGKANTOOR                   | UZOVI           |

	Scenario: Zend als "<afzenderName>" een "MUTATIE_CLIENT" notificatie naar Vecozo
		Given My claims are
			"""
			{
				"scopes": [
					"organisaties/onderneming/notificaties/notificatie:create"
				],
				"uzovi": "<afzenderID>",
				"instantie_type": "Zorgkantoor",
				"instantie_naam": "<afzenderName>"
			}
			"""
		Given My variables are
			"""
			{
				"notificatieInput": {
					"timestamp": "2024-06-01T00:00:00Z",
					"afzenderIDType": "UZOVI",
					"afzenderID": "<afzenderID>",
					"eventType": "MUTATIE_CLIENT",
					"ontvangerIDType": "KVK",
					"ontvangerID": "18065868",
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
		When I send the graphql request "zendnotificatie.graphql" to "notificaties"
		Then the response code should be 200

		Examples:
			| afzenderName   | afzenderID |
			| Menzis_test    | 5000       |
			| Menzis	     | 5501       |
			| Menzis	     | 5505       |
			| Menzis	     | 5505       |
			| ZorgMatch_test | 9997 	  |
			| ZorgMatch      | 5503 	  |
			| ZorgMatch      | 5504 	  |
			| ZorgMatch      | 5521 	  |
			| ZorgMatch      | 5515 	  |
