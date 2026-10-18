import Toybox.Lang;

module PilotTheme {
    const BLACK = 0x000000;
    const WHITE = 0xF3F1EC;
    const GRAPHITE = 0x27292C;
    const MUTED = 0x777777;
    const TRACK = 0x777777;
    const SUN = 0xDAB779;
    const BATTERY_HIGH = 0xA8CFA0;
    const BATTERY_MEDIUM = 0xDAB779;
    const BATTERY_LOW = 0xE08A80;
    const CENTER = 195;
    const TICK_OUTER = 181;
    const TICK_INNER = 174;
    const HOUR_INNER = 169;
    const NUMERAL_RADIUS = 143;
    const BATTERY_Y = 97;
    const WEATHER_X = 103;
    const DATE_X = 287;
    const STEPS_Y = 286;
    const HOUR_LENGTH = 104;
    const HOUR_WIDTH = 16;
    const MINUTE_LENGTH = 148;
    const SECOND_LENGTH = 167;

    function batteryColor(value as Numeric?) as Number {
        if (value == null || value < 0 || value > 100) { return WHITE; }
        if (value >= 80) { return BATTERY_HIGH; }
        if (value >= 30) { return BATTERY_MEDIUM; }
        return BATTERY_LOW;
    }
}
