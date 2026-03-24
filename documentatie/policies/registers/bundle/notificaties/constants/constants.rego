package notificaties.constants

import rego.v1

instantie_type_map := {
	"Zorgaanbieder": "AGB",
	"Zorgkantoor": "UZOVI",
	"Onderneming": "KVK",
}

instantie_type_map_to_scope := {
	"AGB": "zorgaanbieder",
	"UZOVI": "zorgkantoor",
	"KVK": "onderneming",
}

instantie_claim_id_map := {
	"Zorgaanbieder": "agb",
	"Zorgkantoor": "uzovi",
	"Onderneming": "kvk",
}

vecozo_silvester_gebruikersnummers := ["20001000001131", "20001000001011"]
