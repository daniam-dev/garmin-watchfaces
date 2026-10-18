# Modular One

<!-- impeccable:product-schema 1 -->

## Plataforma

Garmin Connect IQ; esfera nativa Monkey C para `fr170`, sin Music.

## Uso

Dani quiere consultar de un vistazo la hora, fecha, meteorología, pasos,
Body Battery y batería física en su Forerunner 170.

## Restricciones confirmadas

AMOLED circular de 390 × 390. API mínima 6.0.2 del proyecto original.
Datos oficiales de Garmin, sin servicios externos ni valores ficticios en producción.
Sin segundos, animaciones ni Always On Display. Reposo en negro.
Se conserva el identificador de aplicación y la estructura del proyecto.

## Diseño solicitado

Hora dominante de 24 horas; fecha española. Tres círculos superiores, arcos
laterales de pasos y Body Battery, y un único círculo inferior de batería física.
Referencia visual: imagen del reloj adjunta en la conversación del 18/10/2026.
Fondo negro, hora marfil, pasos cian y Body Battery coral. El círculo del tiempo
queda más alto que los de fecha y lluvia; los iconos llevan relleno. Arcos
laterales con pista de color oscuro y marcador circular según el dato real.
La imagen no está guardada como archivo en el proyecto.

El anillo de batería física utiliza los mismos estados que Pilot Analog:
carga alta desde 80%, media desde 30% y baja por debajo de 30%. El porcentaje
permanece legible sin depender del color.
