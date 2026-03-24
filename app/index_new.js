import express from "express";
import { createYoga, createSchema } from "graphql-yoga";
import GraphQLJSON from "graphql-type-json";

const OPA_URL = process.env.OPA_URL || "http://opa:8181/v1/data/authz/result";
const PORT = Number(process.env.PORT || 4000);

const data = {
  wlzIndicaties: [
    {
      wlzindicatieID: "11111111-1111-1111-1111-111111111111",
      bsn: "999991234",
      besluitnummer: "BESLUIT-2026-0001",
      soortWlzindicatie: "ZZP",
      afgiftedatum: "2026-01-15",
      ingangsdatum: "2026-02-01",
      einddatum: null,
      meerzorg: false,
      initieelVerantwoordelijkZorgkantoor: "5500",
      vervaldatum: null,
      commentaar: "Demo indicatie",
      grondslag: [
        { grondslagID: "g1", grondslag: "Somatisch", volgorde: 1 }
      ],
      geindiceerdZorgzwaartepakket: [
        {
          geindiceerdZorgzwaartepakketID: "zzp1",
          zzpCode: "VG05",
          ingangsdatum: "2026-02-01",
          einddatum: null,
          voorkeurClient: "Thuis",
          instellingVoorkeur: "Instelling A",
          financiering: "Wlz",
          commentaar: null
        }
      ],
      beperking: [
        {
          beperkingID: "b1",
          categorie: "Mobiliteit",
          duur: "Langdurig",
          commentaar: null,
          beperkingScore: [
            { beperkingScoreID: "bs1", beperkingVraag: "Traplopen", beperkingScore: "2", commentaar: null }
          ]
        }
      ],
      stoornis: [
        {
          stoornisID: "s1",
          grondslag: "Somatisch",
          diagnoseCodelijst: "D001",
          diagnoseSubCodelijst: "D001A",
          ziektebeeldStoornis: "Voorbeeld stoornis",
          prognose: "Stabiel",
          commentaar: null
        }
      ],
      stoornisScore: [
        { stoornisScoreID: "ss1", stoornisVraag: "Cognitief", stoornisScore: "1", commentaar: null }
      ],
      wzd: [
        { wzdID: "w1", wzdVerklaring: true, ingangsdatum: "2026-02-01", einddatum: null }
      ],
      client: {
        clientID: "c1",
        bsn: "999991234",
        geheimeClient: false,
        geboorteDatum: "1973-07-25",
        geboortedatumGebruik: "JA",
        geslacht: "M",
        burgerlijkeStaat: "Gehuwd",
        geslachtsnaam: "Demo",
        voorvoegselGeslachtsnaam: null,
        partnernaam: null,
        voorvoegselPartnernaam: null,
        voornamen: "Chris",
        roepnaam: "Chris",
        voorletters: "C",
        naamGebruik: "Eigen",
        leefeenheid: "1-persoons",
        agbcodeHuisarts: "01020304",
        communicatieVorm: "Nederlands",
        taal: "nl",
        commentaar: null,
        contactGegevens: [
          {
            contactGegevensID: "cg1",
            adres: [
              {
                adresID: "a1",
                adresSoort: "Woonadres",
                straatnaam: "Demo straat",
                huisnummer: "1",
                huisnummerToevoeging: null,
                postcode: "1234AB",
                plaatsnaam: "Hilversum",
                landCode: "NL",
                aanduidingWoonadres: true,
                ingangsdatum: "2026-01-01",
                einddatum: null
              }
            ],
            email: [
              {
                emailID: "e1",
                emailadres: "client@example.test",
                ingangsdatum: "2026-01-01",
                einddatum: null
              }
            ],
            telefoon: [
              {
                telefoonID: "t1",
                telefoonnummer: "0612345678",
                landnummer: "+31",
                ingangsdatum: "2026-01-01",
                einddatum: null
              }
            ]
          }
        ],
        contactPersoon: [
          {
            contactPersoonID: "cp1",
            relatieNummer: "1",
            volgorde: 1,
            soortRelatie: "Familie",
            rol: "Mantelzorger",
            relatie: "Partner",
            voornamen: "Pat",
            roepnaam: "Pat",
            voorletters: "P",
            geslachtsnaam: "Demo",
            voorvoegselGeslachtsnaam: null,
            partnernaam: null,
            voorvoegselPartnernaam: null,
            naamGebruik: "Eigen",
            geslacht: "V",
            geboorteDatum: "1975-05-05",
            geboortedatumGebruik: "JA",
            ingangsdatum: "2026-01-01",
            einddatum: null,
            contactGegevens: [
              {
                contactGegevensID: "cpcg1",
                adres: [
                  {
                    adresID: "a2",
                    adresSoort: "Postadres",
                    straatnaam: "Partner straat",
                    huisnummer: "2",
                    huisnummerToevoeging: null,
                    postcode: "2345BC",
                    plaatsnaam: "Utrecht",
                    landCode: "NL",
                    aanduidingWoonadres: true,
                    ingangsdatum: "2026-01-01",
                    einddatum: null
                  }
                ],
                email: [
                  {
                    emailID: "e2",
                    emailadres: "partner@example.test",
                    ingangsdatum: "2026-01-01",
                    einddatum: null
                  }
                ],
                telefoon: [
                  {
                    telefoonID: "t2",
                    telefoonnummer: "0687654321",
                    landnummer: "+31",
                    ingangsdatum: "2026-01-01",
                    einddatum: null
                  }
                ]
              }
            ]
          }
        ]
      }
    }
  ],
  clients: [
    {
      clientID: "c1",
      bsn: "999991234",
      leefeenheid: "1-persoons",
      huisarts: "Dr. Demo",
      communicatievorm: "Nederlands",
      taal: "nl",
      contactpersoon: [
        {
          contactpersoonID: "cp1",
          relatienummer: "1",
          volgorde: 1,
          soortRelatie: "Familie",
          rol: "Mantelzorger",
          relatie: "Partner",
          geslachtsnaam: "Demo",
          voorvoegselGeslachtsnaam: null,
          partnernaam: null,
          voorvoegselPartnernaam: null,
          voornamen: "Pat",
          voorletters: "P",
          roepnaam: "Pat",
          naamgebruik: "Eigen",
          geslacht: "V",
          geboortedatum: "1975-05-05",
          geboortedatumgebruik: "JA",
          ingangsdatum: "2026-01-01",
          einddatum: null,
          contactgegevens: [
            {
              contactpersoonContactgegevensID: "ccg1",
              adresSoort: "Postadres",
              straatnaam: "Partner straat",
              huisnummer: "2",
              huisletter: null,
              huisnummerToevoeging: null,
              postcode: "2345BC",
              plaatsnaam: "Utrecht",
              land: "NL",
              aanduidingWoonadres: true,
              emailadres: "partner@example.test",
              telefoonnummer01: "0687654321",
              landnummer01: "+31",
              telefoonnummer02: null,
              landnummer02: null,
              ingangsdatum: "2026-01-01",
              einddatum: null
            }
          ]
        }
      ],
      contactgegevens: [
        {
          clientContactgegevensID: "clcg1",
          adresSoort: "Woonadres",
          straatnaam: "Demo straat",
          huisnummer: "1",
          huisletter: null,
          huisnummerToevoeging: null,
          postcode: "1234AB",
          plaatsnaam: "Hilversum",
          land: "NL",
          aanduidingWoonadres: true,
          emailadres: "client@example.test",
          telefoonnummer01: "0612345678",
          landnummer01: "+31",
          telefoonnummer02: null,
          landnummer02: null,
          ingangsdatum: "2026-01-01",
          einddatum: null
        }
      ],
      bemiddeling: []
    }
  ],
  bemiddelingen: [
    {
      bemiddelingID: "bm1",
      wlzIndicatieID: "11111111-1111-1111-1111-111111111111",
      verantwoordelijkZorgkantoor: "5500",
      verantwoordelijkheidIngangsdatum: "2026-02-01",
      verantwoordelijkheidEinddatum: null,
      bemiddelingspecificatie: [
        {
          bemiddelingspecificatieID: "bms1",
          leveringsvorm: "ZIN",
          zzpCode: "VG05",
          toewijzingIngangsdatum: "2026-02-01",
          toewijzingEinddatum: null,
          instelling: "12345678",
          uitvoerendZorgkantoor: "5500",
          vaststellingMoment: "2026-02-01T10:00:00Z",
          percentage: 100,
          opname: true,
          redenIntrekking: null,
          etmalen: 7,
          instellingBestemming: "Instelling A",
          soortToewijzing: "Initieel"
        }
      ],
      client: null,
      overdracht: [
        {
          overdrachtID: "od1",
          verantwoordelijkZorgkantoor: "5500",
          overdrachtDatum: "2026-03-01",
          verhuisDatum: "2026-03-15",
          vaststellingMoment: "2026-03-01T09:00:00Z",
          overdrachtspecificatie: [
            {
              overdrachtspecificatieID: "ods1",
              leveringsstatus: "Gepland",
              leveringsstatusClassificatie: "Actief",
              oorspronkelijkeToewijzingEinddatum: "2026-03-31"
            }
          ]
        }
      ]
    }
  ]
};

data.bemiddelingen[0].client = data.clients[0];
data.clients[0].bemiddeling = [data.bemiddelingen[0]];

function getEq(value) {
  if (!value || typeof value !== "object") return undefined;
  return value.eq;
}

function matchesBemiddelingSome(bemiddelingen, someFilter = {}) {
  return bemiddelingen.some((b) => {
    if (someFilter.verantwoordelijkZorgkantoor?.eq && b.verantwoordelijkZorgkantoor !== someFilter.verantwoordelijkZorgkantoor.eq) {
      return false;
    }
    return true;
  });
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
  return data.clients.filter((item) => {
    const some = where?.bemiddeling?.some;
    if (some) return matchesBemiddelingSome(item.bemiddeling || [], some);
    return true;
  });
}

function filterBemiddelingen(where = {}) {
  return data.bemiddelingen.filter((item) => {
    if (getEq(where.wlzIndicatieID) && item.wlzIndicatieID !== where.wlzIndicatieID.eq) return false;
    if (getEq(where.verantwoordelijkZorgkantoor) && item.verantwoordelijkZorgkantoor !== where.verantwoordelijkZorgkantoor.eq) return false;
    const nestedSome = where?.bemiddeling?.some;
    if (nestedSome?.verantwoordelijkZorgkantoor?.eq && item.verantwoordelijkZorgkantoor !== nestedSome.verantwoordelijkZorgkantoor.eq) return false;
    return true;
  });
}

const typeDefs = /* GraphQL */ `
  scalar JSON

  type Query {
    wlzIndicatie(where: JSON): [WlzIndicatie!]!
    client(where: JSON): [Client!]!
    bemiddeling(where: JSON): [Bemiddeling!]!
    overdracht(where: JSON): [Overdracht!]!
  }

  type WlzIndicatie {
    wlzindicatieID: ID!
    bsn: String
    besluitnummer: String
    soortWlzindicatie: String
    afgiftedatum: String
    ingangsdatum: String
    einddatum: String
    meerzorg: Boolean
    initieelVerantwoordelijkZorgkantoor: String
    vervaldatum: String
    commentaar: String
    grondslag: [Grondslag!]!
    geindiceerdZorgzwaartepakket: [GeindiceerdZorgzwaartepakket!]!
    beperking: [Beperking!]!
    stoornis: [Stoornis!]!
    stoornisScore: [StoornisScore!]!
    wzd: [Wzd!]!
    client: WlzClient
  }

  type Grondslag { grondslagID: ID!, grondslag: String, volgorde: Int }
  type GeindiceerdZorgzwaartepakket {
    geindiceerdZorgzwaartepakketID: ID!
    zzpCode: String
    ingangsdatum: String
    einddatum: String
    voorkeurClient: String
    instellingVoorkeur: String
    financiering: String
    commentaar: String
  }
  type Beperking {
    beperkingID: ID!
    categorie: String
    duur: String
    commentaar: String
    beperkingScore: [BeperkingScore!]!
  }
  type BeperkingScore { beperkingScoreID: ID!, beperkingVraag: String, beperkingScore: String, commentaar: String }
  type Stoornis {
    stoornisID: ID!
    grondslag: String
    diagnoseCodelijst: String
    diagnoseSubCodelijst: String
    ziektebeeldStoornis: String
    prognose: String
    commentaar: String
  }
  type StoornisScore { stoornisScoreID: ID!, stoornisVraag: String, stoornisScore: String, commentaar: String }
  type Wzd { wzdID: ID!, wzdVerklaring: Boolean, ingangsdatum: String, einddatum: String }

  type WlzClient {
    clientID: ID!
    bsn: String
    geheimeClient: Boolean
    geboorteDatum: String
    geboortedatumGebruik: String
    geslacht: String
    burgerlijkeStaat: String
    geslachtsnaam: String
    voorvoegselGeslachtsnaam: String
    partnernaam: String
    voorvoegselPartnernaam: String
    voornamen: String
    roepnaam: String
    voorletters: String
    naamGebruik: String
    leefeenheid: String
    agbcodeHuisarts: String
    communicatieVorm: String
    taal: String
    commentaar: String
    contactGegevens: [WlzContactGegevens!]!
    contactPersoon: [WlzContactPersoon!]!
  }

  type WlzContactGegevens {
    contactGegevensID: ID!
    adres: [WlzAdres!]!
    email: [WlzEmail!]!
    telefoon: [WlzTelefoon!]!
  }
  type WlzAdres {
    adresID: ID!
    adresSoort: String
    straatnaam: String
    huisnummer: String
    huisnummerToevoeging: String
    postcode: String
    plaatsnaam: String
    landCode: String
    aanduidingWoonadres: Boolean
    ingangsdatum: String
    einddatum: String
  }
  type WlzEmail { emailID: ID!, emailadres: String, ingangsdatum: String, einddatum: String }
  type WlzTelefoon { telefoonID: ID!, telefoonnummer: String, landnummer: String, ingangsdatum: String, einddatum: String }

  type WlzContactPersoon {
    contactPersoonID: ID!
    relatieNummer: String
    volgorde: Int
    soortRelatie: String
    rol: String
    relatie: String
    voornamen: String
    roepnaam: String
    voorletters: String
    geslachtsnaam: String
    voorvoegselGeslachtsnaam: String
    partnernaam: String
    voorvoegselPartnernaam: String
    naamGebruik: String
    geslacht: String
    geboorteDatum: String
    geboortedatumGebruik: String
    ingangsdatum: String
    einddatum: String
    contactGegevens: [WlzContactGegevens!]!
  }

  type Client {
    clientID: ID!
    bsn: String
    leefeenheid: String
    huisarts: String
    communicatievorm: String
    taal: String
    contactpersoon: [Contactpersoon!]!
    contactgegevens: [ClientContactgegevens!]!
    bemiddeling: [Bemiddeling!]!
  }

  type Contactpersoon {
    contactpersoonID: ID!
    relatienummer: String
    volgorde: Int
    soortRelatie: String
    rol: String
    relatie: String
    geslachtsnaam: String
    voorvoegselGeslachtsnaam: String
    partnernaam: String
    voorvoegselPartnernaam: String
    voornamen: String
    voorletters: String
    roepnaam: String
    naamgebruik: String
    geslacht: String
    geboortedatum: String
    geboortedatumgebruik: String
    ingangsdatum: String
    einddatum: String
    contactgegevens: [ContactpersoonContactgegevens!]!
  }

  type ContactpersoonContactgegevens {
    contactpersoonContactgegevensID: ID!
    adresSoort: String
    straatnaam: String
    huisnummer: String
    huisletter: String
    huisnummerToevoeging: String
    postcode: String
    plaatsnaam: String
    land: String
    aanduidingWoonadres: Boolean
    emailadres: String
    telefoonnummer01: String
    landnummer01: String
    telefoonnummer02: String
    landnummer02: String
    ingangsdatum: String
    einddatum: String
  }

  type ClientContactgegevens {
    clientContactgegevensID: ID!
    adresSoort: String
    straatnaam: String
    huisnummer: String
    huisletter: String
    huisnummerToevoeging: String
    postcode: String
    plaatsnaam: String
    land: String
    aanduidingWoonadres: Boolean
    emailadres: String
    telefoonnummer01: String
    landnummer01: String
    telefoonnummer02: String
    landnummer02: String
    ingangsdatum: String
    einddatum: String
  }

  type Bemiddeling {
    bemiddelingID: ID!
    wlzIndicatieID: ID!
    verantwoordelijkZorgkantoor: String
    verantwoordelijkheidIngangsdatum: String
    verantwoordelijkheidEinddatum: String
    bemiddelingspecificatie: [Bemiddelingspecificatie!]!
    client: Client
    overdracht: [Overdracht!]!
  }

  type Bemiddelingspecificatie {
    bemiddelingspecificatieID: ID!
    leveringsvorm: String
    zzpCode: String
    toewijzingIngangsdatum: String
    toewijzingEinddatum: String
    instelling: String
    uitvoerendZorgkantoor: String
    vaststellingMoment: String
    percentage: Int
    opname: Boolean
    redenIntrekking: String
    etmalen: Int
    instellingBestemming: String
    soortToewijzing: String
  }

  type Overdracht {
    overdrachtID: ID!
    verantwoordelijkZorgkantoor: String
    overdrachtDatum: String
    verhuisDatum: String
    vaststellingMoment: String
    overdrachtspecificatie: [Overdrachtspecificatie!]!
  }

  type Overdrachtspecificatie {
    overdrachtspecificatieID: ID!
    leveringsstatus: String
    leveringsstatusClassificatie: String
    oorspronkelijkeToewijzingEinddatum: String
  }
`;

const resolvers = {
  JSON: GraphQLJSON,
  Query: {
    wlzIndicatie: (_, { where }) => filterWlzIndicaties(where),
    client: (_, { where }) => filterClients(where),
    bemiddeling: (_, { where }) => filterBemiddelingen(where),
    overdracht: (_, { where }) => filterBemiddelingen(where).flatMap((b) => b.overdracht || [])
  }
};

const yoga = createYoga({
  schema: createSchema({ typeDefs, resolvers }),
  graphqlEndpoint: "/graphql"
});

const app = express();
app.use(express.json());

app.get("/health", (_req, res) => {
  res.json({ ok: true, service: "graphql-demo" });
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

app.use(yoga);

app.listen(PORT, () => {
  console.log(`GraphQL demo listening on http://localhost:${PORT}/graphql`);
});
