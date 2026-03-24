package utils.security

import data.utils.common
import rego.v1

is_token_valid if {
	_jwks_uri == "token_validation_disabled"
}

is_token_valid if {
	_token_signature_is_valid
	_token_is_active
}

_jwks_uri := opa.runtime().env.JWKS_URI

_jwt := split(input.attributes.request.http.headers.authorization, " ")[1]

_token_signature_is_valid if {
	[_, payload, _] := io.jwt.decode(_jwt)
	payload.iss == "auth.nid"

	jwks_response := http.send({
		"method": "GET",
		"url": _jwks_uri,
		"force_cache": true,
		"force_cache_duration_seconds": 3600,
	})

	io.jwt.verify_rs256(_jwt, jwks_response.raw_body)
}

_token_is_active if {
	[_, payload, _] := io.jwt.decode(_jwt)

	now := time.now_ns() / 1000000000 # Convert nanoseconds to seconds
	payload.nbf <= now # not before
	now < payload.exp # not expired
}

error_message := value if {
	not _token_signature_is_valid
	value := "Jwt is invalid"
} else := value if {
	not _token_is_active
	value := "Jwt is expired"
}
