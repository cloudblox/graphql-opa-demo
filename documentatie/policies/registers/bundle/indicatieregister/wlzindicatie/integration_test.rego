package indicatieregister.wlzindicatie_test

import data.authz.global
import data.indicatieregister.wlzindicatie as sut

import rego.v1

test_something if {
	res := sut.error_messages with global.query_ast as graphql.parse_query(query)
		with global.variables as variables
		with input.attributes.request.http.headers.authorization as token

	print(res)
}

token := "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InJzYS1rZXkiLCJ0eXAiOiJKV1QiLCJ4NWMiOlsiTUlJQkNnS0NBUUVBNmY3OUUvbkRialVBUmxjK0puL2ZKbDQ3dHdaMDlUTUljaTFEbWFYNFlsK2pTZk5HWGt1aGZuNVZ3ZmJLN3lONDFKSy9qMmcrNEZKUk5OWEdsM0Q3V1V4QnVMdFdKcndoS0tIVk5WUWkrUzhnQ3QydHlPTnlRendWbzhva1I0NEk0UW91cHJnNkt5NElYRnFCcTdFdWNEN1ovUHZMKzRudGZ2bXZObkYyMUFReXk3ZlE1dVJPdHJHU1FyeHZvR2R0bnpMTFN6L0s1aFJXVmxOQ2JlZ2JVN3pTcHNSTTkwejljOHVrK3lidEcrbWFoVWJFR29HWHlieEFxR0kwazVhT0xMeWsrNlhsS0pIQVZoN2hIbDVYRW1lVERNTzd6aWpoUkVabmVja2h4dUladDlQRzFFYWFObE1PeU5wR2x0M3locUZkUXg1ZFJGZmdTVnJWMXFBb1F3SURBUUFCIl19.eyJpbnN0YW50aWVfdHlwZSI6IlpvcmdrYW50b29yIiwic2NvcGVzIjpbInJlZ2lzdGVycy93bHppbmRpY2F0aWUvcmVnaXN0ZXIvaW5kaWNhdGllcy9pbmRpY2F0aWU6cmVhZCJdLCJ1em92aSI6IjUwMDAifQ.ScoSZBehzB0kRuDHGQY2aD1mtxP3w3XrmClyj5ftne7-40QSJGlSP3ldES_pw5hetcJxDh7A1QpDVWWykJTtQotfO-NdOhjQAHvPBJMIY0jVdloVqotKclqjs-bgGgzMDZ3df4O3mGdwDG_FiPXZCi_abVQHaM81jimhQIAfXUV2D5oUBk9FxeU0IEm8dmwjZxTyWRP4VWrAiIg17GLsfSfW2donWmKvrfbQxRwRxQYwrDdJqmiFj-7Y4OB_241vpNAmRBJHGcStK4OD0IZ72lBBtdYUSXiKkv_0EdKrGIEVWOUWENbsDGYhTQgY2OP20cpRILGyC1gQU0BUto0XfQ"

query := `# QIR-0001-ZKi.graphql
# Query voor initieel Verantwoordelijk Zorgkantoor op Indicatieregister
# Verplichte input:
#   - wlzIndicatieID = te raadplegen WlzIndicatie
#   - uzovicode zorgkantoor = eigen uzovicode raadpleger
# versie 1.0.0 - 2024-10-04

query WlzIndicatie(
    $wlzIndicatieID: UUID!
    $initieelVerantwoordelijkZorgkantoor: String!
) {
    wlzIndicatie(
        where: {
            wlzindicatieID: {eq: $wlzIndicatieID}
            initieelVerantwoordelijkZorgkantoor: {eq: $initieelVerantwoordelijkZorgkantoor}
        }
    ) {
        wlzindicatieID
        bsn
        besluitnummer
        soortWlzindicatie
        afgiftedatum
        ingangsdatum
        einddatum
        meerzorg
        initieelVerantwoordelijkZorgkantoor
        vervaldatum
        commentaar
        grondslag {
            grondslagID
            grondslag
            volgorde
        }
        geindiceerdZorgzwaartepakket {
            geindiceerdZorgzwaartepakketID
            zzpCode
            ingangsdatum
            einddatum
            voorkeurClient
            instellingVoorkeur
            financiering
            commentaar
        }
        beperking {
            beperkingID
            categorie
            duur
            commentaar
            beperkingScore {
                beperkingScoreID
                beperkingVraag
                beperkingScore
                commentaar
            }
        }
        stoornis {
            stoornisID
            grondslag
            diagnoseCodelijst
            diagnoseSubCodelijst
            ziektebeeldStoornis
            prognose
            commentaar
        }
        stoornisScore {
            stoornisScoreID
            stoornisVraag
            stoornisScore
            commentaar
        }
        wzd {
            wzdID
            wzdVerklaring
            ingangsdatum
            einddatum
        }
        client {
            clientID
            bsn
            geheimeClient
            geboorteDatum
            geboortedatumGebruik
            geslacht
            burgerlijkeStaat
            geslachtsnaam
            voorvoegselGeslachtsnaam
            partnernaam
            voorvoegselPartnernaam
            voornamen
            roepnaam
            voorletters
            naamGebruik
            leefeenheid
            agbcodeHuisarts
            communicatieVorm
            taal
            commentaar
            contactGegevens {
                contactGegevensID
                adres {
                    adresID
                    adresSoort
                    straatnaam
                    huisnummer
                    huisnummerToevoeging
                    postcode
                    plaatsnaam
                    landCode
                    aanduidingWoonadres
                    ingangsdatum
                    einddatum
                }
                email {
                    emailID
                    emailadres
                    ingangsdatum
                    einddatum
                }
                telefoon {
                    telefoonID
                    telefoonnummer
                    landnummer
                    ingangsdatum
                    einddatum
                }
            }
            contactPersoon {
                contactPersoonID
                relatieNummer
                volgorde
                soortRelatie
                rol
                relatie
                voornamen
                roepnaam
                voorletters
                geslachtsnaam
                voorvoegselGeslachtsnaam
                partnernaam
                voorvoegselPartnernaam
                naamGebruik
                geslacht
                geboorteDatum
                geboortedatumGebruik
                ingangsdatum
                einddatum
                contactGegevens {
                    contactGegevensID
                    adres {
                        adresID
                        adresSoort
                        straatnaam
                        huisnummer
                        huisnummerToevoeging
                        postcode
                        plaatsnaam
                        landCode
                        aanduidingWoonadres
                        ingangsdatum
                        einddatum
                    }
                    email {
                        emailID
                        emailadres
                        ingangsdatum
                        einddatum
                    }
                    telefoon {
                        telefoonID
                        telefoonnummer
                        landnummer
                        ingangsdatum
                        einddatum
                    }
                }
            }
        }
    }
}`

variables := {
	"wlzIndicatieID": "AC0DA41F-19CC-4A42-992B-493996F5D9A0",
	"initieelVerantwoordelijkZorgkantoor": "5000",
	"now": "2024-09-26",
}
