# Pilot Analog

Lee [las instrucciones comunes](../../AGENTS.md), PRODUCT.md y DESIGN.md.

- Solo `fr170`; identidad propia en manifest.xml.
- La referencia aprobada manda. No añadir números cardinales, marca ni AOD.
- Proveedores leen Garmin; los renderizadores solo reciben datos.
- Conservar valores nulos. El indicador superior usa la batería del dispositivo,
  sin Body Battery ni suscripciones a Complications.
- Recursos y fuentes propios; no importar desde otra esfera.
- Compilar: `../../scripts/build.ps1 -Project pilot-analog`.
