# Garmin watchfaces

Esferas independientes para Forerunner 170 (`fr170`), de uso personal e
instalación por USB. Los proyectos activos son Modular One, Pilot Analog y
Stride Digital.
Consulta la [documentación de Pilot Analog](watchfaces/pilot-analog/README.md)
para conocer sus datos, diseño y validaciones.

## Preparación y compilación

Necesitas Windows, PowerShell, Java y Connect IQ SDK Manager con un SDK activo
y el dispositivo `fr170` instalado. La clave de firma existente está en
`.local/developer_key.der`, excluida del control de versiones.

Abre `garmin-watchfaces.code-workspace` en VS Code e instala la extensión
recomendada `garmin.monkey-c`. En **Terminal → Ejecutar tarea** puedes compilar
cada esfera; `Ctrl+Shift+B` compila Modular One.

También puedes ejecutar desde la raíz:

```powershell
.\scripts\build.ps1 -Project modular-one
.\scripts\build.ps1 -Project pilot-analog
.\scripts\build.ps1 -Project stride-digital
.\scripts\build.ps1 -Project all
```

El script admite `-SdkPath` y `-DeveloperKeyPath` para usar otras rutas.

| Proyecto | Archivo generado |
| --- | --- |
| Modular One | `watchfaces/modular-one/bin/ModularOne.prg` |
| Pilot Analog | `watchfaces/pilot-analog/bin/PilotAnalog.prg` |
| Stride Digital | `watchfaces/stride-digital/bin/StrideDigital.prg` |

Stride Digital es la propuesta deportiva de pantalla completa: hora grande,
arcos de pasos y Body Battery junto al borde, pulso, tiempo y batería.
Su [diseño](watchfaces/stride-digital/DESIGN.md) recoge las medidas y colores.

En las tres esferas, mantén pulsada una complicación para abrir su vista
nativa. Pasos, tiempo y batería tienen acceso en las tres; Modular One añade
Body Battery y minutos; Stride Digital, Body Battery y pulso. Fecha solicita el destino nativo
de fecha; temperatura y lluvia comparten tiempo. La disponibilidad depende
del firmware. El gesto utiliza
[WatchFaceDelegate.onPress](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFaceDelegate.html#onPress-instance_function)
y [Complications.exitTo](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html#exitTo-instance_function).

## Instalar en el reloj por cable USB

Garmin documenta la instalación local de un `.prg` en `GARMIN/APPS` como
[Side Loading an App](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/).
No requiere publicar en Connect IQ Store, pero sí poder abrir el almacenamiento
del reloj desde Windows y usar un programa compilado para el modelo exacto.

Sigue la [guía de instalación y diagnóstico USB](docs/instalacion-usb.md):
incluye MTP en el Forerunner 170, el cable Garmin USB-C, las diferencias entre
tener el reloj registrado en Express y una conexión activa, y los pasos para
instalar cualquiera de las esferas. El procedimiento está contrastado con
documentación oficial; la instalación en el reloj de Dani sigue pendiente.

## Verificación y documentación

```powershell
.\scripts\verify.ps1
.\tests\tooling.tests.ps1
.\scripts\test.ps1 -Project all
```

Cada carpeta en `watchfaces/` contiene su manifiesto, código y recursos.
`projects.json` registra los proyectos; los binarios se guardan en su `bin/`.
`test.ps1` compila y ejecuta las pruebas Monkey C en el simulador `fr170`, con
45 segundos como límite de ejecución por esfera. Los resultados quedan en
`bin/tests.log`. Estos tests comprueban lógica, destinos y llamadas de dibujo;
no sustituyen una captura ni la apertura de las aplicaciones en el reloj.

- [AGENTS.md](AGENTS.md): instrucciones para Codex e Impeccable como norma visual.
- [Arquitectura](docs/architecture.md): responsabilidades y cómo añadir esferas.
- Cada esfera conserva su `PRODUCT.md` y, cuando procede, `DESIGN.md`.
