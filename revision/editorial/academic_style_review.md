# Revisión académica, claridad y estilo

La edición se aplicó a la fuente editorial y a los generadores, con resultados científicos congelados en el commit `8fa06c0577429b643a2e08ee4e1ed1d15ed6b9a8`. Los Word, PDF, suplemento y respuesta se regeneraron desde esas fuentes. Esta revisión de lenguaje no incorpora nuevos análisis.

## Skills y alcance

- `academic-editing` para claridad, concisión, gramática, consistencia y fluidez, preservando el significado.
- `academic-structural-reviewer` para diagnóstico C-C-C y PIER. La edición posterior se realizó bajo el encargo de edición académica; el diagnóstico estructural no se utilizó como autorización para cambiar contenido científico.
- `research-problem-mechanism-evidence` para limitar cada interpretación a la evidencia disponible.
- `compag-elsevier-paper-editing`, solicitado expresamente, para precisión, lógica progresiva, terminología y puntuación. Su uso es estilístico y no implica elegir Computers and Electronics in Agriculture como revista de destino.

No hay un skill instalado llamado humanización. Esa parte se abordó como edición de claridad y fluidez, reduciendo frases rígidas, repeticiones y contraposiciones retóricas. No se aplicó `personal-style`, cuyo uso exige que se solicite por su nombre exacto.

No se evaluó ajuste a una revista porque no se solicitó una revista ni se proporcionaron sus Aims & Scope. El diagnóstico cubre estructura y contenido.

## Diagnóstico estructural C-C-C y PIER

### Skip Test

Las frases iniciales de la introducción original permitían reconstruir la progresión del argumento.

| Párrafo | Frase inicial de la versión anterior | Función |
| --- | --- | --- |
| Introducción P1 | Brum et al. concluded that "asthma mortality remains high and shows an increasing trend for the first time in the past decades" [1]. | Establecer la interpretación que se reanaliza. |
| Introducción P2 | Earlier Brazilian surveillance provides a longer perspective. | Situar los resultados recientes en una serie histórica distinta. |
| Introducción P3 | Neither Brum et al. nor Cardoso et al. directly age-standardised the national mortality series. | Explicar la necesidad de separar composición y tasas. |
| Introducción P4 | We therefore asked to what extent the reported increase in asthma mortality in Brazil during 2014–2021 remains supported when the original analysis is reproduced and population age structure is held fixed. | Formular la pregunta y presentar los análisis. |

Las frases iniciales de la discusión también permitían reconstruir el argumento, aunque algunos párrafos contenían varios propósitos.

| Párrafo | Frase inicial de la versión anterior | Función |
| --- | --- | --- |
| Discusión P1 | The corrected analysis reproduced the historical crude finding while separating it from the national domain of completed ages ≥7. | Interpretar el contraste entre tasas crudas y estandarizadas. |
| Discusión P2 | The decomposition showed positive age-composition contributions across every endpoint pair with both denominator revisions. | Explicar la contribución descriptiva de la composición. |
| Discusión P3 | Within ages 5–34, both crude and standardised mortality increased across 2014–2021. | Interpretar el resultado joven y sus sensibilidades. |
| Discusión P4 | The U071 correction, explicit calendar ages and conservative treatment of the ambiguous pair improve the transparency of selection. | Explicar las consecuencias de la selección revisada. |
| Discusión P5 | Limitations include the ecological design, short annual series, post hoc robustness analyses, unadjusted multiple comparisons and possible changes in death certification. | Delimitar inferencia y procedencia. |
| Discusión P6 | The study supports joint reporting of aligned crude, age-standardised and age-specific mortality. | Expresar la implicación para vigilancia. |

La edición conservó esta secuencia. La introducción termina ahora con el objetivo nacional ≥7, la estandarización dentro de 5–34 y el alcance de las sensibilidades. La discusión interpreta los resultados sin atribución causal. El resumen mantiene la diferencia entre cambio entre extremos y tendencia anual.

### Tres párrafos críticos

| Localización anterior | Diagnóstico | Cambio aplicado |
| --- | --- | --- |
| Métodos, Trends, count models and sensitivity scenarios P2 | Sobrecarga PIER. Fórmulas, bandas, intervalos, modelos de varianza y convergencia compartían un párrafo. | Separar especificación e intervalos de la explicación de varianza, dispersión y advertencias. Conservar ambas fórmulas y las nueve bandas. |
| Discusión P3 | Sobrecarga PIER. Resultado 2014–2021, exclusión de 2020, incertidumbre prepandémica, control 7–34 y comparación histórica competían por el foco. | Separar el resultado joven y sus sensibilidades de la interpretación prepandémica y los límites de comparación histórica. |
| Discusión P5 | Sobrecarga PIER. Limitaciones del diseño y procedencia se mezclaban con convergencia e interpretación de intervalos. | Separar diseño y procedencia de las limitaciones de theta y el alcance de la incertidumbre estadística. |

### Acciones mecánicas completadas

- **ACTION 1:** Separar especificación e inferencia de dispersión — Métodos, Trends P2 — mantener una función técnica por párrafo.
- **ACTION 2:** Dividir el párrafo joven — Discusión P3 — distinguir evidencia del periodo completo e incertidumbre prepandémica.
- **ACTION 3:** Dividir las limitaciones — Discusión P5 — distinguir procedencia, diseño y estimación del modelo.
- **ACTION 4:** Aclarar el objetivo y el dominio — Introducción P4 y resumen — conectar la pregunta epidemiológica con las tasas calculadas.
- **ACTION 5:** Eliminar contraposiciones y redundancias — Métodos, Resultados, Discusión y respuesta — avanzar mediante resultados y explicaciones concretas.

## Edición académica y estilo COMPAG

| Cambio | Motivo y límite |
| --- | --- |
| Frases más directas y uso consistente de primary analysis. | Sustituir formulaciones rígidas sin cambiar qué escenario es principal. |
| Prosa y título sin dos puntos decorativos ni énfasis en cursiva. | Aplicar el skill solicitado. Se preservan DOI, URL, identificadores y títulos bibliográficos como sintaxis o metadatos. |
| Menos construcciones not ... but, rather than y contraposiciones innecesarias. | Conectar observación e interpretación mediante frases progresivas. |
| Explicación directa del control 7–34. | Aclarar sensibilidad a edades cinco y seis sin presentarlo como replicación independiente. |
| Advertencias binomiales negativas explícitas. | Distinguir convergencia del modelo de media y convergencia de theta. |
| WHO sin 2020 mencionado en la respuesta a Amaury. | Hacer visible el intervalo que incluye cero. El p mostrado procede del CSV ya existente. |
| Información de publicación actualizada. | La rama ya fue publicada por instrucción del usuario. No se afirma que se haya enviado correo o presentado a una revista. |

Academic Writing Toolkit no detectó problemas en sus comprobaciones conservadoras de inglés británico y lógica de párrafos, antes y después de la edición. Son comprobaciones de lenguaje, no validación estadística ni garantía de ajuste a una revista. Sus respuestas se conservan en `qa/academic_tool_checks.json`.

## Preservación y verificación

`verify_copyedit.py` verifica por SHA-256 los 322 archivos protegidos de resultados, figuras y código analítico. Las 74 entradas de trazabilidad numérica son idénticas a la versión anterior. Las cinco ecuaciones independientes, fórmulas de modelos, nueve bandas, regla COVID, aniversario del 29 de febrero, referencias, Tabla 1 y sus leyendas se preservan. Las sensibilidades y los resultados que incluyen cero siguen explícitos.

`verify_documents.py` contrasta texto y celdas Word con Markdown y verifica su presencia ordenada en los PDF. También conserva la conciliación de los 486 bloques de la referencia histórica. La inspección visual final se registra en `qa/final_qa.json`. Las declaraciones personales e institucionales siguen pendientes de los autores.
