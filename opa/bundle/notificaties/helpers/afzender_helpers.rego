package notificaties.helpers

import rego.v1

import data.authz.global
import data.utils.common

vecozo_kvk_nummer := "18065868"

afzender_is_vecozo if {
	kvk_nummer := common.claim(global.token, "kvk")
	kvk_nummer == vecozo_kvk_nummer
}

ciz_kvk_nummer := "62253778"

afzender_is_ciz if {
	kvk_nummer := common.claim(global.token, "kvk")
	kvk_nummer == ciz_kvk_nummer
}

valid_kvk_zenders := {ciz_kvk_nummer}

zorgmatch_uzovi_nummer := "9997"

afzender_is_zorgmatch if {
	uzovi_nummer := common.claim(global.token, "uzovi")
	uzovi_nummer == zorgmatch_uzovi_nummer
}

menzis_uzovi_nummer := "5000"

afzender_is_menzis if {
	uzovi_nummer := common.claim(global.token, "uzovi")
	uzovi_nummer == menzis_uzovi_nummer
}
