import { createYoga, createSchema } from "graphql-yoga";
import GraphQLJSON from "graphql-type-json";

// ------------------------------------
// DATA
// ------------------------------------
const data = {
  wlzIndicaties: [
    {
      wlzindicatieID: "11111111-1111-1111-1111-111111111111",
      bsn: "999991234",
      besluitnummer: "BESLUIT-2026-0001",
      soortWlzindicatie: "ZZP",
      initieelVerantwoordelijkZorgkantoor: "5500",
      client: {
        clientID: "c1",
        bsn: "999991234",
        voornamen: "Chris",
        roepnaam: "Chris"
      }
    }
  ],
  clients: [
    {
      clientID: "c1",
      bsn: "999991234",
      bemiddeling: []
    }
  ],
  bemiddelingen: []
};

// ------------------------------------
// HELPERS
// ------------------------------------
function getEq(value) {
  if (!value || typeof value !== "object") return undefined;
  return value.eq;
}

function filterWlzIndicaties(where = {}) {
  return data.wlzIndicaties.filter((item) => {
    const id = getEq(where.wlzindicatieID);
    const uzovi = getEq(where.initieelVerantwoordelijkZorgkantoor);
    if (id && item.wlzindicatieID !== id) return false;
    if (uzovi && item.initieelVerantwoordelijkZorgkantoor !== uzovi) return false;
    return true;
  });
}

function filterClients(where = {}) {
  return data.clients;
}

function filterBemiddelingen(where = {}) {
  return data.bemiddelingen;
}

// ------------------------------------
// SCHEMA
// ------------------------------------
const typeDefs = /* GraphQL */ `
  scalar JSON

  type Query {
    wlzIndicatie(where: JSON): [WlzIndicatie!]!
    client(where: JSON): [Client!]!
    bemiddeling(where: JSON): [Bemiddeling!]!
  }

  type WlzIndicatie {
    wlzindicatieID: ID!
    bsn: String
    besluitnummer: String
    soortWlzindicatie: String
    initieelVerantwoordelijkZorgkantoor: String
    client: WlzClient
  }

  type WlzClient {
    clientID: ID!
    bsn: String
    voornamen: String
    roepnaam: String
  }

  type Client {
    clientID: ID!
    bsn: String
  }

  type Bemiddeling {
    bemiddelingID: ID!
  }
`;

const resolvers = {
  JSON: GraphQLJSON,
  Query: {
    wlzIndicatie: (_, { where }) => filterWlzIndicaties(where),
    client: (_, { where }) => filterClients(where),
    bemiddeling: (_, { where }) => filterBemiddelingen(where)
  }
};

// ------------------------------------
// FACTORY
// ------------------------------------
export function createGraphQLApp(graphqlEndpoint) {
  return createYoga({
    schema: createSchema({ typeDefs, resolvers }),
    graphqlEndpoint
  });
}
