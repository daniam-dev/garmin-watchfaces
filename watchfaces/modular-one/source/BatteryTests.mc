import Toybox.Lang;
import Toybox.Test;

(:test)
function modularBatteryColors(logger as Test.Logger) as Boolean {
    Test.assertEqual(Theme.batteryColor(100),Theme.BATTERY_HIGH);
    Test.assertEqual(Theme.batteryColor(80),Theme.BATTERY_HIGH);
    Test.assertEqual(Theme.batteryColor(79.9f),Theme.BATTERY_MEDIUM);
    Test.assertEqual(Theme.batteryColor(50),Theme.BATTERY_MEDIUM);
    Test.assertEqual(Theme.batteryColor(30),Theme.BATTERY_MEDIUM);
    Test.assertEqual(Theme.batteryColor(29.9f),Theme.BATTERY_LOW);
    Test.assertEqual(Theme.batteryColor(15),Theme.BATTERY_LOW);
    Test.assertEqual(Theme.batteryColor(0),Theme.BATTERY_LOW);
    Test.assertEqual(Theme.batteryColor(null),Theme.BATTERY);
    Test.assertEqual(Theme.batteryColor(-1),Theme.BATTERY);
    Test.assertEqual(Theme.batteryColor(101),Theme.BATTERY);
    return true;
}
