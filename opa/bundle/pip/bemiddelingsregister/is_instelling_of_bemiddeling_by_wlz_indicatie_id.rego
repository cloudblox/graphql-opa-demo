package pip.bemiddelingsregister

import data.authz.global
import data.utils.common
import data.utils.date
import data.utils.graphql.graphql_request

# regal ignore:rule-length
is_instelling_of_bemiddeling_by_wlz_indicatie_id(wlz_indicatie_id) if {
	query := `query GetBemiddeling($wlzIndicatieID: UUID!, $instelling: String!) {
  bemiddeling(where: {
    wlzIndicatieID: { eq: $wlzIndicatieID }
    bemiddelingspecificatie: {
      some: {
        instelling: { eq: $instelling }      
      }
    }
  }) {
    wlzIndicatieID
  }
}`

	scope := "registers/wlzbemiddelingsregister/bemiddelingen/bemiddeling:read"

	agb_claim := common.claim(global.token, "agb")

	responses := graphql_request.request(
		graphql_urls, # regal ignore:external-reference
		scope,
		"",
		query,
		{
			"wlzIndicatieID": wlz_indicatie_id,
			"instelling": agb_claim,
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
