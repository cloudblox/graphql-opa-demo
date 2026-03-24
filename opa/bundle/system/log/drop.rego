package system.log

import data.utils.common
import rego.v1

# Define a set of UIDs for which logs should be dropped
_drop_decisionlog_subjects_str := opa.runtime().env.DROP_DECISIONLOG_SUBJECTS

_drop_decisionlog_subjects := split(_drop_decisionlog_subjects_str, ",")

# Rule to determine if the log should be dropped
drop if {
	_drop_decisionlog_subjects
	some sub in _drop_decisionlog_subjects
	trim_space(sub) == common.token(input.input.attributes.request.http.headers.authorization).sub
}
