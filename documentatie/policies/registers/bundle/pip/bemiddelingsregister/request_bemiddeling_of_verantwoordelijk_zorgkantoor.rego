package pip.bemiddelingsregister

import data.authz.global
import data.utils.common
import data.utils.graphql.graphql_request

query_bemiddeling := `query GetBemiddeling(
  $bemiddelingID: UUID!
  $verantwoordelijkZorgkantoor: String!
) {
  bemiddeling(
    where: {
      bemiddelingID: { eq: $bemiddelingID }
   		verantwoordelijkZorgkantoor: { eq: $verantwoordelijkZorgkantoor }
    }
  ) {
    bemiddelingID
    bemiddelingspecificatie {
      bemiddelingspecificatieID
    }
    regiehouder {
      regiehouderID
    }
  }
}
`

scope := "registers/wlzbemiddelingsregister/bemiddelingen/bemiddeling:read"

request_bemiddeling_of_verantwoordelijk_zorgkantoor(bemiddeling_id) := response if {
	uzovi_claim := common.claim(global.token, "uzovi")
	responses := graphql_request.request_with_tokens(
		[global.jwt], # regal ignore:external-reference
		query_bemiddeling, # regal ignore:external-reference
		{
			"bemiddelingID": bemiddeling_id,
			"verantwoordelijkZorgkantoor": uzovi_claim,
		},
	)
	count(responses) == 1
	response := responses[0]
}
