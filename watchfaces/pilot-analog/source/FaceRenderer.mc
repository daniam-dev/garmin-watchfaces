import Toybox.Graphics;
import Toybox.Lang;

class PilotRenderer {
    private var _dial as PilotDial;
    private var _complications as PilotComplications;
    function initialize() {
        _dial = new PilotDial();
        _complications = new PilotComplications();
    }
    function layout() as Void {
        _dial.layout();
        _complications.layout();
    }
    function draw(dc as Graphics.Dc, data as PilotData, hour as Number, minute as Number, second as Number) as Void {
        dc.setAntiAlias(true);
        _dial.draw(dc);
        _complications.draw(dc,data);
        PilotHands.draw(dc,hour,minute,second);
    }
}
