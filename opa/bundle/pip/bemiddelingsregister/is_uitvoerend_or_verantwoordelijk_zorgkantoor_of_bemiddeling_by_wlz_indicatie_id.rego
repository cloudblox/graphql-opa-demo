package pip.bemiddelingsregister

import data.authz.global
import data.utils.common
import data.utils.date
import data.utils.graphql.graphql_request

# regal ignore:rule-length
is_uitvoerend_or_verantwoordelijk_zorgkantoor_of_bemiddeling_by_wlz_indicatie_id(wlz_indicatie_id) if {
	query := `query GetBemiddeling($wlzIndicatieID: UUID!, $zorgkantoor: String!) {
  bemiddeling(
    where: {
      wlzIndicatieID: { eq: $wlzIndicatieID }
      verantwoordelijkZorgkantoor: { neq: $zorgkantoor }
      or: [
        {
          bemiddelingspecificatie: {
            some: { uitvoerendZorgkantoor: { eq: $zorgkantoor } }
          }
        }
        {
          overdracht: {
            verantwoordelijkZorgkantoor: { eq: $zorgkantoor } 
          }
        }
      ]
    }
  ) {
    wlzIndicatieID
  }
}
`
	scope := "registers/wlzbemiddelingsregister/bemiddelingen/bemiddeling:read"

	uzovi_claim := common.claim(global.token, "uzovi")

	responses := graphql_request.request(
		graphql_urls, # regal ignore:external-reference
		scope,
		"",
		query,
		{
			"wlzIndicatieID": wlz_indicatie_id,
			"zorgkantoor": uzovi_claim,
		},
	)

	bemiddelingen := [response.data.bemiddeling |
		some response in responses
		response.data.bemiddeling != null
		response.data.bemiddeling != []
		lower(response.data.bemiddeling[0].wlzIndicatieID) == lower(wlz_indicatie_id)
	]
	bemiddelingen != []
}
