package notificaties.helpers

import rego.v1

all_event_types(event_types) := {event_type |
	some nested_set in event_types
	some event_type in nested_set
}
