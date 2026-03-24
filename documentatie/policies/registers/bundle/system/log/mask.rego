package system.log

import data.utils.common
import rego.v1

# Mask sensitive information in the decision log
mask contains {
	"op": "upsert",
	"path": "/input/attributes/request/http/headers/authorization",
	"value": "**REDACTED**",
} if {
	input.input.attributes.request.http.headers.authorization
}

mask contains {
	"op": "upsert",
	"path": "/input/attributes/claims",
	"value": auth_token,
} if {
	auth_token := common.token(input.input.attributes.request.http.headers.authorization)
}

mask contains {
	"op": "remove",
	"path": "/input/attributes/request/http/rawBody",
} if {
	input.input.attributes.request.http.rawBody
}
