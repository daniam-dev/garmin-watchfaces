import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Weather;

module Components {
    function circle(dc as Graphics.Dc, x as Number, y as Number, radius as Number) as Void {
        dc.setPenWidth(2);
        dc.setColor(Theme.OUTLINE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(x, y, radius);
    }
    // Garmin angles start at 3 o'clock. Use the same integer angle for caps.
    function cap(dc as Graphics.Dc, x as Number, y as Number, radius as Number,
                 angle as Number, width as Number) as Void {
        var radians = angle * Math.PI / 180.0f;
        dc.fillCircle(x + radius * Math.cos(radians), y - radius * Math.sin(radians), width / 2);
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
        dc.drawArc(x, y, radius, direction, start, finish);
        cap(dc, x, y, radius, start, width);
        cap(dc, x, y, radius, finish, width);
        // Equal angles draw a FULL circle: skip the foreground when zero.
        var degrees = (sweep * progress).toNumber();
        if (degrees > 0) {
            finish = start + sign * degrees;
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(x, y, radius, direction, start, finish);
            cap(dc, x, y, radius, start, width);
            cap(dc, x, y, radius, finish, width);
        }
        if (marker) {
            var angle = (start + sign * degrees) * Math.PI / 180.0f;
            var markerX = x + radius * Math.cos(angle);
            var markerY = y - radius * Math.sin(angle);
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(markerX, markerY, 9);
            dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(markerX, markerY, 7);
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(markerX, markerY, 5);
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
        dc.fillEllipse(x - 7, y - 5, 4, 7);
        dc.fillCircle(x - 7, y + 7, 3);
        dc.fillEllipse(x + 7, y - 11, 4, 7);
        dc.fillCircle(x + 7, y + 1, 3);
    }
    function energy(dc as Graphics.Dc, x as Number, y as Number) as Void {
        // Solid silhouette with a separate bolt; no intersecting thin strokes.
        dc.fillCircle(x - 6, y - 13, 4);
        dc.fillPolygon([[x - 15, y - 9], [x - 6, y - 6], [x + 3, y - 10],
                        [x + 4, y - 7], [x - 5, y - 2], [x - 15, y - 6]]);
        dc.fillPolygon([[x - 9, y - 5], [x - 3, y - 4], [x - 5, y + 3],
                        [x - 9, y + 11], [x - 13, y + 11], [x - 9, y + 1]]);
        dc.fillPolygon([[x + 12, y - 9], [x + 4, y + 3], [x + 9, y + 3],
                        [x + 6, y + 12], [x + 17, y - 2], [x + 11, y - 2]]);
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
