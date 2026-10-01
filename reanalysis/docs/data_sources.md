# Fuentes de datos

## Microdatos de mortalidad SIM/DATASUS

- URL(s) usadas (sustitución, los 8 años 2014-2021):
  `https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SIM/csv/Mortalidade_Geral_{año}_csv.zip`
  (resuelto vía el portal oficial `dadosabertos.saude.gov.br/dataset/sim`, Ministério da Saúde).
- URLs originales del repositorio de referencia (ya no sirven todas):
  - 2014-2020: `https://diaad.s3.sa-east-1.amazonaws.com/sim/Mortalidade_Geral_{año}.csv` — accesible.
  - 2021: `https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SIM/Mortalidade_Geral_2021.csv` — **caída** (`AccessDenied`).
- Fecha de acceso: 2026-10-01.
- Formato: CSV, delimitador `;`, campos entre comillas, codificación latin1, comprimido en `.zip`.
- Columnas usadas: `CAUSABAS`, `DTOBITO`, `DTNASC`, `LINHAA`, `LINHAB`, `LINHAC`, `LINHAD`, `LINHAII`.
- Notas de versión: fichero servido actualmente por el portal con fecha de modificación 2025-10-21
  (ver cabecera del zip); no hay garantía de que sea bit-a-bit idéntico al fichero que usaron los
  autores originales en 2024 (posible revisión/actualización retrospectiva de la base SIM), pero es
  la fuente oficial vigente y el mismo sistema (SIM) y periodo de referência.
- Hashes de fichero: no calculados individualmente por año (ficheros de ~70-100 MB comprimidos);
  los conteos de reconciliación (Fase 1, tolerancia 0,03 %) sirven como verificación indirecta de
  integridad de contenido.

## Denominadores de población IBGE

- URL usada (primaria): `https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/projecoes_2018_populacao_idade_simples_2010_2060_20201209.xls`
- Fecha de acceso: 2026-10-01.
- Identificador de tabla/hoja: hoja `BR`, bloque "POPULAÇÃO TOTAL - IDADES SIMPLES" (ambos sexos),
  edades simples 0 a "90+", años 2010-2060 en columnas.
- Notas de versión: revisión 2018 del IBGE, **anterior** al censo de 2022. Elegida como fuente
  primaria por ser la revisión vigente y contemporánea cuando Brum et al. publicaron su análisis
  (2024); la revisión 2024 (posterior al censo 2022) no estaba disponible entonces.
- Hash de fichero: sha256 `69e4e6a7171bf1bbf02e5ee413f7d6a31114344711ef123277cad6de1595fc28`
  (ver `session_info.txt`).
- Fuente alternativa (no usada en la ejecución primaria, disponible para robustez):
  `https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2024/projecoes_2024_tab1_idade_simples.xlsx`
  (revisión 2024, posterior al censo 2022).

## Sustituciones y manejo de recursos faltantes

- **Recurso original**: `Mortalidade_Geral_2021.csv` en las dos rutas S3 citadas por el repositorio
  original (`diaad...` y `ckan.saude.gov.br/SIM/...` sin subcarpeta `csv/`).
  **Reemplazo**: `ckan.saude.gov.br/SIM/csv/Mortalidade_Geral_2021_csv.zip`, resuelto a través del
  portal oficial de datos abiertos del Ministério da Saúde.
  **Motivo**: ambas URLs originales devuelven `AccessDenied` (enlace caído), confirmado por petición
  directa antes de buscar alternativa.
  **Impacto esperable en reproducibilidad**: ninguno detectado — el total reproducido 2014-2021
  (18.578) está a 0,03 % del objetivo publicado (18.584), y 2021 es uno de los 8 años que componen
  ese total.

- **Recurso original**: `populacao_ano.xlsx` (no versionado en el repositorio original).
  **Reemplazo**: reconstrucción directa desde IBGE (revisión 2018, población por edad simple).
  **Motivo**: el fichero nunca estuvo en el repositorio público.
  **Impacto esperable en reproducibilidad**: bajo para el total nacional y el grupo 18-59; mayor
  para el porcentaje de cambio del grupo ≥60 años (ver `audit_reproduction.md`, sección de
  discrepancias, para el detalle numérico y la interpretación).
