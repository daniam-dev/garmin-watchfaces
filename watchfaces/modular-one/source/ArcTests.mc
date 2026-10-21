import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

(:test)
function modularArcCentering(logger as Test.Logger) as Boolean {
    // Comprueba simetría en píxeles, sin duplicar el cálculo trigonométrico.
    var radii = [Theme.ARC_RADIUS, Theme.GAUGE_RADIUS, Theme.BATTERY_RADIUS];
    var centersX = [Theme.CENTER, Theme.GAUGE_X, Theme.RIGHT_X];
    var centersY = [Theme.CENTER, Theme.GAUGE_Y, Theme.DIAL_Y];
    for (var i = 0; i < radii.size(); i += 1) {
        for (var angle = 0; angle < 360; angle += 1) {
            var point = Components.arcPoint(centersX[i], centersY[i], radii[i], angle);
            var opposite = Components.arcPoint(centersX[i], centersY[i], radii[i], angle + 180);
            Test.assertEqual(point[0] + opposite[0], 2 * centersX[i]);
            Test.assertEqual(point[1] + opposite[1], 2 * centersY[i]);
            var dx = point[0] - centersX[i];
            var dy = point[1] - centersY[i];
            var error = Math.sqrt(dx * dx + dy * dy) - radii[i];
            // Al redondear ambos ejes, el error radial máximo es sqrt(0,5²+0,5²).
            Test.assert(error >= -0.708f && error <= 0.708f);
        }
    }
    var top = Components.arcPoint(195, 195, 180, 90);
    Test.assertEqual(top[0], 195);
    Test.assertEqual(top[1], 15);
    var bottom = Components.arcPoint(195, 195, 180, -90);
    Test.assertEqual(bottom[0], 195);
    Test.assertEqual(bottom[1], 375);
    return true;
}

(:test)
function modularArcFillAndDrain(logger as Test.Logger) as Boolean {
    var previous = -1;
    for (var i = 0; i <= 1000; i += 1) {
        var progress = i / 1000.0f;
        var degrees = Components.progressDegrees(Theme.ARC_SWEEP, progress);
        Test.assert(degrees >= previous && degrees >= 0 && degrees <= Theme.ARC_SWEEP);
        var error = degrees - Theme.ARC_SWEEP * progress;
        Test.assert(error >= -0.501f && error <= 0.501f);
        var left = Components.arcPoint(Theme.CENTER, Theme.CENTER, Theme.ARC_RADIUS,
                                       Theme.STEPS_ARC_START + degrees);
        var right = Components.arcPoint(Theme.CENTER, Theme.CENTER, Theme.ARC_RADIUS,
                                        Theme.RIGHT_ARC_START - degrees);
        Test.assertEqual(left[0] + right[0], 2 * Theme.CENTER);
        Test.assertEqual(left[1], right[1]);
        previous = degrees;
    }
    previous = Theme.ARC_SWEEP + 1;
    for (var i = 1000; i >= 0; i -= 1) {
        var degrees = Components.progressDegrees(Theme.ARC_SWEEP, i / 1000.0f);
        Test.assert(degrees <= previous);
        previous = degrees;
    }
    Test.assertEqual(previous, 0);
    Test.assertEqual(Components.progressDegrees(360, 0.0f), 0);
    Test.assertEqual(Components.progressDegrees(360, 0.0001f), 0);
    Test.assertEqual(Components.progressDegrees(360, 1.0f), 360);
    Test.assertEqual(Components.progressDegrees(180, -0.1f), 0);
    Test.assertEqual(Components.progressDegrees(180, 1.1f), 180);
    return true;
}
