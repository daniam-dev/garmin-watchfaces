---
name: Stride Digital
description: Esfera deportiva de hora grande y progreso al borde para Garmin fr170.
colors:
  background: "#000000"
  text: "#F2F4EF"
  muted: "#A6ADA8"
  track: "#2C312E"
  steps-track: "#2C312E"
  body-track: "#2C312E"
  accent: "#9ACD62"
  steps: "#9ACD62"
  body: "#9ACD62"
  sun: "#DAB779"
  low: "#DF827A"
typography:
  display: {fontFamily: StrideRajdhaniNumeric, fontSize: "112px"}
  value: {fontFamily: StrideRajdhaniNumeric, fontSize: "30px"}
  compact: {fontFamily: StrideRajdhaniNumeric, fontSize: "19px"}
  label: {fontFamily: RobotoCondensedRegular, fontSize: "16px"}
  date: {fontFamily: RobotoRegular, fontSize: "22px"}
components:
  activity-rail:
    textColor: "{colors.steps}"
    size: "382px"
  body-rail:
    backgroundColor: "{colors.body-track}"
    textColor: "{colors.body}"
    size: "382px"
---

# Design System: Stride Digital

## Overview

Esfera nativa Monkey C de consulta rápida para `fr170`, con composición
deportiva cercana a Garmin. Fondo negro, hora blanca dominante y dos arcos
en el borde físico. La parte inferior agrupa pasos, Body Battery y pulso
en tres columnas. Batería y fecha quedan encima de la hora;
tiempo y lluvia, al pie. No incluye marca ni imágenes de una esfera ajena.

La fuente de las medidas y colores es `source/Theme.mc`; las fuentes y los
componentes se extraen de `source/FaceRenderer.mc`. Es una composición propia,
sin captura de referencia persistente. Sin segundos, animaciones ni AOD;
el reposo es negro.

## Colors

Los valores normativos están en el frontmatter. Hora y cifras blancas, con
un único verde suave en el progreso de pasos y Body Battery, batería suficiente
y lluvia. Rótulos y fecha en gris claro, pistas y separadores oscuros.
El sol usa amarillo cálido; batería baja, coral. La aclaración de Dani pide
carácter Garmin en los números y descarta la hora multicolor anterior.

El icono de batería pasa a rojo coral por debajo del 30%; el porcentaje permanece
blanco. Los rótulos, cifras y longitudes permiten reconocer cada dato sin
depender solo del color. Una condición desconocida se dibuja con dos rayas.

## Typography

Cifras propias desde Rajdhani Bold de Indian Type Foundry, bajo SIL OFL 1.1,
con trazos rectos, contraformas más cuadradas y anchura reducida al 80%.
No es una fuente extraída de Garmin. `tools/generate_fonts.py` genera los
recursos BMFont `Time`, `Value` y `Compact`, cargados una vez en `layout()`.
El TTF, la licencia y la procedencia se conservan en `resources/fonts/`.

Los tamaños del frontmatter son las alturas de línea finales del recurso,
recortadas a la tinta de las cifras: 112, 30 y 19 píxeles. La hora usa `display`;
actividad y pulso, `value`; batería y cifras largas, `compact`. Si una cifra
supera 82 píxeles, se reduce a `compact`. `999.999` mide 77 píxeles así.
Rótulos y fecha conservan Roboto nativa de Garmin, sin cambios de posición.

El simulador mide `88:88` en 328 × 112 píxeles. Las pruebas recorren las 1.440
horas y exigen ancho máximo de 342 píxeles. La caja de hora ocupa y = 108–220,
con cuatro píxeles hasta la regla. Esto verifica medidas, no la legibilidad
visual del reloj ni su fidelidad a una referencia.

## Layout

Lienzo circular completo de 390 × 390, centro (195, 195). Sin bisel interior.
Los arcos tienen radio 191 y ancho 6: su borde exterior alcanza radio 194,
a un píxel del círculo físico. Cada arco recorre 168°; el izquierdo empieza
a 96° en sentido antihorario y el derecho, a 84° en sentido horario.

| Elemento | Posición o medida en píxeles |
| --- | --- |
| Batería | Icono desde (154, 28), porcentaje centrado en (207, 34) |
| Fecha | Centro (195, 74) |
| Hora | Centro (195, 164) |
| Separador horizontal | De (49, 224) a (341, 224) |
| Columnas de actividad | Centros x = 96, 195 y 294; cifras y = 258; rótulos y = 287 |
| Separadores de columnas | x = 146 y 244, de y = 244 a 295 |
| Tiempo y lluvia | Línea central y = 334; separación en x = 195 |

La composición y las zonas de pulsación permanecen dentro del círculo. No
se reduce el contenido para simular una caja o un bisel.

## Elevation & Depth

Superficie plana, sin sombras ni degradados. Fondo negro continuo y trazos
de separación finos. Las pistas conservan el recorrido completo; el color
indica únicamente el progreso disponible.

## Shapes

Arcos finos continuos sin marcadores. Cero o ausencia no dibujan el arco de
primer plano; el ángulo se redondea antes de llamar a `drawArc`. Los iconos
de batería, condición y lluvia se dibujan con primitivas vectoriales Monkey C.
Los atlas de fuentes son PNG grises de 8 bits con cobertura suavizada;
no se comparten recursos con otra esfera.

## Components

- Hora y fecha: 24 horas, día y mes abreviados en español; hora blanca y fecha gris.
- Arcos: pasos respecto al objetivo diario a la izquierda; Body Battery
  sobre 100 a la derecha. Se limita el progreso al 100%, conservando la
  cifra real. Sin objetivo positivo de pasos no se dibuja su progreso.
- Columnas: rótulos `PASOS`, `BODY BATTERY` y `PULSO / LPM`. Pasos con puntos
  de miles; pulso en latidos por minuto, con `--` si no hay lectura válida.
  Las dos líneas verticales solo separan columnas. Se retira la barra corta
  de Body Battery, cuyo progreso ya se muestra en el arco derecho.
- Batería física: silueta, relleno proporcional y porcentaje, con ausencia
  explícita. El cero válido se conserva.
- Tiempo: condición oficial y temperatura Celsius redondeada; lluvia con
  gota y porcentaje. Un dato ausente muestra `--`.
- Pulsación larga: batería, fecha y cada columna solicitan su vista nativa;
  ambos valores meteorológicos comparten tiempo actual. Los arcos abren
  pasos o Body Battery según el lado; la columna de pulso abre frecuencia
  cardíaca. `WatchFaceDelegate.onPress` utiliza
  `Complications.exitTo`; si el firmware rechaza el destino con
  `InvalidValueException`, devuelve `false` sin abrir otra vista.

La compilación con avisos (`-w`) y las cuatro pruebas en el simulador `fr170`
pasan. Cubren formatos, objetivos, pulso ausente/cero/válido, las 1.440 horas
con los recursos nuevos, reconocimiento
de eventos de ambas complicaciones, zonas de pulsación y dibujo con datos
ausentes y extremos. El dibujo de estas pruebas usa un búfer de 1 × 1;
no valida píxeles. `tests/Smoke.mc` ejecutó el dibujo sobre el DC completo con
datos ausentes, máximos y cero, con el límite normal de memoria: 15.224 bytes
usados de 126.880, sin inspeccionar sus píxeles.
La captura aportada por Dani en esta conversación muestra la versión anterior
con minutos semanales y hora blanca; no está guardada como archivo local.
No se obtuvo una nueva captura real de 390 × 390: Computer Use no pudo conectar con
su canal nativo. La legibilidad, los posibles recortes y la apertura de las
vistas nativas en el reloj siguen pendientes. No se presenta una
previsualización HTML/CSS como sustituto de esta revisión.

## Do's and Don'ts

- Mantener la hora dominante y los arcos junto al borde físico.
- Conservar los colores y rótulos de cada dato.
- Mostrar ausencia explícita y conservar los ceros válidos.
- Mantener reposo negro sin segundos, timers, animaciones ni AOD.
- No añadir un bisel interior, marca o recursos de otra esfera.
- No convertir una condición desconocida en sol ni una ausencia en cero.
- No presentar una compilación, geometría o búfer de pruebas como captura real.
