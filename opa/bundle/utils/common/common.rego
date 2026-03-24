package utils.common

import rego.v1

# HELPER Create error messages with operation name and type.
err(message, operation_ast) := sprintf("%s %s: %s", [operation_ast.Name, operation_ast.Operation, message])

scope_err(message, operation_ast) := sprintf("%s for scope %s", [message, operation_ast])

# HELPER Errors.
errors := {
	"INTERNAL_SERVER_ERROR": "INTERNAL_SERVER_ERROR",
	"UNAUTHORIZED": "UNAUTHORIZED",
	"BAD_REQUEST": "BAD_REQUEST",
	"FORBIDDEN": "FORBIDDEN",
	"GRAPHQL_VALIDATION_FAILED": "GRAPHQL_VALIDATION_FAILED",
}

# HELPER Combine a two dimensional array into a one dimensional array.
flatten_array(arr) := [elem | elem = arr[_][_]]

# HELPER Check if all provided scopes starts with the provided prefix.
contains_scope(target_scope, scopes) if {
	some scope in scopes
	prefix_regex := concat("", ["^", target_scope])
	regex.match(prefix_regex, scope)
}

# HELPER Error message generator for action based policy decisions.
scope_not_allowed_error_msg(operation) := {
	"message": err("scope not allowed", operation),
	"extensions": {"code": "BAD_REQUEST"},
}

# HELPER Error message generator for scope based policy decisions.
action_not_allowed_error_msg(scope) := {
	"message": scope_err("action not allowed for current scope", scope),
	"extensions": {"code": "BAD_REQUEST"},
}

# HELPER Check if all provided operations are allowed.
not_allowed_operations(operations, allowed_operations) := operation if {
	some operation in operations
	not allowed_operations[operation.Name] == operation.Operation
}

# HELPER Get a claim by name from a claims object, whether is a direct claim or an aggregated claim.
claim(claims, claim_name) := claims[claim_name]

# HELPER Get a claim by name from a claims object, whether is a direct claim or an aggregated claim.
claim(claims, claim_name) := value if {
	not claims[claim_name]
	value := aggregated_claim(claims, claim_name)
}

has_actor_claim(claims, actor) if {
	some _act_claim, _act_claim_value in claims.act
	_act_claim == "sub"
	_act_claim_value == actor
}

has_actor_claim(claims, actor) if {
	some _act_claim, _act_claim_value in claims.act
	_act_claim == "sub"
	some act in actor
	_act_claim_value == act
}

aggregated_claim(claims, claim_name) := value if {
	some claim_name_kv in claims
	some _claim_name, _claim_name_value in claim_name_kv
	_claim_name == claim_name

	some claim_source_kv in claims
	some _claim_source, _claim_source_value in claim_source_kv
	_claim_source == _claim_name_value

	value := io.jwt.decode(_claim_source_value.jwt)[1][claim_name]
}

# helpers to identify the instantie type
is_zorgkantoor(claims) if {
	claim(claims, "instantie_type") == "Zorgkantoor"
}

is_zorgaanbieder(claims) if {
	claim(claims, "instantie_type") == "Zorgaanbieder"
}

is_onderneming(claims) if {
	claim(claims, "instantie_type") == "Onderneming"
}

# helpers to rewrite null as specific string value, ex. use case return "null" as value for graphql argument
null_value(value) := value if {
	not is_null(value)
}

null_value(value) := res if {
	is_null(value)
	res := "$null$"
}

is_null_value("$null$") := true

is_not_null_or_empty(value) if {
	not is_null(value)
	not is_null_value(value)
	not value == ""
}

token(bearer) := io.jwt.decode(split(bearer, " ")[1])[1]
