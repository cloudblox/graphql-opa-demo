package notificaties.zendnotificatie_test

import data.authz.global
import data.notificaties.zendnotificatie as sut

import rego.v1

test_something if {
	res := sut.error_messages with global.query_ast as graphql.parse_query(query)
		with global.variables as variables
		with input.attributes.request.http.headers.authorization as token

	print(res)
}

# token := "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InJzYS1rZXkiLCJ0eXAiOiJKV1QiLCJ4NWMiOlsiTUlJQkNnS0NBUUVBMjVsOXFuWTVvT3FXM09OWXpqNWV1ek9tN0VySGduYm1yak0xbjNmZGl4Nm93NG01N2EzazExRGgyM0NsNmdpOUlIRStYUVJyclgwT2tHcFpnb2NxNDBFN0xvbnhlQmwyUzJCTkZmQS81S0tyMWc4YW9Ba1czYlR3WkNLVXY0Q0pnYy9VKzVpUytpTkhBU3hKNzZBWkpPcXhxU3ZMY3FDRXI1YThyaW5kVEJZY1FOdURBb3JVQ1VMZ2pHRzRCSVV3UXlSaUJpemdXZVc2MkYyVlhXWEZ4UVlNcWxCc1kzaXY1dE04S3lwbXhMWVVLN083MHY2UGNRY053MzRPY3JaaGxTckFvdlpxZk1LcFRKbmU3WFcrY040aHhkUCtHWTd5enMya0JXbHh0VWN4YUpXaWQwQWM4Sis3bWc0dkdud2ZIMmNsVkw1UTdhZllkS0ozMWZhWUt3SURBUUFCIl19.eyJpbnN0YW50aWVfbmFhbSI6IlN0aWNodGluZyBDaXoiLCJpbnN0YW50aWVfdHlwZSI6Ik9uZGVybmVtaW5nIiwia3ZrbnVtbWVyIjoiNDEyMDI5NTAiLCJzY29wZXMiOlsib3JnYW5pc2F0aWVzL3pvcmdrYW50b29yL25vdGlmaWNhdGllcy9ub3RpZmljYXRpZTpjcmVhdGUiXX0.y79qvRZTIzKOtubq2OEbhNZxFS2JZc5pNkNFFmnq6YApw5z2XBUrCAJfUdFg6s3PQqFM6FJjSRqzx3I0avko5ygNVEqcA1m3ID7aDpLxIcRpQMzgEzqO7UVHXsMVmrS2bL_zo5zkiODD92AU-Xt8WP0BBSh80qQ_D-WZhWEvYkeIOUctxdnDVaTXJyxZqzvPmAySfM02KXjUIPQs8WGZvwautsFQlSmSkJOCx5LxV6CnqKQspa9vS4QlFc4ona_YhpFOdOwlAMxdzAKsv--YKZXFyqOa_MhhuS3YSiDW5RqBfVYTMtBz2hLg9meysKWueNnV6alw5wiV71hFGV6SUw"

token := "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InJzYS1rZXkiLCJ0eXAiOiJKV1QiLCJ4NWMiOlsiTUlJQkNnS0NBUUVBM2N3ditydzhRZFVRTDJRdWpwWHMwamZCRFRvYnBuVWVMMXc5dnNuWGx3bUFKSjBicDBwcDIwQUVwUW5JSkl2TmpFa2U2MEJoblRzUkZ6cmNGVDU5VXYySGwxNFphSTByODR5WnJ6cks3TC9lamVkVzJvV3ZtU3Nwa0pXVFBORDFqck1CdEt1M1ZHU1ZwMmtBQXVvMGpmRGtTcmpzenYvVHcrUm80WW1yT2dpUWI1bld4RDB2SCtrN2pJalJQVk84V0FxMlQ3SEsxMC9pNUhhNDJreDI5eG5NYmZ1WTU4QUFPU0lVbnhjR0RWbEdFTFNsY0R5c0o3S0hweGdaZW5VdmFuYWtiWDYrTTRJcktrdHBLam5xWExpdjBQQkVHdUJKcTd5U3hmZzZqczNKSjlhbnBrZExVQ0IrR2tRZmVsNUovbVViUlpkTEluNHhqM29aWjl6WTB3SURBUUFCIl19.eyJpbnN0YW50aWVfbmFhbSI6IlN0aWNodGluZyBDaXoiLCJpbnN0YW50aWVfdHlwZSI6Ik9uZGVybmVtaW5nIiwia3ZrbnVtbWVyIjoiNjIyNTM3NzgiLCJzY29wZXMiOlsib3JnYW5pc2F0aWVzL3pvcmdrYW50b29yL25vdGlmaWNhdGllcy9ub3RpZmljYXRpZTpjcmVhdGUiXSwidXpvdmkiOm51bGx9.dOgh9H7O756EXQ84HVUWRauqdf-KxvoGH2kaTSEuK_7Dst3TAum2wFFrKNho-Xw1llK79VcYKjzGfDG5hyMx4qZBcCrRcPT5zWCw9Xg_fr9HP9mh-NVEqKIOlKYV31ywWB9lMFUN6nE0PjB_Sm_7pOnuLvjqdUEJaX8eSRi8iz9gl_VigKeoORmTGvCj6hl-jG-8h77LOJnpU02AhSDW1HAEWJKRf5guIvSidduKnFicN4kuDcGWzzInPUBLwLXeS8-upH1ffAi-ZsmdSPVhS8IB77dvPNOZiYqzw5_4CjJ7k0999zkp93TWX65ZLn864lYI-Pg8ryNi1gLyxMR0Ig"

query := `mutation ZendNotificatie {
    zendNotificatie(
        notificatieInput: {
            afzenderID: "62253778"
            afzenderIDType: KVK
            eventType: "NIEUWE_INDICATIE_ZORGKANTOOR"
            ontvangerID: "5000"
            ontvangerIDType: UZOVI
            ontvangerKenmerk: "ontvangerKenmerk"
            subjectList: [{ recordID: "1", subject: "subject" }]
            timestamp: "2024-06-01"
        }
    ) {
        afzenderID
        afzenderIDType
        eventType
        ontvangerID
        ontvangerIDType
        ontvangerKenmerk
        subjectList {
            recordID
            subject
        }
        timestamp
        ... on Notificatie {
            notificatieID
        }
    }
}`

variables := ``

# variables := {"notificatieInput": {
# 	"timestamp": "2022-01-01T00:00:00Z",
# 	"afzenderIDType": "KVK",
# 	"afzenderID": "62253778",
# 	"eventType": "NIEUWE_INDICATIE_ZORGKANTOOR",
# 	"ontvangerID": "2",
# 	"ontvangerIDType": "UZOVI",
# 	"ontvangerKenmerk": "ontvangerKenmerk",
# 	"subjectList": [{
# 		"recordID": "1",
# 		"subject": "test",
# 	}],
# }}
