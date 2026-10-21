# Stride Digital

<!-- impeccable:product-schema 1 -->

## Plataforma y uso

Esfera nativa Monkey C para Forerunner 170 (`fr170`), AMOLED circular
de 390 × 390. API mínima 6.0.2. Uso personal de Dani.

Hora grande, fondo negro y español, con consulta de pasos, Body Battery, pulso,
tiempo, lluvia y batería. El carácter deportivo se apoya en las cifras Rajdhani
inclinadas: horas con relleno oscuro y contorno lima, minutos blancos. Pasos
usan lima; Body Battery y lluvia, cian contenido. No se añaden marca Garmin
ni servicios externos.

El rediseño aprobado tras la auditoría del 21/10/2026 sustituye la composición
de arcos laterales y datos inferiores. La hora ocupa la izquierda en dos líneas;
pasos, Body Battery y pulso forman una columna a la derecha. Los dos progresos
son barras junto a su dato. Fecha y batería quedan arriba; tiempo y lluvia,
al pie. Las medidas y los recursos vigentes se documentan en `DESIGN.md`.

El ajuste del 22/10/2026 conserva esa composición y toma como referencia las
esferas de las imágenes oficiales de Forerunner 970, Venu 4 y fēnix 9:
inclinación, contraste entre contorno y relleno, iconos compactos y barras
segmentadas. Las fuentes y los iconos de Stride siguen siendo propios. Cada línea de
la hora mide 176 × 130 px; la fecha, el pie y la columna dejan espacio
a las cifras ampliadas.
Las imágenes y su procedencia están en `.impeccable/references/README.md`;
son referencias de producto, no capturas de Stride ni recursos compilados.

## Comportamiento

Hora local de 24 horas y fecha española. Pasos diarios y objetivo, pulso en
latidos por minuto, Body Battery oficial,
temperatura Celsius, condición y probabilidad de precipitación, batería física.
Los valores ausentes muestran `--`; cero válido se conserva. Los objetivos
alcanzados completan la barra sin recortar la cifra real. Sin objetivo no hay
progreso. Una condición desconocida se presenta con rayas, nunca como sol.

Actualización de datos por minuto y al despertar. Body Battery y pulso usan
suscripciones mientras la esfera está visible, liberadas al ocultarse.
El pulso procede de `COMPLICATION_TYPE_HEART_RATE`, sin activar sensores
desde el dibujo; se actualiza cuando Garmin publica el dato. Sin lectura o
con cero inválido se muestra `--`. No se le asigna un porcentaje ficticio:
las barras representan pasos/objetivo y Body Battery sobre 100, cada una bajo
su cifra y rótulo. El pulso no tiene indicador de progreso.
Sin segundos, temporizadores, animaciones o AOD; reposo negro.

Mantener pulsado cada dato abre su complicación nativa: batería, fecha, pasos,
pulso, Body Battery o tiempo. Temperatura y lluvia comparten el destino del
tiempo. El firmware determina la disponibilidad del destino; no se simula
una aplicación que Garmin no exponga.

## Validación

`../../scripts/build.ps1 -Project stride-digital` compila con avisos.
La compilación con `-w` y las cuatro pruebas en `fr170` pasan. Cubren ausencia,
ceros, objetivos, pulso, destinos de pulsación, cada píxel de las dos barras
segmentadas, los iconos y las cajas de las 1.440 horas dentro del círculo para
`Time` y `TimeOutline`. El dibujo con datos ausentes
y extremos se ejecuta en un búfer de 1 × 1; no valida su aspecto.

El diagnóstico en el DC completo, con el límite normal de memoria, registra
16.464 bytes usados, 110.416 libres y 126.880 totales, sin errores de ejecución.
Estos estados de prueba no representan lecturas reales. La app está cargada
en el simulador; se han inspeccionado los atlas `Time.png` y `TimeOutline.png`. No se obtuvo
captura: Computer Use no dispone de canal nativo. Quedan pendientes la revisión
visual a 390 × 390 y la apertura de los destinos en el reloj. Las comprobaciones
geométricas y de compilación no sustituyen esa revisión.
