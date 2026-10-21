# Stride Digital

Lee [las instrucciones comunes](../../AGENTS.md), PRODUCT.md y DESIGN.md.

- Proyecto autónomo para `fr170`; no importar código ni recursos de otra esfera.
- Aprovechar el círculo completo de 390 × 390. Hora recta en dos líneas a la
  izquierda; pasos, Body Battery y pulso en una columna a la derecha. Sin
  arcos de actividad, paneles ni círculos de datos.
- Datos oficiales, nulos explícitos, hora de 24 horas y fecha española.
- Sin segundos, timers, animaciones ni AOD; reposo negro.
- `StrideView` controla refresco y suscripciones de Body Battery y pulso; `StrideProvider`
  lee Garmin; `StrideFormat` formatea; `StrideRenderer` dibuja con `StrideTheme`.
- `StrideTargets` define zonas de pulsación; `StrideDelegate` abre Garmin.
- Compilar desde aquí: `../../scripts/build.ps1 -Project stride-digital`.
- Cifras deportivas propias en `resources/fonts/`; regenerar con
  `python tools/generate_fonts.py`. Mantener licencia, horas de relleno oscuro
  y contorno lima, minutos blancos, pasos lima y Body Battery cian contenido.
  Los cuatro recursos numéricos usan Barlow Condensed ExtraBold, con licencia
  SIL OFL 1.1. `Time` y `TimeOutline` tienen dígitos tabulares rectos (0°),
  celdas de 88 px y 130 px de altura final; el contorno interior nominal de
  3 px no amplía sus cajas.
  `Value` y `Compact`
  conservan 30 y 19 px. Cambiar medidas y colores en `StrideTheme` y mantener
  `DESIGN.md` y `.impeccable/design.json` coherentes.
- Barras de diez segmentos e iconos vectoriales propios junto a las cifras.
  Las imágenes Garmin en `.impeccable/references/` son referencias de diseño;
  no se compilan ni se copian a los recursos de la esfera.
