# Cifras de Stride Digital

Fuente base Barlow Condensed ExtraBold, de Jeremy Tribby, distribuida bajo SIL
OFL 1.1. Copyright 2017 The Barlow Project Authors. Se conservan
`BarlowCondensed-ExtraBold.ttf` y su licencia `OFL.txt`.

Origen: https://github.com/google/fonts/tree/main/ofl/barlowcondensed

TTF: https://raw.githubusercontent.com/google/fonts/main/ofl/barlowcondensed/BarlowCondensed-ExtraBold.ttf

Licencia: https://raw.githubusercontent.com/google/fonts/main/ofl/barlowcondensed/OFL.txt

Metadatos oficiales: https://raw.githubusercontent.com/google/fonts/main/ofl/barlowcondensed/METADATA.pb

`tools/generate_fonts.py` genera cuatro recursos BMFont propios. Mantiene
la línea base y recorta la caja vertical a
la tinta numérica para centrarla de forma estable. `Time` se genera desde
179 px y tiene 130 px de altura final. La hora usa escala horizontal de 0,97,
recta y sin sesgo añadido (0°), dentro de su celda de 88 px. Sus dígitos
son tabulares: comparten avance y se centran en su celda; `11` y `88` miden
lo mismo (176 px). `TimeOutline` repite la geometría y resta una erosión
de 7 × 7 para generar un contorno interior nominal de 3 px, sin ampliar
cajas ni avances. Las horas combinan relleno oscuro con ese contorno lima;
los minutos usan `Time` blanco. Así las dos líneas mantienen el ancho al
cambiar de minuto. Los recursos
`Value` y `Compact` usan Barlow desde 42 y 26 px, sin condensación adicional,
con alturas finales de 30 y 19 px y avances proporcionales. Los atlas PNG son grises
de 8 bits con cobertura suavizada, sin RGBA. Se incluyen solo los caracteres
necesarios en `fonts.xml`; no se importa ningún recurso de otra esfera.

Para regenerarlos desde la carpeta de la esfera, con Python y Pillow:

```powershell
python tools/generate_fonts.py
```

Las fuentes se cargan una vez en `StrideRenderer.layout()`. Los rótulos y
la fecha siguen usando las fuentes vectoriales nativas de Garmin.
