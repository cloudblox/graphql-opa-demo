package utils.graphql

import data.utils.common
import rego.v1

query_operation(ast, alias) := operation if {
	some operation in ast.Operations
	operation.Operation == "query"
	some selection_set in operation.SelectionSet
	selection_set.Alias == alias
}

mutation_operation(ast, alias) := operation if {
	some operation in ast.Operations
	operation.Operation == "mutation"
	some selection_set in operation.SelectionSet
	selection_set.Alias == alias
}

query_name(ast, alias) := result if {
	some operation in ast.Operations
	some selection_set in operation.SelectionSet
	selection_set.Alias == alias
	result := operation.Name
}

# HELPER Filter selection sets only where the alias is in the provided fields.
query_fields(ast, fields) := [value |
	walk(ast, [_, value])
	value.Alias in fields
]

# HELPER Extract the children for a variable argument.
children_arg(value, argname) := arg.Value.Children if {
	some arg in value.Arguments
	arg.Name == argname
}

children_arg_list(values, argname) := arg.Value.Children if {
	some list_element in values
	some arg in list_element.Arguments
	arg.Name == argname
}

# HELPER Extract child.
children(value, argname) := child.Value.Children if {
	some child in value
	child.Name == argname
}

# HELPER Extract child.
children_in(value, arg_names) := child.Value.Children if {
	some child in value
	child.Name in arg_names
}

# HELPER Extract the children for a nameless variable argument.
nameless_children_arg(value, argname) := child.Value.Children if {
	some v in value
	some child in v.Value.Children
	child.Name == argname
}

# HELPER Extract the children for a nameless variable argument.
nameless_children_arg_in(value, arg_names) := child.Value.Children if {
	some v in value
	some child in v.Value.Children
	child.Name in arg_names
}

nameless_children_arg_in_list(value, arg_names) := child.Value.Children if {
	some v in value
	some arg in v
	some child in arg.Value.Children
	child.Name in arg_names
}

# HELPER Extract selectionSet by name.
selection(value, name) := field if {
	some field in value.SelectionSet
	field.Name == name
}

selections(value, arg_names) := field if {
	some field in value.SelectionSet
	field.Name in arg_names
}

# Helper to check if the selection set only contains the provided fields.
only_selections(value, arg_names) if {
	every field in value.SelectionSet {
		field.Name in arg_names
	}
}

# Helper Extract a selection set that matches the name, any layer deep.
walk_selection(operation, name) := selection_set if {
	walk(operation, [_, value])
	selection_set := selection(value, name)
}

walk_selections(operation, name) := {selection_set |
	walk(operation, [_, value])
	selection_set := selection(value, name)
}

walk_selections_multi_args(operation, arg_names) := {selection_set |
	walk(operation, [_, value])
	some arg in arg_names
	selection_set := selection(value, arg)
}

walk_selections_no_set(operation, arg_names) := selection_set if {
	walk(operation, [_, value])
	selection_set := selections(value, arg_names)
}

# HELPER Extract the variable if provided, otherwise return the value.
# Value should be an ast value like { "Kind": 0, "Raw": "value" }
val_or_var(value, variables) := res if {
	value.Kind != 6
	var := [_var |
		value.Kind == 0
		_var := common.null_value(variables[value.Raw])
	]

	val := [_val |
		value.Kind != 0
		_val := common.null_value(value.Raw)
	]
	res := concat("", array.concat(var, val))
}

val_or_var(value, variables) := res if {
	value.Kind == 6
	res := "$null$"
}

# HELPER Require a where clause that contains the provided field name, type and value.
# The value can be a variable so we need the variables to resolve it.
where_required(operation, variables, field_name, equality_type, value) if {
	where_children := children_arg(operation, "where")
	children_of_field_name := children(where_children, field_name)

	some child in children_of_field_name
	child.Name == equality_type

	val_or_var(child.Value, variables) == value
}

# HELPER Require a where clause that contains the provided field name and type.
where_required_name(operation, field_name, equality_type) := value if {
	where_children := children_arg(operation, "where")

	children_of_field_name := children(where_children, field_name)

	some child in children_of_field_name
	child.Name == equality_type
	value := child.Value
}

# HELPER Require a where clause that contains the provided field name and type and the value is not empty.
where_required_name_not_empty(operation, variables, field_name, equality_type) := value if {
	value := where_required_name(operation, field_name, equality_type)
	val_or_var(value, variables) != ""
}

# regal ignore:line-length
where_required_name_subentity(selection, primary_field, primary_equality_type, sub_field_name, sub_equality_type) := value if {
	some_filer := where_required_name(selection, primary_field, primary_equality_type)

	some child in some_filer.Children
	child.Name == sub_field_name

	some value_child in child.Value.Children
	value_child.Name == sub_equality_type
	value := value_child.Value
}

# HELPER Get a field value from a mutation input object argument
#
# This function is used to extract the field value from a variable object
# ex:
# mutation UpdateUser($input: UpdateUserInput!) {
#  updateUser(input: $input) {
#
# ..
# {
#   "input": {
#     "id": "1"
# }
#
mutation_obj_arg(selection, variables, obj_name, field_name) := value if {
	some arg in selection.Arguments
	arg.Name == obj_name
	arg.Value.Kind == 0
	value := variables[arg.Value.Raw][field_name]
}

# HELPER Get a field value from a mutation input object argument
#
# This function is used to extract the field value from a variable field
# ex:
# mutation UpdateUser($id: id!) {
#  updateUser(input: { id: $id }) {
#
# ..
# {
# 	"id": "1"
# }
mutation_obj_arg(selection, variables, obj_name, field_name) := value if {
	some arg in selection.Arguments
	arg.Name == obj_name
	arg.Value.Kind == 9
	some k in arg.Value.Children
	k.Name == field_name
	k.Value.Kind == 0
	value := variables[k.Value.Raw]
}

# HELPER Get a field value from a mutation input object argument
#
# This function is used to extract the field value directly out of the input object
# ex:
# mutation UpdateUser {
#  updateUser { id: "1" }) {
#
mutation_obj_arg(selection, variables, obj_name, field_name) := value if {
	some arg in selection.Arguments
	arg.Name == obj_name
	arg.Value.Kind == 9
	some k in arg.Value.Children
	k.Name == field_name
	k.Value.Kind != 0
	value := k.Value.Raw
}

mutation_obj_selection(selection, obj_name, field_name) := value if {
	some arg in selection.Arguments
	arg.Name == obj_name
	arg.Value.Kind == 9
	some value in arg.Value.Children
	value.Name == field_name
}

# HELPER Validate a field value from a mutation input object argument
mutation_obj_arg_required(operation, variables, obj_name, field_name, value) if {
	mutation_obj_arg(operation, variables, obj_name, field_name) == value
}

# HELPER Validate a field value from a mutation input object argument
mutation_obj_arg_not_empty(selection, variables, obj_name, field_name) if {
	value := mutation_obj_arg(selection, variables, obj_name, field_name)
	value != ""
}

mutation_obj_arg_field(selection, variables, field_name) := value if {
	some arg in selection.Arguments
	arg.Name == field_name
	value := val_or_var(arg.Value, variables)
}

mutation_obj_arg_field_not_empty_or_null(selection, variables, field_name) := value if {
	value := mutation_obj_arg_field(selection, variables, field_name)
	not common.is_null_value(value)
	value != ""
}
