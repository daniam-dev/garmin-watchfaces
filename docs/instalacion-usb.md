# Instalar esferas propias por USB en Windows

Garmin permite probar aplicaciones propias sin publicarlas en Connect IQ Store:
se compila un programa para el dispositivo y se copia su `.prg` a `GARMIN/APPS`.
La guía oficial [Your First Connect IQ App, apartado Side Loading an App](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/)
describe ese procedimiento. El asistente `Monkey C: Build for Device` genera el
programa; la copia al reloj sigue siendo un paso manual.

También está en la documentación del SDK instalado, bajo
`doc/docs/Connect_IQ_Basics/Your_First_App.html`, apartado `Side Loading an App`.
Se ha comprobado su contenido en el SDK 9.2.0 de este entorno.

Esta guía se aplica a Modular One, Pilot Analog y Stride Digital para Forerunner 170 **sin
Music**, identificador `fr170` en sus manifiestos. No presupone compatibilidad
con otro modelo o variante. Fuentes contrastadas el 21 de octubre de 2026;
la transferencia e instalación en el reloj de Dani todavía no están verificadas.

## 1. Comprobar la conexión antes de compilar

El cable con USB-C en el extremo del PC y el conector Garmin en el reloj es el
tipo previsto por el [manual del Forerunner 170, apartado Charging the Watch](https://www8.garmin.com/manuals/webhelp/GUID-4A2FC8FE-7025-4AEC-946E-097B31131B45/EN-US/Forerunner_170_Series_OM_EN-US.pdf).
No necesitas un conector USB-A por este procedimiento. Que el reloj cargue solo
confirma alimentación. Si Express logra sincronizarlo por ese cable, hay
comunicación de datos en ese momento; haberlo añadido anteriormente a Express
no confirma una conexión actual.

1. Conecta el reloj encendido directamente a un puerto USB del PC.
2. Para acceder a archivos, selecciona `MTP` en el reloj. El manual sitúa
   `Modo USB` en `Configuración del reloj > Sistema > Avanzada`, manteniendo
   pulsado el botón central izquierdo desde la esfera. Si ya está en MTP,
   continúa con la comprobación de Windows.
3. Abre el Explorador con `Win+E` y entra en **Este equipo**. Busca el nombre del
   reloj, aunque no tenga letra de unidad. En MTP puede aparecer como un
   dispositivo portátil; no tiene por qué existir una ruta como `E:\`.
4. Abre el reloj y, si aparece, `Almacenamiento interno` o `Primary`.
   Comprueba que puedes abrir `GARMIN` y después `APPS`.

El [manual del modelo confirma las opciones MTP y Garmin](https://www8.garmin.com/manuals/webhelp/GUID-4A2FC8FE-7025-4AEC-946E-097B31131B45/ES-XM/GUID-B6EEC065-0BAB-4A19-8350-A3A9DA44AD1D.html).
La [ayuda de detección de Garmin Express](https://support.garmin.com/en-SG/?faq=Wkf9e0fPST0gP0KoM63DK9)
distingue el modo Garmin del modo de transferencia de datos. Garmin también
documenta la navegación por [Este equipo y el almacenamiento interno](https://support.garmin.com/hr-HR/?faq=BAoGNOOLURAVh0AatVJiv5).

## 2. Si no puedes abrir `GARMIN/APPS`

Empieza por el síntoma que observas con el cable conectado:

| Lo que ocurre | Siguiente comprobación |
| --- | --- |
| Express muestra el reloj registrado, pero desconectado | Comprueba si Windows detecta un dispositivo al conectar el cable. El registro de Express no prueba la conexión. |
| Express sincroniza ahora, pero no ves el reloj en el Explorador | Revisa **Este equipo**, no solo las unidades con letra. Después prueba la reconexión con Express cerrado. |
| Ves el reloj, pero su almacenamiento no abre o aparece vacío | Espera a que termine la sincronización y vuelve a conectar con Express cerrado. Revisa MTP en el Administrador de dispositivos si persiste. |
| Solo carga y tampoco lo detecta Express | Comprueba puerto, contactos y cable; observa si Windows registra un dispositivo nuevo. |
| Puedes copiar el `.prg`, pero la esfera no aparece | La transferencia ya funciona. Continúa en el apartado 4. |

### Reconectar y revisar Windows

1. Espera a que termine cualquier sincronización o actualización. Cierra
   Express, también desde su icono junto al reloj de Windows si sigue abierto.
   Desconecta el Garmin, vuelve a conectarlo y actualiza **Este equipo** con `F5`.
   Es una prueba para aislar el acceso; no demuestra que Express sea la causa.
2. Abre **Administrador de dispositivos** desde `Win+X`. Observa qué entrada
   aparece y desaparece al conectar y desconectar el reloj. Revisa
   **Dispositivos portátiles**, **Otros dispositivos** y los controladores USB.
   Puede figurar con el nombre del reloj o como un dispositivo MTP.
3. Si hay una advertencia, abre sus propiedades y anota el mensaje y código.
   Usa Windows Update o `Actualizar controlador > Buscar controladores
   automáticamente`, según la [guía de Microsoft](https://support.microsoft.com/en-us/windows/update-drivers-through-device-manager-in-windows-ec62f46c-ff14-c91d-eead-d7126dc1f7b6).
   El mensaje concreto debe orientar el siguiente paso; no basta con instalar
   de nuevo Express para identificar un problema de MTP.
4. Si Windows no registra ningún cambio, prueba otro puerto directo, sin hub
   ni base intermedia. Comprueba que los contactos estén limpios y secos.
   Después prueba otro PC o un cable Garmin de datos conocido para aislar la
   conexión, siguiendo la [ayuda de detección de Garmin](https://support.garmin.com/en-SG/?faq=Wkf9e0fPST0gP0KoM63DK9).

Como consulta opcional de solo lectura en PowerShell:

```powershell
Get-PnpDevice -PresentOnly |
    Where-Object { $_.FriendlyName -match 'Garmin|Forerunner|MTP' -or $_.Class -eq 'WPD' } |
    Select-Object Status, Class, FriendlyName
```

Si no devuelve resultados, no encuentra un dispositivo presente con esos nombres
o esa clase. No identifica por sí sola la causa: un fallo USB puede aparecer con
otro nombre. Compárala con el Administrador de dispositivos al conectar el reloj.

Si sigue fallando, conserva estos datos para soporte: modelo exacto, versión de
Windows, si Express sincroniza **ahora**, si aparece en **Este equipo**, entrada
y error del Administrador de dispositivos, y resultado en otro puerto o PC.

### Express sincroniza, pero solo aparece «Garmin USB GPS»

El mensaje «Este dispositivo funciona correctamente» describe el estado que
Windows informa para ese controlador; no confirma acceso al almacenamiento.
Comprueba que la entrada desaparece al desconectar el reloj. Después consulta
`Propiedades > Detalles > Id. de hardware`, siguiendo la
[documentación de Microsoft](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/hardware-ids).

El identificador `USB\VID_091E&PID_0003` está asociado a la interfaz GPS propia de
Garmin en el [controlador del kernel Linux](https://github.com/torvalds/linux/blob/master/drivers/usb/serial/garmin_gps.c).
Si aparece esa interfaz, no hay una entrada MTP visible y el reloj tiene MTP
seleccionado, los síntomas apuntan a que no está disponible la interfaz de
archivos esperada. No identifican por sí solos la causa ni justifican forzar
manualmente un controlador MTP sobre la entrada Garmin.

### Continuar el diagnóstico en el mismo PC

Si cerrar Express y reiniciar el reloj no cambia el resultado, todavía puedes
comprobar la conexión y la detección de Windows sin disponer de otro PC:

1. **Conexión directa.** Conecta el cable Garmin al puerto USB-C del PC,
   retirando la base, hub o adaptador intermedio cuando sea posible. Que Express
   sincronice a través de un hub confirma comunicación, pero no valida todos
   los modos USB del reloj. Garmin recomienda la conexión directa en su
   [guía de detección](https://support.garmin.com/en-US/?faq=Wkf9e0fPST0gP0KoM63DK9).
   Comprueba después si aparece el almacenamiento; no hace falta compilar.
2. **Regenerar la entrada del Garmin.** Si la conexión directa tampoco cambia
   nada, espera a que termine cualquier transferencia y cierra Express. En
   el Administrador de dispositivos, desinstala únicamente la entrada
   `Garmin USB GPS`, conservando el paquete de controlador si se ofrece la
   opción de eliminarlo. Vuelve a conectar el reloj y busca cambios de hardware.
   Es una prueba de reinstalación del dispositivo, no una solución confirmada
   para este modelo. Microsoft documenta la
   [reinstalación desde el Administrador de dispositivos](https://support.microsoft.com/en-us/windows/update-drivers-through-device-manager-in-windows-ec62f46c-ff14-c91d-eead-d7126dc1f7b6).
3. **Si aparece una entrada MTP con error.** Anota el código y utiliza la
   actualización automática del controlador o Windows Update. Ese es un estado
   distinto de tener únicamente `Garmin USB GPS` sin errores. Selecciona un
   controlador MTP manualmente solo si Windows lo ofrece como compatible con
   la entrada correspondiente.

En Windows 11, el segundo paso también puede hacerse desde **Terminal como
administrador**, con el Garmin conectado y Express cerrado:

```powershell
pnputil /remove-device /deviceid 'USB\VID_091E&PID_0003'
pnputil /scan-devices
```

La [documentación de PnPUtil](https://learn.microsoft.com/es-es/windows-hardware/drivers/devtest/pnputil-command-syntax)
describe ambos comandos. El primero quita las entradas coincidentes del
dispositivo, sin borrar el paquete del controlador; el segundo solicita otra
detección. No elimina archivos del reloj. Si se indica que es necesario
reiniciar Windows, guarda tu trabajo y reinicia antes de repetir la comprobación.
No lo sustituyas por una eliminación de todos los dispositivos USB ni por
`/delete-driver`.

Microsoft incluye el controlador de clase MTP mediante
[`WpdMtp.inf`](https://learn.microsoft.com/es-es/windows-hardware/drivers/portable/the-mtp-setup-information---inf--file).
Que el archivo exista no confirma que el reloj esté presentando una interfaz
compatible. Reinstalarlo o forzar su selección sobre una interfaz propietaria
no equivale a activar MTP en el dispositivo.

La instalación de
[Media Feature Pack](https://support.microsoft.com/es-es/windows/experience/platform-variants/media-feature-pack-list-for-windows-n-editions)
corresponde a las ediciones **N** de Windows; no es una reparación general para
Windows 11 Home. Del mismo modo, que `WPDBusEnum` esté parado en una consulta
no basta para diagnosticar una avería: comprueba su configuración y sus
desencadenadores antes de cambiar servicios.

### Comparación con otro PC, cuando esté disponible

Si las pruebas anteriores fallan, prueba otro PC Windows manteniendo el mismo
cable y adaptador, si lo utilizas. No hace falta instalar Express ni compilar una
esfera para comprobar si el Explorador permite abrir `GARMIN/APPS`.

- Si funciona allí, el problema depende del primer PC o de su conexión USB.
- Si falla también allí, sigue sin quedar aislado el reloj del cable y el
  adaptador. Prueba una conexión de datos conocida o consulta al
  [soporte de Garmin](https://support.garmin.com/es-ES/?productSearch=57)
  con el modelo, firmware, identificador USB y resultados en ambos equipos.

## 3. Compilar, copiar y activar

Cuando puedas abrir `GARMIN/APPS`, ejecuta desde la raíz del repositorio el
comando de la esfera elegida:

| Esfera | Comando | Archivo que se copia |
| --- | --- | --- |
| Modular One | `.\scripts\build.ps1 -Project modular-one` | `watchfaces/modular-one/bin/ModularOne.prg` |
| Pilot Analog | `.\scripts\build.ps1 -Project pilot-analog` | `watchfaces/pilot-analog/bin/PilotAnalog.prg` |
| Stride Digital | `.\scripts\build.ps1 -Project stride-digital` | `watchfaces/stride-digital/bin/StrideDigital.prg` |

El script compila con destino `fr170`, avisos activados y la clave de firma
existente. Necesita el SDK y el perfil instalados como indica el
[README](../README.md#preparación-y-compilación). La clave permanece en el PC.

1. Copia únicamente el `.prg` de la tabla a `GARMIN/APPS` del reloj mediante el
   Explorador. No copies la carpeta `bin`, los archivos de depuración ni los
   programas Tests o Smoke. Un paquete `.iq` para la tienda no sustituye este
   archivo para la instalación local.
2. Espera a que termine la transferencia. Usa la opción de expulsión si Windows
   la ofrece y desconecta el cable cuando ya no haya una copia o actualización
   en curso.
3. Deja que el reloj procese la instalación. Desde la esfera, mantén pulsado el
   botón central izquierdo, entra en el selector de pantallas del reloj
   (`Watch Face` en el manual inglés), busca Modular One, Pilot Analog o Stride Digital y
   aplícala. El [manual explica cómo activar una esfera instalada](https://www8.garmin.com/manuals/webhelp/GUID-4A2FC8FE-7025-4AEC-946E-097B31131B45/EN-US/Forerunner_170_Series_OM_EN-US.pdf).

Para actualizar, recompila y repite la copia conservando nombre de archivo,
UUID y clave de firma. Las tres esferas tienen UUID distintos y pueden coexistir.

## 4. Si se copia, pero no aparece o falla al abrir

Comprueba primero que el reloj es el Forerunner 170 sin Music y que has usado
el `.prg` recién compilado para `fr170`. No utilices un programa generado para
el simulador de otro modelo ni un binario antiguo descargado para otro reloj.

Busca un registro `CIQ_LOG` en `GARMIN/APPS/LOGS`, si se ha generado tras el
intento. Garmin lo denomina `CIQ_LOG.YAML` en su documentación de
[errores de ejecución](https://developer.garmin.com/connect-iq/core-topics/debugging/),
también incluida en el SDK bajo `doc/docs/Core_Topics/Debugging.html`.
Si encuentras `CIQ_LOG.YML`, revisa igualmente su mensaje de error.
Un error de firma requiere revisar también el SDK y recompilar: el
[equipo de Connect IQ anunció cambios de firma que exigían SDK 7.4.3 o posterior en determinados firmwares de 2025](https://forums.garmin.com/developer/connect-iq/f/discussion/410569/side-loading-connect-iq-apps-to-q2-beta-firmware-builds).
Ese aviso no fija todos los requisitos actuales del `fr170`; usa un SDK estable
compatible con su perfil. La API mínima del manifiesto y la versión del SDK son
datos distintos. No regeneres la clave ni cambies UUID o permisos como prueba.

La instalación queda comprobada cuando puedes seleccionar la esfera y esta se
abre en el reloj. Compilar y verla en el simulador no confirma ese resultado.
También queda pendiente revisar los datos reales y el comportamiento en reposo.

## Otra vía: distribuir mediante Connect IQ

Garmin describe un flujo distinto en [Submit an App](https://developer.garmin.com/connect-iq/submit-an-app/):
exportar un paquete `.iq` con `Monkey C: Export Project` y subirlo a Connect IQ
Store. Su guía indica que el autor puede previsualizar y descargar su aplicación
mientras está pendiente de revisión; hasta su aprobación no aparece en la tienda.
Esto requiere preparar el envío como desarrollador. No equivale a pasar el `.prg`
local al móvil. Esta vía tampoco se ha probado en el reloj de Dani.
