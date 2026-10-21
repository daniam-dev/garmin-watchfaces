import Toybox.Lang;
import Toybox.Math;

module StrideFormat {
    const DAYS = ["DOM","LUN","MAR","MIÉ","JUE","VIE","SÁB"];
    const MONTHS = ["ENE","FEB","MAR","ABR","MAY","JUN","JUL","AGO","SEP","OCT","NOV","DIC"];
    function number(value as Numeric?) as String { return value == null ? "--" : value.toNumber().format("%d"); }
    function percent(value as Numeric?) as String { return value == null ? "--" : number(value) + "%"; }
    function temperature(value as Numeric?) as String { return value == null ? "--" : Math.round(value).toNumber().format("%d") + "°"; }
    function validPercent(value as Numeric?) as Numeric? { return value == null || value < 0 || value > 100 ? null : value; }
    function nonNegative(value as Number?) as Number? { return value == null || value < 0 ? null : value; }
    function heartRate(value as Number?) as Number? { return value == null || value <= 0 ? null : value; }
    function progress(value as Numeric?, goal as Numeric?) as Float {
        if (value == null || goal == null || goal <= 0 || value <= 0) { return 0.0f; }
        return value >= goal ? 1.0f : value.toFloat()/goal.toFloat();
    }
    function steps(value as Number?) as String {
        if (value == null) { return "--"; }
        var raw = value.format("%d");
        var result = "";
        for (var i = 0; i < raw.length(); i += 1) {
            if (i > 0 && (raw.length()-i)%3 == 0) { result += "."; }
            result += raw.substring(i,i+1);
        }
        return result;
    }
}
