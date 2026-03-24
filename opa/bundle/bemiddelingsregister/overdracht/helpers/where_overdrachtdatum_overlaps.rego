package bemiddelingsregister.overdracht.helpers

import data.authz.global
import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql
import rego.v1

# For overdrachtdatum: check if actor's overdrachtdatum is before queried the (toewijzing)einddatum of the subentity
where_overdrachtdatum_overlaps_contact(q, overdracht_datum) if {
	where := _graphql.children_arg(q, "where")
	_or := _graphql.children(where, "or")

	_einddatum_greater_than_or_greater_than_equal(_or, overdracht_datum)
	_einddatum_equals_null(_or, overdracht_datum)
}

# regiehouder specific: checks both ingangsdatum and einddatum
where_overdrachtdatum_overlaps(q, overdracht_datum) if {
	where := _graphql.children_arg(q, "where")

	_ingangsdatum_smaller_than_equal(where, overdracht_datum)

	_or := _graphql.children(where, "or")

	_einddatum_greater_than_or_greater_than_equal(_or, overdracht_datum)
	_einddatum_equals_null(_or, overdracht_datum)
}

# Same as previous function, but with an extra and level of nesting
where_overdrachtdatum_overlaps(q, overdracht_datum) if {
	where := _graphql.children_arg(q, "where")
	_and := _graphql.children(where, "and")
	_ingangsdatum_smaller_than_equal(_and, overdracht_datum)

	_or := _graphql.children(_and, "or")

	_einddatum_greater_than_or_greater_than_equal(_or, overdracht_datum)
	_einddatum_equals_null(_or, overdracht_datum)
}

# Check if the ingangsdatum is smaller than or equal to the overdrachtdatum and is the same overdracht_datum as in the overdracht. regal ignore: line-length
_ingangsdatum_smaller_than_equal(obj, overdracht_datum) if {
	children := _graphql.children_in(obj, ["ingangsdatum", "toewijzingIngangsdatum"])
	every c in children {
		c.Name == "ngt"
		_graphql.val_or_var(c.Value, global.variables) == overdracht_datum
	}
}

# Check if the einddatum is smaller than or equal to the overdrachtdatum and is the same overdracht_datum as in the overdracht. regal ignore: line-length
_einddatum_greater_than_or_greater_than_equal(obj, overdracht_datum) if {
	some child in obj
	children := _graphql.children_in(child.Value.Children, ["einddatum", "toewijzingEinddatum"])
	every c in children {
		c.Name in ["gt", "gte"]

		# einddatum must be compared to one day prior to the overdrachtdatum
		_graphql.val_or_var(c.Value, global.variables) == date.subtract_one_day(overdracht_datum)
	}
}

# Check if the einddatum is null
_einddatum_equals_null(obj, ingang_datum) if {
	some child in obj
	children := _graphql.children_in(child.Value.Children, ["einddatum", "toewijzingEinddatum"])
	every c in children {
		c.Name == "eq"
		common.is_null_value(_graphql.val_or_var(c.Value, global.variables))
	}
}
