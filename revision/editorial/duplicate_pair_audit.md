# Audit of the ambiguous 2018 pair

Verified full-field candidates correspond to data rows 971828 and 971831 (header excluded) in Mortalidade_Geral_2018.csv. The historical pipeline reads eight raw columns and computes its key from parsed death date, days/365.25 age, underlying cause and five cause lines. That key is identical for this pair. Full public records differ in eight fields:

| Field | Interpretation/evidence | Effect on identity determination |
| --- | --- | --- |
| OCUP | Occupation differs | Full records are not identical |
| NUMEROLOTE | Administrative lot differs | Lot cannot establish a unique death event |
| TPPOS | Investigation status differs (official dictionary) | Updates/status do not prove event identity |
| DTCADASTRO | Registration date differs (official dictionary) | Administrative update |
| DTRECEBIM | Central receipt/last-update date differs (official dictionary) | Administrative update |
| DTRECORIGA | Administrative original-receipt field differs | No reliable death-declaration key |
| DIFDATA | Administrative interval differs | No reliable death-declaration key |
| CONTADOR | Record counter differs | Distinct record counters alone neither prove two events nor one event |

The official SIM structure document archived by UFBA describes NUMERODO as the declaration-of-death number, sequential within reporting state and year. NUMERODO is absent in these CSVs. The archived dictionary does not define all later administrative fields; no unsupported meaning or linkage capability is attributed to them. The live ministry dictionary URL returned 404; the preserved official document hosted by UFBA was retrieved and fixed by hash.

**Principal decision:** retain both records because there is insufficient verifiable evidence that they represent the same death. This does not assert two distinct people. **Sensitivity:** collapse according to the historical key, removing source row 971831. It reduces ≥7 and ≥60 by one in 2018; it does not change the young domains. Every sensitivity changes one condition from the principal.

Source: https://ccvisat.ufba.br/wp-content/uploads/2019/10/Estrutura-do-SIM-para-o-CD-ROM.pdf . Consulted 11 October 2026. Document SHA-256: a2e5c28a1fb71a873a0f8db2e594468de4ce4431afd9d06f98e4d56c92311ebb.
