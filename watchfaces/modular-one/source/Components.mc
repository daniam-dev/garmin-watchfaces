import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Weather;

module Components {
    function dial(dc as Graphics.Dc, x as Number) as Void {
        dc.setColor(Theme.DIAL, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, Theme.DIAL_Y, Theme.DIAL_RADIUS);
        dc.setPenWidth(1);
        dc.setColor(Theme.OUTLINE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(x, Theme.DIAL_Y, Theme.DIAL_RADIUS);
    }
    function rail(dc as Graphics.Dc, start as Number, clockwise as Boolean,
                  progress as Float, color as Number, available as Boolean) as Void {
        var sign = clockwise ? -1 : 1;
        dc.setColor(Theme.TICK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        for (var i = 0; i <= 42; i += 1) {
            var angle = start + sign * i * 4;
            var inner = i % 7 == 0 ? 172 : 177;
            var from = arcPoint(Theme.CENTER, Theme.CENTER, inner, angle);
            var to = arcPoint(Theme.CENTER, Theme.CENTER, 184, angle);
            dc.drawLine(from[0], from[1], to[0], to[1]);
        }
        // El progreso fino deja visible la escala. Sin dato no hay marcador.
        arc(dc, Theme.CENTER, Theme.CENTER, Theme.ARC_RADIUS, start, Theme.ARC_SWEEP, clockwise,
            progress, color, Theme.OUTLINE, Theme.ARC_WIDTH, false);
        if (available) {
            var markerAngle = start + sign * progressDegrees(Theme.ARC_SWEEP, progress);
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            cap(dc, Theme.CENTER, Theme.CENTER, Theme.ARC_RADIUS, markerAngle, Theme.MARKER_RADIUS * 2);
        }
    }
    function circle(dc as Graphics.Dc, x as Number, y as Number, radius as Number) as Void {
        dc.setPenWidth(2);
        dc.setColor(Theme.OUTLINE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(x, y, radius);
    }
    function progressDegrees(sweep as Number, progress as Float) as Number {
        if (progress <= 0.0f) { return 0; }
        if (progress >= 1.0f) { return sweep; }
        // drawArc trunca ángulos: elegimos una sola vez el grado más próximo.
        return Math.round(sweep * progress).toNumber();
    }
    function arcPoint(x as Number, y as Number, radius as Number, angle as Number) as Array<Number> {
        var normalized = angle % 360;
        if (normalized < 0) { normalized += 360; }
        var acute = normalized;
        if (normalized > 270) { acute = 360 - normalized; }
        else if (normalized > 180) { acute = normalized - 180; }
        else if (normalized > 90) { acute = 180 - normalized; }
        var radians = acute * Math.PI / 180.0f;
        // Redondear los módulos antes del signo conserva la simetría entre lados.
        var dx = Math.round(radius * Math.cos(radians)).toNumber();
        var dy = Math.round(radius * Math.sin(radians)).toNumber();
        if (normalized > 90 && normalized < 270) { dx = -dx; }
        if (normalized < 180) { dy = -dy; }
        return [x + dx, y + dy];
    }
    function cap(dc as Graphics.Dc, x as Number, y as Number, radius as Number,
                 angle as Number, width as Number) as Void {
        var point = arcPoint(x, y, radius, angle);
        dc.fillCircle(point[0], point[1], width / 2.0f);
    }
    function arc(dc as Graphics.Dc, x as Number, y as Number, radius as Number,
                 start as Number, sweep as Number, clockwise as Boolean,
                 progress as Float, color as Number, track as Number,
                 width as Number, marker as Boolean) as Void {
        var direction = clockwise ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE;
        var sign = clockwise ? -1 : 1;
        var finish = start + sign * sweep;
        dc.setPenWidth(width);
        dc.setColor(track, Graphics.COLOR_TRANSPARENT);
        if (sweep == 360) {
            dc.drawCircle(x, y, radius);
        } else {
            dc.drawArc(x, y, radius, direction, start, finish);
            cap(dc, x, y, radius, start, width);
            cap(dc, x, y, radius, finish, width);
        }
        // Ángulos iguales dibujan un círculo entero: el cero no tiene relleno.
        var degrees = progressDegrees(sweep, progress);
        finish = start + sign * degrees;
        if (degrees > 0) {
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            if (degrees == 360) {
                dc.drawCircle(x, y, radius);
            } else {
                dc.drawArc(x, y, radius, direction, start, finish);
                cap(dc, x, y, radius, start, width);
                cap(dc, x, y, radius, finish, width);
            }
        }
        if (marker) {
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            cap(dc, x, y, radius, finish, 18);
            dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
            cap(dc, x, y, radius, finish, 14);
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            cap(dc, x, y, radius, finish, 10);
        }
        dc.setPenWidth(2);
    }
    function batteryIcon(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setPenWidth(2);
        dc.drawRoundedRectangle(x - 12, y - 7, 24, 14, 2);
        dc.fillRectangle(x + 13, y - 3, 3, 6);
        dc.fillRectangle(x - 9, y - 4, 18, 8);
    }
    function feet(dc as Graphics.Dc, x as Number, y as Number) as Void {
        // fillEllipse takes a center and two radii, not a bounding box.
        // Separate soles and heels, staggered like the reference footprints.
        var scale = Theme.STEPS_ICON_SCALE;
        dc.fillEllipse(x - 7 * scale, y - 5 * scale, 4 * scale, 7 * scale);
        dc.fillCircle(x - 7 * scale, y + 7 * scale, 3 * scale);
        dc.fillEllipse(x + 7 * scale, y - 11 * scale, 4 * scale, 7 * scale);
        dc.fillCircle(x + 7 * scale, y + scale, 3 * scale);
    }
    function intensity(dc as Graphics.Dc, x as Number, y as Number) as Void {
        // Cronómetro compacto, con trazos comparables a las huellas pequeñas.
        dc.setPenWidth(2);
        dc.drawCircle(x, y, 8);
        dc.fillRoundedRectangle(x - 3, y - 13, 6, 3, 1);
        dc.drawLine(x, y - 10, x, y - 8);
        dc.drawLine(x + 6, y - 7, x + 8, y - 9);
        dc.drawLine(x, y, x, y - 4);
        dc.drawLine(x, y, x + 3, y + 2);
    }
    function cloud(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(Theme.CLOUD, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - 9, y, 6);
        dc.fillCircle(x - 1, y - 5, 8);
        dc.fillCircle(x + 8, y, 6);
        dc.fillRoundedRectangle(x - 15, y - 1, 29, 8, 4);
    }
    function rain(dc as Graphics.Dc, x as Number, y as Number) as Void {
        cloud(dc, x, y - 4);
        dc.setColor(Theme.STEPS, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawLine(x - 8, y + 8, x - 11, y + 13);
        dc.drawLine(x + 1, y + 8, x - 2, y + 13);
        dc.drawLine(x + 10, y + 8, x + 7, y + 13);
    }
    function sun(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(Theme.WEATHER, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.fillCircle(x, y, 9);
        dc.drawLine(x, y - 12, x, y - 16);
        dc.drawLine(x, y + 12, x, y + 16);
        dc.drawLine(x - 12, y, x - 16, y);
        dc.drawLine(x + 12, y, x + 16, y);
        dc.drawLine(x - 9, y - 9, x - 12, y - 12);
        dc.drawLine(x + 9, y - 9, x + 12, y - 12);
        dc.drawLine(x - 9, y + 9, x - 12, y + 12);
        dc.drawLine(x + 9, y + 9, x + 12, y + 12);
    }
    function weather(dc as Graphics.Dc, x as Number, y as Number, kind as Number?) as Void {
        dc.setColor(Theme.MUTED, Graphics.COLOR_TRANSPARENT);
        if (kind == null || kind == Weather.CONDITION_UNKNOWN) {
            dc.drawLine(x - 8, y, x - 2, y);
            dc.drawLine(x + 2, y, x + 8, y);
        } else if (kind == Weather.CONDITION_CLEAR || kind == Weather.CONDITION_FAIR) {
            sun(dc, x, y);
        } else if (kind == Weather.CONDITION_PARTLY_CLOUDY || kind == Weather.CONDITION_MOSTLY_CLEAR) {
            sun(dc, x - 6, y - 5);
            cloud(dc, x + 2, y + 2);
        } else if (kind == Weather.CONDITION_RAIN || kind == Weather.CONDITION_SHOWERS ||
                   kind == Weather.CONDITION_DRIZZLE || kind == Weather.CONDITION_HEAVY_RAIN ||
                   kind == Weather.CONDITION_SCATTERED_SHOWERS) {
            rain(dc, x, y);
        } else if (kind == Weather.CONDITION_THUNDERSTORMS || kind == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS ||
                   kind == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
            cloud(dc, x, y - 5);
            dc.setColor(Theme.WEATHER, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(x + 1, y + 5, x - 4, y + 11);
            dc.drawLine(x - 4, y + 11, x + 3, y + 11);
            dc.drawLine(x + 3, y + 11, x - 2, y + 17);
        } else if (kind == Weather.CONDITION_SNOW || kind == Weather.CONDITION_LIGHT_SNOW ||
                   kind == Weather.CONDITION_HEAVY_SNOW || kind == Weather.CONDITION_FLURRIES ||
                   kind == Weather.CONDITION_SLEET || kind == Weather.CONDITION_ICE) {
            dc.drawLine(x - 12, y, x + 12, y);
            dc.drawLine(x - 7, y - 11, x + 7, y + 11);
            dc.drawLine(x + 7, y - 11, x - 7, y + 11);
        } else if (kind == Weather.CONDITION_FOG || kind == Weather.CONDITION_HAZY) {
            dc.drawLine(x - 15, y - 7, x + 15, y - 7);
            dc.drawLine(x - 11, y, x + 11, y);
            dc.drawLine(x - 15, y + 7, x + 15, y + 7);
        } else if (kind == Weather.CONDITION_CLOUDY || kind == Weather.CONDITION_MOSTLY_CLOUDY) {
            cloud(dc, x, y);
        } else {
            // Unmapped conditions remain unavailable, never a false sun.
            dc.drawLine(x - 8, y, x - 2, y);
            dc.drawLine(x + 2, y, x + 8, y);
        }
    }
}
