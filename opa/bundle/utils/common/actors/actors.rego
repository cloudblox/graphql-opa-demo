package utils.common.actors

import data.authz.global
import data.utils.common
import rego.v1

vecozo_instantie_naam := "VECOZO"
vecozo_instantie_type := "Onderneming"

actor_is_vecozo if {
	instantie_naam := common.claim(global.token, "instantie_naam")
	instantie_naam == vecozo_instantie_naam

	instantie_type := common.claim(global.token, "instantie_type")
	instantie_type == vecozo_instantie_type
}
