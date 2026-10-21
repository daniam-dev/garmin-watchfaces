---
name: Modular One
description: Esfera Garmin con hora superior, escalas laterales y panel de Body Battery.
colors:
  background: "#000000"
  text: "#F4F5F3"
  muted: "#A4AAA8"
  steps: "#42BDD9"
  intensity: "#F0B965"
  body: "#37CFAB"
  body-track: "#28574B"
  body-outline: "#326153"
  outline: "#3B4546"
  surface: "#102823"
  weather-dial: "#282216"
  rain-dial: "#12242B"
  battery-dial: "#1C251B"
  weather-outline: "#71582F"
  rain-outline: "#2B5864"
  battery-outline: "#465B3B"
  tick: "#727A78"
  weather: "#F8C32A"
  cloud: "#D8DAD8"
  battery: "#929496"
  battery-high: "#9FD76B"
  battery-medium: "#E5BC5B"
  battery-low: "#EC7975"
typography:
  display: {fontFamily: RobotoCondensedBold, fontSize: "148px"}
  calendar: {fontFamily: RobotoRegular, fontSize: "17px"}
  value: {fontFamily: RobotoRegular, fontSize: "26px"}
  label: {fontFamily: RobotoRegular, fontSize: "16px"}
  compact: {fontFamily: RobotoCondensedRegular, fontSize: "14px"}
  date: {fontFamily: RobotoRegular, fontSize: "19px"}
  body: {fontFamily: RobotoRegular, fontSize: "29px"}
rounded:
  panel: "17px"
components:
  body-panel:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    rounded: "{rounded.panel}"
    width: "274px"
    height: "82px"
  data-dial:
    textColor: "{colors.text}"
    size: "66px"
---

# Design System: Modular One

## Overview

Esfera nativa Monkey C para `fr170`, circular de 390 × 390. La hora blanca
domina la parte superior, con la fecha española encima. Dos escalas laterales
enmarcan el panel de Body Battery y los tres círculos inferiores. Cian para
pasos; ámbar para los minutos semanales del arco derecho; turquesa para el
panel de Body Battery. La hora se amplía con cifras gruesas y condensadas,
conservando el blanco. El panel se compacta y los círculos reciben tintes
oscuros para añadir color sin competir con la hora.

Esta composición corresponde al cambio aprobado a partir de la imagen adjunta
en la conversación del 21/10/2026, sin archivo persistente en el repositorio.
La documentación se extrae de `Theme.mc`, `FaceRenderer.mc` y `Components.mc`.

La compilación con `-w` terminó sin avisos y pasaron ocho pruebas en el
simulador Garmin `fr170`: umbrales de batería, medidas de fuentes reales,
dibujo con datos ausentes/máximos/cero y separación geométrica de arcos y
círculos, además de ausencia, cero y exceso de objetivo de minutos, las 1.440
horas posibles y zonas de pulsación larga adaptadas. Se comprueba
la simetría en los 360 grados y el llenado/vaciado en 1.001 niveles; el dibujo
nativo se ejercita en 0%, 1%, 25%, 50%, 75%, 99% y 100%. Las medidas
y el dibujo usan un búfer de 1 × 1; no constituyen una
revisión visual. Queda pendiente comprobar una captura real de 390 × 390:
Computer Use no pudo conectar con su canal nativo, aunque el simulador sí
ejecutó las pruebas. No se certifica el aspecto ni la fidelidad a la imagen.

## Colors

Los valores normativos están en el frontmatter y corresponden a `Theme.mc`.
Cian para pasos, lluvia y su cifra; ámbar para minutos semanales; turquesa para Body Battery.
Blanco para hora y cifras; gris atenuado para datos ausentes del indicador
central. Las escalas son grises, con pista oscura y
progreso fino de color. El panel es petróleo oscuro; el círculo de tiempo tiene
fondo ocre oscuro, el de lluvia azul oscuro y el de batería verde oscuro,
con contornos del mismo matiz.
Sol amarillo y nubes claras representan las condiciones oficiales disponibles.

La batería física usa verde desde 60%, amarillo desde 30% y rojo por debajo de
30%. Solo cambia el progreso del anillo: icono y porcentaje siguen blancos.
Los datos inválidos tienen un color neutro; los proveedores conservan la
ausencia como `null`. Sin dato o con cero no se dibuja progreso de primer plano.

## Typography

Fuentes vectoriales oficiales Garmin, sin TTF empaquetados. Hora con
`RobotoCondensedBold` a 148 px; el resto conserva Roboto regular. `23:59`
mide 291 px de ancho en el simulador, frente a 204 px con el rol anterior de
96 px: el aumento de anchura es del 43% aproximadamente. El alto de fuente
devuelto por Garmin es 148 px, que no equivale a la caja visible de los dígitos.

La hora usa el rol `display`; temperatura y lluvia, `value`; texto secundario y cifras superiores,
`label`; fecha española, `calendar`; título del panel y porcentaje de batería, `date`; cifra de
Body Battery, `body`. La lluvia pasa de `value` a `date` si supera 52 píxeles
de ancho, para que `100%` quepa en el círculo.
Los minutos usan `compact` si el texto con unidad supera 56 píxeles con `label`.

Si Garmin no proporciona la fuente vectorial, la hora conserva
`FONT_NUMBER_HOT`; valores y Body Battery, `FONT_SMALL`; rótulos,
`FONT_XTINY`; fecha, `FONT_TINY`. El texto se centra verticalmente; el panel y
la cifra de pasos tienen alineación horizontal propia.

## Layout

Coordenadas fijas en píxeles sobre un lienzo circular; centro (195, 195).
Pasos y minutos sobre la fecha; fecha en (195, 80), hora en (195, 139).
No hay rótulos `PASOS` ni `ENERGÍA`.

Escalas laterales centradas en pantalla: 43 marcas por lado, separadas cuatro
grados y con trazo de 2 píxeles; cada séptima marca es más larga. Llegan al
radio 184, desde 172 para marcas largas y 177 para cortas. Pista y progreso
comparten radio 180, grosor 4 y recorrido 168 grados. Pasos empieza a 96 grados
en sentido antihorario; la escala derecha a 84 en sentido horario. El marcador
simple tiene radio 5 y sigue el mismo radio que el arco.

Panel de Body Battery en (58, 188), de 274 × 82. Semicírculo centrado en
(113, 232), radio 32 y grosor 13; cifra centrada en (113, 234). Título y estado
alineados a la izquierda desde x = 169, en y = 213 e y = 238.

Tiempo, lluvia y batería física comparten y = 310 y radio 33, con centros en
x = 116, 195 y 274. Iconos de tiempo y lluvia en y = 295 y valores en y = 324.
Batería: anillo de radio 29 y grosor 4, icono en y = 299, porcentaje en y = 322.
Los círculos laterales se mantienen dentro de las escalas y de sus marcadores.

Arriba, pasos y minutos se centran en x = 158 y x = 232. Los iconos se refieren
a y = 38 y las cifras están en y = 58, dentro de los arcos y sobre la fecha. Las huellas
usan una escala de 0,7 respecto a su tamaño anterior, unos 15 × 20 píxeles;
los minutos se identifican con un cronómetro compacto y la unidad `min`.
La hora conserva su centro y gana tamaño. La fecha tiene un rol propio de
17 px y los indicadores superiores suben 2 px. El panel conserva el borde
inferior en y = 270 y todos sus contenidos en sus posiciones; se reduce el
margen superior. Los círculos inferiores y las escalas conservan su posición.
La zona pulsable de fecha termina en y = 92 para no invadir la hora ampliada.

## Elevation & Depth

Sin sombras ni degradados. El panel y los círculos se distinguen del fondo por
su matiz oscuro y por un contorno de un píxel. Las pistas indican el recorrido completo
y el color muestra el progreso disponible.

## Shapes

Panel rectangular de esquinas redondeadas, círculos inferiores y arcos con
extremos redondeados. Escalas con marcas radiales y marcador circular simple.
Pista, relleno y marcador usan el mismo centro, radio y ángulo final. Como
`drawArc` trabaja con ángulos enteros, el progreso se redondea una sola vez
al grado más cercano. Las marcas, remates y marcadores redondean sus posiciones
respecto al centro con simetría entre cuadrantes; no se truncan coordenadas
absolutas de forma independiente. Los remates usan la mitad del grosor con
división decimal. El anillo completo se dibuja con `drawCircle`, sin remates
superpuestos; el progreso cero no dibuja relleno.
Iconos dibujados con primitivas Monkey C, rellenos y trazos, sin glifos ni
recursos de otras esferas. Las huellas separan suela y talón.

## Components

- Hora y fecha: formato de 24 horas; hora blanca gruesa y condensada;
  día de la semana y mes abreviados en español, en gris y con fuente propia.
- Escalas: pasos respecto a su objetivo diario y minutos de intensidad respecto
  al objetivo semanal de Garmin. El progreso se limita al recorrido completo,
  conservando las cifras reales aunque superen sus objetivos. Sin dato o sin
  objetivo positivo no hay marcador ni progreso; en cero válido el marcador
  queda al comienzo, sin arco de primer plano.
- Panel de Body Battery: dato oficial, semicírculo y cifra. Muestra `--` y
  `Sin datos` cuando falta; con dato muestra `Nivel actual`.
- Tiempo: condición oficial y temperatura redondeada. Una condición desconocida
  o no representada dibuja dos rayas; una temperatura ausente muestra `--`.
- Lluvia: nube y trazos cian, con probabilidad de precipitación; `--` si falta.
- Batería física: anillo de progreso sin marcador, icono blanco y porcentaje.
  Ausencia: `--` sin relleno; cero válido: `0%` sin relleno.
- Indicadores superiores: huellas cian pequeñas y pasos con puntos para separar
  miles; cronómetro ámbar y minutos semanales con unidad `min`. Cifras
  blancas y ausencia explícita con `--`. El cronómetro y el arco derecho usan
  ámbar; Body Battery aparece solo en el panel.
- Pulsación larga: panel hacia Body Battery; pasos y arco izquierdo hacia pasos;
  minutos y arco derecho hacia minutos de intensidad; fecha hacia fecha;
  tiempo y lluvia hacia tiempo actual; círculo de batería hacia batería.
  `WatchFaceDelegate.onPress` solicita cada vista con `Complications.exitTo`.
  Si el firmware rechaza el destino con `InvalidValueException`, el evento
  devuelve `false`. La apertura de las vistas nativas queda pendiente de
  comprobar en el reloj.

## Do's and Don'ts

- Mantener la hora dominante arriba y la fecha española encima.
- Conservar cian para pasos y turquesa para Body Battery.
- Conservar las escalas largas y finas, el panel central y los tres círculos inferiores.
- Situar los progresos y marcadores según los datos reales disponibles.
- Mantener el reposo negro, sin AOD, segundos ni animaciones.
- No convertir un dato ausente en cero ni una condición desconocida en sol.
- No presentar compilación, medidas de fuentes o geometría como revisión visual.
