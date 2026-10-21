# Modular One

Lee también [las instrucciones comunes](../../AGENTS.md), incluso si abriste
esta carpeta por separado. `PRODUCT.md` y `DESIGN.md` contienen el contexto.

- Identidad estable: `60e7de33-3720-4ecd-ba97-e40f6e1bb1a0`; solo `fr170`.
- Mantén la hora de 24 horas, fecha española, tiempo, lluvia, pasos,
  minutos de intensidad semanales, Body Battery y batería física con datos
  oficiales y ausencia explícita.
- Conserva el diseño aceptado, los arcos largos y el reposo negro sin AOD.
- `garmin-watchfacesView.mc` coordina ciclo de vida y refresco; `DataProviders.mc`
  obtiene datos; `Formatters.mc` transforma valores; `FaceRenderer.mc` compone;
  `Components.mc` dibuja primitivas; `Theme.mc` reúne tokens.
- `Graphics.Dc.fillEllipse` recibe centro y radios, no ancho y alto.
  Un arco con ángulos iguales puede dibujar el círculo entero: conserva el
  tratamiento del progreso cero.
- Desde esta carpeta: `..\..\scripts\build.ps1 -Project modular-one`.
