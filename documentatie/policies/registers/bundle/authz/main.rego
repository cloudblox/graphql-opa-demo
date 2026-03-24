package authz

import rego.v1

import data.authz.global
import data.authz.router
import data.utils.common
import data.utils.security

# METADATA
# description: This is the entrypoint for the registers bundle.
# entrypoint: true
default allow := false

allow if {
	security.is_token_valid
	count(global.error_messages) == 0
	router.error_messages == {}
	router.allow
}

default result["allowed"] := false

result["allowed"] if {
	allow
	router.error_messages == {}
}

result["body"] := value if {
	not security.is_token_valid
	value := security.error_message
} else := value if {
	count(global.error_messages) > 0
	value := json.marshal({"errors": global.error_messages})
} else := value if {
	router.error_messages != {}
	value := json.marshal({"errors": router.error_messages})
} else := value if {
	not allow

	# Catch-all error when default allow and no error_messages are found.
	# We assume there's no operation found to evaluate.
	# Error code should equal the default http_status, which is 400/BAD_REQUEST
	value := json.marshal({"errors": [{
		"message": "No operation found to evaluate",
		"extensions": {"code": common.errors.BAD_REQUEST},
	}]})
}

default result["headers"] := {"content-type": "application/json"}

result["headers"] := {"content-type": "text/plain"} if {
	not security.is_token_valid
}

default result["http_status"] := 400

result["http_status"] := 401 if {
	not security.is_token_valid
} else := 200 if {
	router.error_messages == {}
	not result.body
} else := 500 if {
	some error in router.error_messages
	error.extensions.code == common.errors.INTERNAL_SERVER_ERROR
} else := 401 if {
	some error in router.error_messages
	error.extensions.code == common.errors.UNAUTHORIZED
} else := 400 if {
	some error in router.error_messages
	error.extensions.code == common.errors.BAD_REQUEST
} else := 400 if {
	some error in router.error_messages
	error.extensions.code == common.errors.GRAPHQL_VALIDATION_FAILED
} else := 403 if {
	some error in router.error_messages
	error.extensions.code == common.errors.FORBIDDEN
}
