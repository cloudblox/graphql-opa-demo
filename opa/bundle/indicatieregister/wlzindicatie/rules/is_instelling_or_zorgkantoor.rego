package indicatieregister.wlzindicatie.rules

import rego.v1

import data.authz.global
import data.indicatieregister.wlzindicatie.config
import data.pip.bemiddelingsregister as bemiddelingsregister_pip
import data.utils.common
import data.utils.graphql as _graphql
import data.utils.graphql.graphql_request

subject_is_instelling if {
	common.is_zorgaanbieder(global.token)
	common.claim(global.token, "agb")
}

subject_is_zorgkantoor if {
	common.is_zorgkantoor(global.token)
	common.claim(global.token, "uzovi")
}

is_instelling_or_zorgkantoor if {
	subject_is_instelling
}

is_instelling_or_zorgkantoor if {
	subject_is_zorgkantoor
}

error_messages contains msg if {
	config.operation
	config.scope_allowed

	not is_instelling_or_zorgkantoor

	msg := {
		"message": common.err("Subject does not have a valid 'uzovi' or 'agb'.", config.operation), # regal ignore:line-length
		"extensions": {"code": common.errors.UNAUTHORIZED},
	}
}
