Feature: Global graphql errors

	Scenario: There is an graphql parse error
		When I send the graphql request "invalid_graphql_query.graphql" to "global"
		Then the response code should be 400
		And the response body should contain the error message "Unable to parse graphql query"

	Scenario: There are multiple operations in the query
		When I send the graphql request "multiple_operations.graphql" to "global"
		Then the response code should be 400
		And the response body should contain the error message "Only one operation at the time is supported."

	Scenario: There are multiple selections the operation of the query
		When I send the graphql request "multiple_selections.graphql" to "global"
		Then the response code should be 400
		And the response body should contain the error message "Only one selectionset in an operation is supported."

	Scenario: There is an invalid scope in the request
		Given My claims are
			"""
			{
				"scopes": [
					"invalid/scope"
				]
			}
			"""
		When I send the graphql request "valid_query.graphql" to "global"
		Then the response code should be 400
		And the response body should contain the error message "scope not allowed"