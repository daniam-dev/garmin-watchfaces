# Stride Digital

<!-- impeccable:product-schema 1 -->

## Plataforma y uso

Esfera nativa Monkey C para Forerunner 170 (`fr170`), AMOLED circular
de 390 × 390. API mínima 6.0.2. Uso personal de Dani.

La petición del 21/10/2026 fija una apariencia cercana a las esferas Garmin,
libertad de composición y el aprovechamiento máximo de la pantalla. Se toma
como preferencia conocida la hora grande, el fondo negro, el español y la
consulta de pasos, Body Battery, tiempo, lluvia y batería. La petición posterior
sustituye los minutos semanales por frecuencia cardíaca. La aclaración de Dani
sitúa el carácter deportivo en el dibujo de los números, cercano a Garmin:
hora blanca y cifras compactas, con un único acento verde contenido. Se conserva
la composición y se descarta la hora multicolor.
No se añaden marca Garmin ni servicios externos.

## Comportamiento

Hora local de 24 horas y fecha española. Pasos diarios y objetivo, pulso en
latidos por minuto, Body Battery oficial,
temperatura Celsius, condición y probabilidad de precipitación, batería física.
Los valores ausentes muestran `--`; cero válido se conserva. Los objetivos
alcanzados completan el arco sin recortar la cifra real. Sin objetivo no hay
progreso. Una condición desconocida se presenta con rayas, nunca como sol.

Actualización de datos por minuto y al despertar. Body Battery y pulso usan
suscripciones mientras la esfera está visible, liberadas al ocultarse.
El pulso procede de `COMPLICATION_TYPE_HEART_RATE`, sin activar sensores
desde el dibujo; se actualiza cuando Garmin publica el dato. Sin lectura o
con cero inválido se muestra `--`. No se le asigna un porcentaje ficticio:
el arco derecho representa Body Battery sobre 100; el izquierdo, pasos/objetivo.
Sin segundos, temporizadores, animaciones o AOD; reposo negro.

Mantener pulsado cada dato abre su complicación nativa: batería, fecha, pasos,
pulso, Body Battery o tiempo. Temperatura y lluvia comparten el destino del
tiempo. El firmware determina la disponibilidad del destino; no se simula
una aplicación que Garmin no exponga.

## Validación

`../../scripts/build.ps1 -Project stride-digital` compila con avisos.
Las pruebas `:test` cubren ausencia, ceros, objetivos, zonas táctiles y dibujo
con datos ausentes y extremos. La revisión de píxeles exige una captura real
del simulador o reloj; las medidas del motor no la sustituyen.
