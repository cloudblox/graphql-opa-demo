package bemiddelingsregister.overdracht.rules

import data.authz.global
import data.bemiddelingsregister.overdracht.config
import data.bemiddelingsregister.overdracht.helpers
import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql
import rego.v1

subentities_bemiddeling := ["regiehouder", "contactpersoon", "contactgegevens", "bemiddelingspecificatie"]

# Check if the overdrachtdatum is required based on whether any subentities are queried which require a filter
overdrachtdatum_filter_is_required if {
	# Checks if the Bemiddeling "Branch" has any subentities which need a datefilter
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	helpers.no_subentities(bemiddeling_selection)

	# Checks if the overdrachtSpecificatie "Branch" has any required valid subentities
	bemspec_selection := helpers.bemspec_extractor(config.query_selection)
	helpers.no_subentities(bemspec_selection)
}

# MAIN RULE: Extracts all subentities and checks whether they are filtered correctly.
overdrachtdatum_filter_is_required if {
	# Collects the overdrachtdatum for later filter checking
	input_overdrachtdatum := _graphql.where_required_name(config.query_selection, "overdrachtDatum", "eq")
	overdrachtdatum_variable := _graphql.val_or_var(input_overdrachtdatum, global.variables)

	# Checks if the Bemiddeling "Branch" subentities have a correct datefilter
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	helpers.all_subentities_valid_filter(bemiddeling_selection, subentities_bemiddeling, overdrachtdatum_variable)

	# Checks if the overdrachtSpecificatie "Branch" subentities have a correct datefilter
	bemspec_selection := helpers.bemspec_extractor(config.query_selection)
	helpers.bemspec_subentity_filter_valid(bemspec_selection, overdrachtdatum_variable)
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	overdrachtdatum_is_required
	not overdrachtdatum_filter_is_required

	msg := {
		"message": common.err("Subentities must be filtered using the `overdrachtDatum` and the day before the `overdrachtDatum`.", config.operation), # regal ignore: line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
