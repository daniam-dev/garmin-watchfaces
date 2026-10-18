import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

module PilotPrimitives {
    function cap(dc as Graphics.Dc, x as Number, y as Number, radius as Number,
                 angle as Number, width as Number) as Void {
        var a = angle * Math.PI / 180.0f;
        dc.fillCircle(x + radius * Math.cos(a), y - radius * Math.sin(a), width / 2.0f);
    }
    function ring(dc as Graphics.Dc, x as Number, y as Number, radius as Number,
                  start as Number, sweep as Number, progress as Float, color as Number,
                  width as Number) as Void {
        dc.setPenWidth(width);
        dc.setColor(PilotTheme.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, start, start - sweep);
        cap(dc, x, y, radius, start, width);
        cap(dc, x, y, radius, start - sweep, width);
        var degrees = (sweep * progress).toNumber();
        // Equal arc angles mean a full circle in Garmin: zero must skip drawing.
        if (degrees > 0) {
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, start, start - degrees);
            cap(dc, x, y, radius, start, width);
            cap(dc, x, y, radius, start - degrees, width);
        }
    }
    function capsule(dc as Graphics.Dc, x1 as Numeric, y1 as Numeric,
                     x2 as Numeric, y2 as Numeric, width as Number) as Void {
        dc.setPenWidth(width);
        dc.drawLine(x1, y1, x2, y2);
        dc.fillCircle(x1, y1, width / 2.0f);
        dc.fillCircle(x2, y2, width / 2.0f);
    }
}
