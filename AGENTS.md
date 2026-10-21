# Trabajo en este repositorio

Esferas nativas Garmin Connect IQ en Monkey C para Forerunner 170 (`fr170`).
Windows y PowerShell; no hay dependencias Node ni una aplicación web.

## Contexto y alcance

- Identifica la esfera afectada y lee su `AGENTS.md` y `PRODUCT.md`.
  Para cambios visuales, lee también su `DESIGN.md`, si existe.
- `projects.json` registra carpeta y nombre del programa. Los manifiestos de
  cada esfera son la autoridad sobre identidad, permisos y dispositivo.
- Consulta `docs/architecture.md` si cambias límites entre componentes,
  herramientas comunes o añades una esfera. No leas todo el repositorio para
  un cambio localizado. Omite `bin/` y `.local/` al explorar código.
- Conserva el comportamiento y la identidad de cada esfera salvo petición
  expresa. Los proyectos activos se registran en `projects.json`.
- Las esferas nuevas deben aprovechar todo el lienzo circular de 390 × 390
  del Forerunner 170, sin simular un bisel interior ni reducir la composición.
  Ajusta trazos y texto al borde físico para evitar recortes.
- Las complicaciones deben abrir su vista nativa al mantener pulsado el dato
  siempre que Garmin ofrezca un destino compatible. Usa `WatchFaceDelegate`
  y `Complications.exitTo`; documenta los destinos que el firmware no permita.

## Arquitectura

- Cada `watchfaces/<slug>/` posee manifiesto, `monkey.jungle`, código, recursos
  y `bin/`. No importes código ni recursos de otra esfera.
- Comparte herramientas de desarrollo en `scripts/`, no estado de ejecución.
  No crees un framework o barrel común sin una necesidad concreta demostrada.
- Separa ciclo de vida, acceso a Garmin, formatos y dibujo. Los proveedores
  leen datos; el renderizador los presenta. No consultes sensores desde iconos.
- Conserva la suscripción y liberación de complicaciones y el reposo de cada
  esfera. No añadas timers, animaciones, segundos o AOD a Modular One.
- Usa datos oficiales y tipos anulables. Un dato no disponible no es cero;
  mantén los indicadores de ausencia y evita condiciones meteorológicas falsas.
- No cambies UUID, `fr170`, API mínima o permisos como efecto de un refactor.

## Impeccable

- Es la norma para diseñar, revisar o modificar la interfaz de una esfera.
  Usa la skill `impeccable` instalada y lee su `SKILL.md` antes de aplicarla.
- Trabaja desde la carpeta de la esfera y pasa un archivo o superficie concreta
  como objetivo. `.impeccable/config.json` de la raíz declara `watchfaces/*`.
  Cada esfera mantiene sus propios documentos y artefactos visuales.
- Una mejora conserva el diseño aceptado; no la conviertas en un rediseño.
  Cambia medidas y colores en los tokens existentes, con iconos vectoriales
  legibles a 390 × 390 y respetando el borde circular.
- Aplica las partes pertinentes a Garmin. No añadas HTML, CSS, Playwright ni
  hooks de análisis web para validar Monkey C. Usa el simulador o el reloj
  para revisar píxeles y legibilidad.
- Si la skill o la captura no están disponibles, explica la limitación y
  continúa con el código y la documentación aplicables. No presentes una
  compilación o una comprobación geométrica como validación visual.
- Guarda una referencia o captura persistente cuando esté disponible y sea
  pertinente. No supongas que una imagen de otro chat está en el repositorio.

## Comandos y validación

Desde la raíz:

```powershell
.\scripts\verify.ps1
.\scripts\build.ps1 -Project modular-one
.\scripts\build.ps1 -Project pilot-analog
.\scripts\build.ps1 -Project all
.\scripts\test.ps1 -Project all
.\tests\tooling.tests.ps1
```

- Cambio de código o recursos: compila la esfera afectada con avisos activados.
  Cambio común, de manifiestos o workspace: verifica estructura y compila ambas.
  Cambio de scripts: ejecuta también las pruebas de herramientas.
- Cambio visual: revisa una captura real a 390 × 390 y datos representativos,
  incluidos los ausentes. Informa de lo que no se haya podido comprobar.
- Añade pruebas que detecten fallos relevantes de lógica o contratos. No
  introduzcas dependencias de pruebas por cambios cosméticos ni compruebes
  solo que una implementación repite sus propias constantes.
- Un error de Computer Use no demuestra un fallo del simulador de Garmin.

## Archivos locales y entrega

- `.local/developer_key.der` es la clave existente compartida para firmar.
  No la leas, copies, regeneres, imprimas ni subas. Los scripts reciben su ruta.
  Binarios, cachés y claves permanecen fuera del control de versiones.
- Mantén rutas portables; no guardes rutas absolutas de tu máquina en archivos
  versionables. SDK y firma se resuelven al ejecutar los scripts.
- Actualiza documentación cuando cambien contratos, comandos o diseño.
  No añadas diarios, planes o configuraciones de Codex por rutina.
- Responde y documenta en español, con palabras corrientes y detalles
  comprobables. Evita elogios, adornos y repeticiones; conserva nombres técnicos.
- Al entregar, indica cambios, validaciones reales y límites pendientes.
  No afirmes haber hecho commits, pruebas o capturas que no se ejecutaron.
