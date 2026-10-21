# Auditoría de Stride Digital

Estado del 22/10/2026: el ajuste inspirado en imágenes oficiales de Garmin
mantiene la composición resuelta el día anterior. Cada línea de la hora mide
176 × 130 px tras el retoque de tamaño. La fuente Barlow Condensed ExtraBold
sustituye a Rajdhani por petición del usuario, recta y sin sesgo añadido (0°).
Mantiene
horas de contorno lima y minutos blancos, iconos vectoriales propios y barras
de diez segmentos; Body Battery y lluvia usan cian contenido. Compilación
con avisos y cuatro pruebas en `fr170` superadas. El diagnóstico en el DC
completo registra 16.464 de 126.880 bytes usados, sin errores de ejecución.
Se inspeccionaron los atlas `Time.png`, `TimeOutline.png` y `Value.png`, además de las
referencias oficiales guardadas. Sigue pendiente una captura real de Stride
a 390 × 390: Computer Use no dispone de canal nativo. También queda pendiente
abrir los destinos en el reloj. `DESIGN.md` describe el diseño vigente;
`.impeccable/references/README.md` recoge las fuentes de inspiración.

## Resolución anterior

Resolución del 21/10/2026: se implementó el rediseño aprobado, con hora en dos
líneas a la izquierda, columna de datos a la derecha y barras junto a pasos y
Body Battery. Se retiraron los arcos y se ajustaron los destinos táctiles a la
nueva composición. Compilación con avisos y cuatro pruebas en `fr170`
superadas; la comprobación técnica incluye las 1.440 horas y cada píxel de las
barras. El diagnóstico de dibujo con memoria normal usa 15.304 de 126.880
bytes, sin errores de ejecución. La revisión independiente final no detectó
errores materiales de código, geometría o contratos. No hay validación visual:
solo se inspeccionó el atlas `Time.png`; Computer Use no dispone de canal
nativo para obtener una captura. Siguen pendientes una captura real de
390 × 390 y los destinos en el reloj. `DESIGN.md` describe el diseño vigente.

El informe que sigue se conserva como histórico de la versión previa. Sus
medidas, resultados y referencias de líneas corresponden a esa base.

## Informe histórico

21/10/2026. Implementación revisada en `d06d9d8`; Stride no cambia respecto a
`c246b07`. Objetivo: valorar su uso y darle una identidad Garmin propia,
distinta de Modular One. Auditoría con `to-prompt` e `impeccable`, adaptada a
Monkey C y al círculo de 390 × 390 de `fr170`.

## Dictamen

La base técnica permite conservar fuentes, datos y destinos nativos. La
composición necesita una decisión más profunda que cambiar colores: repite
fecha sobre hora horizontal, dos arcos laterales y tres datos inferiores,
también presentes en Modular. Es una conclusión del código de dibujo; falta
una captura actual para juzgar el equilibrio y el acabado en pantalla.

Se contrastaron una valoración de diseño y otra técnica independientes.
No se ha modificado la implementación ni el diseño vigente de Stride.

## Hallazgos prioritarios

### P1 de diseño: la estructura se parece demasiado a Modular

`source/Theme.mc:18` y `source/FaceRenderer.mc:46` definen dos arcos de 168°.
La fecha, hora horizontal y terna inferior aparecen en
`source/FaceRenderer.mc:57` y `source/FaceRenderer.mc:62`. Modular conserva
ese mismo recorrido principal, aunque añade el panel de Body Battery y
los círculos inferiores.

Impacto: Rajdhani y el verde distinguen el acabado, pero no bastan para
cumplir la petición de dos esferas con personalidad distinta. Esta prioridad
afecta al objetivo de diseño; no significa que haya un fallo de ejecución.

Recomendación: cambiar la organización de hora, datos y progreso. Conservar
la fuente propia; volver a sustituirla no resolvería el parecido.

### P2 de diseño: el arco derecho tiene una asociación ambigua

Ambos arcos usan el mismo verde (`source/Theme.mc:10`). El derecho mide
Body Battery (`source/FaceRenderer.mc:47`), pero el dato de la columna derecha
es pulso y Body Battery está en el centro (`source/FaceRenderer.mc:63`).

Impacto probable: por proximidad, el arco derecho puede interpretarse como
progreso del pulso. Es una inferencia de composición, no un error de datos
ni un resultado de una prueba con usuarios.

Recomendación: colocar cada indicador junto a su cifra y rótulo. El pulso
debe seguir mostrando latidos por minuto, sin porcentaje inventado.

### P2 de interacción: hay tramos de arco sin destino al mantener pulsado

El dibujo llega aproximadamente a y = 5 y y = 385, mientras que
`source/ComplicationDelegate.mc:15` solo acepta el anillo entre y = 60 y
y = 350. Los puntos (99, 30), del arco izquierdo, y (291, 360), del derecho,
quedan sobre el recorrido dibujado y devuelven `null` en el reconocimiento.

Impacto: mantener pulsado esos tramos no solicita la complicación que sí
se solicita desde el lateral del mismo arco. El contrato documentado promete
acceso desde los arcos completos.

Recomendación: si se conservan arcos, derivar la zona del mismo barrido
angular y ampliarla hacia dentro, respetando los destinos cercanos. Añadir
cobertura de los extremos: `source/LogicTests.mc:38` solo comprueba el centro
lateral de cada arco. Si se adopta otra composición, definir las zonas a
partir de los nuevos indicadores.

No se han encontrado problemas P0 ni P1 técnicos en esta revisión.

## Dirección propuesta

Hora blanca en dos líneas, horas sobre minutos, ocupando el lado izquierdo.
La fuente Rajdhani actual aporta el carácter deportivo sin añadir colores
a cada dígito. A la derecha, una columna de pasos, Body Battery y pulso con
rótulos breves. Pasos y Body Battery tendrían indicadores lineales pequeños
junto a sus cifras; pulso conservaría solo su valor y unidad.

Fecha y batería arriba; tiempo y lluvia al pie. Fondo negro, blanco cálido
y el verde actual como acento. Sin paneles, círculos inferiores ni dos arcos
simétricos. El contenido seguiría aprovechando el círculo completo, con
espacio suficiente en sus estrechamientos superior e inferior.

Esta distribución cambia la silueta y vincula cada progreso a su dato. Los
datos comunes con Modular se conservan porque son útiles; cambia su
organización. Es una propuesta para sustituir la composición conservada en
`PRODUCT.md`, todavía sin implementar ni validar visualmente.

## Comprobaciones y aspectos que conservar

| Área | Resultado y alcance |
| --- | --- |
| Compilación | `scripts/build.ps1 -Project stride-digital`: correcta, con avisos activados y sin avisos emitidos. |
| Pruebas | `scripts/test.ps1 -Project stride-digital`: 4 correctas, 0 fallos, 0 errores en el simulador `fr170`. |
| Tipografía | Las pruebas recorren las 1.440 horas; `88:88` mide 328 × 112 px. Verifican anchos y separación, no legibilidad. |
| Ausencias | `--` para dato ausente; cero válido conservado; pulso cero tratado como lectura inválida. |
| Datos y arquitectura | Proveedor separado del dibujo; datos oficiales; fuentes propias con licencia; sin dependencias de otra esfera. |
| Ciclo de vida | Suscripciones de Body Battery y pulso liberadas al ocultar; reposo negro; sin timers, segundos ni AOD. Revisión de código. |
| Interacción | Destinos nativos mediante pulsación larga y tratamiento de destino rechazado; discrepancia de extremos detallada arriba. Apertura real pendiente en el reloj. |
| Presentación | Colores en tokens; fondo negro y hora blanca. Rasterizado, legibilidad y ajuste al círculo pendientes de captura. |

Las pruebas de dibujo usan un búfer de 1 × 1: ejercitan llamadas y estados,
pero no permiten inspeccionar los píxeles del reloj. No se asigna una nota
visual ni una puntuación de conformidad iOS/Android a una esfera Garmin.

La versión actual se envió al simulador para inspección manual. Su registro
de errores está vacío. No se obtuvo una captura actual: Computer Use no
dispone de conexión con su canal nativo; esto no demuestra un fallo del
simulador. Quedan pendientes una captura real de 390 × 390 con datos
representativos y ausentes, y la comprobación de destinos en el reloj.

La siguiente intervención de diseño debe resolver primero la composición,
después las zonas de pulsación y finalmente comprobar píxeles y legibilidad
en el simulador o reloj. No requiere cambiar UUID, permisos, API ni modelo.
