import Toybox.Complications;
import Toybox.Lang;
import Toybox.Test;

(:test)
function modularComplicationTargets(logger as Test.Logger) as Boolean {
    Test.assertEqual(ModularTargets.at(158,40),Complications.COMPLICATION_TYPE_STEPS);
    Test.assertEqual(ModularTargets.at(232,60),Complications.COMPLICATION_TYPE_INTENSITY_MINUTES);
    Test.assertEqual(ModularTargets.at(195,80),Complications.COMPLICATION_TYPE_DATE);
    Test.assertEqual(ModularTargets.at(113,232),Complications.COMPLICATION_TYPE_BODY_BATTERY);
    Test.assertEqual(ModularTargets.at(329,268),Complications.COMPLICATION_TYPE_BODY_BATTERY);
    Test.assertEqual(ModularTargets.at(116,310),Complications.COMPLICATION_TYPE_CURRENT_WEATHER);
    Test.assertEqual(ModularTargets.at(195,310),Complications.COMPLICATION_TYPE_CURRENT_WEATHER);
    Test.assertEqual(ModularTargets.at(274,310),Complications.COMPLICATION_TYPE_BATTERY);
    Test.assertEqual(ModularTargets.at(15,195),Complications.COMPLICATION_TYPE_STEPS);
    Test.assertEqual(ModularTargets.at(375,195),Complications.COMPLICATION_TYPE_INTENSITY_MINUTES);
    Test.assert(ModularTargets.at(195,139) == null);
    Test.assert(ModularTargets.at(195,180) == null);
    Test.assert(ModularTargets.at(195,96) == null);
    Test.assert(ModularTargets.at(0,0) == null);
    Test.assert(ModularTargets.at(309,273) == null);
    return true;
}
