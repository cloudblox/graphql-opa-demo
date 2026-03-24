package utils.graphql.graphql_request

_pep_uri := opa.runtime().env.PEP_URL

_auth_uri := opa.runtime().env.AUTH_SERVER_URL

default _auth_token_retention_duration := 0

_auth_token_retention_duration := to_number(opa.runtime().env.AUTH_TOKEN_CACHE_DURATION_SECONDS)

default _auth_token_caching := false

_auth_token_caching if opa.runtime().env.AUTH_TOKEN_CACHE_DURATION_SECONDS

__get_auth_tokens(urls, scope, impersonation, caching, caching_duration) := tokens if {
	requests := [r |
		some url in urls
		r := {
			"method": "POST",
			"url": _auth_uri, # regal ignore:external-reference
			"headers": {"Content-Type": "application/json"},
			"body": {
				"grant_type": "client_credentials",
				"scope": scope,
				"audience": url,
				"access_token": {"sub": impersonation},
			},
			"timeout": "10s",
			"force_cache": caching,
			"force_cache_duration_seconds": caching_duration,
			"tls_client_cert_file": opa.runtime().env.CLIENT_CERTIFICATE_CRT_PATH,
			"tls_client_key_file": opa.runtime().env.CLIENT_CERTIFICATE_KEY_PATH,
		}
	]

	tokens := [response.body.access_token |
		some request in requests
		response := http.send(request)
		response.status_code == 200
	]
}

request_with_tokens(tokens, query, variables) := response_bodies if {
	requests := [r |
		some token in tokens
		r := {
			"method": "POST",
			"url": _pep_uri, # regal ignore:external-reference
			"headers": {
				"Content-Type": "application/json",
				"Authorization": sprintf("Bearer %s", [token]),
			},
			"body": {
				"query": query,
				"variables": variables,
			},
			"timeout": "10s",
		}
	]
	response_bodies := [response.body |
		some request in requests
		response := http.send(request)
		response.status_code == 200
	]
}

request(graphql_urls, scope, impersonation, query, variables) := response_bodies if {
	tokens := __get_auth_tokens(graphql_urls, scope, impersonation, _auth_token_caching, _auth_token_retention_duration)
	response_bodies := request_with_tokens(tokens, query, variables)
}
