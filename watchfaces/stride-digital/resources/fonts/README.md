# Cifras de Stride Digital

Fuente base Rajdhani Bold, de Indian Type Foundry, distribuida bajo SIL OFL
1.1. Se conservan el TTF original y su licencia `OFL.txt`.

Origen: https://github.com/google/fonts/tree/main/ofl/rajdhani

`tools/generate_fonts.py` genera tres recursos BMFont propios. Reduce al 80%
el ancho de las cifras, mantiene la línea base y recorta la caja vertical a
la tinta numérica para centrarla de forma estable. `Time` se genera desde
186 px y tiene 120 px de altura final. Sus dígitos son tabulares: comparten
avance y se centran en su celda; `11` y `88` miden lo mismo (162 px). Así las
dos líneas de la hora mantienen el ancho al cambiar de minuto. Los recursos
`Value` y `Compact` conservan alturas finales de 30 y 19 px y avances
proporcionales. Los atlas PNG son grises
de 8 bits con cobertura suavizada, sin RGBA. Se incluyen solo los caracteres
necesarios en `fonts.xml`; no se importa ningún recurso de otra esfera.

Para regenerarlos desde la carpeta de la esfera, con Python y Pillow:

```powershell
python tools/generate_fonts.py
```

Las fuentes se cargan una vez en `StrideRenderer.layout()`. Los rótulos y
la fecha siguen usando las fuentes vectoriales nativas de Garmin.
