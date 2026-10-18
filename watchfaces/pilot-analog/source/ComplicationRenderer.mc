import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class PilotComplications {
    private var _value as Graphics.FontType = Graphics.FONT_NUMBER_MEDIUM;
    private var _label as Graphics.FontType = Graphics.FONT_SMALL;
    private var _small as Graphics.FontType = Graphics.FONT_TINY;
    function initialize() {}
    function layout() as Void {
        _value = WatchUi.loadResource(Rez.Fonts.Value) as WatchUi.FontResource;
        _label = WatchUi.loadResource(Rez.Fonts.Label) as WatchUi.FontResource;
        _small = WatchUi.loadResource(Rez.Fonts.Small) as WatchUi.FontResource;
    }
    function text(dc as Graphics.Dc, x as Number, top as Number, value as String, font as Graphics.FontType) as Void {
        dc.setColor(PilotTheme.WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x,top,font,value,Graphics.TEXT_JUSTIFY_CENTER);
    }
    function draw(dc as Graphics.Dc, data as PilotData) as Void {
        var c = PilotTheme.CENTER;
        var b = PilotTheme.BATTERY_Y;
        var s = PilotTheme.STEPS_Y;
        var w = PilotTheme.WEATHER_X;
        var d = PilotTheme.DATE_X;
        dc.setColor(PilotTheme.GRAPHITE,Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(c,b,49); dc.fillCircle(w,c,47); dc.fillCircle(d,c,45); dc.fillCircle(c,s,48);
        PilotPrimitives.ring(dc,c,b,40,225,270,PilotFormat.progress(data.battery,100),PilotTheme.batteryColor(data.battery),7);
        PilotIcons.battery(dc,c,b-14);
        text(dc,c,b+4,PilotFormat.integer(data.battery),_value);
        // Fixed decorative arc, never a fictional temperature percentage.
        PilotPrimitives.ring(dc,w,c,41,225,270,0.5f,PilotTheme.WHITE,7);
        PilotIcons.weather(dc,w,c-7,data.condition);
        text(dc,w,c+12,PilotFormat.temperature(data.temperature),_value);
        PilotIcons.calendar(dc,d,c-23);
        text(dc,d,c-6,data.month,_label);
        text(dc,d,c+17,data.day,_label);
        PilotPrimitives.ring(dc,c,s,40,225,270,PilotFormat.progress(data.steps,data.goal),PilotTheme.WHITE,7);
        PilotIcons.feet(dc,c,s-16);
        var steps = PilotFormat.steps(data.steps);
        var font = dc.getTextWidthInPixels(steps,_label) > 73 ? _small : _label;
        text(dc,c,s+3,steps,font);
    }
}
