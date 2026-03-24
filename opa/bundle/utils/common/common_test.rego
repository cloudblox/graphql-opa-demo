package utils.common_test

import data.utils.common
import rego.v1

test_scope_allowed_regex_valid if {
	common.contains_scope(`organisaties/[^\\s/:]+/notificaties`, [
		"organisaties/zorgkantoren/notificaties:read",
		"organisaties/zorgaanbieder/notificaties:write",
	])
}

test_scope_allowed_valid if {
	common.contains_scope("some-register/scope", [
		"some-register/scope:read",
		"some-register/scope:write",
	])
}

test_not_allowed_operations_invalid_operation_name if {
	input_operation := {
		"Name": "invalid-operation",
		"Operation": "query",
	}

	allowed_operations := {"allowed-operation": "query"}

	operation := common.not_allowed_operations([input_operation], allowed_operations)
	operation.Name == input_operation.Name
	operation.Operation == input_operation.Operation
}

test_not_allowed_operations_invalid_operation_type if {
	input_operation := {
		"Name": "allowed-operation",
		"Operation": "mutation",
	}

	allowed_operations := {"allowed-operation": "query"}

	operation := common.not_allowed_operations([input_operation], allowed_operations)
	operation.Name == input_operation.Name
	operation.Operation == input_operation.Operation
}

test_not_allowed_operations if {
	input_operation := {
		"Name": "allowed-operation",
		"Operation": "query",
	}

	allowed_operations := {"allowed-operation": "query"}

	not common.not_allowed_operations([input_operation], allowed_operations)
}

test_aggregated_claim_valid if {
	claim := common.aggregated_claim(
		{
			"_claim_names": {"uzovi": "localhost"},
			"_claim_sources": {"localhost": {"jwt": "eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJ1em92aSI6ICI1MDAwIn0.6hps2JiPS-G56NirlZwoLoqEL7JbESPvW7sTKUw3tzQ"}},
		},
		"uzovi",
	)

	claim == "5000"
}

test_aggregated_claim_no_claim_names if {
	not common.aggregated_claim(
		{"_claim_sources": {"localhost": {}}},
		"uzovi",
	)
}

test_aggregated_claim_no_claim_sources if {
	not common.aggregated_claim(
		{"_claim_names": {"uzovi": "localhost"}},
		"uzovi",
	)
}

test_aggregated_claim_claim_names_not_claim if {
	not common.aggregated_claim(
		{
			"_claim_names": {"not_requested_claim": "localhost"},
			"_claim_sources": {"localhost": {"jwt": "a.b.c"}},
		},
		"uzovi",
	)
}

test_aggregated_claim_claim_sources_not_claim_name if {
	not common.aggregated_claim(
		{
			"_claim_names": {"uzovi": "localhost"},
			"_claim_sources": {"not_a_claim_names_value": {}},
		},
		"uzovi",
	)
}

test_aggregated_claim_no_jwt if {
	not common.aggregated_claim(
		{
			"_claim_names": {"uzovi": "localhost"},
			"_claim_sources": {"not_a_claim_names_value": {"no_jwt": ""}},
		},
		"uzovi",
	)
}

test_aggregated_claim_no_valid_jwt if {
	not common.aggregated_claim(
		{
			"_claim_names": {"uzovi": "localhost"},
			"_claim_sources": {"not_a_claim_names_value": {"jwt": "a.b.c"}},
		},
		"uzovi",
	)
}

test_claim_direct_claim if {
	claims := {"my_claim": "value"}

	common.claim(claims, "my_claim") == "value"
}

test_claim_double_claim_name if {
	claims := {
		"uzovi": "value",
		"_claim_names": {"uzovi": "localhost"},
		"_claim_sources": {"localhost": {"jwt": "eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJ1em92aSI6ICI1MDAwIn0.6hps2JiPS-G56NirlZwoLoqEL7JbESPvW7sTKUw3tzQ"}},
	}

	common.claim(claims, "uzovi") == "value"
}

test_claim_aggregated_claim if {
	claims := {
		"_claim_names": {"uzovi": "localhost"},
		"_claim_sources": {"localhost": {"jwt": "eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJ1em92aSI6ICI1MDAwIn0.6hps2JiPS-G56NirlZwoLoqEL7JbESPvW7sTKUw3tzQ"}},
	}

	common.claim(claims, "uzovi") == "5000"
}
