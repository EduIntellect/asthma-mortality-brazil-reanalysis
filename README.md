# Reanálisis: mortalidad por asma en Brasil (2014-2021)

Reanálisis reproducible de Brum et al. (mortalidad por asma en Brasil, microdatos SIM/DATASUS,
2014-2021). Repositorio de referencia: `mobrant94/asthma_mortality`, commit `8d527a5`.

Pregunta: ¿persiste el aumento de mortalidad reportado para 2014-2021 (a) tras estandarización
directa por edad y (b) en el grupo de edad 5-34 años?

## Resultado (ver `reanalysis/audit_reproduction.md` y `reanalysis/primary_results.csv`)

- Reproducción del total publicado (18.584 muertes): 18.583 reproducidas, 0,0054 % de diferencia.
- Tasa cruda nacional (reproducción literal de Brum): sube +12,6 % 2014→2021, p=0,029.
- **Tras estandarizar por edad** (estándar poblacional Brasil 2014): el aumento **no persiste**
  — pendiente ≈0 (p=0,98).
- **Grupo 5-34 años**: el aumento **sí persiste** y es significativo (+20,3 %, p=0,014),
  confirmado por el grupo control 7-34 (compatible con el filtro de edad original).
- Robustez (fuera del protocolo): con modelos de conteos el 5-34 se mantiene (+4,0 %/año,
  cuasi-Poisson p=0,013) y el estándar WHO da lo mismo; la tendencia nacional ajustada por edad
  queda entre 0 y +1 %/año según el modelo. Ver `reanalysis/R/08_count_models_and_who_standard.R`.
- Sensibilidad con población post-censo 2022 (IBGE, revisión 2024): mismas conclusiones
  (estandarizada p=0,67; 5-34 p=0,012). Ver `reanalysis/R/07_denominator_sensitivity.R`.

## Estructura

- `reanalysis/R/`: pipeline en R, un script por fase (`00_provenance.R` a `06_trend_models.R`),
  más `run_pipeline.R` (orquestador, procesa un año de SIM cada vez, memoria acotada) y
  `check_fase1_reconciliation.R` (verificación de los grupos de edad originales de Brum).
- `reanalysis/audit_reproduction.md`: auditoría completa — procedencia de los datos, sustituciones
  de fuentes documentadas, chequeo de tolerancia, discrepancias y correcciones aplicadas.
- `reanalysis/docs/data_sources.md`: URLs, versiones y hashes de las fuentes SIM/IBGE usadas.
- `reanalysis/primary_results.csv`: tabla principal de resultados (todas las series, por año).
- `reanalysis/annual_aggregates.csv`: muertes J45/J46 por año y edad simple, tras todos los
  filtros y exclusiones.
- `reanalysis/data/`: denominadores IBGE, comparaciones de denominador, series intermedias.
- `reanalysis/figures_comparative.png`: figura única comparando las tres series clave.
- `reanalysis/session_info.txt`: versiones de R/paquetes y procedencia completa de la ejecución.

## Reproducir

```
Rscript reanalysis/R/run_pipeline.R
Rscript reanalysis/R/check_fase1_reconciliation.R
```

Descarga los microdatos SIM (2014-2021) y el fichero de proyección poblacional IBGE la primera vez
que se ejecuta (ver `reanalysis/docs/data_sources.md` para las URLs exactas); las ejecuciones
siguientes reutilizan los ficheros ya descargados en `reanalysis/data_raw/` (no versionado, ver
`.gitignore`).
