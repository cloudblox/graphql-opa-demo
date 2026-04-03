import express from "express";
import { createGraphQLApp } from "./shared.js";

const OPA_URL = process.env.OPA_URL || "http://opa:8181/v1/data/authz/result";
const PORT = Number(process.env.PORT || 4001);

function extractOperationName(query) {
  if (!query) return "unknown";
  if (query.includes("wlzIndicatie")) return "raadpleegIndicatie";
  if (query.includes("client")) return "raadpleegClient";
  if (query.includes("bemiddeling")) return "raadpleegBemiddeling";
  if (query.includes("overdracht")) return "raadpleegOverdracht";
  return "unknown";
}

function mapService(operation) {
  switch (operation) {
    case "raadpleegIndicatie":
      return "INDICATIEREGISTER";
    case "raadpleegClient":
      return "CLIENTREGISTER";
    case "raadpleegBemiddeling":
      return "BEMIDDELINGSREGISTER";
    default:
      return "UNKNOWN_SERVICE";
  }
}

function mapResourceType(operation) {
  switch (operation) {
    case "raadpleegIndicatie":
      return "WLZ_INDICATIE";
    case "raadpleegClient":
      return "CLIENT";
    case "raadpleegBemiddeling":
      return "BEMIDDELING";
    default:
      return "UNKNOWN_RESOURCE";
  }
}

function buildAuthorizationContext(req) {
  const authzHeader = req.headers.authorization || "";
  const operation = extractOperationName(req.body?.query || "");

  return {
    subject: {
      id: authzHeader ? "demo-subject" : "anonymous",
      organization_type: "ZORGKANTOOR",
      roles: ["RAADPLEGER"]
    },
    action: "read",
    resource: {
      type: mapResourceType(operation),
      id: req.body?.variables?.wlzIndicatieID || req.body?.variables?.id || null
    },
    context: {
      service: mapService(operation),
      operation,
      source: "graphql_authz"
    }
  };
}

const app = express();
app.use(express.json());

app.get("/health", (_req, res) => {
  res.json({ ok: true, service: "graphql-demo-new" });
});

app.use("/graphql_authz", async (req, res, next) => {
  const businessContext = {
    query: req.body?.query || "",
    variables: req.body?.variables || {}
  };

  const authorizationContext = buildAuthorizationContext(req);

  console.log("Business context:", JSON.stringify(businessContext, null, 2));
  console.log("OPA URL:", OPA_URL);
  console.log("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
  console.log("OPA payload:", JSON.stringify(authorizationContext, null, 2));


  const opaResponse = await fetch(OPA_URL, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ input: authorizationContext })
  });

  const opaJson = await opaResponse.json();
  const decision = opaJson.result || {};

  console.log("OPA decision:", JSON.stringify(decision, null, 2));

  if (!decision.allowed) {
    const status = decision.http_status || 403;
    res.status(status).json({
      error: "Forbidden",
      decision
    });
    return;
  }

  req.businessContext = businessContext;
  req.authorizationContext = authorizationContext;

  next();
});

app.use(createGraphQLApp("/graphql_authz"));

app.listen(PORT, () => {
  console.log(`New GraphQL demo listening on http://localhost:${PORT}/graphql_authz`);
});
