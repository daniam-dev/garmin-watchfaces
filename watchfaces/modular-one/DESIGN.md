---
name: Modular One
description: Esfera Garmin con hora central, círculos y arcos.
colors:
  background: "#000000"
  text: "#FFF9EC"
  muted: "#BDBDBB"
  steps: "#20E0DF"
  steps-track: "#106E70"
  body: "#FF997A"
  body-track: "#874B41"
  outline: "#333536"
  weather: "#F8C32A"
  cloud: "#D8DAD8"
  battery: "#929496"
  battery-high: "#A8CFA0"
  battery-medium: "#DAB779"
  battery-low: "#E08A80"
typography:
  display: {fontFamily: RobotoCondensedBold, fontSize: "116px"}
  value: {fontFamily: RobotoRegular, fontSize: "24px"}
  small: {fontFamily: RobotoRegular, fontSize: "20px"}
  date: {fontFamily: RobotoRegular, fontSize: "13px"}
  compact: {fontFamily: RobotoCondensedBold, fontSize: "21px"}
  day: {fontFamily: RobotoRegular, fontSize: "28px"}
---

# Design System: Modular One

## Overview

Esfera nativa Monkey C para `fr170`, circular de 390 × 390. Hora marfil dominante sobre negro y datos secundarios alrededor, según la referencia del usuario. Documento extraído de `Theme.mc`, `FaceRenderer.mc` y `Components.mc`; no acredita una comparación visual con la imagen.

## Colors

Cian para pasos y lluvia; coral para Body Battery. Los arcos tienen pistas oscuras del mismo grupo de color. Marfil para hora y cifras, gris atenuado para día de la semana y gris oscuro para contornos. Sol amarillo y nubes gris claro. Los valores normativos están en el frontmatter.

El relleno de la batería física comparte paleta y umbrales con Pilot Analog:
verde salvia `#A8CFA0` desde 80%, amarillo cálido `#DAB779` desde 30% y rojo
coral `#E08A80` por debajo de 30%. Solo cambia el relleno del anillo; icono y
porcentaje conservan el marfil. Ausencia: `--` sin relleno; cero válido: `0%`
sin relleno. El gris `battery` queda como color neutro para datos inválidos.

## Typography

Fuentes vectoriales oficiales de Garmin, sin TTF empaquetados. Alternativas de sistema: `FONT_NUMBER_HOT` para hora; `FONT_SMALL` para valores y día; `FONT_XTINY` para texto pequeño y compacto; `FONT_TINY` para fecha. Textos centrados horizontal y verticalmente. Los pasos usan la fuente compacta si superan 96 píxeles de ancho con la fuente de valores.

## Layout

Coordenadas fijas en píxeles. Centro de pantalla (195, 195); hora en (195, 201). Fecha y lluvia en (113, 106) y (277, 106), radio 36. Tiempo elevado en (195, 92), radio 39.

Arcos laterales centrados en pantalla: radio 180, grosor 12, recorrido de 168 grados. Pasos empieza a 96 grados en sentido antihorario y Body Battery a 84 grados en sentido horario. Dejan huecos de 12 grados arriba y abajo y más espacio frente a las complicaciones. Iconos en (88, 277) y (301, 277), cifras a la altura 302. Batería física en (195, 311).

## Elevation & Depth

Plano, sin sombras ni degradados. Contornos para delimitar círculos y pistas oscuras para mostrar el recorrido disponible.

## Shapes

Contornos circulares de 2 píxeles, iconos con primitivas y rellenos y arcos de extremos redondeados. Marcadores laterales de círculos concéntricos: radios 9, 7 y 5, en acento, marfil y acento.

## Components

- Fecha: día de la semana atenuado, número de día destacado y mes debajo.
- Tiempo: condición oficial y temperatura; dos rayas para condición desconocida o no representada.
- Lluvia: nube, lluvia cian y porcentaje de precipitación.
- Pasos y Body Battery: progreso real; marcador sólo con datos disponibles. Progreso cero no dibuja arco de primer plano.
- Pasos: dos huellas separadas, cada una con suela elíptica y talón. Body Battery: silueta sólida con cabeza, brazos y cuerpo, y rayo separado a su derecha.
- Batería física: contorno de radio 44 y anillo de radio 39, grosor 6, sin marcador; icono en (195, 301) y porcentaje en (195, 326).

## Do's and Don'ts

- Mantener la hora dominante y el círculo del tiempo elevado.
- Conservar la relación cian/pasos y coral/Body Battery.
- Situar los marcadores según datos reales disponibles.
- Mantener reposo negro, sin segundos ni animaciones.
- No presentar la compilación como validación visual de la referencia.
