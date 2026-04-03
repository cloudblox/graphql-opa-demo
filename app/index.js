import express from "express";
import { createGraphQLApp } from "./shared.js";

const OPA_URL = process.env.OPA_URL || "http://opa:8181/v1/data/authz/result";
const PORT = Number(process.env.PORT || 4000);

const app = express();
app.use(express.json());

app.get("/health", (_req, res) => {
  res.json({ ok: true, service: "graphql-demo-old" });
});

app.use("/graphql", async (req, res, next) => {
  const authzHeader = req.headers.authorization || "";
  const payload = {
    input: {
      parsed_body: {
        query: req.body?.query || "",
        variables: req.body?.variables || {}
      },
      attributes: {
        request: {
          http: {
            headers: {
              authorization: authzHeader
            }
          }
        }
      }
    }
  };

  console.log("OPA URL:", OPA_URL);
  console.log("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
  console.log("OPA payload:", JSON.stringify(payload, null, 2));

  const opaResponse = await fetch(OPA_URL, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(payload)
  });

  const opaJson = await opaResponse.json();
  const decision = opaJson.result || {};

  if (!decision.allowed) {
    const status = decision.http_status || 403;
    const contentType = decision.headers?.["content-type"] || "application/json";
    res.status(status).type(contentType);
    if (decision.body) {
      res.send(decision.body);
      return;
    }
    res.send(JSON.stringify({ errors: [{ message: "Forbidden" }] }));
    return;
  }

  next();
});

app.use(createGraphQLApp("/graphql"));

app.listen(PORT, () => {
  console.log(`Old GraphQL demo listening on http://localhost:${PORT}/graphql`);
});
