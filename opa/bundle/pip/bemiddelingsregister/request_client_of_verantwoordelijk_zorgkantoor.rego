package pip.bemiddelingsregister

import data.authz.global
import data.utils.common
import data.utils.graphql.graphql_request

# regal ignore:rule-length
request_client_of_verantwoordelijk_zorgkantoor(client_id) := response if {
	scope := "registers/wlzbemiddelingsregister/bemiddelingen/bemiddeling:read"

	query := `query GetClient($clientID: UUID!, $verantwoordelijkZorgkantoor: String!) {
			client(
				where: {
				clientID: { eq: $clientID }
				bemiddeling: { some: { verantwoordelijkZorgkantoor: { eq: $verantwoordelijkZorgkantoor } } }
				}
			) {
				clientID
				contactgegevens {
				clientContactgegevensID
				}
				contactpersoon {
				contactpersoonID
				contactgegevens {
					contactpersoonContactgegevensID
				}
			}
		}
	}
`

	uzovi_claim := common.claim(global.token, "uzovi")
	responses := graphql_request.request_with_tokens(
		[global.jwt], # regal ignore:external-reference
		query,
		{
			"clientID": client_id,
			"verantwoordelijkZorgkantoor": uzovi_claim,
		},
	)
	count(responses) == 1
	response := responses[0]
}
