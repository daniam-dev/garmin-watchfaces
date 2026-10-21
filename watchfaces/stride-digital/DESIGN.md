---
name: Stride Digital
description: Esfera deportiva de hora en dos líneas y columna de datos para Garmin fr170.
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
  display: {fontFamily: StrideRajdhaniNumeric, fontSize: "120px", fontFeature: "Tabular digits"}
  value: {fontFamily: StrideRajdhaniNumeric, fontSize: "30px"}
  compact: {fontFamily: StrideRajdhaniNumeric, fontSize: "19px"}
  label: {fontFamily: RobotoCondensedRegular, fontSize: "16px"}
  date: {fontFamily: RobotoRegular, fontSize: "18px"}
  weather: {fontFamily: RobotoRegular, fontSize: "22px"}
components:
  steps-bar:
    backgroundColor: "{colors.steps-track}"
    textColor: "{colors.steps}"
    width: "84px"
    height: "5px"
  body-bar:
    backgroundColor: "{colors.body-track}"
    textColor: "{colors.body}"
    width: "84px"
    height: "5px"
---

# Design System: Stride Digital

## Overview

Esfera deportiva de fondo negro, hora blanca en dos líneas a la izquierda
y una columna de pasos, Body Battery y pulso a la derecha. Las barras de
progreso quedan bajo su cifra y rótulo. Fecha y batería ocupan la parte
superior; tiempo y lluvia, el pie.

Esta composición sustituye el diseño anterior tras la auditoría del
21/10/2026. Aprovecha el círculo físico sin bisel interior ni paneles de datos.
El carácter deportivo procede de Rajdhani y del acento verde contenido.
No incluye marca ni recursos de una esfera ajena.

Los tokens del frontmatter son normativos. Su implementación está en
`source/Theme.mc`, `source/FaceRenderer.mc` y los recursos de fuentes.
Las coordenadas y contratos nativos que no caben en el esquema se conservan
en `.impeccable/design.json`. Sin segundos, animaciones ni AOD; reposo negro.

## Colors

Hora y cifras usan `text`; fecha y datos secundarios, `muted`. El verde
`accent` se aplica a pasos, Body Battery, batería suficiente y lluvia.
`steps` y `body` mantienen sus nombres semánticos y el mismo acento;
sus pistas usan el gris oscuro correspondiente. El sol usa `sun`.

El icono de batería usa `low` por debajo del 30%; el porcentaje conserva
el color del texto. Si el dato de actividad está ausente, su cifra y rótulo
pasan a gris. Cada barra permanece junto a su dato, de modo que la asociación
no depende solo del color. Una condición desconocida se dibuja con dos rayas.

## Typography

Cifras propias desde Rajdhani Bold de Indian Type Foundry, bajo SIL OFL 1.1,
condensadas al 80%. No proceden de Garmin. `tools/generate_fonts.py` genera
los BMFont `Time`, `Value` y `Compact`; se cargan una vez en `layout()`.
El TTF, la licencia y la procedencia permanecen en `resources/fonts/`.

Los tamaños del frontmatter son alturas finales recortadas a la tinta numérica.
`Time` se genera desde 186 px con dígitos tabulares: cada pareja mide 162 px,
incluidas `11` y `88`. Se muestran horas sobre minutos, sin dibujar los
dos puntos. Las dos líneas conservan su posición y anchura al cambiar la hora.

Las cifras de actividad usan `value`; si superan los 94 px de
`METRIC_WIDTH`, cambian a `compact`. La batería también usa `compact`.
Rótulos, fecha y meteorología usan las fuentes vectoriales nativas indicadas
en el frontmatter. Se conservan los recursos `Value` y `Compact`.

Las pruebas recorren las 1.440 horas y comprueban las esquinas de sus cajas
dentro del radio 193, con separación mínima de ocho píxeles entre líneas.
Verifican medidas del motor, no rasterizado ni legibilidad en pantalla.

## Layout

Lienzo circular completo de 390 × 390, centro (195, 195), sin bisel interior.
Las posiciones de texto son centros; la de batería es el origen de su icono.
Las medidas se aplican mediante `StrideTheme`.

| Elemento | Posición o medida en píxeles |
| --- | --- |
| Fecha | Centro (149, 43) |
| Batería | Icono desde (252, 52); porcentaje centrado en (297, 58) |
| Horas y minutos | Centros (130, 131) y (130, 259) |
| Columna de datos | Centro x = 284; cifras en y = 107, 192 y 277 |
| Rótulos | 27 px bajo cada cifra |
| Barras | Origen x = 242; y = 151 para pasos y 236 para Body Battery; dimensiones en los tokens de componentes |
| Tiempo y lluvia | Línea central y = 344; condición x = 118, temperatura x = 160, gota x = 218 y lluvia x = 260 |
| Separador meteorológico | x = 195, de y = 332 a 356 |

No hay separadores entre la hora y la columna, ni entre los tres datos.
La columna y las barras tienen zonas de pulsación propias, recortadas
al círculo físico. Las dos líneas de la hora no abren complicaciones.

## Elevation & Depth

Superficie plana, sin sombras ni degradados. El fondo negro es continuo.
La jerarquía depende del tamaño de la hora, la alineación de los datos y
el contraste. Las barras conservan su pista completa; el relleno representa
únicamente progreso disponible.

## Shapes

Barras rectangulares horizontales sin marcadores. El relleno se redondea al
píxel más cercano; cero o ausencia no dibujan relleno. No hay arcos de
actividad, paneles ni círculos alrededor de datos.

Batería, condición y lluvia usan primitivas vectoriales Monkey C; las curvas
del sol, nube y gota son partes de sus iconos. Los atlas de fuentes son PNG
grises de 8 bits con cobertura suavizada. No se comparten recursos con
otra esfera.

## Components

- Hora y fecha: 24 horas en dos líneas, día y mes abreviados en español.
- Pasos: cifra real con puntos de miles, rótulo `PASOS` y barra respecto al
  objetivo diario. Sin objetivo positivo no se dibuja relleno; superar el
  objetivo completa la barra y conserva la cifra real.
- Body Battery: cifra, rótulo `BODY BATTERY` y barra sobre 100.
- Pulso: cifra en latidos por minuto y rótulo `PULSO / LPM`, sin progreso.
  Lectura ausente o no positiva muestra `--`.
- Batería física: silueta, relleno proporcional y porcentaje. Ausencia
  explícita y cero válido conservado.
- Tiempo y lluvia: condición oficial, temperatura Celsius redondeada, gota
  y probabilidad de precipitación. Un dato ausente muestra `--`.
- Pulsación larga: batería, fecha y cada dato de la columna solicitan su
  vista nativa. Cada barra abre el mismo destino que su cifra; temperatura
  y lluvia comparten tiempo actual. `WatchFaceDelegate.onPress` utiliza
  `Complications.exitTo`; ante `InvalidValueException`, devuelve `false`
  sin abrir otra vista.

La compilación con avisos (`-w`) y las cuatro pruebas pasan en `fr170`.
Cubren formatos, pulso, eventos, destinos, cada píxel de las barras, las
1.440 horas, ancho tabular y dibujo con ausencias y extremos. Este último
usa un búfer de 1 × 1. El diagnóstico de dibujo en el DC completo, con el
límite normal, registra 15.304 bytes usados, 111.576 libres y 126.880 totales,
sin errores de ejecución. Sus datos son estados de prueba.

La revisión independiente final no detectó errores materiales de código,
geometría o contratos. La app está cargada en el simulador y solo se ha
inspeccionado el atlas `Time.png`. No se obtuvo captura real de 390 × 390:
Computer Use no dispone de canal nativo. Quedan pendientes la revisión
visual de rasterizado, recortes y legibilidad con datos representativos
y ausentes, y la apertura de vistas nativas en el reloj. No se presenta
la compilación ni la geometría como validación visual.

## Do's and Don'ts

- Mantener la hora blanca en dos líneas a la izquierda y los datos en la columna derecha.
- Conservar cada barra junto a su cifra y rótulo.
- Mostrar ausencia explícita y conservar los ceros válidos.
- Mantener reposo negro sin segundos, timers, animaciones ni AOD.
- No añadir arcos de actividad, paneles, círculos de datos ni bisel interior.
- No añadir marca o recursos de otra esfera.
- No convertir una condición desconocida en sol ni una ausencia en cero.
- No presentar una compilación, geometría o búfer de pruebas como captura real.