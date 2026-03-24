package authz.router

import rego.v1

import data.authz.global
import data.bemiddelingsregister
import data.indicatieregister
import data.notificaties

### route allowed registers

## notificaties
allow if notificaties.zendmelding.allow

allow if notificaties.zendnotificatie.allow

## indicatieregister
allow if indicatieregister.wlzindicatie.allow

## bemiddelingsregister
allow if bemiddelingsregister.bemiddeling.allow

allow if bemiddelingsregister.bemiddelingspecificatie.allow

allow if bemiddelingsregister.regiehouder.allow

allow if bemiddelingsregister.client.allow

allow if bemiddelingsregister.overdracht.allow

### route error messages

default error_messages := {}

## notificaties error messages
error_messages := msg if {
	count(notificaties.zendmelding.error_messages) > 0
	msg := notificaties.zendmelding.error_messages
}

error_messages := msg if {
	count(notificaties.zendnotificatie.error_messages) > 0
	msg := notificaties.zendnotificatie.error_messages
}

## indicatie error messages
error_messages := msg if {
	count(indicatieregister.wlzindicatie.error_messages) > 0
	msg := indicatieregister.wlzindicatie.error_messages
}

## bemiddelingsregister error messages
error_messages := msg if {
	count(bemiddelingsregister.bemiddeling.error_messages) > 0
	msg := bemiddelingsregister.bemiddeling.error_messages
}

error_messages := msg if {
	count(bemiddelingsregister.bemiddelingspecificatie.error_messages) > 0
	msg := bemiddelingsregister.bemiddelingspecificatie.error_messages
}

error_messages := msg if {
	count(bemiddelingsregister.client.error_messages) > 0
	msg := bemiddelingsregister.client.error_messages
}

error_messages := msg if {
	count(bemiddelingsregister.overdracht.error_messages) > 0
	msg := bemiddelingsregister.overdracht.error_messages
}

error_messages := msg if {
	count(bemiddelingsregister.regiehouder.error_messages) > 0
	msg := bemiddelingsregister.regiehouder.error_messages
}
