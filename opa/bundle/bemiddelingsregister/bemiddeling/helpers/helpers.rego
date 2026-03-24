package bemiddelingsregister.bemiddeling.helpers

import rego.v1

import data.utils.graphql as _graphql

some_bemiddeling_is(selection, vars, field_name, equality_type, value) if {
	value_child := some_bemiddeling(selection, vars, field_name, equality_type)
	_graphql.val_or_var(value_child.Value, vars) == value
}

some_bemiddeling(selection, vars, field_name, equality_type) := value_child if {
	some_bemiddeling_filter := _graphql.where_required_name(selection, "bemiddeling", "some")

	some child in some_bemiddeling_filter.Children
	child.Name == field_name

	some value_child in child.Value.Children
	value_child.Name == equality_type
}
