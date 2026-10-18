# Fuentes

Roboto variable, peso 700 y anchura 100, licencia [SIL OFL 1.1](OFL.txt).
Origen: [Google Fonts / Roboto](https://github.com/google/fonts/tree/main/ofl/roboto).
Se incluye el TTF utilizado; no se extrae de aplicaciones ni capturas.

SHA-256 de `Roboto.ttf`:
`d7598e12c5dbef095ff8272cfc55da0250bd07fbdecbac8a530b9b277872a134`.

`tools/generate_assets.py` produce los tres BMFont y los ocho números
inclinados con Pillow 13.x. Los recursos generados se versionan: compilar la
esfera solo requiere el SDK y Java, sin Python ni Node.

Los atlas BMFont son PNG gris de 8 bits: blanco representa cobertura completa
y negro ausencia de trazo. No exportarlos como RGBA. Los números horarios
son recursos RGB sobre negro y se importan sin tramado ni paleta automática.
Comprueba estos contratos con `python watchfaces/pilot-analog/tests/asset_contracts.py`
desde la raíz del repositorio; no requiere Pillow.
