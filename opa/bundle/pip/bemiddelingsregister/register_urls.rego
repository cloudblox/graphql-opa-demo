package pip.bemiddelingsregister

graphql_urls_feature_tests := ["http://localhost:9090/test1", "http://localhost:9090/test2"]

graphql_urls_dev := ["https://dev-api.vecozo.nl/dev/bemiddelingsregister/v1/graphql"]

graphql_urls_oti := ["https://dev-api.vecozo.nl/oti/bemiddelingsregister/v1/graphql"]

graphql_urls_tst := ["https://tst-api.vecozo.nl/tst/bemiddelingsregister/v1/graphql"]

graphql_urls_acc := ["https://tst-api.vecozo.nl/acc/bemiddelingsregister/v1/graphql"]

graphql_urls_prd := ["https://api.vecozo.nl/bemiddelingsregister/v1/graphql"]

env := opa.runtime().env.ENV

graphql_urls := {
	"feature_tests": graphql_urls_feature_tests,
	"dev": graphql_urls_dev,
	"oti": graphql_urls_oti,
	"tst": graphql_urls_tst,
	"acc": graphql_urls_acc,
	"prd": graphql_urls_prd,
}[env]
