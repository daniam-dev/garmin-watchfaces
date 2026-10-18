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
Complications. Mantiene código y recursos independientes de Modular One.

La petición posterior del usuario sustituye Body Battery por el porcentaje
de batería del reloj. El arco superior debe tener el mismo inicio, recorrido,
grosor y relleno proporcional que el arco de pasos.
El relleno de batería indica carga alta desde 80%, media desde 30% y baja
por debajo de 30%. El porcentaje numérico conserva su legibilidad sin depender
del color.

## Evidencia

La referencia está visible en el encargo, sin archivo original localizado en
el repositorio. DESIGN.md conserva las medidas normalizadas de esa imagen.
Las capturas del simulador, cuando se obtengan, se guardan en `docs/`.
