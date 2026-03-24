# Links

* iStandaarden - [Informatiemodel iWlz bemiddelingsregister 1 (in ontwikkeling)](https://informatiemodel.istandaarden.nl/informatiemodel/iwlz/netwerk/bemiddelingsregister-1/)

  

* iStandaarden - [Autorisatieregels - Indicatieregister (IRA)](https://informatiemodel.istandaarden.nl/informatiemodel/iwlz/netwerk/indicatieregister-2/regels/autorisatieregel/)

  

* iStandaarden - [Autorisatieregels - Bemiddelingsregister (BRA)](https://informatiemodel.istandaarden.nl/informatiemodel/iwlz/netwerk/bemiddelingsregister-1/regels/autorisatieregel/)

  

* nID - [Backlog items](https://dev.azure.com/vecozo/Platform/_backlogs/backlog/N-ID%20Team/Backlog%20items?System.Tags=%23Refinement)

  

* Bemiddelingsregister query Graphql schema- [Graphql schema](https://github.com/iStandaarden/iWlz-bemiddeling/tree/main/gql-specificatie)

  

* Indicatieregister query Graphql schema- [Graphql schema](

https://github.com/iStandaarden/iWlz-indicatie/tree/Indicatierpolegister-2/gql-specificatie)

  

* Uitwerking Indicatieregister policy - [Graphql query](https://github.com/iStandaarden/iWlz-indicatie/tree/Indicatieregister-2/gql-query)

  

* Uitwerking Bemiddelingsregister policy - [Graphql query](https://github.com/iStandaarden/iWlz-bemiddeling/tree/Bemiddelingsregister-1/gql-query)

  

#Status legenda

* ❔ Analyse: specificaties dienen onderzocht te worden

* 🚫 on hold: Policy is (voorlopig) niet benodigd en wordt niet verder ontwikkeld

* 👷 ToDo: Aanvraag is geaccepteerd en dient opgepakt te worden door team nID.

* 🏗️ InProgress: team nID heeft de werkzaamheden voor de policy opgepakt

* 💎 ToVerify: werkzaamheden zijn uitgevoerd en de resultaten dienen met team Zilver geaccepteerd te worden

* ✅ Done: Policy is geaccepteerd en afgerond

  

# Policies Raadplegen

| Code | Status | Trigger | Actie | Entiteit | Register | Actor | Autorisatie regel | Externe referentie | PBI | Impliciete criteria | PR Criteria 1 | Criteria 2 | Criteria 3 | Criteria 4 | Criteria 5 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| POL100 | ✅ Done | RolToewijzing / beeindiging | Raadplegen | Bemiddeling > Regiehouder + Client | BemReg | Regiehouder | BRA0012 | [QBR-0009](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgaanbieder/QBR-0009-ZAr.graphql) | [#596670](https://dev.azure.com/vecozo/Platform/_sprints/taskboard/N-ID%20Team/Platform/Platform%20Teams/2025-14?workitem=596670) | Sub entiteiten van de bemiddeling en sub entiteiten van de client mag je niet ophalen zonder datumfilter - zie QBR-0002 | Raadplegen specifieke bemiddeling obv RegiehouderID| Actor komt voor als regierhouder onder de bemiddeling |  |  |  |
| POL101 | 🚫 on hold | Gewijzigde Zorgsamenstelling | Raadplegen | volledige Bemiddeling > volledige Client | BemReg | Regiehouder | BRA0012 | X | X |  | Raadplegen specifieke bemiddeling obv BemRegID | Actor komt voor als regierhouder onder de bemiddeling | Alleen entiteiten met overlap op periode van de eigen regiehouder |  |  |
| POL102 | ✅ Done | Zorgtoewijzing / aanpassing | Raadplegen | Eigen BemSpec > Bemiddeling > Client | BemReg | Zorgaanbieder | BRA0001 | [QBR-0001](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgaanbieder/QBR-0001-ZA.graphql) | [#598153](https://dev.azure.com/vecozo/Platform/_sprints/taskboard/N-ID%20Team/Platform/Platform%20Teams/2025-14?workitem=598153)| Sub entiteiten van de bemiddeling en sub entiteiten van de client mag je niet ophalen zonder datumfilter - zie QBR-0002 |  Raadplegen specifieke BemSpec obv BemSpecID | Actor is de instelling van de BemSpec |  |  |  |
| POL103 | ✅ Done | Zorgtoewijzing / aanpassing | Raadplegen | volledige Bemiddeling > volledige Client | BemReg | Zorgaanbieder | BRA0001 + BRA0002 + BRA0004 + BRA0005 | [QBR-0002](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgaanbieder/QBR-0002-ZA.graphql) + [QBR-0003](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgaanbieder/QBR-0003-ZA.graphql) | [#598157](https://dev.azure.com/vecozo/Platform/_sprints/taskboard/N-ID%20Team/Platform/Platform%20Teams/2025-14?workitem=598157) | | Raadplegen specifieke BemSpec obv BemSpecID | Actor is de instelling van de BemSpec | Client entiteiten moeten in periode overlappen met de BemSpec, toegang geldt tot 2 jaar na einddatum BemSpec | Regiehouder + Andere BemSpecs binnen de Bemiddeling moeten in periode overlappen, toegang geldt tot 31 mei van opvolgend jaar | Bij leveringsvorm pgb mag percentage niet bevraagd worden |
| **POL104 | ✅ Done | Zorgtoewijzing / aanpassing | Raadplegen | Volledige indicatie | IndicatieReg | Zorgaanbieder | IRA0003 | [QIR-0002](https://github.com/iStandaarden/iWlz-indicatie/blob/Indicatieregister-2/gql-query/zorgaanbieder/QIR-0002-ZA.graphql) | [#598158](https://dev.azure.com/vecozo/Platform/_sprints/taskboard/N-ID%20Team/Platform/Platform%20Teams/2025-14?workitem=598158) | |  Raadplegen specifieke Indicatie obv IndicatieID | Actor komt voor in een Bemiddeling van de Indicatie |  |  |  |
| POL105 | ✅ Done | Zorgtoewijzing / aanpassing | Raadplegen | Eigen BemSpec > Bemiddeling > Client | BemReg | Uitvoerend zorgkantoor | BRA0006 | [QBR-0004](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgkantoor/QBR-0004-ZKu.graphql) | [nID: 598201](https://dev.azure.com/vecozo/Platform/_sprints/taskboard/N-ID%20Team/Platform/Platform%20Teams/2025-17?workitem=598201) | Sub entiteiten van de bemiddeling en sub entiteiten van de client mag je niet ophalen zonder datumfilter - zie QBR-0004 | Raadplegen specifieke BemSpec obv BemSpecID | Actor is het uitvoerend Zorgkantoor van de BemSpec |  |  |  |
| POL106 | ✅ Done | Zorgtoewijzing / aanpassing | Raadplegen | volledige Bemiddeling + volledige Client | BemReg | Uitvoerend zorgkantoor | BRA0006 + BRA0007 + BRA0008 + BRA0009 | [QBR-0005](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgkantoor/QBR-0005-ZKu.graphql)  + [QBR-0006](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgkantoor/QBR-0006-ZKu.graphql) | [nID: 598202](https://dev.azure.com/vecozo/Platform/_sprints/taskboard/N-ID%20Team/Platform/Platform%20Teams/2025-17?workitem=598202) | | Raadplegen specifieke BemSpec obv BemSpecID | Actor is het uitvoerend Zorgkantoor van de BemSpec | Client entiteiten moeten in periode overlappen met de BemSpec, toegang geldt tot 2 jaar na einddatum BemSpe | Regiehouder + Andere BemSpecs binnen de Bemiddeling moeten in periode overlappen, toegang geldt tot 31 mei van opvolgend jaar | Bij leveringsvorm pgb mag percentage niet bevraagd worden |
| **POL107 | ✅ Done | Zorgtoewijzing / aanpassing | Raadplegen | Volledige indicatie | IndicatieReg | Uitvoerend zorgkantoor | IRA0002 | [QIR-0004](https://github.com/iStandaarden/iWlz-indicatie/blob/Indicatieregister-2/gql-query/zorgkantoor/QIR-0004-ZKu.graphql) | X | | Raadplegen specifieke Indicatie obv IndicatieID | Actor komt voor in een Bemiddeling van de Indicatie |  |  |  |
| POL108 | ✅ Done | Indicatietoewijzing | Raadplegen | Volledige indicatie | IndicatieReg | Initieel Verantwoordelijk Zorgkantoor | IRA0001(A) | [QIR-0001](https://github.com/iStandaarden/iWlz-indicatie/blob/Indicatieregister-2/gql-query/zorgkantoor/QIR-0001-ZKi.graphql) | X | | Raadplegen specifieke Indicatie obv IndicatieID | Actor is het initieel Verantwoordelijk Zorgkantoor |  |  |  |
| POL109 | ✅ Done | Ontvangen overdracht | Raadplegen | Overdracht > Bemiddeling > Client | BemReg | verantwoordelijk Zorgkantoor | BRA0010 | [QBR-0007](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgkantoor/QBR-0007-ZKn.graphql) | [#600700](https://dev.azure.com/vecozo/Platform/_backlogs/backlog/N-ID%20Team/Backlog%20items?workitem=600700) | Overige entiteiten mogen zonder overdachtdatum niet geraadpleegd worden | Raadplegen specifieke Overdracht obv OverdrachtID | Actor is het verantwoordelijk Zorgkantoor |  |  |  |
| POL110 | ✅ Done | Inzien eigengegevens | Raadplegen | Volledige Client > Volledige Bemiddeling | BemReg | verantwoordelijk Zorgkantoor | X | X | X | | Alleen clienten waarvoor de actor het verantwoordelijk Zorgkantoor is |  |  |  |  |
| POL111 | ✅ Done | Inzien eigengegevens | Raadplegen | volledige Bemiddeling > volledige Client | BemReg | verantwoordelijk Zorgkantoor | X | X | X | | Alleen bemiddelingen waarvoor de actor het verantwoordelijk Zorgkantoor is |  |  |  |  |
| POL112 | 🚫 on hold | Vervallen Indicatie | Raadplegen | Aleen verantwoordelijk zorgkantoren van de bemiddeling | BemReg | CIZ | BRA0011 | [QBR-0010](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/ciz/QBR-0010-CIZ.graphql) | X | | Alleen specifieke bemiddelingen obv indicatieID |  |  |  |  |
| **POL113 | ✅ Done | Ontvangen overdracht | Raadplegen | Volledige indicatie | IndicatieReg | verantwoordelijk Zorgkantoor | IRA0001(B) | [QIR-0003](https://github.com/iStandaarden/iWlz-indicatie/blob/Indicatieregister-2/gql-query/zorgkantoor/QIR-0003-ZKn.graphql) | X | | Raadplegen specifieke Indicatie obv IndicatieID | Actor komt voor in een Bemiddeling van de Indicatie |  |  |  |
| POL114 | ✅ Done | Ontvangen overdracht | Raadplegen | Overdracht > volledige Bemiddeling > volledige Client | BemReg | verantwoordelijk Zorgkantoor | BRA0010 | [QBR-0008](https://github.com/iStandaarden/iWlz-bemiddeling/blob/Bemiddelingsregister-1/gql-query/zorgkantoor/QBR-0008-ZKn.graphql) | [#608215](https://dev.azure.com/vecozo/Platform/_backlogs/backlog/N-ID%20Team/Backlog%20items?workitem=608215) | | Raadplegen specifieke Overdracht obv OverdrachtID | Actor is het verantwoordelijk Zorgkantoor | Alleen entiteiten die actief zijn met de overdrachtsdatum |  |  |

  

** Nu vanuit VECOZO, daarna bepalen of dat een impersonatie moet worden!

  

# Policies Notificaties

| Code | Status | Trigger | Actie | Entiteit | Register | Actor | Autorisatie regel | Externe referentie | PBI | Impliciete criteria | PR Criteria 1 | Criteria 2 | Criteria 3 | Criteria 4 | Criteria 5 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| POL206 | ✅ Done | Wijziging in het BemReg | Muteren | Notificatie | Generiek | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is afzender van de notificatie | Actor is een zorgkantoor | Ontvangen is een **zorgkantoor** | Eventtype is een van de volgende types:  <br>GEWIJZIGDE_BEMIDDELING SPECIFICATIE_ZORGKANTOOR  <br>GEWIJZIGDE_OVERDRACHT_ZORGKANTOOR  <br>NIEUWE_BEMIDDELINGSPECIFICATIE _ZORGKANTOOR  <br>NIEUWE_OVERDRACHT_ZORGKANTOOR  <br>VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR  <br>VERWIJDERDE_OVERDRACHT_ZORGKANTOOR <br>INFORMATIEVE_BEMIDDELINGSPECIFICATIE_ZORGKANTOOR |  |
| POL207 | ✅ Done | Wijziging in het BemReg | Muteren | Notificatie | Generiek | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is afzender van de notificatie | Actor is een zorgkantoor | Ontvangen is een **zorgaanbieder** | Eventtype is een van de volgende types:  <br>GEWIJZIGDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER  <br>GEWIJZIGDE_REGIEHOUDER_ZORGAANBIEDER  <br>NIEUWE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER  <br>NIEUWE_REGIEHOUDER_ZORGAANBIEDER  <br>VERWIJDERDE_BEMIDDELINGSPECIFICATIE_ZORGAANBIEDER  <br>VERWIJDERDE_REGIEHOUDER_ZORGAANBIEDER |  |
| POL 214 | ✅ Done | Een wijziging van de client in de database van een zorgkantoor | Muteren | Notificatie | BemReg | Verantwoordelijk zorgkantoor | X | X | X | X | Actor is een zorgkantoor dat valt onder Menzis of Zorgmatch. Zie onderstaande tabel | Ontvanger is VECOZO | Eventtype is de volgende type: <br>MUTATIE_CLIENT

  
  

| Omgeving | Menzis | Zorgmatch |  |
|--|--|--|--|
| DEV, OTI, TST, ACC | 5000, 5501, 5505, 5507 | 9997, 5503, 5504, 5510, 5513, 5514, 5521, 5506, 5509, 5511, 5515, 5533, 5518, 5523, 5525, 5526, 5529, 5531, 5508, 5512, 5520, 5524, 5527, 5528, 5530, 5516, 5517 |  |
| PRD  | 5501, 5505, 5507 | 5503, 5504, 5510, 5513, 5514, 5521, 5506, 5509, 5511, 5515, 5533, 5518, 5523, 5525, 5526, 5529, 5531, 5508, 5512, 5520, 5524, 5527, 5528, 5530, 5516, 5517 |  |
|  |  |  |  |

  
  

POL214 aanvulling:

Op DEV, OTI, TST, ACC omgeving zijn dit de uzovi's: 5503, 5504, 5510, 5513, 5514, 5521, 5506, 5509, 5511, 5515, 5533, 5518, 5523, 5525, 5526, 5529, 5531, 5508, 5512, 5520, 5524, 5527, 5528, 5530, 5516, 5517, 5501, 5505, 5507, 9997 en 5000.

  

Op PROD: 5503, 5504, 5510, 5513, 5514, 5521, 5506, 5509, 5511, 5515, 5533, 5518, 5523, 5525, 5526, 5529, 5531, 5508, 5512, 5520, 5524, 5527, 5528, 5530, 5516, 5517, 5501, 5505, 5507

  

# Policies Meldingen

| Code | Status | Trigger | Actie | Entiteit | Register | Actor | Autorisatie regel | Externe referentie | PBI | Impliciete criteria | PR Criteria 1 | Criteria 2 | Criteria 3 | Criteria 4 | Criteria 5 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| POL208 | ✅ Done | Fout in het register | Muteren | Melding | Generiek | Zorgkantoor | X | X | X | ? | Actor is afzender van de notificatie | Actor is een **zorgkantoor** | Ontvangen is een zorgkantoor | Eventtype is iWLZFOUTMELDING |  |
| POL209 | ✅ Done | Fout in het register | Muteren | Melding | Generiek | Zorgaanbieder | X | X | X | ? | Actor is afzender van de notificatie | Actor is een **zorgaanbieder** | Ontvangen is een zorgkantoor | Eventtype is iWLZFOUTMELDING |  |
| POL213 | ✅ Done | Fout in het register | Muteren | Melding | Generiek | Ondernemer (KVK) | X | X | X | ? | Actor is afzender van de notificatie | Actor is **VECOZO**| Ontvanger is een zorgkantoor | Eventtype is iWLZFOUTMELDING |  |
| POL216 | ✅ Done | Fout in het register | Muteren | Melding | Generiek | Zorgkantoor | X | X | X | ? | Actor is **ontvanger** van de notificatie | Actor is **Zorgkantoor** | Afzender is zorgaanbieder van zorgkantoor | Eventtype is IWLZFOUTMELDING| **Subject** is Silvester |

  

# Policies Mutaties (ON HOLD)

| Code | Status | Trigger | Actie | Entiteit | Register | Actor | Autorisatie regel | Externe referentie | PBI | Impliciete criteria | PR Criteria 1 | Criteria 2 | Criteria 3 | Criteria 4 | Criteria 5 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| POL200 | 🚫 on hold | Wijziging clientgegevens | Muteren | Client | BemReg | verantwoordelijk Zorgkantoor | X | X | [#596866](https://dev.azure.com/vecozo/Platform/_sprints/taskboard/N-ID%20Team/Platform/Platform%20Teams/2025-11?workitem=596866) | ? | Actor is verantwoordelijk Zorgkantoor voor de client | De opgegeven sub entiteiten vallen onder de bovenliggende entiteit |  |  |  |
| POL201 | 🚫 on hold | Wijziging bemiddelingsgegevens | Muteren | Bemiddeling | BemReg | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is verantwoordelijk Zorgkantoor voor de bemiddeling | De opgegeven sub entiteiten vallen onder de bovenliggende entiteit |  |  |  |
| POL202 | 🚫 on hold | Toevoegen client | Muteren | Client | BemReg | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is opgegeven verantwoordelijk Zorgkantoor voor de client |  |  |  |  |
| POL203 | 🚫 on hold | Toevoegen bemiddeling | Muteren | Bemiddeling | BemReg | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is opgegeven verantwoordelijk Zorgkantoor voor de bemiddeling | Actor is verantwoordelijk Zorgkantoor van opgegeven Client |  |  |  |
| POL204 | 🚫 on hold | Verwijderen client | Muteren | Client | BemReg | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is verantwoordelijk Zorgkantoor voor de client |  |  |  |  |
| POL205 | 🚫 on hold | Verwijderen bemiddeling | Muteren | Bemiddeling | BemReg | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is verantwoordelijk Zorgkantoor voor de bemiddeling |  |  |  |  |
| POL211 | 🚫 on hold | Toevoegen overdracht | Muteren | Bemiddeling | BemReg | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is verantwoordelijk Zorgkantoor voor de bemiddeling | De opgegeven sub entiteiten vallen onder de bovenliggende entiteit |  |  |  |
| POL212 | 🚫 on hold | Wijzigngen overdracht | Muteren | Bemiddeling | BemReg | verantwoordelijk Zorgkantoor | X | X | X | ? | Actor is verantwoordelijk Zorgkantoor voor de bemiddeling | De opgegeven sub entiteiten vallen onder de bovenliggende entiteit |  |  |  |