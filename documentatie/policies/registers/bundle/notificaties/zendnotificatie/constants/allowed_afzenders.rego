package notificaties.zendnotificatie.constants

import rego.v1

allowed_afzender_id_types := {"UZOVI", "KVK"}

afzender_ids_menzis := ["5501", "5505", "5507"]

afzender_ids_zorgmatch := ["5503", "5504", "5510", "5513", "5514", "5521", "5506", "5509", "5511", "5515", "5533", "5518", "5523", "5525", "5526", "5529", "5531", "5508", "5512", "5520", "5524", "5527", "5528", "5530", "5516", "5517"] # regal ignore: line-length

afzender_ids_prd := array.concat(afzender_ids_menzis, afzender_ids_zorgmatch)

afzender_ids_test_uzovis := ["5000", "9997"] # test uzovi's Menzis en ZorgMatch

afzender_ids_tst := array.concat(afzender_ids_test_uzovis, afzender_ids_prd)

env := opa.runtime().env.ENV
afzender_ids := {
	"feature_tests": afzender_ids_tst,
	"dev": afzender_ids_tst,
	"oti": afzender_ids_tst,
	"tst": afzender_ids_tst,
	"acc": afzender_ids_tst,
	"prd": afzender_ids_prd,
}[env]
