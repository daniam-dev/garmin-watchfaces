import Toybox.Graphics;
import Toybox.Lang;

module Theme {
    const BACKGROUND = 0x000000;
    const TEXT = 0xFFF9EC;
    const MUTED = 0xBDBDBB;
    const STEPS = 0x20E0DF;
    const STEPS_TRACK = 0x106E70;
    const BODY = 0xFF997A;
    const BODY_TRACK = 0x874B41;
    const OUTLINE = 0x333536;
    const WEATHER = 0xF8C32A;
    const CLOUD = 0xD8DAD8;
    const BATTERY = 0x929496;
    const BATTERY_HIGH = 0xA8CFA0;
    const BATTERY_MEDIUM = 0xDAB779;
    const BATTERY_LOW = 0xE08A80;
    const CENTER = 195;
    const TOP_Y = 106;
    const TOP_RADIUS = 36;
    const WEATHER_Y = 92;
    const WEATHER_RADIUS = 39;
    const LEFT_X = 113;
    const RIGHT_X = 277;
    const TIME_Y = 201;
    const ARC_RADIUS = 180;
    const ARC_WIDTH = 12;
    const ARC_SWEEP = 168;
    const STEPS_ARC_START = 96;
    const BODY_ARC_START = 84;
    const BATTERY_Y = 311;
    const BATTERY_RADIUS = 39;
    const TEXT_CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

    function batteryColor(value as Numeric?) as Number {
        if (value == null || value < 0 || value > 100) { return BATTERY; }
        if (value >= 80) { return BATTERY_HIGH; }
        if (value >= 30) { return BATTERY_MEDIUM; }
        return BATTERY_LOW;
    }
}
