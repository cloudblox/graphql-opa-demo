package bemiddelingsregister.overdracht_test

import data.authz.global
import data.bemiddelingsregister.overdracht as sut

import rego.v1

test_something if {
	res := sut.error_messages with global.query_ast as graphql.parse_query(query)
		with global.variables as variables
		with input.attributes.request.http.headers.authorization as token

	print(res)
}

token := "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InJzYS1rZXkiLCJ0eXAiOiJKV1QiLCJ4NWMiOlsiTUlJQkNnS0NBUUVBNzJUNWNRWnQ5MkNZQ1JTL0N3MXJGV2dNcGhVLzRianJMUkIxSmJoVXRGNmN3Z2E2UjZWcDlJS1hDUlV0QjRYc1QwWDJrV2FMSVMyeStqSHM0dzY0VWdVeXRkTnpGNk84TURlZU1xSTVSSzNJUTZlNTJHanVqcjJZMHdMZkhuNlVlTGlna05KRHVOdE9iYU1vSzZCWXZ3eTFGUVZSQ0E5aUp0dWdqa2JXZWZBcitGM0h1QklvcHovelNsTnRYMzVQZUhiV3M1c01LL3A0dlVrNEM0RS9JQmxKcVJ2TEI1S1o0VWZDYjE4NndoY2FhZWNUNW5DMytuUzRkTXYwQVp6NHF6YTRWK2F3SUNQWlJzMm5VYVh6K2RrbGsxWmxWVDhjekV0b3FDcGY2eTcxYVVCKy95VmQrbFZKZ0NMcXFCcUZkUi8vNDNGa2NmRmFDazZiVUFhZHZRSURBUUFCIl19.eyJpbnN0YW50aWVfdHlwZSI6IlpvcmdrYW50b29yIiwic2NvcGVzIjpbInJlZ2lzdGVycy93bHpiZW1pZGRlbGluZ3NyZWdpc3Rlci9kb2VpZXRzIl0sInV6b3ZpIjoiNTAwMCJ9.dCc1--M1SdisaKmDkqyvblmb12G1ShAyBtAEXOJUn1TIQ6JbixHJTrm1Ie-bVG7mHu8PmXU2UlVJRQHyLtWmKT0wIWrrtWWTpPUNIlATmbAdFG-xvAv-9cgNprZpaHVXQygm_htooJiae4TdbBlA_Fj_CIwDSSsPiyQZ0ZlBCCJo8J6kU6-69mcfWAAOSaVPpDYLKAih1NwUxbBF4E1lHu5A9MJvoFZqjGmE3Mr6sLfihInxcBP5LjpVERC0OIYXIoBPbiztM80NF-i_Tdx8NgrxfCiM8rkoRjjbpwuMhT6V-ugks_8PzDCFO4PvD8erpvfSKH5SOX82qtmHK_5hFQ"

query := `
query Overdracht(
  $overdrachtID: UUID!
  $VerantwoordelijkZorgkantoor: String!
  $OverdrachtDatum: Date!
) {
  overdracht(
    where: {
      overdrachtID: { eq: $overdrachtID }
      verantwoordelijkZorgkantoor: { eq: $VerantwoordelijkZorgkantoor }
      overdrachtDatum: { eq: $OverdrachtDatum }
    }
  ) {
    overdrachtID
    verantwoordelijkZorgkantoor
    overdrachtDatum
    verhuisDatum
    vaststellingMoment
    bemiddeling {
      bemiddelingID
      wlzIndicatieID
      verantwoordelijkZorgkantoor
      verantwoordelijkheidIngangsdatum
      verantwoordelijkheidEinddatum
      client {
        clientID
        bsn
        leefeenheid
        huisarts
        communicatievorm
        taal
        contactgegevens(
          where: {
            ingangsdatum: { ngt: $OverdrachtDatum }
            or: [
              { einddatum: { gt: $OverdrachtDatum } }
              { einddatum: { eq: null } }
            ]
          }
        ) {
          clientContactgegevensID
          adressoort
          straatnaam
          huisnummer
          huisletter
          huisnummertoevoeging
          postcode
          plaatsnaam
          land
          emailadres
          telefoonnummer01
          landnummer01
          telefoonnummer02
          landnummer02
          ingangsdatum
          einddatum
        }
        contactpersoon(
          where: {
            ingangsdatum: { ngt: $OverdrachtDatum }
            or: [
              { einddatum: { gt: $OverdrachtDatum } }
              { einddatum: { eq: null } }
            ]
          }
        ) {
          contactpersoonID
          contactgegevens(
            where: {
            ingangsdatum: { ngt: $OverdrachtDatum }
            or: [
              { einddatum: { gt: $OverdrachtDatum } }
              { einddatum: { eq: null } }
            ]
          }
          ) {
            contactpersoonContactgegevensID
            adressoort
            straatnaam
            huisnummer
            huisnummertoevoeging
            postcode
            plaatsnaam
            land
            emailadres
            telefoonnummer01
            landnummer01
            telefoonnummer02
            landnummer02
            ingangsdatum
            einddatum
          }
          relatienummer
          volgorde
          soortRelatie
          rol
          relatienummer
          geslachtsnaam
          voorvoegselGeslachtsnaam
          voornamen
          voorletters
          roepnaam
          naamgebruik
          geslacht
          geboortedatum
          geboortedatumgebruik
          ingangsdatum
          einddatum
        }
      }
      regiehouder(
        where: {
          ingangsdatum: { ngt: $OverdrachtDatum }
          or: [
            { einddatum: { gt: $OverdrachtDatum } }
            { einddatum: { eq: null } }
          ]
        }
      ) {
        regiehouderID
        instelling
        ingangsdatum
        einddatum
        regierol
      }
    }
    overdrachtspecificatie {
      overdrachtspecificatieID
      leveringsstatus
      leveringsstatusClassificatie
      oorspronkelijkeToewijzingEinddatum
      bemiddelingspecificatie {
        bemiddelingspecificatieID
        leveringsvorm
        zzpCode
        toewijzingIngangsdatum
        toewijzingEinddatum
        instelling
        uitvoerendZorgkantoor
        vaststellingMoment
        percentage
        opname
        redenIntrekking
        etmalen
        instellingBestemming
        soortToewijzing
      }
    }
  }
}
`

variables := {
	"overdrachtID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
	"VerantwoordelijkZorgkantoor": "5151",
	"OverdrachtDatum": "2023-04-17",
}
