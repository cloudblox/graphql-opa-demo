package bemiddelingsregister.helpers

import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql
import rego.v1

# For ingangsdatum: check if actor's toewijzingeinddatum is before queried the (toewijzing)ingangsdatum of the subentity
where_toewijzingeinddatum_overlaps(q, vars, eind_datum) if {
	where := _graphql.children_arg(q, "where")
	not _graphql.children_in(where, ["ingangsdatum", "toewijzingIngangsdatum"])

	_and := _graphql.children(where, "and")
	_ingangsdatum_smaller_than_or_smaller_than_equal(_and, vars, eind_datum)
}

where_toewijzingeinddatum_overlaps(q, vars, eind_datum) if {
	where := _graphql.children_arg(q, "where")
	_ingangsdatum_smaller_than_or_smaller_than_equal(where, vars, eind_datum)
}

_ingangsdatum_smaller_than_or_smaller_than_equal(obj, vars, eind_datum) if {
	some child in obj
	children := _graphql.children_in(child.Value.Children, ["ingangsdatum", "toewijzingIngangsdatum"])
	every c in children {
		c.Name == "ngt"
		_graphql.val_or_var(c.Value, vars) == eind_datum
	}
}

_ingangsdatum_smaller_than_or_smaller_than_equal(obj, vars, eind_datum) if {
	children := _graphql.children_in(obj, ["ingangsdatum", "toewijzingIngangsdatum"])
	every c in children {
		c.Name == "ngt"
		_graphql.val_or_var(c.Value, vars) == eind_datum
	}
}
