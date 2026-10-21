# Modular One

<!-- impeccable:product-schema 1 -->

## Plataforma

Garmin Connect IQ; esfera nativa Monkey C para `fr170`, sin Music.

## Uso

Dani quiere consultar de un vistazo la hora, fecha, meteorología, pasos,
minutos de intensidad semanales, Body Battery y batería física en su Forerunner 170.

## Restricciones confirmadas

AMOLED circular de 390 × 390. API mínima 6.0.2 del proyecto original.
Datos oficiales de Garmin, sin servicios externos ni valores ficticios en producción.
Sin segundos, animaciones ni Always On Display. Reposo en negro.
Se conservan el identificador de aplicación, el permiso `ComplicationSubscriber`
y la estructura del proyecto.

## Diseño solicitado

Dirección aprobada a partir de la imagen adjunta en la conversación del
21/10/2026: hora blanca grande en la parte superior, con fecha española encima;
escalas laterales largas y finas; panel central carbón para Body Battery;
tres círculos inferiores para tiempo, lluvia y batería física. Pasos y minutos
se muestran sobre la fecha, con huellas pequeñas y cronómetro, cifras debajo
y sin los rótulos `PASOS` y `ENERGÍA`. El bloque de fecha, hora, panel y círculos
se ha desplazado 20 píxeles hacia abajo para dejar espacio a estos indicadores.
Body Battery aparece solo en el panel. El ajuste posterior eleva el panel y
todo su contenido 3 píxeles, manteniendo fecha, hora y círculos en su posición.
Fondo negro, pasos cian y Body Battery turquesa. Los progresos y marcadores
representan los datos reales. La imagen no está guardada como archivo en el
proyecto. Los tokens y la composición implementada se recogen en `DESIGN.md`.

El anillo de batería física es verde desde 60%, amarillo desde 30% y rojo por
debajo de 30%. El porcentaje permite leer el estado sin depender del color.

## Datos y estados

Se conservan hora de 24 horas, fecha española, condición meteorológica,
temperatura, probabilidad de precipitación, pasos y objetivo, Body Battery y
batería física. Se añaden los minutos de intensidad semanales y su objetivo.
Los datos ausentes se muestran con `--`; el panel de Body Battery indica
también `Sin datos`; con dato muestra `Nivel actual`. Un cero válido sigue siendo cero. Una condición
meteorológica desconocida o no representada no se convierte en sol.

El arco derecho representa minutos de intensidad semanales respecto al
objetivo real de Garmin. `ActivityMonitor.getInfo()` proporciona
`activeMinutesWeek.total` y `activeMinutesWeekGoal`; el total ya pondera los
minutos vigorosos. Se leen con los pasos una vez por minuto y al despertar,
sin permisos nuevos ni consultas de sensores desde el dibujo.

Al superar el objetivo, el arco queda completo y la cifra conserva el total
real, con la unidad `min`. Sin minutos disponibles se muestra `--`; sin un
objetivo positivo se conserva la cifra disponible y no hay progreso ni marcador.
El reinicio semanal y los cambios de objetivo proceden del reloj.

Mantener pulsado un dato solicita su vista nativa mediante
`WatchFaceDelegate.onPress` y `Complications.exitTo`: pasos, minutos de
intensidad, fecha, Body Battery y batería física. Tiempo y lluvia comparten
el destino de tiempo actual. Los arcos laterales abren pasos o minutos según
el lado. Si el firmware no admite un destino y devuelve
`InvalidValueException`, no se abre una vista alternativa.

## Validación

Compilar desde la raíz con `.\scripts\build.ps1 -Project modular-one`.
El script activa los avisos del compilador (`-w`). Las pruebas Monkey C están
en `source/BatteryTests.mc`, `source/RendererTests.mc`, `source/ArcTests.mc`
y `source/InteractionTests.mc`;
se compilan en modo de pruebas (`-t`) y se ejecutan en el simulador `fr170`.
Cubren el centrado de pistas, extremos y marcadores al llenar y vaciar los
arcos, además de los datos, la distribución y las zonas de pulsación.
Las ocho pruebas pasan en `fr170`.

La compilación y las pruebas no sustituyen la revisión de una captura real
de 390 × 390 con datos representativos y ausentes. El dibujo de pruebas usa
un búfer de 1 × 1. No se ha comprobado en el reloj la apertura de las vistas
nativas; Computer Use no pudo conectar con su canal nativo para la captura.
