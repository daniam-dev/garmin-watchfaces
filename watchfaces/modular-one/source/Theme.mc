import Toybox.Graphics;
import Toybox.Lang;

module Theme {
    const BACKGROUND = 0x000000;
    const TEXT = 0xF4F5F3;
    const MUTED = 0xA4AAA8;
    const STEPS = 0x42BDD9;
    const INTENSITY = 0xF0B965;
    const BODY = 0x37CFAB;
    const BODY_TRACK = 0x28574B;
    const BODY_OUTLINE = 0x326153;
    const OUTLINE = 0x3B4546;
    const SURFACE = 0x102823;
    const WEATHER_DIAL = 0x282216;
    const RAIN_DIAL = 0x12242B;
    const BATTERY_DIAL = 0x1C251B;
    const WEATHER_OUTLINE = 0x71582F;
    const RAIN_OUTLINE = 0x2B5864;
    const BATTERY_OUTLINE = 0x465B3B;
    const TICK = 0x727A78;
    const WEATHER = 0xF8C32A;
    const CLOUD = 0xD8DAD8;
    const BATTERY = 0x929496;
    const BATTERY_HIGH = 0x9FD76B;
    const BATTERY_MEDIUM = 0xE5BC5B;
    const BATTERY_LOW = 0xEC7975;
    const CENTER = 195;
    const DATE_Y = 80;
    const TIME_Y = 139;
    const PANEL_X = 58;
    const PANEL_Y = 188;
    const PANEL_WIDTH = 274;
    const PANEL_HEIGHT = 82;
    const PANEL_RADIUS = 17;
    const GAUGE_X = 113;
    const GAUGE_Y = 232;
    const BODY_VALUE_Y = 234;
    const BODY_TITLE_Y = 213;
    const BODY_STATUS_Y = 238;
    const GAUGE_RADIUS = 32;
    const GAUGE_WIDTH = 13;
    const DIAL_Y = 310;
    const DIAL_RADIUS = 33;
    const DIAL_ICON_Y = 295;
    const DIAL_VALUE_Y = 324;
    const BATTERY_ICON_Y = 299;
    const BATTERY_VALUE_Y = 322;
    const METRICS_VALUE_Y = 58;
    const METRICS_ICON_Y = 38;
    const STEPS_METRIC_X = 158;
    const INTENSITY_METRIC_X = 232;
    const STEPS_ICON_SCALE = 0.7f;
    const LEFT_X = 116;
    const RIGHT_X = 274;
    const ARC_RADIUS = 180;
    const ARC_WIDTH = 4;
    const MARKER_RADIUS = 5;
    const ARC_SWEEP = 168;
    const STEPS_ARC_START = 96;
    const RIGHT_ARC_START = 84;
    const BATTERY_RADIUS = 29;
    const TIME_SIZE = 148;
    const TIME_FACE = "RobotoCondensedBold";
    const CALENDAR_SIZE = 17;
    const VALUE_SIZE = 26;
    const LABEL_SIZE = 16;
    const COMPACT_SIZE = 14;
    const DATE_SIZE = 19;
    const BODY_SIZE = 29;
    const TEXT_CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

    function batteryColor(value as Numeric?) as Number {
        if (value == null || value < 0 || value > 100) { return BATTERY; }
        if (value >= 60) { return BATTERY_HIGH; }
        if (value >= 30) { return BATTERY_MEDIUM; }
        return BATTERY_LOW;
    }
}
