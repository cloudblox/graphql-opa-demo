package bemiddelingsregister.bemiddelingspecificatie_test

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie as sut

import rego.v1

test_something if {
	res := sut.error_messages with global.query_ast as graphql.parse_query(query)
		with global.variables as variables
		with input.attributes.request.http.headers.authorization as token
}

token := "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InJzYS1rZXkiLCJ0eXAiOiJKV1QiLCJ4NWMiOlsiTUlJQkNnS0NBUUVBc3NzU1NNTUJaODY5cHJOWDJuSEwwRkJGQmhCY2d1MUkrVUI0NkIrdTNSOVJ6Ym1YbHMxS1ByQzA4a0JmMEZPNmVYRUhhRy9odEozWTJObVd3aGJEQVJ0aGpOZktDWVZPOUdpbTk2ZlRDT3RDdDNhQ2NsRUdONVZYY0ozakFQM1Evd0tiZkszZzhsNjdYTGpvVk04SjhqZ21VandpbGwzWU8vM0lpaVJtLzFOSUtqeVhMamh0K0tVenA2MmZBc05PNytuYVBhV2NkcDZsRHE3RGx6ZVJZZzRnNUgyT3Buc2IyeTRyRlpFYkdjUFpwRFN1QkRuemNZenUzVVY4S3FSZWprSmxJbHhnY1pmbzJOUFduOHZDL1FWTCtaSTFraGpxd2FWbnZhUE9hcDU3RndIamx1Z2hwT2lDMnVlMmVSZHVORG82T3N4Q0dpODdZL0daaENOZkJ3SURBUUFCIl19.eyJhZ2IiOiI2NjYwMDAxMSIsInNjb3BlcyI6WyJyZWdpc3RlcnMvd2x6YmVtaWRkZWxpbmdzcmVnaXN0ZXIvYmVtaWRkZWxpbmc6cmVhZCJdfQ.V0qjXHJ2SL-HGew8XL5doc0_An4Ku3FtFnGjDnQxldeDdG2uSzPPST8hiFFggyabhLMbWSsDOfRp3Chtax8vsh97fvc_1ppT3Z_HqAlfaT7pwMo5MVuqSW2KNdc5hVWvFoHmjy8rzfqyzDW4gS4z5PkqKe1WkGyb1EyCeUYyrY_a0F0u-PVwXdAW9cU_oS74j9Zyhe5le23V_KyRr4f0YQzT4R1HtqMwow6qwVq6OACManQJTUVDgxgRvUodETVlzY9ejOfdIxSlXcju2CMBhl1t2FtYENpXhjL8c4CykPlOkCRm6t5Rqt0uZYUl6pJ5tKFOiwYLBmznjx6LqsZE2A"

query := `
query Bemiddelingspecificatie(
  $BemiddelingspecificatieID: UUID!
  $Instelling: String!
) {
  bemiddelingspecificatie(
    where: {
      bemiddelingspecificatieID: { eq: $BemiddelingspecificatieID }
      instelling: { eq: $Instelling }
    }
  ) {
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
    bemiddeling {
      bemiddelingID
      wlzIndicatieID
      verantwoordelijkZorgkantoor
      verantwoordelijkheidIngangsdatum
      verantwoordelijkheidEinddatum
      client {
        bsn
        clientID
        taal
        communicatievorm
        huisarts
        leefeenheid
      }
    overdracht {
      overdrachtID
      verantwoordelijkZorgkantoor
      overdrachtDatum
      verhuisDatum
      vaststellingMoment
      bemiddeling
    }
  }
}
`

variables := {
	"BemiddelingspecificatieID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
	"UitvoerendZorgkantoor": "5151",
}
