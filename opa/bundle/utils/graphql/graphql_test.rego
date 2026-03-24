package utils.graphql_test

import data.utils.graphql.ast
import data.utils.graphql.helper
import data.utils.graphql.input as test_input
import rego.v1

import data.utils.graphql as sut

test_where_required_no_where if {
	not sut.where_required(ast.selection_set_args("name", []), {}, "", "", "")
}

test_where_required_no_fieldname if {
	not sut.where_required(
		ast.selection_set_args("name", [ast.child("where", {})]),
		{}, "field-name", "", "",
	)
}

test_where_required_no_required_fieldname if {
	not sut.where_required(
		ast.selection_set_args("name", [ast.child("where", ast.children([ast.child("not-required-field-name", {})]))]),
		{}, "field-name", "", "",
	)
}

test_where_required_no_child_with_equality_type if {
	not sut.where_required(
		ast.selection_set_args("name", [ast.child(
			"where",
			ast.children([ast.child(
				"field-name",
				ast.children([ast.child("neq", ast.raw(""))]),
			)]),
		)]),
		{}, "field-name", "eq", "",
	)
}

test_where_required_value_incorrect if {
	sut.where_required(
		ast.selection_set_args(
			"name",
			[ast.child(
				"where",
				ast.children([ast.child(
					"field-name",
					ast.children([ast.child("eq", ast.raw("value"))]),
				)]),
			)],
		),
		{}, "field-name", "eq", "value",
	)
}

test_where_required_correct if {
	sut.where_required(
		ast.selection_set_args(
			"name",
			[ast.child(
				"where",
				ast.children([ast.child(
					"field-name",
					ast.children([ast.child("eq", ast.raw("value"))]),
				)]),
			)],
		),
		{}, "field-name", "eq", "value",
	)
}

test_val_or_var_no_matching_variable if {
	result := sut.val_or_var(ast.raw_kind("some-value", 0), {"variable1": "value1"})

	result == ""
}

test_val_or_var_no_matching_variable_definitions if {
	result := sut.val_or_var(ast.raw_kind("some-value", 9), {"variable1": "value1"})

	result == "some-value"
}

test_val_or_var_correct if {
	result := sut.val_or_var(ast.raw_kind("variable1", 0), {"variable1": "value1"})

	result == "value1"
}

############################################################
# walk_selection tests
############################################################

test_walk_selection_no_operation if {
	not sut.walk_selection(false, "selection-name")
}

test_walk_selection_no_selection_set if {
	operation := ast.operation_selection_set("operation", "query", [])

	not sut.walk_selection(operation, "selection-name")
}

test_walk_selection_top_layer if {
	operation := ast.operation_selection_set("operation", "query", [ast.selection_set("selection-name", [])])

	selection := sut.walk_selection(operation, "selection-name")
	selection.Name == "selection-name"
}

test_walk_selection_one_deep_valid if {
	operation := ast.operation_selection_set(
		"operation",
		"query",
		[ast.selection_set(
			"other-parent",
			[ast.selection_set(
				"selection-name",
				[ast.selection_set_empty("child")],
			)],
		)],
	)

	selection := sut.walk_selection(operation, "selection-name")
	selection.Name == "selection-name"

	some child in selection.SelectionSet
	child.Name == "child"
}

test_walk_selection_two_deep_valid if {
	operation := ast.operation_selection_set(
		"operation",
		"query",
		[ast.selection_set(
			"other-parent",
			[ast.selection_set(
				"another-parent",
				[ast.selection_set("selection-name", [])],
			)],
		)],
	)
	child := sut.walk_selection(operation, "selection-name")
	child.Name == "selection-name"
}

############################################################
# mutation_obj_arg tests
############################################################

test_mutation_obj_arg_from_variable_object if {
	# arrange
	query_ast := graphql.parse_query(test_input.query_mutation_obj_arg_from_variable_object)
	variables := test_input.variables_mutation_obj_arg_from_variable_object
	operation_selection_set_alias := "updateUser"
	obj_name := "input"
	field_name := "name"
	expected := "John Doe"

	# act
	operation := helper.operation_by_selection_set_alias(query_ast, operation_selection_set_alias)
	selection := operation.SelectionSet[0]
	result := sut.mutation_obj_arg(selection, variables, obj_name, field_name)

	# assert
	expected == result
}

test_mutation_obj_arg_from_variable_field if {
	# arrange
	query_ast := graphql.parse_query(test_input.query_mutation_obj_arg_from_variable_field)
	variables := test_input.variables_mutation_obj_arg_from_variable_field
	operation_selection_set_alias := "updateUser"
	obj_name := "input"
	field_name := "name"
	expected := "John Doe"

	# act
	operation := helper.operation_by_selection_set_alias(query_ast, operation_selection_set_alias)
	selection := operation.SelectionSet[0]

	result := sut.mutation_obj_arg(selection, variables, obj_name, field_name)

	# assert
	expected == result
}

test_mutation_obj_arg_from_input_object if {
	# arrange
	query_ast := graphql.parse_query(test_input.query_mutation_obj_arg_from_input_object)
	variables := test_input.variables_mutation_obj_arg_from_input_object
	operation_selection_set_alias := "updateUser"
	obj_name := "input"
	field_name := "name"
	expected := "John Doe"

	# act
	operation := helper.operation_by_selection_set_alias(query_ast, operation_selection_set_alias)
	selection := operation.SelectionSet[0]
	result := sut.mutation_obj_arg(selection, variables, obj_name, field_name)

	# assert
	expected == result
}

test_mutation_obj_arg_required if {
	# arrange
	query_ast := graphql.parse_query(test_input.query_mutation_obj_arg_from_input_object)
	variables := test_input.variables_mutation_obj_arg_from_input_object
	operation_selection_set_alias := "updateUser"
	obj_name := "input"
	field_name := "name"
	field_value := "John Doe"

	# act
	# assert
	operation := helper.operation_by_selection_set_alias(query_ast, operation_selection_set_alias)
	selection := operation.SelectionSet[0]
	sut.mutation_obj_arg_required(selection, variables, obj_name, field_name, field_value)
}
