package General {

    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class MatrixPad extends Bitmap {
	public var sequences:Vector.<int> = new Vector.<int>(20);
	public var sequencesFill:Vector.<int> = new Vector.<int>(20);
	public var tendence:int;
    
	function MatrixPad(stage:Stage) {
	    super(new BitmapData(320, 320, false, 0)); // rudiment
	    var i:int;
	    for (i=0; i<20; i++) sequences[i] = 0; 
	}
    
	public function generateUniversalSong($tendence:int = 0):void {
	    if ($tendence > 0) {
		tendence = $tendence;
	    }
	    for (var i:int=0; i<20; i++) sequences[i] = 0;
	    for (i=0; i<20; i++) sequencesFill[i] = 0;
	    for (i=0; i<12; i++) {
		var t:int = Math.floor((Math.random() * 16 - tendence) * 0.23 + tendence) % 20;
		var n:int = Math.floor(Math.random() * 16);
		var tg:int = Math.floor(t / 4) * 4;
		while ((sequences[tg] & 1<<n) || (sequences[tg + 1] & 1<<n) || (sequences[tg + 2] & 1<<n) || (sequences[tg + 3] & 1<<n)) {
		    n = (n + 1) % 20;
		}
		sequences[t] |= 1<<n;
		sequencesFill[t] = sequences[t];
	    }
	    for (i=0; i<6; i++) {
		t = Math.floor((Math.random() * 16 - tendence) * 0.23 + tendence) % 20;
		sequencesFill[t] |= 1<<Math.floor(Math.random() * 16);
		if (i % 3 == 0)
		    sequencesFill[0] |= 1<<Math.floor(Math.random() * 16);
	    }
	    sequences[0] |= 0x01 | 0x20 | 0x200 | 0x2000;
	    sequencesFill[0] |= 0x01 | 0x20 | 0x200 | 0x2000;
	}
    
    
	public function square(beat16th:int) : void {
	    // TODO
	}
    }

}