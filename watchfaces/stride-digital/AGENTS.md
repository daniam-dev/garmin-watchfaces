# Stride Digital

Lee [las instrucciones comunes](../../AGENTS.md), PRODUCT.md y DESIGN.md.

- Proyecto autónomo para `fr170`; no importar código ni recursos de otra esfera.
- Aprovechar el círculo completo de 390 × 390. Hora blanca en dos líneas a la
  izquierda; pasos, Body Battery y pulso en una columna a la derecha. Sin
  arcos de actividad, paneles ni círculos de datos.
- Datos oficiales, nulos explícitos, hora de 24 horas y fecha española.
- Sin segundos, timers, animaciones ni AOD; reposo negro.
- `StrideView` controla refresco y suscripciones de Body Battery y pulso; `StrideProvider`
  lee Garmin; `StrideFormat` formatea; `StrideRenderer` dibuja con `StrideTheme`.
- `StrideTargets` define zonas de pulsación; `StrideDelegate` abre Garmin.
- Compilar desde aquí: `../../scripts/build.ps1 -Project stride-digital`.
- Hora blanca y cifras deportivas propias en `resources/fonts/`; regenerar
  con `python tools/generate_fonts.py`. Mantener licencia y acento verde suave.
  `Time` usa dígitos tabulares de 120 px de altura final; `Value` y `Compact`
  conservan 30 y 19 px. Cambiar medidas y colores en `StrideTheme` y mantener
  `DESIGN.md` y `.impeccable/design.json` coherentes.
