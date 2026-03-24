package notificaties.zendmelding_test

import data.authz.global

import data.notificaties.zendmelding as sut

import rego.v1

test_something if {
	res := sut.allow with global.query_ast as graphql.parse_query(query)
		with global.variables as variables
		with input.attributes.request.http.headers.authorization as token

	print(res)
}

token := "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjgyQ0JFODQ2LUQyNEUtNDU4QS1BNkU2LUQ1MDk4RTA5NkQ1MiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhdXRoLm5pZCIsInN1YiI6IjIwMDAxMDAwMDAxMTMxIiwiYXVkIjoidGVzdCIsImV4cCI6MTc0NzMyMzEzOCwibmJmIjoxNzQ3MzE5NDE4LCJpYXQiOjE3NDczMTk1MzgsImp0aSI6ImFiZDZiMWYwLTgyMTgtNGM4YS1iMmZlLTFjYmMxZDg3YWVkZCIsIl9jbGFpbV9uYW1lcyI6eyJhZ2IiOiJsb2NhbGhvc3QiLCJpbnN0YW50aWVfbmFhbSI6ImxvY2FsaG9zdCIsImluc3RhbnRpZV90eXBlIjoibG9jYWxob3N0Iiwia3ZrIjoibG9jYWxob3N0IiwidXpvdmkiOiJsb2NhbGhvc3QifSwiX2NsYWltX3NvdXJjZXMiOnsibG9jYWxob3N0Ijp7Imp3dCI6ImV5SmhiR2NpT2lKSVV6STFOaUlzSW5SNWNDSTZJa3BYVkNKOS5leUpoWjJJaU9tNTFiR3dzSW1sdWMzUmhiblJwWlY5dVlXRnRJam9pVm1WamIzcHZJaXdpYVc1emRHRnVkR2xsWDNSNWNHVWlPaUpQYm1SbGNtNWxiV2x1WnlJc0ltdDJheUk2SWpFNE1EWTFPRFk0SWl3aWRYcHZkbWtpT201MWJHeDkublpHTjJ4djdGcHFhNEtQaUs5MVpqTk1QNmZXeUVVdV8tdXBWay1LX1hqOCJ9fSwiY2xpZW50X2lkIjoiMjAwMDEwMDAwMDExMzEiLCJzdWJqZWN0cyI6bnVsbCwic2NvcGVzIjpbIm9yZ2FuaXNhdGllcy96b3Jna2FudG9vci9tZWxkaW5nZW4vbWVsZGluZzpjcmVhdGUiXSwiY29uc2VudF9pZCI6IjYyYWM2NjdkLTY2ZjMtNDRiMy04ODQ3LWRmODhkZWVhZGQwZiIsImNsaWVudF9tZXRhZGF0YSI6bnVsbH0.hG7OPJLz5Wo6bhh52euce39yiSIwSzMxl29LGgkeZ6H2iD9dIDcRebxGOcfb4lHM_biE7WVzPv4GkysOHZtFnOMHMEXG55Jn5UjPFxOO6AapAHwSah85ugJCMozKJ3J2QKdRu5kb3Lqp4LXr6NQj5cCRSNYSj8yH61Cf7p693l2n1-RgAmCwedOihwyeMbs8z6BrCqxjXE9pBLn7OgbUHZrYXi-Kk6hVM0cntju9YG1bUUeE_KD3MQe9Kazhbb8qFhqiE4PxQDIbybMGP8QVl2OOcPhvDbLaesjKXNVEMHhj-zCfGmeVut7cPogY5MEHw-GcSSbVU9dfFa8GX0R3wkx5jx0X56u2G8ZSMFlDFwReEuqnaWaMUxssKcgPD5b1DMV6iSoFwiOG2tFRIZJoQFeePhGtsQ-4jtvZSGCjQqfZf_EmnmNzhIHwaCFNb2p46oOZeuarECGtQ9nbRFbRjVqRvUkj8KjYn6EVxJraAC3lJr4yC2Jg7e9m5YHXaqN-PY3pgRmF50d79Po4VUVVNhP4WpNuFdsBYb-p6WcvSwu85lP1Gf6cHj2nFNfRejvT7WWBhtgYi_F9MCTgV1o0tuxdIZRbNGHAFumB0AmB9G0nw0TKScyUnOggvW8d3B30VM0DivqkUquOS2IjfIGity_uH9FJhiZ-IIBbnBrlFjU"

query := `mutation ZendMelding($meldingInput: MeldingInput!) {
    zendMelding(meldingInput: $meldingInput) {
        afzenderID
        afzenderIDType
        eventType
        ontvangerID
        ontvangerIDType
        ontvangerKenmerk
        timestamp
        subjectList {
            recordID
            subject
        }
        ... on Melding {
            meldingID
        }
    }
}`

variables := {"meldingInput": {
	"timestamp": "2024-06-01T00:00:00Z",
	"afzenderIDType": "KVK",
	"afzenderID": "18065868",
	"eventType": "iWLZFOUTMELDING",
	"ontvangerIDType": "UZOVI",
	"ontvangerID": "5000",
	"ontvangerKenmerk": "Zorgkantoor",
	"subjectList": [{
		"recordID": "1",
		"subject": "bemiddeling",
	}],
}}
