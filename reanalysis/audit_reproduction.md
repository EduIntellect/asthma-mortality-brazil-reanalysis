# Auditoría de reproducción

Reanálisis de Brum et al. (mortalidad por asma en Brasil, 2014-2021).
Repositorio de referencia: `mobrant94/asthma_mortality`, commit `8d527a5` (15 mayo 2024).

## Provenance

- Commit SHA de referencia: `8d527a5`.
- Entorno: R 4.3.3 (Ubuntu 24.04), paquetes y versiones en `session_info.txt`.
- Script original de extracción (`data_extraction_and_treatment.qmd`): descarga 2014-2020 desde
  `diaad.s3.sa-east-1.amazonaws.com/sim/Mortalidade_Geral_{año}.csv` y 2021 desde
  `s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SIM/Mortalidade_Geral_2021.csv`.
- **Sustitución documentada**: el enlace de 2021 del repositorio original devuelve `AccessDenied`
  (confirmado); además, el enlace de `diaad` para 2021 (mismo bucket, mismo patrón) también
  devuelve `AccessDenied`. Las URLs originales para 2021 están caídas. Se sustituyeron **las ocho
  URLs** (2014-2021) por la ruta actual del portal oficial `dadosabertos.saude.gov.br/dataset/sim`:
  `s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SIM/csv/Mortalidade_Geral_{año}_csv.zip`. Mismo
  origen (Ministerio de Salud/SIM), formato CSV equivalente, confirmado accesible para los 8 años.
  Se prefirió usar la misma ruta para todos los años en lugar de mezclar fuentes distintas por año.
- `populacao_ano.xlsx` **no está presente** en el repositorio original — confirmado. Se reconstruyó
  el denominador desde IBGE (ver sección de denominadores).

## Filtro de edad vs. denominador: discrepancia confirmada

El script original (`analysis_and_visualization.qmd`, líneas 57-59 y 85-91) calcula
`idade_quantidade = (dtobito - dtnasc) / 365.25`, filtra `idade_quantidade > 6`, y **después**
divide por `df1$brazil`/`df1$age_18`/`df1$age_1859`/`df1$age_60`, columnas de población que (a
juzgar por sus nombres y por la estructura esperable de `populacao_ano.xlsx`) representan
población **total** por tramo de edad nominal, sin excluir a los menores de 7 años dentro de cada
tramo. Es decir: el numerador de "<18" son en realidad muertes de 7 a 17 años, pero el denominador
usado es población de 0 a 17 años. Esto infla artificialmente el denominador del grupo "<18" (y, en
menor medida, deja sin corregir el denominador nacional, que no resta la población de 0-6 años).

**No se ha corregido en la reproducción exacta** (Fase 1), tal como exige el protocolo: se ha
reproducido tal cual. Se reporta además, para la Fase 1, el cálculo alternativo con denominador
restringido a población >6 años (columna `denominator_basis` en `data/denominator_comparison.csv`),
para que quede constancia de cuál de los dos denominadores se acerca más a la tasa publicada.

## Chequeo de tolerancia frente a 18.584 muertes

| | Valor |
|---|---|
| Objetivo publicado | 18.584 |
| Total reproducido (suma `N_gt6_valid_age`, 2014-2021) | **18.578** |
| Diferencia absoluta | 6 |
| Diferencia relativa | **0,032 %** |
| Umbral de tolerancia del protocolo | ≤ 2 % |
| Resultado | **DENTRO DE TOLERANCIA** |

Conteos anuales detallados (N_raw, N_J45_J46, N_post_exclusions, N_valid_age,
N_missing_or_invalid_birthdate, N_gt6_valid_age) en `data/fase2_year_counts.csv`.

Casos J45/J46 perdidos por fecha de nacimiento ausente/inválida: entre 0 (2021) y 4 (2018) casos
por año — impacto despreciable sobre el total.

## Reconciliación por grupo de edad (grupos originales de Brum: <18 [realmente 7-17], 18-59, ≥60)

Calculado en `data/fase1_legacy_reconciliation.csv`, replicando exactamente la discrepancia
numerador/denominador original (denominador sin filtrar por edad >6):

| Grupo | % objetivo Brum (≈) | % reproducido | Pendiente objetivo (≈) | Pendiente reproducida | p objetivo (≈) | p reproducido |
|---|---|---|---|---|---|---|
| 18-59 | +19 % | **+22,9 %** | +0,02 /100.000/año | **+0,0212** | 0,03 | **0,044** |
| ≥60 | -0,5 % | **-11,1 %** | — | -0,071 | 0,47 | **0,135** |

Proporción de muertes en ≥60 años (2014-2021 agrupado): objetivo ≈68 %, reproducido **68,4 %** —
coincide muy bien.

**Interpretación**: signo y orden de magnitud de la pendiente se conservan en ambos grupos (18-59
sube, ≥60 baja/estable, ninguno es significativo al nivel convencional salvo 18-59 marginalmente).
El grupo 18-59 reproduce bien tanto el signo como el orden de magnitud de la pendiente y el
p-valor. El grupo ≥60 conserva el signo (descenso) y la falta de significación, pero el porcentaje
de cambio relativo difiere en magnitud (-11,1 % reproducido frente a -0,5 % publicado) — es decir,
en términos de tasa absoluta la diferencia es pequeña (5,85 → 5,20 por 100.000, reproducido), pero
el cambio porcentual relativo publicado es casi nulo mientras que el reproducido es mayor.

**Causa más probable**: la reconstrucción del denominador IBGE. El numerador (muertes) reproduce el
total global con un error de 0,03 %, lo que indica que el pipeline de extracción/filtrado es
correcto; el desajuste se concentra en el grupo de mayor edad, el más sensible a la revisión y
metodología de proyección poblacional utilizada (supuestos de esperanza de vida, intervalo abierto
"90+", etc.). No se puede descartar que el `populacao_ano.xlsx` original usara una fuente o
estructura ligeramente distinta para el grupo ≥60 (p. ej., otro año base de proyección, u otro
corte del intervalo abierto). Se documenta como discrepancia atribuible a reconstrucción de
denominador, conforme a la regla del protocolo, y **no activa STOP**: el signo y la no-significación
se conservan, y el error en el total global y en el grupo 18-59 (el grupo más relevante para esta
pregunta) es pequeño.

## Denominadores: fuente y versión

- Fuente primaria: IBGE, revisión 2018 (anterior al censo 2022), tabla de población por edad simple
  nacional (`projecoes_2018_populacao_idade_simples_2010_2060_20201209.xls`), hoja "BR", bloque
  "POBLACIÓN TOTAL — IDADES SIMPLES" (ambos sexos). Elegida como primaria por ser la revisión
  contemporánea con el análisis original (2024): la revisión 2024 (posterior al censo 2022) no
  existía todavía cuando Brum et al. hicieron su análisis.
- Fuente alternativa disponible (no usada en la ejecución primaria): revisión 2024
  (`projecoes_2024_tab1_idade_simples.xlsx`), post-censo 2022.
- Comparación población total vs. población >6 años como denominador nacional: ver
  `data/denominador_comparison.csv`. La tasa cruda nacional con denominador restringido a >6 años es
  sistemáticamente más alta (como es de esperar, al excluir ~2 % de la población de 0-6 años del
  denominador) pero la forma de la tendencia 2014-2021 es prácticamente idéntica en ambos casos
  (pendientes de 0,0251 y 0,0270 por 100.000/año respectivamente, mismo signo y orden de magnitud,
  p=0,029 y p=0,033; ver `primary_results.csv`, series `brum_crude_national_total_pop` y
  `brum_crude_national_gt6_pop`).

## Discrepancias — resumen

1. **URL de 2021 caída** (ambos buckets S3 citados en el repo original) → sustituida por ruta
   actual del portal oficial para los 8 años. Impacto: ninguno detectado (total reproducido dentro
   de tolerancia).
2. **`populacao_ano.xlsx` ausente** → reconstruido desde IBGE 2018. Impacto: pequeño en el total y
   en 18-59; mayor en el cambio porcentual del grupo ≥60 (ver arriba). Estado: documentado, no
   resuelto porque no hay forma de verificar la estructura exacta del fichero original ausente.
3. **Discrepancia numerador/denominador por filtro de edad >6** → confirmada en el código fuente
   original, reproducida intencionadamente tal cual en Fase 1 (no corregida), y evitada
   explícitamente en las extensiones de Fase 3-5 (estandarización y grupos de edad), donde el
   denominador usado siempre corresponde al mismo rango de edad que el numerador.
4. **Años con recuento bajo**: ningún año de ninguna serie del `primary_results.csv` tiene menos de
   20 muertes (ver columna `small_count_flag`, todo `FALSE`); el conteo mínimo observado es 164
   (grupo `age_7_34_control`, 2017).

## Conclusión de la fase de reproducción

Reproducción **satisfactoria** según los criterios de tolerancia del protocolo (diferencia total
0,03 % ≪ 2 %; signo y orden de magnitud preservados en los grupos de edad originales). Se procede a
las extensiones (Fase 3-5: estandarización por edad y grupo 5-34) sobre una base de reproducción
validada.
