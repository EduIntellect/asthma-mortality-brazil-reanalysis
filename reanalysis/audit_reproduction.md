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
| Total reproducido (suma `N_gt6_valid_age`, 2014-2021) | **18.583** |
| Diferencia absoluta | 1 |
| Diferencia relativa | **0,0054 %** |
| Umbral de tolerancia del protocolo | ≤ 2 % |
| Resultado | **DENTRO DE TOLERANCIA** |

(Cifra tras la corrección de deduplicación descrita más abajo; la primera ejecución daba 18.578.)

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

Proporción de muertes en ≥60 años (2014-2021 agrupado): objetivo ≈68 %, reproducido **68,2 %** —
coincide muy bien. (Calculada como muertes ≥60 años / total con filtro continuo `idade_quantidade
> 6`, el mismo denominador validado arriba; una primera versión de `check_fase1_reconciliation.R`
usaba por error el mismo esquema de edad entera corregido en la sección siguiente, dando 68,4 %.)

**Interpretación**: signo y orden de magnitud de la pendiente se conservan en ambos grupos (18-59
sube, ≥60 baja/estable, ninguno es significativo al nivel convencional salvo 18-59 marginalmente).
El grupo 18-59 reproduce bien tanto el signo como el orden de magnitud de la pendiente y el
p-valor. El grupo ≥60 conserva el signo (descenso) y la falta de significación, pero el porcentaje
de cambio relativo difiere en magnitud (-11,1 % reproducido frente a -0,5 % publicado) — es decir,
en términos de tasa absoluta la diferencia es pequeña (5,85 → 5,20 por 100.000, reproducido), pero
el cambio porcentual relativo publicado es casi nulo mientras que el reproducido es mayor.

**Causa inicialmente atribuida (revisada en la "Cuarta corrección", más abajo: en gran parte era
una diferencia de métrica, no de denominador)**: la reconstrucción del denominador IBGE. El numerador (muertes) reproduce el
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
  `data/denominator_comparison.csv`. La tasa cruda nacional con denominador restringido a >6 años es
  sistemáticamente más alta (como es de esperar, al excluir ~2 % de la población de 0-6 años del
  denominador) pero la forma de la tendencia 2014-2021 es prácticamente idéntica en ambos casos
  (pendientes de 0,0250 y 0,0268 por 100.000/año respectivamente, mismo signo y orden de magnitud,
  p=0,029 y p=0,032; ver `primary_results.csv`, series `brum_crude_national_total_pop` y
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

## Corrección aplicada tras revisión post-hoc

Una revisión de consistencia interna de `primary_results.csv` (recalculando `pct_change`,
pendiente, IC y p-valor de forma independiente a partir de `rate` y `year`, y comparando el total
de muertes de la serie `brum_crude_national_*` contra el número validado en esta misma auditoría)
detectó un error: las series `brum_crude_national_total_pop`, `brum_crude_national_gt6_pop` y
`age_standardized_2014std` se habían calculado a partir de `annual_aggregates.csv` filtrando por
edad entera (`age_floor > 6`), en vez de usar el filtro continuo original `idade_quantidade > 6`. Al
agrupar por `floor(idade_quantidade)`, una muerte con edad continua entre 6 y 7 años (p. ej. 6,5
años) cae en el cubo `age_floor == 6` y quedaba excluida por `age_floor > 6`, aunque sí cumple
`idade_quantidade > 6`. Esto infravaloraba el total de la reproducción cruda en 39 muertes
(18.539 en vez de 18.578) — la comprobación de tolerancia de esta misma auditoría, calculada
correctamente sobre el filtro continuo, nunca estuvo mal, pero `primary_results.csv` no coincidía
con ella.

**Corrección**: la serie `brum_crude_national_*` ahora usa directamente el recuento anual
`N_gt6_valid_age` de `data/fase2_year_counts.csv` (filtro continuo), en lugar de re-derivarlo de
`annual_aggregates.csv`. En el momento de esta corrección, la suma de `n_deaths` de
`brum_crude_national_total_pop` pasó a coincidir exactamente con el total validado entonces
(18.578); tras la segunda corrección descrita a continuación (deduplicación), el total final queda
en 18.583 (ver cabecera de esta sección).

Las series `age_standardized_2014std`, `age_5_34`, `age_7_34_control` y `age_35_59` siguen usando
el recuento por edad entera (`floor(idade_quantidade)`), necesario para casar cada muerte con el
denominador IBGE de su mismo año de edad simple. Esto es una elección metodológica razonable y
deliberada para las extensiones (no una reproducción literal del corte continuo de Brum), y queda
así documentada; no se ha "corregido" porque no era un error, a diferencia del caso anterior.

## Segunda corrección: deduplicación demasiado agresiva

Una revisión posterior de los scripts R (`01_load_year.R`) encontró que la deduplicación de
registros usaba como clave únicamente `(fecha de óbito, edad continua)`, descartando `CAUSABAS` y
las cinco columnas de línea de causa (`LINHAA`-`LINHAII`) que ya estaban cargadas en memoria. Esto
es más agresivo que el `distinct()` del script original, que opera sobre todas las columnas del
registro. Verificado contra los datos crudos de 2014: existen dos registros con CONTADOR distinto
(30907 y 51872) que comparten fecha de nacimiento y de óbito, pero tienen `CAUSABAS` (J459 vs J46) y
líneas de causa distintas — es decir, casi con toda seguridad dos personas distintas, no un
duplicado del mismo registro. La clave estrecha los colapsaba en uno solo por error.

**Corrección**: la clave de deduplicación ahora incluye también `CAUSABAS` y las cinco columnas
`LINHA*`, no solo las dos fechas. Esto recupera 5 muertes en total repartidas entre 2014 (+1), 2017
(+2), 2018 (+1) y 2021 (+1). El total reproducido pasa de 18.578 a **18.583**, a 1 sola muerte del
objetivo publicado (18.584) — una mejora clara en la fidelidad de la reproducción. El `CONTADOR` del
SIM no es un identificador único de fila dentro del fichero anual (se repite cientos de veces en
cada año; no sirve como clave de deduplicación), por lo que no se ha usado para este fin.

Nota: esta clave ampliada sigue sin ser idéntica al `distinct()` original (que usa además sexo,
raza, escolaridad y decenas de columnas más no cargadas aquí por razones de memoria), así que no se
garantiza una reproducción bit a bit de esa deduplicación. Dada la mejora observada y el tamaño
residual del error (1 muerte sobre 18.584), no se ha considerado necesario cargar columnas
adicionales solo para este fin.

## Tercera corrección: mismo fallo de edad entera en el script de reconciliación

Al revisar `check_fase1_reconciliation.R` (el único script de verificación versionado en el
repositorio) se encontró que calculaba el denominador del "% de muertes en ≥60 años" sumando
`annual_aggregates` con `age_floor > 6` — el mismo esquema de edad entera que causó la primera
corrección, y que este script no había heredado el arreglo porque es un script aparte de
`run_pipeline.R`. El numerador (≥60 años) no se ve afectado, pero el denominador estaba
infravalorado en las mismas 39 muertes (18.544 en vez de 18.583), lo que inflaba el porcentaje
reportado a 68,4 % en vez del 68,2 % correcto.

**Corrección**: el script ahora toma el total correcto desde `data/fase2_year_counts.csv`
(`N_gt6_valid_age`, filtro continuo), igual que `run_pipeline.R`. El valor correcto, ya reflejado
arriba, es **68,2 %**.

## Cuarta corrección: métrica de comparación y sensibilidad a la revisión de denominadores

**Métrica.** El código original (`analysis_and_visualization.qmd`, bloques `relative_variation*`)
publica como "% de cambio" la **media 2015-2021 de (tasa_t − tasa_2014) / tasa_2014**, no el cambio
extremo a extremo 2014→2021. Las secciones anteriores comparaban el cambio extremo a extremo con ese
objetivo, y no son comparables. Con la métrica original (`data/sensitivity_brum_style_change_metrics.csv`):

| Serie | Cambio 2014→2021 | Métrica de Brum, rev. 2018 | Métrica de Brum, rev. 2024 | Objetivo publicado |
|---|---|---|---|---|
| 18-59 | +22,9 % | +16,5 % | +17,3 % | ≈ +19 % |
| ≥60 | −11,1 % | **−1,9 %** | −1,8 % | ≈ −0,5 % |
| Nacional (media de variaciones interanuales) | — | +2,0 %/año | +2,1 %/año | +2,5 %/año (abstract) |

Consecuencia: la explicación dada arriba para el grupo ≥60 ("reconstrucción del denominador") era en
gran parte errónea. El desajuste de −11 % frente a −0,5 % venía de comparar métricas distintas.
Queda un residuo pequeño sin explicar (−1,9 % frente a −0,5 %; +16,5 % frente a +19 %).

**Denominadores.** Se repitió el análisis con la proyección IBGE revisión 2024, posterior al censo
2022 (`R/07_denominator_sensitivity.R`; fichero `projecoes_2024_tab1_idade_simples.xlsx`, sha256
`6e5c3d21a2e8ff50badd7be2785e1664b41a43277543be541641b0cd802c3205`). Los numeradores son idénticos;
la población de 2021 pasa de 213,3 M (rev. 2018) a 210,1 M (rev. 2024). Los resultados primarios
no se han sobrescrito (siguen con rev. 2018); salidas en `data/sensitivity_denominators_*.csv`.

| Serie | Rev. 2018: cambio, pendiente, p | Rev. 2024: cambio, pendiente, p |
|---|---|---|
| Cruda nacional (denominador total) | +12,5 %; 0,0250; 0,029 | +13,7 %; 0,0269; 0,022 |
| Estandarizada por edad (estándar 2014) | −4,0 %; 0,0002; 0,983 | −1,5 %; 0,0040; 0,668 |
| 5-34 años | +20,3 %; 0,0080; 0,014 | +21,7 %; 0,0085; 0,012 |
| 7-34 (control) | +23,5 %; 0,0094; 0,011 | +25,0 %; 0,0099; 0,009 |
| 35-59 años | +15,5 %; 0,0221; 0,132 | +16,0 %; 0,0227; 0,125 |

Las conclusiones sustantivas no dependen de la revisión de denominadores: la serie estandarizada
sigue sin tendencia y el grupo 5-34 sigue mostrando un aumento significativo.

**Lo que no se reproduce.** El abstract de Brum et al. da una pendiente nacional de 0,03 (IC 95 %
0,01-0,04; p=0,01); aquí sale 0,025-0,027 (IC 0,004-0,048; p=0,022-0,029). Se descartó que lo
explique el redondeo de la tasa a 2 decimales previo al GLM que hace el código original (da p=0,027).
Tampoco lo explica la revisión de denominadores. Queda sin explicar.

**Retractación.** En la sección "Denominadores" se afirmó que la revisión 2018 era la
"contemporánea" y que la de 2024 no existía cuando Brum et al. hicieron su análisis. Esa elección no
está respaldada: en su carta a la revista (DOI 10.36416/1806-3756/e20240162) Brum et al. defienden
expresamente ajustar la población al censo 2022. La revisión 2018 se mantiene como primaria por
continuidad con lo ya ejecutado, y la 2024 queda como sensibilidad.

## Análisis de robustez posteriores al protocolo (modelos de conteos y estándar WHO)

Fuera del protocolo original, que fijaba el mismo modelo que Brum (`lm`/`glm` gaussiano sobre
tasas). Los resultados primarios no se modifican. Script `R/08_count_models_and_who_standard.R`;
salidas en `data/robustness_*.csv`. Se ejecutó con las dos revisiones de denominadores.

**Modelos de conteos** (regresión de Poisson, cuasi-Poisson y binomial negativa con offset
log(población); cambio anual en %, rev. 2018). Cuando la sobredispersión es fuerte, el p-valor de
Poisson no es creíble y se debe leer la cuasi-Poisson (conservadora) o la binomial negativa:

| Serie | Cambio anual (IC 95 %) | p cuasi-Poisson | p binomial neg. | Dispersión (Poisson) |
|---|---|---|---|---|
| Cruda nacional | +2,25 % (0,3 a 4,2) | 0,029 | 0,0007 | 5,9 |
| **Ajustada por edad, ≥7 años** | +0,00 % (−1,1 a 1,1) | 0,99 | 0,10 | 3,1 |
| **5-34 años** | **+4,04 % (1,2 a 7,0)** | **0,013** | 0,0003 | 1,07 |
| 7-34 (control) | +4,65 % (1,6 a 7,7) | 0,009 | 0,00005 | 1,13 |
| 35-59 | +2,78 % | 0,13 | 0,036 | 5,5 |

- El resultado del 5-34 se sostiene con modelos de conteos y es algo más sólido de lo que sugería
  el OLS: casi no hay sobredispersión (1,07), por lo que Poisson y binomial negativa coinciden
  (la binomial negativa degenera a Poisson, de ahí los avisos `iteration limit reached`). Con la
  revisión 2024: +4,22 %/año, cuasi-Poisson p=0,011.
- La tendencia nacional ajustada por edad (Poisson con bandas de edad como factor, sin población
  estándar) es nula con Poisson y cuasi-Poisson, y la binomial negativa da +0,9 %/año (p=0,10).
  Con la revisión 2024 la binomial negativa da +1,14 %/año (IC 0,04 a 2,26; p=0,043). Formulación
  prudente: la tendencia nacional se atenúa de +2,3 %/año a entre 0 y +1,1 %/año según el modelo, y
  no es distinguible de cero en la mayoría de las especificaciones. No debe escribirse como
  "desaparece" sin esa matización.
- La inferencia del 35-59 y de los grupos ≥60 y 18-59 depende del modelo (p entre 0,04 y 0,13);
  no se interpretan.

**Estándar WHO** (Ahmad et al. 2000; pesos verificados contra `seer.cancer.gov/stdpopulations`,
normalizados a la edad cubierta; para ≥7 años la banda 5-9 se pondera por 3/5, aproximación
asumiendo reparto uniforme dentro de la banda):

| Serie | Cambio 2014→2021 | Pendiente (IC 95 %) | p (OLS sobre 8 años) |
|---|---|---|---|
| Estandarizada WHO, ≥7 años, rev. 2018 | −4,2 % | −0,0001 (−0,021 a 0,021) | 0,99 |
| Estandarizada WHO, ≥7 años, rev. 2024 | −2,0 % | 0,0031 (−0,018 a 0,024) | 0,73 |
| Estandarizada WHO, 5-34, rev. 2018 | +16,9 % | 0,0069 (0,0015 a 0,0122) | 0,020 |
| Estandarizada WHO, 5-34, rev. 2024 | +19,1 % | 0,0075 (0,0021 a 0,0130) | 0,015 |

Los resultados con el estándar WHO coinciden con los del estándar Brasil 2014; el 5-34
estandarizado por bandas quinquenales sube algo menos (+17 % frente a +20 %).

**Limitaciones que siguen vigentes**: 8 puntos anuales, comparaciones múltiples entre series sin
corregir (las dos preguntas principales se fijaron antes del análisis; el resto es descriptivo),
y la explicación del abstract de Brum (pendiente nacional 0,03; p=0,01) sigue sin reproducirse.

## Conclusión de la fase de reproducción

Reproducción **satisfactoria** según los criterios de tolerancia del protocolo (diferencia total
0,0054 % ≪ 2 %; signo y orden de magnitud preservados en los grupos de edad originales). Se procede
a las extensiones (Fase 3-5: estandarización por edad y grupo 5-34) sobre una base de reproducción
validada.

## Quinta comprobación: contraste con el texto completo del artículo original

Se dispuso del PDF completo (J Bras Pneumol 2024;50(5):e20240138). Hechos verificados:

- La pendiente nacional publicada (0,03; IC 0,01–0,04; p=0,01) es reproducible a partir de las tasas anuales de su Figura 1 (1,03; 1,08; 1,10; 1,21; 1,12; 1,21; 1,33; 1,20): regresión lineal sobre esos valores da 0,032, p=0,013. El 14 % publicado es la media de variaciones relativas respecto a 2014 aplicada a esas tasas (+14,4 %).
- Nuestras tasas son un 1,8 %–5,4 % menores y la brecha crece de 2014 a 2021 (cociente 1,018→1,054). Hipótesis (no verificada): denominador distinto; el artículo cita el censo 2022 y población >6 años sin indicar la tabla.
- Grupos de edad: signo y clase de significación coinciden (<18: −0,01, p=0,88; 18–59: +0,02, p=0,03; ≥60: −0,03, p=0,47). Reparto 2 %/30 %/68 % coincide. Cambios porcentuales publicados: −10 %, +19 %, −0,5 %; los nuestros (extremo a extremo / media de variaciones): −9,2/+12,1; +22,9/+16,5; −11,1/−1,9. El de ≥60 no se reconcilia.
- Criterio de reproducción: cumplido en total de muertes y en signo/significación; la magnitud de los cambios porcentuales no coincide exactamente.
