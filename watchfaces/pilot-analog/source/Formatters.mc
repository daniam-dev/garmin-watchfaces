import Toybox.Lang;
import Toybox.Math;

module PilotFormat {
    const MONTHS = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];
    function percent(value as Numeric?) as Numeric? {
        if (value == null || value < 0 || value > 100) { return null; }
        return value;
    }
    function progress(value as Numeric?, goal as Numeric?) as Float {
        if (value == null || goal == null || value <= 0 || goal <= 0) { return 0.0f; }
        var ratio = value.toFloat() / goal.toFloat();
        return ratio > 1.0f ? 1.0f : ratio;
    }
    function integer(value as Numeric?) as String {
        return value == null ? "--" : value.toNumber().format("%d");
    }
    function temperature(value as Numeric?) as String {
        return value == null ? "--°" : Math.round(value).toNumber().format("%d") + "°";
    }
    function steps(value as Number?) as String {
        if (value == null || value < 0) { return "--"; }
        var text = value.format("%d");
        var result = "";
        while (text.length() > 3) {
            var split = text.length() - 3;
            result = "." + text.substring(split, text.length()) + result;
            text = text.substring(0, split);
        }
        return text + result;
    }
    function hourAngle(hour as Number, minute as Number, second as Number) as Float {
        return ((hour % 12) * 30.0f + minute * 0.5f + second / 120.0f).toFloat();
    }
    function minuteAngle(minute as Number, second as Number) as Float {
        return (minute * 6.0f + second * 0.1f).toFloat();
    }
}
