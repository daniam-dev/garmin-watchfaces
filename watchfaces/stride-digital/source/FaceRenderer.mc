import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Weather;
import Toybox.WatchUi;

class StrideRenderer {
    private var _time as Graphics.FontType = Graphics.FONT_NUMBER_HOT;
    private var _timeOutline as Graphics.FontType = Graphics.FONT_NUMBER_HOT;
    private var _value as Graphics.FontType = Graphics.FONT_SMALL;
    private var _small as Graphics.FontType = Graphics.FONT_XTINY;
    private var _label as Graphics.FontType = Graphics.FONT_XTINY;
    private var _date as Graphics.FontType = Graphics.FONT_TINY;
    private var _weather as Graphics.FontType = Graphics.FONT_TINY;
    function initialize() {}
    function layout() as Void {
        _time = WatchUi.loadResource(Rez.Fonts.Time) as WatchUi.FontResource;
        _timeOutline = WatchUi.loadResource(Rez.Fonts.TimeOutline) as WatchUi.FontResource;
        _value = WatchUi.loadResource(Rez.Fonts.Value) as WatchUi.FontResource;
        _small = WatchUi.loadResource(Rez.Fonts.Compact) as WatchUi.FontResource;
        var label = Graphics.getVectorFont({:face => "RobotoCondensedRegular", :size => StrideTheme.LABEL_SIZE});
        var date = Graphics.getVectorFont({:face => "RobotoRegular", :size => StrideTheme.DATE_SIZE});
        var weather = Graphics.getVectorFont({:face => "RobotoRegular", :size => StrideTheme.WEATHER_SIZE});
        if (label != null) { _label = label; }
        if (date != null) { _date = date; }
        if (weather != null) { _weather = weather; }
    }
    function text(dc as Graphics.Dc, x as Number, y as Number, font as Graphics.FontType, value as String, color as Number) as Void {
        dc.setColor(color,Graphics.COLOR_TRANSPARENT);
        dc.drawText(x,y,font,value,StrideTheme.ALIGN);
    }
    function progress(dc as Graphics.Dc, y as Number, ratio as Float, color as Number, track as Number) as Void {
        var width = Math.round(ratio*StrideTheme.BAR_WIDTH).toNumber();
        for (var i = 0; i < StrideTheme.BAR_SEGMENTS; i += 1) {
            var start = i*StrideTheme.BAR_WIDTH/StrideTheme.BAR_SEGMENTS;
            var end = (i+1)*StrideTheme.BAR_WIDTH/StrideTheme.BAR_SEGMENTS;
            var gap = i == StrideTheme.BAR_SEGMENTS-1 ? 0 : StrideTheme.BAR_GAP;
            var segmentWidth = end-start-gap;
            dc.setColor(track,Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(StrideTheme.BAR_X+start,y,segmentWidth,StrideTheme.BAR_HEIGHT);
            var fill = width-start;
            if (fill > segmentWidth) { fill = segmentWidth; }
            if (fill > 0) {
                dc.setColor(color,Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(StrideTheme.BAR_X+start,y,fill,StrideTheme.BAR_HEIGHT);
            }
        }
    }
    function metric(dc as Graphics.Dc, y as Number, value as String, label as String, color as Number) as Void {
        var font = dc.getTextWidthInPixels(value,_value) > StrideTheme.METRIC_WIDTH ? _small : _value;
        text(dc,StrideTheme.METRIC_VALUE_X,y,font,value,value == "--" ? StrideTheme.MUTED : StrideTheme.WHITE);
        text(dc,StrideTheme.METRIC_X,y+StrideTheme.LABEL_OFFSET,_label,label,value == "--" ? StrideTheme.MUTED : color);
    }
    function draw(dc as Graphics.Dc, data as StrideData) as Void {
        dc.setColor(StrideTheme.WHITE,StrideTheme.BLACK); dc.clear(); dc.setAntiAlias(true);
        dc.setPenWidth(1);
        var batteryColor = data.battery == null ? StrideTheme.MUTED : (data.battery < 30 ? StrideTheme.LOW : StrideTheme.STEPS);
        dc.setColor(batteryColor,Graphics.COLOR_TRANSPARENT);
        var bx = StrideTheme.BATTERY_ICON_X; var by = StrideTheme.BATTERY_ICON_Y;
        dc.drawRoundedRectangle(bx,by,18,11,2); dc.fillRectangle(bx+19,by+3,2,5);
        if (data.battery != null && data.battery > 0) {
            var fill = Math.round(data.battery*0.12f).toNumber();
            dc.fillRectangle(bx+3,by+3,fill < 1 ? 1 : fill,5);
        }
        text(dc,StrideTheme.BATTERY_X,StrideTheme.BATTERY_Y,_small,StrideFormat.percent(data.battery),StrideTheme.WHITE);
        text(dc,StrideTheme.DATE_X,StrideTheme.DATE_Y,_date,data.dateText,StrideTheme.MUTED);
        text(dc,StrideTheme.TIME_X,StrideTheme.HOURS_Y,_time,data.timeText.substring(0,2),StrideTheme.HOUR_FILL);
        text(dc,StrideTheme.TIME_X,StrideTheme.HOURS_Y,_timeOutline,data.timeText.substring(0,2),StrideTheme.ACCENT);
        text(dc,StrideTheme.TIME_X,StrideTheme.MINUTES_Y,_time,data.timeText.substring(3,5),StrideTheme.WHITE);
        metric(dc,StrideTheme.STEPS_Y,StrideFormat.steps(data.steps),"PASOS",StrideTheme.STEPS);
        footsteps(dc,StrideTheme.METRIC_ICON_X,StrideTheme.STEPS_Y,data.steps == null ? StrideTheme.MUTED : StrideTheme.STEPS);
        progress(dc,StrideTheme.STEPS_Y+StrideTheme.BAR_OFFSET,StrideFormat.progress(data.steps,data.goal),StrideTheme.STEPS,StrideTheme.STEPS_TRACK);
        metric(dc,StrideTheme.BODY_Y,StrideFormat.number(data.body),"BODY BATTERY",StrideTheme.BODY);
        energy(dc,StrideTheme.METRIC_ICON_X,StrideTheme.BODY_Y,data.body == null ? StrideTheme.MUTED : StrideTheme.BODY);
        progress(dc,StrideTheme.BODY_Y+StrideTheme.BAR_OFFSET,StrideFormat.progress(data.body,100),StrideTheme.BODY,StrideTheme.BODY_TRACK);
        metric(dc,StrideTheme.HEART_Y,StrideFormat.number(data.heartRate),"PULSO / LPM",StrideTheme.MUTED);
        heart(dc,StrideTheme.METRIC_ICON_X,StrideTheme.HEART_Y,StrideTheme.MUTED);
        weather(dc,StrideTheme.WEATHER_ICON_X,StrideTheme.WEATHER_Y,data.condition);
        text(dc,StrideTheme.TEMPERATURE_X,StrideTheme.WEATHER_Y,_weather,StrideFormat.temperature(data.temperature),StrideTheme.WHITE);
        dc.setColor(StrideTheme.MUTED,Graphics.COLOR_TRANSPARENT);
        dc.drawLine(StrideTheme.WEATHER_SEPARATOR_X,StrideTheme.WEATHER_Y-12,StrideTheme.WEATHER_SEPARATOR_X,StrideTheme.WEATHER_Y+12);
        droplet(dc,StrideTheme.RAIN_ICON_X,StrideTheme.WEATHER_Y);
        text(dc,StrideTheme.RAIN_X,StrideTheme.WEATHER_Y,_weather,StrideFormat.percent(data.rain),StrideTheme.WHITE);
        dc.setPenWidth(1);
    }
    function footsteps(dc as Graphics.Dc, x as Number, y as Number, color as Number) as Void {
        dc.setColor(color,Graphics.COLOR_TRANSPARENT); dc.setPenWidth(3);
        dc.fillCircle(x-3,y-7,2); dc.drawLine(x-4,y-2,x-5,y+3);
        dc.fillCircle(x+4,y-2,2); dc.drawLine(x+3,y+3,x+2,y+8);
        dc.setPenWidth(1);
    }
    function energy(dc as Graphics.Dc, x as Number, y as Number, color as Number) as Void {
        dc.setColor(color,Graphics.COLOR_TRANSPARENT); dc.setPenWidth(2);
        dc.drawLine(x+3,y-8,x-4,y+1); dc.drawLine(x-4,y+1,x+3,y+1);
        dc.drawLine(x+3,y+1,x-3,y+8); dc.setPenWidth(1);
    }
    function heart(dc as Graphics.Dc, x as Number, y as Number, color as Number) as Void {
        dc.setColor(color,Graphics.COLOR_TRANSPARENT); dc.setPenWidth(2);
        dc.drawArc(x-3,y-2,4,Graphics.ARC_CLOCKWISE,180,0);
        dc.drawArc(x+3,y-2,4,Graphics.ARC_CLOCKWISE,180,0);
        dc.drawLine(x-7,y-2,x-7,y); dc.drawLine(x+7,y-2,x+7,y);
        dc.drawLine(x-7,y,x,y+8); dc.drawLine(x+7,y,x,y+8); dc.setPenWidth(1);
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
