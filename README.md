# Garmin watchfaces

Esferas independientes para Forerunner 170 (`fr170`), de uso personal e
instalación por USB. Modular One está implementada; Pixel Analog es una base
compilable sin diseño.

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
.\scripts\build.ps1 -Project pixel-analog
.\scripts\build.ps1 -Project all
```

El script admite `-SdkPath` y `-DeveloperKeyPath` para usar otras rutas.

| Proyecto | Archivo generado |
| --- | --- |
| Modular One | `watchfaces/modular-one/bin/ModularOne.prg` |
| Pixel Analog | `watchfaces/pixel-analog/bin/PixelAnalog.prg` |

## Instalar en el reloj por cable USB

1. Compila Modular One con el comando anterior.
2. Conecta el reloj al PC con un cable USB de datos. Acepta la conexión de
   transferencia de archivos si el reloj la solicita.
3. En el Explorador de archivos, abre el reloj y busca `GARMIN\APPS`.
   Si aparece «Almacenamiento interno», entra primero ahí.
4. Copia `watchfaces/modular-one/bin/ModularOne.prg` dentro de `GARMIN\APPS`.
   Solo necesitas el archivo `.prg`.
5. Espera a que termine la copia y desconecta el reloj de forma segura.
6. En el reloj, abre el selector de pantallas del reloj, elige Modular One
   y aplícala.

Para actualizarla, vuelve a compilar y repite la copia conservando el nombre
del archivo y el identificador de la aplicación. Si el PC no detecta el reloj,
prueba otro cable de datos o puerto USB.

Este método no requiere publicar en Connect IQ Store. Garmin lo documenta como
[Side Loading an App](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/).

## Verificación y documentación

```powershell
.\scripts\verify.ps1
.\tests\tooling.tests.ps1
```

Cada carpeta en `watchfaces/` contiene su manifiesto, código y recursos.
`projects.json` registra los proyectos; los binarios se guardan en su `bin/`.

- [AGENTS.md](AGENTS.md): instrucciones para Codex e Impeccable como norma visual.
- [Arquitectura](docs/architecture.md): responsabilidades y cómo añadir esferas.
- Cada esfera conserva su `PRODUCT.md` y, cuando procede, `DESIGN.md`.
