import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

module PilotHands {
    function draw(dc as Graphics.Dc, hour as Number, minute as Number, second as Number) as Void {
        var c = PilotTheme.CENTER;
        var angle = PilotFormat.hourAngle(hour, minute, second);
        var a = angle * Math.PI / 180.0f;
        var dx = Math.sin(a);
        var dy = -Math.cos(a);
        var nx = Math.cos(a);
        var ny = Math.sin(a);
        var r = PilotTheme.HOUR_WIDTH / 2;
        var tip = PilotTheme.HOUR_LENGTH - r;
        dc.setColor(PilotTheme.WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(c - 2 * dx + r * nx, c - 2 * dy + r * ny,
                    c + tip * dx + r * nx, c + tip * dy + r * ny);
        dc.drawLine(c - 2 * dx - r * nx, c - 2 * dy - r * ny,
                    c + tip * dx - r * nx, c + tip * dy - r * ny);
        dc.drawArc(c + tip * dx, c + tip * dy, r, Graphics.ARC_COUNTER_CLOCKWISE, -angle, 180 - angle);
        dc.drawArc(c - 2 * dx, c - 2 * dy, r, Graphics.ARC_COUNTER_CLOCKWISE, 180 - angle, 360 - angle);
        dc.drawCircle(c, c, 9);
        a = PilotFormat.minuteAngle(minute, second) * Math.PI / 180.0f;
        PilotPrimitives.capsule(dc, c, c, c + PilotTheme.MINUTE_LENGTH * Math.sin(a),
                                c - PilotTheme.MINUTE_LENGTH * Math.cos(a), 5);
        a = second * Math.PI / 30.0f;
        dc.setPenWidth(1);
        dc.drawLine(c - 8 * Math.sin(a), c + 8 * Math.cos(a),
                    c + PilotTheme.SECOND_LENGTH * Math.sin(a), c - PilotTheme.SECOND_LENGTH * Math.cos(a));
        dc.fillCircle(c, c, 5);
        dc.setColor(PilotTheme.BLACK, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(c, c, 1);
    }
}
