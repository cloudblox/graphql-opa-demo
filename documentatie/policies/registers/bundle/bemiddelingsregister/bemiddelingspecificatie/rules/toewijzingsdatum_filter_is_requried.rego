package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.bemiddelingsregister.helpers
import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql
import rego.v1

_toewijzing_einddatum := _graphql.where_required_name(config.query_selection, "toewijzingEinddatum", "eq")
_einddatum_var := _graphql.val_or_var(_toewijzing_einddatum, global.variables)

_einddatum_null if {
	common.is_null_value(_einddatum_var)
}

_einddatum_null if {
	not _einddatum_var
}

subentities := ["bemiddelingspecificatie", "regiehouder", "contactpersoon", "contactgegevens"]

toewijzingsdatum_filter_is_requried if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")

	# Iterates the datumfilter check over all subentities for both the toewijzingingangsdatum and toewijzingeinddatum
	every subentity in subentities {
		_subentities_valid_ingangsdatum_filter(bemiddeling_selection, subentity, global.variables, ingangsdata_vars)
		_subentities_valid_einddatum_filter(bemiddeling_selection, subentity, global.variables, _einddatum_var)
	}
}

toewijzingsdatum_filter_is_requried if {
	# Check if the toewijzingeinddatum is set to null value
	_einddatum_null
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")

	# Iterates the datumfilter check over all subentities for only the toewijzingingangsdatum
	every subentity in subentities {
		_subentities_valid_ingangsdatum_filter(bemiddeling_selection, subentity, global.variables, ingangsdata_vars)
	}
}

toewijzingsdatum_filter_is_requried if {
	not _graphql.selection(config.query_selection, "bemiddeling")
}

toewijzingsdatum_filter_is_requried if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	count(_graphql.walk_selections_multi_args(bemiddeling_selection, subentities)) == 0
}

_subentities_valid_ingangsdatum_filter(query, subentity, vars, datum_var) if {
	selections := _graphql.walk_selections(config.query_selection, subentity)

	every date_valid in selections {
		helpers.where_toewijzingingangsdatum_overlaps(date_valid, global.variables, datum_var)
	}
}

_subentities_valid_einddatum_filter(query, subentity, vars, datum_var) if {
	selections := _graphql.walk_selections(config.query_selection, subentity)

	every date_valid in selections {
		helpers.where_toewijzingeinddatum_overlaps(date_valid, global.variables, datum_var)
	}
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	# Rules need to be true to prevent multiple error messages
	toewijzingingangsdatum_is_required
	toewijzingeinddatum_is_required
	vaststellingmoment_is_required

	not toewijzingsdatum_filter_is_requried

	msg := {
		"message": common.err("'vaststellingMoment', 'toewijzingIngangsdatum', and `toewijzingEinddatum` are required and must be used to filter the subentities.", config.operation), # regal ignore: line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
