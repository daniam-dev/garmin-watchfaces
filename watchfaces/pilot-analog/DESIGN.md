# Pilot Analog — referencia a 390 × 390

Superficie: `source/PilotAnalogView.mc`. Modo: consulta de hora y datos de un
vistazo en la muñeca. La composición está fijada por la imagen del encargo.

## Medidas

Estimación sobre la imagen adjunta de 1254 × 1254: eje en (625,603), radio
visible útil aproximado de 420 px; escala 390/840. Se excluyen caja, bisel,
marca y correa. La perspectiva de la fotografía impide precisión subpíxel.

| Elemento | Coordenadas/medida en pantalla |
| --- | --- |
| Centro | (195,195) |
| Minuteros | radio exterior 181, interior 174; ancho 2 |
| Horarios | radio exterior 181, interior 169; ancho 5; extremos redondos |
| Números | radio 143; altura visible aproximada 28–31 |
| Batería del dispositivo | (195,97), radio 49; anillo radio 40, ancho 7 |
| Tiempo | (103,195), radio 47; anillo radio 41, ancho 7 |
| Fecha | (287,195), radio 45 |
| Pasos | (195,286), radio 48; anillo radio 40, ancho 7 |
| Horaria | longitud 104, ancho 16, contorno 2; cola 8 |
| Minutera | longitud 148, ancho 5, extremos redondos |
| Segundero | longitud 167, ancho 1, cola 8 |

Se muestran 1, 2, 4, 5, 7, 8, 10 y 11. Rotaciones horarias respectivas:
30°, 60°, −60°, −30°, 30°, 60°, −60° y −30°. Los cuatro cardinales
tienen únicamente marcador. Los trazos no sobrepasan el círculo de pantalla.

## Paleta y recursos

Negro `#000000`, porcelana `#F3F1EC`, grafito `#27292C`, secundario `#777777`,
sol `#DAB779`. Anillo meteorológico fijo porcelana; no codifica temperatura.
Sin degradados ni sombras. Anillos abiertos 270° con extremos redondos,
progreso de batería 0–100 y pasos/objetivo limitado al 100%.
Por petición del usuario, el indicador superior usa batería del dispositivo
e icono de batería. Su arco comparte con pasos el radio 40, inicio 225°,
recorrido horario 270°, grosor 7 y extremos redondos.

Solo el tramo relleno de batería cambia de color, sin degradados:

| Carga | Color |
| --- | --- |
| 80–100% | Verde salvia `#A8CFA0` |
| 30–menos de 80% | Amarillo cálido `#DAB779`, compartido con el sol |
| 0–menos de 30% | Rojo coral `#E08A80` |

Paleta suave para conservar el carácter monocromático del dial. Contraste
calculado sobre grafito: verde 8,40:1, amarillo 7,66:1 y rojo 5,64:1.
Porcentaje e icono permanecen porcelana y la pista gris. El valor numérico
y la longitud del arco permiten leer la carga sin depender del color.
Ausencia: `--`, sin relleno; cero válido: `0`, sin relleno.

Roboto bajo SIL OFL 1.1, procedente de Google Fonts, no extraída de una app.
Los PNG de números inclinados y las fuentes BMFont se generan desde el TTF
incluido mediante `tools/generate_assets.py`. Iconos vectoriales originales.
BMFont utiliza PNG gris de 8 bits (cobertura de un canal), sin RGBA. Los números
horarios se componen sobre negro en RGB, con `dithering="none"` y
`automaticPalette="false"`, para conservar el suavizado sin tramado.
El dial dibuja primero los números y después los marcadores: las esquinas
negras de los PNG del 10 y el 11 no deben ocultar ningún trazo horario.
El margen radial entre el trazo visible de los números y el extremo redondo
de su marcador horario queda aproximadamente entre 8 y 10 px. Este margen
se ha comprobado con los píxeles de los recursos; no sustituye la captura real.
Valores de 28 px nominales; pasos y mes 23 px. Los valores largos de pasos
usan una fuente de 18 px para respetar el ancho del círculo.

La referencia coloca el icono meteorológico encima de la temperatura y las
huellas encima de los pasos; se conserva ese orden por prioridad visual.
La horaria es hueca y deja ver el contenido que atraviesa; las agujas se
dibujan encima de las complicaciones como en la referencia.
