package bemiddelingsregister.overdracht.helpers

import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql
import rego.v1

subentities_bemiddeling := ["regiehouder", "contactpersoon", "contactgegevens", "bemiddelingspecificatie"]
subentities_bemspec := ["regiehouder", "contactpersoon", "contactgegevens"]

# Extracts the nested bemiddelingspecificatie selection from the query
bemspec_extractor(query_selection) := bemspec_selection if {
	overdrachtspec_selection := _graphql.selection(query_selection, "overdrachtspecificatie")
	bemspec_selection := _graphql.selection(overdrachtspec_selection, "bemiddelingspecificatie")
}

# Checks if all subentities in the bemiddelingspecificatie have a valid filter on the overdrachtdatum
bemspec_subentity_filter_valid(bemspec_selection, overdrachtdatum_variable) if {
	# Checks for all subentities that may exist directly in the bemiddelingspecificatie
	all_subentities_valid_filter(bemspec_selection, subentities_bemspec, overdrachtdatum_variable)

	# Checks if there is a bemiddeling in the bemiddelingspecificatie, and then checks for the subentities nested in this bemiddeling. regal ignore: line-length
	overdracht_bemiddeling_correct(bemspec_selection, overdrachtdatum_variable)
}

# There is no need to check the overdrachtdatum filter if there is no bemiddeling selection
overdracht_bemiddeling_correct(bemspec_selection, overdrachtdatum_variable) if {
	not _graphql.selection(bemspec_selection, "bemiddeling")
}

# Checks for ALL subentities in the bemiddeling selection (including other bemiddelingspecificaties)
overdracht_bemiddeling_correct(bemspec_selection, overdrachtdatum_variable) if {
	nested_bemiddeling_selection := _graphql.selection(bemspec_selection, "bemiddeling")

	all_subentities_valid_filter(nested_bemiddeling_selection, subentities_bemiddeling, overdrachtdatum_variable)
}

# Iterates the filter check function for all subentities in the list
all_subentities_valid_filter(selection, subentities, overdrachtdatum_variable) if {
	every subentity in subentities {
		subentity_filter_check(selection, subentity, overdrachtdatum_variable)
	}
}

# Checks if there are no subentities in the query selection
no_subentities(subentities) if {
	every subentity in subentities_bemiddeling {
		count(_graphql.walk_selections(subentities, subentity)) == 0
	}
}

# Checks if all instances of a subentity type have a valid date filter
subentity_filter_check(query_selection, subentity_type, overdrachtdatum_variable) if {
	not subentity_type == "regiehouder"
	subentity_type_instances := _graphql.walk_selections(query_selection, subentity_type)

	every subentity_instance in subentity_type_instances {
		where_overdrachtdatum_overlaps_contact(subentity_instance, overdrachtdatum_variable)
	}
}

# Checks if all instances of a subentity type have a valid date filter
subentity_filter_check(query_selection, subentity_type, overdrachtdatum_variable) if {
	subentity_type_instances := _graphql.walk_selections(query_selection, subentity_type)

	every subentity_instance in subentity_type_instances {
		where_overdrachtdatum_overlaps(subentity_instance, overdrachtdatum_variable)
	}
}
