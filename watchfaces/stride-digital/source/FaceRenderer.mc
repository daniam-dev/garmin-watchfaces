import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Weather;
import Toybox.WatchUi;

class StrideRenderer {
    private var _time as Graphics.FontType = Graphics.FONT_NUMBER_HOT;
    private var _value as Graphics.FontType = Graphics.FONT_SMALL;
    private var _small as Graphics.FontType = Graphics.FONT_XTINY;
    private var _label as Graphics.FontType = Graphics.FONT_XTINY;
    private var _date as Graphics.FontType = Graphics.FONT_TINY;
    function initialize() {}
    function layout() as Void {
        _time = WatchUi.loadResource(Rez.Fonts.Time) as WatchUi.FontResource;
        _value = WatchUi.loadResource(Rez.Fonts.Value) as WatchUi.FontResource;
        _small = WatchUi.loadResource(Rez.Fonts.Compact) as WatchUi.FontResource;
        var label = Graphics.getVectorFont({:face => "RobotoCondensedRegular", :size => 16});
        var date = Graphics.getVectorFont({:face => "RobotoRegular", :size => 22});
        if (label != null) { _label = label; }
        if (date != null) { _date = date; }
    }
    function text(dc as Graphics.Dc, x as Number, y as Number, font as Graphics.FontType, value as String, color as Number) as Void {
        dc.setColor(color,Graphics.COLOR_TRANSPARENT);
        dc.drawText(x,y,font,value,StrideTheme.ALIGN);
    }
    // Garmin cuantiza los ángulos: cero no llama a drawArc con extremos iguales.
    function rail(dc as Graphics.Dc, start as Number, clockwise as Boolean, ratio as Float, color as Number, track as Number) as Void {
        dc.setPenWidth(StrideTheme.EDGE_WIDTH);
        var end = start + (clockwise ? -StrideTheme.SWEEP : StrideTheme.SWEEP);
        var direction = clockwise ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE;
        dc.setColor(track,Graphics.COLOR_TRANSPARENT);
        dc.drawArc(195,195,StrideTheme.EDGE_RADIUS,direction,start,end);
        var sweep = Math.round(ratio*StrideTheme.SWEEP).toNumber();
        if (sweep <= 0) { return; }
        dc.setColor(color,Graphics.COLOR_TRANSPARENT);
        dc.drawArc(195,195,StrideTheme.EDGE_RADIUS,direction,start,start+(clockwise ? -sweep : sweep));
    }
    function metric(dc as Graphics.Dc, x as Number, value as String, label as String) as Void {
        var font = dc.getTextWidthInPixels(value,_value) > 82 ? _small : _value;
        text(dc,x,StrideTheme.VALUE_Y,font,value,value == "--" ? StrideTheme.MUTED : StrideTheme.WHITE);
        text(dc,x,StrideTheme.LABEL_Y,_label,label,StrideTheme.MUTED);
    }
    function draw(dc as Graphics.Dc, data as StrideData) as Void {
        dc.setColor(StrideTheme.WHITE,StrideTheme.BLACK); dc.clear(); dc.setAntiAlias(true);
        rail(dc,96,false,StrideFormat.progress(data.steps,data.goal),StrideTheme.STEPS,StrideTheme.STEPS_TRACK);
        rail(dc,84,true,StrideFormat.progress(data.body,100),StrideTheme.BODY,StrideTheme.BODY_TRACK);
        dc.setPenWidth(1);
        var batteryColor = data.battery == null ? StrideTheme.MUTED : (data.battery < 30 ? StrideTheme.LOW : StrideTheme.STEPS);
        dc.setColor(batteryColor,Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(154,28,18,11,2); dc.fillRectangle(173,31,2,5);
        if (data.battery != null && data.battery > 0) {
            var fill = Math.round(data.battery*0.12f).toNumber();
            dc.fillRectangle(157,31,fill < 1 ? 1 : fill,5);
        }
        text(dc,207,StrideTheme.BATTERY_Y,_small,StrideFormat.percent(data.battery),StrideTheme.WHITE);
        text(dc,195,StrideTheme.DATE_Y,_date,data.dateText,StrideTheme.MUTED);
        text(dc,195,StrideTheme.TIME_Y,_time,data.timeText,StrideTheme.WHITE);
        dc.setColor(StrideTheme.TRACK,Graphics.COLOR_TRANSPARENT);
        dc.drawLine(49,StrideTheme.RULE_Y,341,StrideTheme.RULE_Y);
        dc.drawLine(146,244,146,295); dc.drawLine(244,244,244,295);
        metric(dc,StrideTheme.STEPS_X,StrideFormat.steps(data.steps),"PASOS");
        metric(dc,StrideTheme.BODY_X,StrideFormat.number(data.body),"BODY BATTERY");
        metric(dc,StrideTheme.HEART_X,StrideFormat.number(data.heartRate),"PULSO / LPM");
        weather(dc,118,StrideTheme.WEATHER_Y,data.condition);
        text(dc,158,StrideTheme.WEATHER_Y,_date,StrideFormat.temperature(data.temperature),StrideTheme.WHITE);
        dc.setColor(StrideTheme.MUTED,Graphics.COLOR_TRANSPARENT); dc.drawLine(195,322,195,346);
        droplet(dc,218,StrideTheme.WEATHER_Y);
        text(dc,260,StrideTheme.WEATHER_Y,_date,StrideFormat.percent(data.rain),StrideTheme.WHITE);
        dc.setPenWidth(1);
    }
    function droplet(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(StrideTheme.BODY,Graphics.COLOR_TRANSPARENT); dc.setPenWidth(2);
        dc.drawLine(x,y-10,x-6,y); dc.drawLine(x,y-10,x+6,y);
        dc.drawArc(x,y,6,Graphics.ARC_CLOCKWISE,0,180);
    }
    function cloud(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(StrideTheme.WHITE,Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x-8,y,5); dc.fillCircle(x,y-4,8); dc.fillCircle(x+9,y,5);
        dc.fillRectangle(x-8,y,17,5);
    }
    function sun(dc as Graphics.Dc, x as Number, y as Number) as Void {
        dc.setColor(StrideTheme.SUN,Graphics.COLOR_TRANSPARENT); dc.fillCircle(x,y,5); dc.setPenWidth(2);
        for (var a = 0; a < 360; a += 45) {
            var rad = a*Math.PI/180.0f;
            dc.drawLine(x+Math.round(Math.cos(rad)*8).toNumber(),y+Math.round(Math.sin(rad)*8).toNumber(),
                        x+Math.round(Math.cos(rad)*11).toNumber(),y+Math.round(Math.sin(rad)*11).toNumber());
        }
    }
    function weather(dc as Graphics.Dc, x as Number, y as Number, condition as Number?) as Void {
        if (condition == Weather.CONDITION_CLEAR || condition == Weather.CONDITION_FAIR) { sun(dc,x,y); }
        else if (condition == Weather.CONDITION_PARTLY_CLOUDY || condition == Weather.CONDITION_MOSTLY_CLEAR) { sun(dc,x-5,y-5); cloud(dc,x+2,y+2); }
        else if (condition == Weather.CONDITION_CLOUDY || condition == Weather.CONDITION_MOSTLY_CLOUDY) { cloud(dc,x,y); }
        else if (condition == Weather.CONDITION_RAIN || condition == Weather.CONDITION_SHOWERS || condition == Weather.CONDITION_DRIZZLE || condition == Weather.CONDITION_HEAVY_RAIN || condition == Weather.CONDITION_SCATTERED_SHOWERS) {
            cloud(dc,x,y-4); dc.setColor(StrideTheme.BODY,Graphics.COLOR_TRANSPARENT); dc.setPenWidth(2);
            dc.drawLine(x-6,y+5,x-8,y+10); dc.drawLine(x+3,y+5,x+1,y+10);
        } else {
            dc.setColor(StrideTheme.MUTED,Graphics.COLOR_TRANSPARENT); dc.setPenWidth(2);
            dc.drawLine(x-9,y,x-3,y); dc.drawLine(x+3,y,x+9,y);
        }
    }
}
