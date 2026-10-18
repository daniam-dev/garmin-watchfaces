# Pilot Analog

Esfera independiente para Forerunner 170 sin Music, `fr170`, API mínima 6.0.2.
UUID: `9bf7b908a3104ff6a49d912b876ae2d5`.

## Compilar e instalar

Desde la raíz del repositorio:

```powershell
.\scripts\build.ps1 -Project pilot-analog
```

El archivo instalable es `watchfaces/pilot-analog/bin/PilotAnalog.prg`.
Conecta el Garmin mediante USB de datos, abre `GARMIN\APPS` (dentro de
Almacenamiento interno, si aparece) y copia ese `.prg`. Desconecta de forma
segura y selecciona Pilot Analog en las pantallas del reloj. Conserva nombre,
UUID y clave de firma para actualizarla. No copies los programas Tests o Smoke.

Modular One se compila e instala por separado y conserva su UUID. No hace
falta desinstalarla para instalar Pilot Analog.

## Simulador y pruebas

Con el SDK seleccionado:

```powershell
$sdkPath = (Get-Content "$env:APPDATA/Garmin/ConnectIQ/current-sdk.cfg" -Raw).Trim()
& "$sdkPath/bin/connectiq.bat"
& "$sdkPath/bin/monkeydo.bat" watchfaces/pilot-analog/bin/PilotAnalog.prg fr170
.\watchfaces\pilot-analog\tests\run.ps1
python watchfaces/pilot-analog/tests/asset_contracts.py
```

Las pruebas requieren el simulador abierto. Sus registros quedan en
`bin/tests.log` y `bin/smoke.log`. El diagnóstico termina automáticamente y
ejercita dibujo, datos Garmin y reposo/despertar.
No modifica el `.prg` instalable. Las pruebas no sustituyen la revisión visual.

Para regenerar fuentes y números, con Python y Pillow 13.x instalados:

```powershell
python watchfaces/pilot-analog/tools/generate_assets.py
```

## Datos y comportamiento

- Batería del dispositivo: `System.getSystemStats().battery`, porcentaje
  validado entre 0 y 100. Ausente o inválido: `--`, sin progreso. Se refresca
  por minuto y al despertar. El arco tiene el mismo radio, inicio, recorrido,
  grosor y relleno proporcional que el de pasos. No utiliza Body Battery ni
  requiere el permiso `ComplicationSubscriber`.
  Relleno verde salvia desde 80%, amarillo cálido desde 30% y rojo coral por
  debajo de 30%; el número y el icono siguen blancos.
- Meteorología: caché oficial `Weather.getCurrentConditions()`, `temperature`
  Celsius y `condition`. Ausente: `--°`; condición desconocida: dos trazos.
  El arco es decorativo y fijo.
- Fecha: `Gregorian.info(Time.now(), Time.FORMAT_SHORT)`, hora local,
  abreviaturas españolas en mayúsculas.
- Pasos: `ActivityMonitor.getInfo().steps` y `stepGoal`. Un objetivo ausente o
  no positivo deja el arco sin progreso. El valor puede superar el objetivo;
  el arco se limita a 100%. Ausencia: `--`; cero válido: `0`.

Garmin llama `onUpdate` por segundo en estado activo. Se calculan las tres
agujas con la hora actual, incluida la fracción de minuto/hora. En reposo,
pantalla negra; al despertar, se refrescan los datos. Sin timers, red,
actualizaciones parciales ni AOD. Los proveedores no se consultan cada segundo.

## Referencia y límites

La imagen adjunta al encargo fija composición y orientación. [DESIGN.md](DESIGN.md)
recoge su normalización. Se recrean números con Roboto OFL e iconos vectoriales
propios; no se usa una fotografía como fondo. No se dibujan caja, bisel ni marca.

Se respeta el orden visible en la imagen: icono sobre temperatura y huellas
sobre pasos, aunque los apartados de texto del encargo describen el orden inverso.
La horaria hueca deja visible el contenido que atraviesa. Los datos y la hora
reales cambiarán inevitablemente los solapamientos frente a la imagen de ejemplo.

El usuario ha revisado y aceptado el diseño mediante capturas del simulador
en la conversación. No se incluye una captura final persistente en el
repositorio ni se afirma fidelidad píxel a píxel con la referencia.
Falta comprobar en reloj el porcentaje de batería, la sincronización
meteorológica, el gesto de activación y el consumo a lo largo del día.

## Validación ejecutada

- SDK instalado 9.2.0: ambas esferas compilan para `fr170` con `-w` sin avisos.
- `scripts/verify.ps1` y `tests/tooling.tests.ps1`: pasan.
- Seis pruebas Monkey C: pasan en `fr170`. Incluyen ausencia, formato español,
  ángulos, límites de color al 30% y 80%, y dibujo con datos representativos,
  cero, objetivo cero y sobreobjetivo.
- Dos pruebas de recursos: pasan. Comprueban los atlas de cobertura gris,
  los límites de los glifos y la importación sin tramado de los números horarios.
- Diagnóstico como watchface: tres actualizaciones de 47–62 ms; 22.360 bytes
  usados y 104.520 libres según `System.getSystemStats()` (126.880 disponibles
  en esa ejecución). Reposo y despertar sin errores.
  Son medidas del simulador, no del consumo ni del tiempo de dibujo en reloj.

Los registros de prueba quedan en `bin/`, fuera del control de versiones.

## Documentación de Garmin consultada

- [WatchFace](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html): ciclo activo y reposo.
- [Weather](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather.html) y [CurrentConditions](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather/CurrentConditions.html): caché anulable y Celsius; API 3.2.0.
- [ActivityMonitor.Info](https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityMonitor/Info.html): pasos y objetivo anulables.
- [Gregorian](https://developer.garmin.com/connect-iq/api-docs/Toybox/Time/Gregorian.html): fecha local.
- [Graphics.Dc](https://developer.garmin.com/connect-iq/api-docs/Toybox/Graphics/Dc.html): primitivas, antialias y texto.
- [Resources](https://developer.garmin.com/connect-iq/articles/core-topics/Resources.html): importación BMFont y opciones de tramado y paleta.
- [System.Stats](https://developer.garmin.com/connect-iq/api-docs/Toybox/System/Stats.html): batería del dispositivo y memoria de la aplicación; API 1.0.0.

El perfil instalado `fr170` declara AMOLED 390 × 390, API de dispositivo
6.0.3 y límite normal de 131.072 bytes para watchfaces. La compilación contra
ese perfil verifica los símbolos utilizados; no sustituye una prueba en reloj.
