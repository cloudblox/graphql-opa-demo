package utils.graphql.input

import rego.v1

query_mutation_obj_arg_from_variable_object := `mutation UpdateUser($input: UpdateUserInput!) {
	updateUser(input: $input) {
		id
		name
	}
}`

variables_mutation_obj_arg_from_variable_object := {"input": {
	"id": "1",
	"name": "John Doe",
}}

query_mutation_obj_arg_from_variable_field := `mutation UpdateUser($id: ID, $name: String!) {
	updateUser(input: {
		id: $id,
		name: $name
	}) {
		id
		name
	}
}`

variables_mutation_obj_arg_from_variable_field := {
	"id": "1",
	"name": "John Doe",
}

query_mutation_obj_arg_from_input_object := `mutation UpdateUser {
	updateUser(input: {
		id: "1",
		name: "John Doe"
	}) {
		id
		name
	}
}`

variables_mutation_obj_arg_from_input_object := {}
