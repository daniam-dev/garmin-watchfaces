import Toybox.Lang;
import Toybox.Math;

module Formatters {
    const DAYS = ["DOM", "LUN", "MAR", "MIÉ", "JUE", "VIE", "SÁB"];
    const MONTHS = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];

    function clock(hour as Number, minute as Number) as String {
        return hour.format("%02d") + ":" + minute.format("%02d");
    }
    function integer(value as Numeric?) as String {
        return value == null ? "--" : value.toNumber().format("%d");
    }
    function percent(value as Numeric?) as String {
        return value == null ? "--" : integer(value) + "%";
    }
    function minutes(value as Number?) as String {
        return value == null ? "--" : integer(value) + " min";
    }
    function nonNegative(value as Number?) as Number? {
        return value == null || value < 0 ? null : value;
    }
    function temperature(value as Numeric?) as String {
        return value == null ? "--" : Math.round(value).toNumber().format("%d") + "°";
    }
    function steps(value as Number?) as String {
        if (value == null) { return "--"; }
        var raw = value.format("%d");
        var result = "";
        var count = 0;
        for (var i = raw.length() - 1; i >= 0; i -= 1) {
            if (count > 0 && count % 3 == 0) { result = "." + result; }
            result = raw.substring(i, i + 1) + result;
            count += 1;
        }
        return result;
    }
    // Unavailable values or an invalid denominator leave an empty track.
    function ratio(value as Numeric?, maximum as Numeric?) as Float {
        if (value == null || maximum == null || maximum <= 0 || value <= 0) { return 0.0f; }
        if (value >= maximum) { return 1.0f; }
        return value.toFloat() / maximum.toFloat();
    }
    function validPercent(value as Numeric?) as Numeric? {
        if (value == null || value < 0 || value > 100) { return null; }
        return value;
    }
}
