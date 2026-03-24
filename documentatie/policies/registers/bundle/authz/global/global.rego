package authz.global

import rego.v1

import data.utils.common

query_ast := graphql.parse_query(input.parsed_body.query)

default variables := {}

variables := value if {
	"variables" in object.keys(input.parsed_body)
	value := input.parsed_body.variables
}

default jwt := ""

jwt := split(input.attributes.request.http.headers.authorization, " ")[1]

default token := {}

token := io.jwt.decode(jwt)[1]

error_messages contains msg if {
	not query_ast
	msg := {
		"message": "Unable to parse graphql query", # regal ignore:line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}

error_messages contains msg if {
	count(query_ast.Operations) > 1
	msg := {
		"message": "Only one operation at the time is supported.", # regal ignore:line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}

error_messages contains msg if {
	count(query_ast.Operations) == 1
	count(query_ast.Operations[_].SelectionSet) > 1
	msg := {
		"message": "Only one selectionset in an operation is supported.", # regal ignore:line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
