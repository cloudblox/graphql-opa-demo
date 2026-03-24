package bemiddelingsregister.regiehouder_test

import data.authz.global
import data.bemiddelingsregister.regiehouder as sut

import rego.v1

test_something if {
	res := sut.error_messages with global.query_ast as graphql.parse_query(query)
		with global.variables as variables
		with input.attributes.request.http.headers.authorization as token

	print(res)
}

token := "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjgyQ0JFODQ2LUQyNEUtNDU4QS1BNkU2LUQ1MDk4RTA5NkQ1MiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhdXRoLm5pZCIsInN1YiI6IjQwMDAwMDAwMTAwMzUxIiwiYXVkIjoiaHR0cHM6Ly9kZXYtYXBpLnZlY296by5ubC9vdGkvcG9jZGVlbG5lbWVyc3JlZ2lzdGVyL3YxL2dyYXBocWwiLCJleHAiOjE3NDc2NjE2NzksIm5iZiI6MTc0NzY1Nzk1OSwiaWF0IjoxNzQ3NjU4MDc5LCJqdGkiOiI5MjFkYjJiZC0xYTkwLTRmZTQtYThjYi05MjJhZDQ2NWEyZDAiLCJfY2xhaW1fbmFtZXMiOnsiYWdiIjoibG9jYWxob3N0IiwidXpvdmkiOiJsb2NhbGhvc3QifSwiX2NsYWltX3NvdXJjZXMiOnsibG9jYWxob3N0Ijp7Imp3dCI6ImV5SmhiR2NpT2lKSVV6STFOaUlzSW5SNWNDSTZJa3BYVkNKOS5leUpoWjJJaU9pSTFNVFV4TURFd01TSXNJblY2YjNacElqcHVkV3hzZlEuMkstbGtBem9qT1hrdDIydmI0VmZWUHFORUl4LTJYWW1sR0xtTEJWSGZqVSJ9fSwiY2xpZW50X2lkIjoiNDAwMDAwMDAxMDAzNTEiLCJzdWJqZWN0cyI6bnVsbCwic2NvcGVzIjpbInJlZ2lzdGVycy93bHpiZW1pZGRlbGluZ3NyZWdpc3Rlci9iZW1pZGRlbGluZ2VuL2JlbWlkZGVsaW5nOnJlYWQiXSwiY29uc2VudF9pZCI6IjA4MDUzZTcwLWRlN2MtNGIxMS05YWM0LWRiNDM0ZjBmNTJiNCIsImNsaWVudF9tZXRhZGF0YSI6bnVsbH0.S5B7K6_jwJAxw3unPwwwWG9bsRiMIBBHizEGypU5zsECzdA0V6yiHXy1LNy2BHt3z6FSJjA5NHEqClCCo_7paMRb48xXrYIWy1zDDxnzYsGx4JHAypGvJG6eiSWSvGv67UKUv26aweaSreC6nvoUl3liT2EenFfzu8r9mqjRvf3-xpyJ93_9jwXauekVf_hSKSBY9N5tg007VpU8zAyVSv_kimUwBzkjlBgur8C9BtgfHVcZFtU3cffPYK3UHHCAFRbyEu3IGdrjaHvi3emr9uloEy8OT7cN3P9mEG90b1xe3raPIJhcHPR07GNJmngv8VdCWe6uTTSt4Pg5v0YngIFw9ZltEV8Z0Bi1D_WHsXrhDck8S4rg-g0ZAjFvx7ECctueHfeiFwfA-dsJZJ1KtBL2Yho-kUrSfjCVpVP-TSIS4cxScirb0QYoXCQs0U__u4FrIZZ0CwyTWTz_uHnRA4npjY_qsa1xWBcq8K7tuDXEidjo6h_A_39Nifjxf_d_2gbXoXDzBu1vTHI24xyKlohrOPvBWWCbPB9j7e_AWaP1QKdeoLuL3LWmIR345QSi-3gSVGU3VV_W0LIeGl1W3v85__JBaDOjhu7Uq5PjTrK-0ykM5rNunCAGPmOw0fKkws2X-LZqgfpe5gyIuC9qMItY8QTyCplS8n_oBb8EJ0U"

query := `
query Regiehouder(
  $regiehouderID: UUID!
  $Instelling: String!
) {
  regiehouder(
    where: {
      regiehouderID: { eq: $regiehouderID }
      instelling: { eq: $Instelling }
    }
  ) {
    regiehouderID
    instelling
    ingangsdatum
    einddatum
    regierol
    bemiddeling {
      bemiddelingID
      wlzIndicatieID
      verantwoordelijkZorgkantoor
      verantwoordelijkheidIngangsdatum
      verantwoordelijkheidEinddatum
      # Sub entiteiten van de bemiddeling mag je niet ophalen zonder datumfilter - zie QBR-0002-ZA.graphql
      client {
        bsn
        clientID
        taal
        communicatievorm
        huisarts
        leefeenheid
        # Sub entiteiten van de client mag je niet ophalen zonder datumfilter - zie QBR-0002-ZA.graphql
      }
    }
  }
}
`

variables := {
	"regiehouderID": "c37239b0-9e3d-4c00-88fd-01f37e590fc0",
	"Instelling": "51510101",
}
