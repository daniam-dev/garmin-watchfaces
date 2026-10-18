import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.WatchUi;

class PilotDial {
    private var _ticks as Array<Array<Number>> = [];
    private var _numerals as Array<WatchUi.BitmapResource> = [];
    private var _positions as Array<Array<Number>> = [];
    function initialize() {}
    function layout() as Void {
        _ticks = [];
        _positions = [];
        _numerals = [];
        var c = PilotTheme.CENTER;
        for (var i = 0; i < 60; i += 1) {
            var a = i * Math.PI / 30.0f;
            var inner = i % 5 == 0 ? PilotTheme.HOUR_INNER : PilotTheme.TICK_INNER;
            _ticks.add([(c + inner * Math.sin(a)).toNumber(),
                        (c - inner * Math.cos(a)).toNumber(),
                        (c + PilotTheme.TICK_OUTER * Math.sin(a)).toNumber(),
                        (c - PilotTheme.TICK_OUTER * Math.cos(a)).toNumber()]);
        }
        var ids = [Rez.Drawables.N1, Rez.Drawables.N2, Rez.Drawables.N4, Rez.Drawables.N5,
                   Rez.Drawables.N7, Rez.Drawables.N8, Rez.Drawables.N10, Rez.Drawables.N11];
        var hours = [1, 2, 4, 5, 7, 8, 10, 11];
        for (var n = 0; n < ids.size(); n += 1) {
            var bitmap = WatchUi.loadResource(ids[n]) as WatchUi.BitmapResource;
            _numerals.add(bitmap);
            var a = hours[n] * Math.PI / 6.0f;
            _positions.add([(c + PilotTheme.NUMERAL_RADIUS * Math.sin(a) - bitmap.getWidth() / 2).toNumber(),
                            (c - PilotTheme.NUMERAL_RADIUS * Math.cos(a) - bitmap.getHeight() / 2).toNumber()]);
        }
    }
    function draw(dc as Graphics.Dc) as Void {
        // Los PNG tienen fondo negro: pintar las marcas después evita que las
        // esquinas de los números de dos cifras recorten sus trazos.
        for (var n = 0; n < _numerals.size(); n += 1) {
            dc.drawBitmap(_positions[n][0], _positions[n][1], _numerals[n]);
        }
        dc.setColor(PilotTheme.WHITE, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < _ticks.size(); i += 1) {
            var t = _ticks[i];
            if (i % 5 == 0) {
                PilotPrimitives.capsule(dc, t[0], t[1], t[2], t[3], 5);
            } else {
                dc.setPenWidth(2);
                dc.drawLine(t[0], t[1], t[2], t[3]);
            }
        }
    }
}
