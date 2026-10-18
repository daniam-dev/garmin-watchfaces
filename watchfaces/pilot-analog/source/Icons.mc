import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Weather;

module PilotIcons {
    function battery(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(PilotTheme.WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawRoundedRectangle(x-11,y-6,20,12,2);
        dc.fillRectangle(x+10,y-3,3,6);
    }
    function calendar(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(PilotTheme.WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawRoundedRectangle(x-9,y-7,18,15,1);
        dc.drawLine(x-9,y-4,x+9,y-4);
        dc.drawLine(x-5,y-11,x-5,y-6);
        dc.drawLine(x+5,y-11,x+5,y-6);
    }
    function feet(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(PilotTheme.WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(x-5,y-4,4,7);
        dc.fillCircle(x-4,y+6,2);
        dc.fillEllipse(x+6,y-1,4,7);
        dc.fillCircle(x+5,y+9,2);
    }
    function cloud(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(PilotTheme.WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x-9,y+1,5);
        dc.fillCircle(x-2,y-4,7);
        dc.fillCircle(x+7,y+1,6);
        dc.fillRoundedRectangle(x-14,y,27,7,3);
    }
    function sun(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(PilotTheme.SUN, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x,y,7);
        dc.setPenWidth(2);
        for (var i = 0; i < 8; i += 1) {
            var a = i * Math.PI / 4.0f;
            dc.drawLine(x+10*Math.cos(a), y+10*Math.sin(a), x+14*Math.cos(a), y+14*Math.sin(a));
        }
    }
    function weather(dc as Graphics.Dc, x as Number, y as Number, kind as Number?) as Void {
        dc.setPenWidth(2);
        dc.setColor(PilotTheme.MUTED, Graphics.COLOR_TRANSPARENT);
        if (kind == null || kind == Weather.CONDITION_UNKNOWN) {
            dc.drawLine(x-7,y,x-2,y); dc.drawLine(x+2,y,x+7,y);
        } else if (kind == Weather.CONDITION_CLEAR || kind == Weather.CONDITION_FAIR) {
            sun(dc,x,y);
        } else if (kind == Weather.CONDITION_PARTLY_CLOUDY || kind == Weather.CONDITION_MOSTLY_CLEAR) {
            sun(dc,x+6,y-5); cloud(dc,x-3,y+2);
        } else if (kind == Weather.CONDITION_CLOUDY || kind == Weather.CONDITION_MOSTLY_CLOUDY) {
            cloud(dc,x,y);
        } else if (kind == Weather.CONDITION_RAIN || kind == Weather.CONDITION_SHOWERS ||
                   kind == Weather.CONDITION_DRIZZLE || kind == Weather.CONDITION_HEAVY_RAIN ||
                   kind == Weather.CONDITION_SCATTERED_SHOWERS) {
            cloud(dc,x,y-4);
            dc.drawLine(x-7,y+7,x-10,y+12); dc.drawLine(x+1,y+7,x-2,y+12); dc.drawLine(x+9,y+7,x+6,y+12);
        } else if (kind == Weather.CONDITION_THUNDERSTORMS || kind == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS ||
                   kind == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
            cloud(dc,x,y-5);
            dc.setColor(PilotTheme.SUN,Graphics.COLOR_TRANSPARENT);
            dc.fillPolygon([[x+1,y+3],[x-4,y+9],[x,y+9],[x-2,y+15],[x+6,y+6],[x+2,y+6]]);
        } else if (kind == Weather.CONDITION_SNOW || kind == Weather.CONDITION_LIGHT_SNOW ||
                   kind == Weather.CONDITION_HEAVY_SNOW || kind == Weather.CONDITION_FLURRIES ||
                   kind == Weather.CONDITION_SLEET || kind == Weather.CONDITION_ICE) {
            dc.setColor(PilotTheme.WHITE,Graphics.COLOR_TRANSPARENT);
            dc.drawLine(x-11,y,x+11,y); dc.drawLine(x-6,y-10,x+6,y+10); dc.drawLine(x+6,y-10,x-6,y+10);
        } else if (kind == Weather.CONDITION_FOG || kind == Weather.CONDITION_HAZY) {
            dc.drawLine(x-13,y-6,x+13,y-6); dc.drawLine(x-9,y,x+9,y); dc.drawLine(x-13,y+6,x+13,y+6);
        } else {
            dc.drawLine(x-7,y,x-2,y); dc.drawLine(x+2,y,x+7,y);
        }
    }
}
