Feature: Geen geldige operatie gevonden

	Scenario: Er is geen geldige operatie gevonden om te controleren
		When I send the graphql request "no_operation_found.graphql" to "global"
		Then the response code should be 400
		And the response body should contain the error message "No operation found to evaluate"
