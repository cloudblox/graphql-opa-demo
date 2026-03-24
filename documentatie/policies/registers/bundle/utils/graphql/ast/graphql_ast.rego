package utils.graphql.ast

import rego.v1

operation(name, operation_type, variables) := {
	"Name": name,
	"Operation": operation_type,
	"VariableDefinitions": variables,
}

operation_selection_set(name, operation_type, selection_set) := {
	"Name": name,
	"Operation": operation_type,
	"SelectionSet": selection_set,
}

variable_def(name) := {"Variable": name}

selection_set_empty(name) := {
	"Alias": name,
	"Name": name,
}

selection_set_args(name, args) := {
	"Alias": name,
	"Name": name,
	"Arguments": args,
}

selection_set(name, _selection_set) := {
	"Alias": name,
	"Name": name,
	"SelectionSet": _selection_set,
}

child(name, value) := {
	"Name": name,
	"Value": value,
}

children(_children) := {"Children": _children}

raw(value) := {
	"Kind": 9,
	"Raw": value,
}

raw_kind(value, kind) := {
	"Kind": kind,
	"Raw": value,
}
