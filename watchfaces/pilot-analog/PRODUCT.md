# Pilot Analog

<!-- impeccable:product-schema 1 -->

## Plataforma

Garmin Connect IQ / Monkey C, Watch Face para Forerunner 170 sin Music
(`fr170`), AMOLED circular de 390 × 390, API mínima 6.0.2.

## Producto y alcance confirmado

Esfera analógica independiente. La imagen adjunta al encargo de Pilot Analog
es la autoridad visual: números inclinados, cuatro complicaciones circulares,
horaria hueca, minutera sólida y segundero fino. No se incluye la caja, la
correa ni la marca del reloj fotografiado en el dibujo de la pantalla.

Hora y fecha locales. Meses españoles en mayúsculas, pasos con separador de
miles `.` y temperatura Celsius. Batería del dispositivo, meteorología Garmin,
fecha y pasos diarios. Los datos ausentes conservan `--`; no se inventan.

## Ciclo de vida

Sin AOD, temporizadores, red o animaciones propias. Segundero en las
actualizaciones activas que entrega Garmin. Pantalla negra en reposo.
Los datos se refrescan al despertar y por minuto. Sin suscripciones a
Complications. El permiso `ComplicationSubscriber` permite abrir las vistas
nativas con `Complications.exitTo`; no añade suscripciones ni Body Battery.
Mantiene código y recursos independientes de Modular One.

La petición posterior del usuario sustituye Body Battery por el porcentaje
de batería del reloj. El arco superior debe tener el mismo inicio, recorrido,
grosor y relleno proporcional que el arco de pasos.
El relleno de batería indica carga alta desde 80%, media desde 30% y baja
por debajo de 30%. El porcentaje numérico conserva su legibilidad sin depender
del color.

Mantener pulsado cada círculo solicita la vista nativa de batería del
dispositivo, tiempo actual, fecha o pasos. `WatchFaceDelegate.onPress` usa
`Complications.exitTo`; si el firmware rechaza el destino con
`InvalidValueException`, el evento devuelve `false` sin abrir otra vista.

## Evidencia

La referencia está visible en el encargo, sin archivo original localizado en
el repositorio. DESIGN.md conserva las medidas normalizadas de esa imagen.
Las capturas del simulador, cuando se obtengan, se guardan en `docs/`.

La compilación con avisos (`-w`) y las siete pruebas en el simulador `fr170`
pasan, incluidas las zonas de pulsación. El dibujo de pruebas usa un búfer
de 1 × 1 y no valida el aspecto. No se obtuvo una captura real a 390 × 390:
Computer Use no pudo conectar con su canal nativo. La apertura de las vistas
nativas queda pendiente de comprobar en el reloj.
