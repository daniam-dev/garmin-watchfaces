import Toybox.Complications;
import Toybox.Lang;
import Toybox.Test;

(:test)
function pilotComplicationTargets(logger as Test.Logger) as Boolean {
    Test.assertEqual(PilotTargets.at(195,97),Complications.COMPLICATION_TYPE_BATTERY);
    Test.assertEqual(PilotTargets.at(103,195),Complications.COMPLICATION_TYPE_CURRENT_WEATHER);
    Test.assertEqual(PilotTargets.at(287,195),Complications.COMPLICATION_TYPE_DATE);
    Test.assertEqual(PilotTargets.at(195,286),Complications.COMPLICATION_TYPE_STEPS);
    Test.assert(PilotTargets.at(195,195) == null);
    Test.assert(PilotTargets.at(0,0) == null);
    Test.assert(PilotTargets.at(146,48) == null);
    return true;
}
