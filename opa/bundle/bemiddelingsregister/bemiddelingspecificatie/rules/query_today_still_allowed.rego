package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.bemiddelingsregister.helpers
import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql
import rego.v1

_toewijzing_einddatum := _graphql.where_required_name(config.query_selection, "toewijzingEinddatum", "eq")

_einddatum_variable := _graphql.val_or_var(_toewijzing_einddatum, global.variables)

bemiddeling_subentities := ["regiehouder", "bemiddelingspecificatie"]

client_subentities := ["contactgegevens", "contactpersoon"]

_regiehouder_or_bemspec_is_queried if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	some subentity in bemiddeling_subentities
	date_selection := _graphql.walk_selections(bemiddeling_selection, subentity)
	count(date_selection) > 0
}

regiehouder_and_bemspec_today_still_allowed if {
	_einddatum_variable
	_regiehouder_or_bemspec_is_queried

	last_allowed_query_date := _may_31_next_year(_einddatum_variable)
	date.compare_time_before(date.ns_to_datum(time.now_ns()), last_allowed_query_date)
}

regiehouder_and_bemspec_today_still_allowed if {
	not _regiehouder_or_bemspec_is_queried
}

regiehouder_and_bemspec_today_still_allowed if {
	common.is_null_value(_einddatum_variable)
}

_contactgegevens_or_contactpersoon_is_queried if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	some subentity in client_subentities
	date_selection := _graphql.walk_selections(bemiddeling_selection, subentity)
	count(date_selection) > 0
}

contactgegevens_and_contactpersoon_today_still_allowed if {
	_einddatum_variable
	_contactgegevens_or_contactpersoon_is_queried

	last_allowed_query_date := _add_2_years(_einddatum_variable)
	date.compare_time_before(date.ns_to_datum(time.now_ns()), last_allowed_query_date)
}

contactgegevens_and_contactpersoon_today_still_allowed if {
	not _contactgegevens_or_contactpersoon_is_queried
}

contactgegevens_and_contactpersoon_today_still_allowed if {
	common.is_null_value(_einddatum_variable)
}

query_today_still_allowed if {
	_einddatum_variable
	regiehouder_and_bemspec_today_still_allowed
	contactgegevens_and_contactpersoon_today_still_allowed
}

query_today_still_allowed if {
	not _einddatum_variable
}

query_today_still_allowed if {
	common.is_null_value(_einddatum_variable)
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not query_today_still_allowed
	not regiehouder_and_bemspec_today_still_allowed

	msg := {
		"message": common.err(
			"A 'regiehouder' or 'bemiddelingspecificatie' may only be queried until the next year's may 31st after the 'ToewijzingEinddatum'.", # regal ignore: line-length
			config.operation,
		),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not query_today_still_allowed
	not contactgegevens_and_contactpersoon_today_still_allowed

	msg := {
		"message": common.err(
			"A 'contactgegevens' or 'contactpersoon' may only be queried until 2 years after the 'ToewijzingEinddatum'.", # regal ignore: line-length
			config.operation,
		),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
