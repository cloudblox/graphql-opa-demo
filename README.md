# GraphQL + OPA demo for the attached WLZ register queries

This demo serves the three GraphQL operations from the attachment and places the provided Rego bundle in front of the GraphQL endpoint.

Included queries:
- `POL108.graphql` -> `wlzIndicatie`
- `POL110.graphql` -> `client`
- `POL111.graphql` -> `bemiddeling`

The demo uses the original policy bundle from the attachment, cleaned from macOS metadata files. Authorization decisions are made by OPA through `data.authz.result`.

## What this demo does

- Exposes a GraphQL endpoint on `http://localhost:4000/graphql`
- Calls OPA before each GraphQL request
- Uses the provided Rego policies to allow or deny the request
- Returns mocked register data so you can test the policy flow with plain `curl`

## What this demo does not do

This demo intentionally keeps token validation disabled by setting `JWKS_URI=token_validation_disabled` in OPA. The token is still decoded by Rego, so claims and scopes are used exactly as expected by the policies.

The sample curl requests below are chosen so they stay on the direct authorization path and do not require the policy PIP helper calls to other services.

## Start

```bash
docker compose up --build
```

Health check:

```bash
curl http://localhost:4000/health
curl http://localhost:8181/health
```

## Create a demo token

Zorgkantoor token:

```bash
TOKEN=$(python3 scripts/make-demo-jwt.py --actor zorgkantoor)
echo "$TOKEN"
```

Zorgaanbieder token:

```bash
TOKEN=$(python3 scripts/make-demo-jwt.py --actor zorgaanbieder)
```

## POL108: wlzIndicatie

This request passes because:
- the token has scope `registers/wlzindicatieregister/indicaties/indicatie:read`
- the actor is a Zorgkantoor
- `initieelVerantwoordelijkZorgkantoor` equals the token's `uzovi`

```bash
TOKEN=$(python3 scripts/make-demo-jwt.py --actor zorgkantoor)

curl -s http://localhost:4000/graphql   -H "Content-Type: application/json"   -H "Authorization: Bearer $TOKEN"   -d @- <<'JSON'
{
  "query": "query WlzIndicatie($wlzIndicatieID: UUID!, $initieelVerantwoordelijkZorgkantoor: String!) { wlzIndicatie(where: { wlzindicatieID: {eq: $wlzIndicatieID}, initieelVerantwoordelijkZorgkantoor: {eq: $initieelVerantwoordelijkZorgkantoor} }) { wlzindicatieID bsn besluitnummer soortWlzindicatie initieelVerantwoordelijkZorgkantoor client { clientID bsn voornamen roepnaam } } }",
  "variables": {
    "wlzIndicatieID": "11111111-1111-1111-1111-111111111111",
    "initieelVerantwoordelijkZorgkantoor": "5500"
  }
}
JSON
```

## POL110: client

This request passes because:
- the token has scope `registers/wlzbemiddelingsregister`
- the token contains `uzovi: 5500`
- the query filters on `bemiddeling.some.verantwoordelijkZorgkantoor == 5500`

```bash
TOKEN=$(python3 scripts/make-demo-jwt.py --actor zorgkantoor)

curl -s http://localhost:4000/graphql   -H "Content-Type: application/json"   -H "Authorization: Bearer $TOKEN"   -d @- <<'JSON'
{
  "query": "query Client($verantwoordelijkZorgkantoor: String!) { client(where: { bemiddeling: { some: { verantwoordelijkZorgkantoor: { eq: $verantwoordelijkZorgkantoor } } } }) { clientID bsn taal bemiddeling { bemiddelingID wlzIndicatieID verantwoordelijkZorgkantoor } } }",
  "variables": {
    "verantwoordelijkZorgkantoor": "5500"
  }
}
JSON
```

## POL111: bemiddeling

This request passes because the same `uzovi` check is satisfied for the root `bemiddeling` query.

```bash
TOKEN=$(python3 scripts/make-demo-jwt.py --actor zorgkantoor)

curl -s http://localhost:4000/graphql   -H "Content-Type: application/json"   -H "Authorization: Bearer $TOKEN"   -d @- <<'JSON'
{
  "query": "query Bemiddeling($verantwoordelijkZorgkantoor: String!) { bemiddeling(where: { bemiddeling: { some: { verantwoordelijkZorgkantoor: { eq: $verantwoordelijkZorgkantoor } } } }) { bemiddelingID wlzIndicatieID verantwoordelijkheidIngangsdatum bemiddelingspecificatie { bemiddelingspecificatieID zzpCode uitvoerendZorgkantoor } client { clientID bsn taal } overdracht { overdrachtID verantwoordelijkZorgkantoor overdrachtDatum } } }",
  "variables": {
    "verantwoordelijkZorgkantoor": "5500"
  }
}
JSON
```

## Quick deny test

Wrong `uzovi` should be denied by Rego:

```bash
TOKEN=$(python3 scripts/make-demo-jwt.py --actor zorgkantoor)

curl -i -s http://localhost:4000/graphql   -H "Content-Type: application/json"   -H "Authorization: Bearer $TOKEN"   -d @- <<'JSON'
{
  "query": "query Client($verantwoordelijkZorgkantoor: String!) { client(where: { bemiddeling: { some: { verantwoordelijkZorgkantoor: { eq: $verantwoordelijkZorgkantoor } } } }) { clientID } }",
  "variables": {
    "verantwoordelijkZorgkantoor": "9999"
  }
}
JSON
```

## Mapping to the provided policies

- `opa/bundle/authz/main.rego` is the OPA entrypoint.
- `opa/bundle/authz/router/router.rego` routes to the register packages.
- `opa/bundle/indicatieregister/wlzindicatie/*` governs `POL108`.
- `opa/bundle/bemiddelingsregister/client/*` governs `POL110`.
- `opa/bundle/bemiddelingsregister/bemiddeling/*` governs `POL111`.

## Next useful step

If you want the full end-to-end path with policy PIP lookups as well, the next increment is to add:
- a token endpoint for `client_credentials`
- a second protected GraphQL endpoint for the PIP helper calls
- signed JWT validation with a local JWKS
