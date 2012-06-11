// ..re-touched version of
// SiON TENORION for v0.57
// [GUI is banished in favor of API for CG sound]
package General {
    import flash.display.*;
    import flash.events.*;
    import flash.text.TextField;
    import org.si.sion.*;
    import org.si.sion.events.*;
    import org.si.sion.utils.SiONPresetVoice;
    import org.si.sion.effector.SiCtrlFilterLowPass;
    import General.Input;
    
    [SWF(backgroundColor="#000000")]
    public class Tenorion extends Sprite {
        // driver
        public var driver:SiONDriver = new SiONDriver();
        
        // preset voice
        public var presetVoice:SiONPresetVoice = new SiONPresetVoice();
        
        // voices, notes and tracks
        public var voices:Vector.<SiONVoice> = new Vector.<SiONVoice>(16);
        public var notes :Vector.<int>;
        public var notes1 :Vector.<int> = Vector.<int>([36,48,60,72, 43,46,55,43, 43,44,50,55, 50,54,57,60, 60,64,66,71,]);
        public var notes2 :Vector.<int> = Vector.<int>([36,48,60,72, 46,50,52,46, 46,41,53,55, 48,52,59,55, 62,66,71,74,]);
        public var notes3 :Vector.<int> = Vector.<int>([36,48,60,72, 41,45,55,41, 43,48,55,56, 54,50,62,60, 55,59,60,64,]);
	public var phrases:Vector.<String> = Vector.<String>(["AABB", "AABC", "ABAB", "ABAC", "AAAB", "BBCC", "BBCA", "BCBC", "BCBA", "BBBC", "CCAA", "CCAB", "CACA", "CACB", "CCCA"]);
	public var phrase:String = "AABB";
        public var length:Vector.<int> = Vector.<int>([ 1, 1, 1, 1,  1, 1, 1, 1,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4]);
        
        // beat counter
        public var beatCounter:int;
        
        // control pad
        public var matrixPad:MatrixPad;
	
	// mute sound trigger
	public var muteSound:Boolean = false;
	
	public var needRebuild:Boolean = true;
	
	//public var filter:SiCtrlFilterLowPass = new SiCtrlFilterLowPass();
	private var cutoffCur:Number = 1;
	private var cutoffTo:Number = 1
	private var resCur:Number = 0.5;
	private var resTo:Number = 0.5;

        // constructor
        function Tenorion() {
            var i:int;
            
            // set voices from preset
            var percusVoices:Array = presetVoice["valsound.percus"];
            voices[0] = presetVoice["valsound.percus3"];  // bass drum
            voices[1] = percusVoices[27]; // snare drum
            voices[2] = percusVoices[16]; // close hihat
            voices[3] = percusVoices[22]; // open hihat
            for (i=4; i<8;  i++) voices[i] = presetVoice["valsound.bass18"];  // bass
            for (i=8; i<12; i++) voices[i] = presetVoice["valsound.special4"]; 
            for (i=12; i<16; i++) voices[i] = presetVoice["valsound.strpad19"]; // strpad7, 15, 19?!, wind5, special1, 2, 4, lead10, 11, 19(highCPU), 34, 37, 38?, 39!
            for (i=16; i<20; i++) voices[i] = presetVoice["valsound.bell16"];


            // listen
            driver.setBeatCallbackInterval(1);
            driver.addEventListener(SiONTrackEvent.BEAT, _onBeat);
            driver.setTimerInterruption(1, _onTimerInterruption);
            
            // control pad
            with(addChild(matrixPad = new MatrixPad(stage))) {
                x = y = 72;
            }

            // start streaming
            beatCounter = 0;
	    notes = notes1;
	    //filter.control(1, 0.5);
	    //driver.effector.slot0 = [filter];
	    if (!this.muteSound)
		driver.play(null, false);
        }
        
        
        // _onBeat (SiONTrackEvent.BEAT) is called back in each beat at the sound timing.
        private function _onBeat(e:SiONTrackEvent) : void {
	    //if (beatCounter % 16 == 0)
	    //matrixPad.square(e.eventTriggerID & 15);
        }
        
        
        // _onTimerInterruption (SiONDriver.setTimerInterruption) is called back in each beat at the buffering timing.
        private function _onTimerInterruption() : void {
	    if (!muteSound) {
		var beatIndex:int = beatCounter & 15;
		if (beatCounter % 128 == 0 && needRebuild) {
		    matrixPad.generateUniversalSong();
		    needRebuild = false;
		}
		if (beatCounter % 512 == 0) {
		    phrase = phrases[Math.floor(Math.random() * 24) % 15];
		}
		cutoffCur += (cutoffTo - cutoffCur) * 0.05;
		resCur += (resTo - resCur) * 0.05;
		//filter.control(cutoffCur, resCur);
		if (beatCounter % 64 == 0) {
		    cutoffTo = Math.random() / 4 + 0.375;
		    resTo = Math.random() / 4 + 0.375;
		    var code:String = phrase.substr(Math.floor((beatCounter % 256) / 64), 1);
		    if (code == "A") {
			notes = notes1;
		    } else if (code == "B") {
			notes = notes2;
		    } else {
			notes = notes3;
		    }
		}
		for (var i:int=0; i<20; i++) {
		    if (beatCounter % 64 >= 48) {
			if (matrixPad.sequencesFill[i] & (1<<beatIndex)) driver.noteOn(notes[i], voices[i], length[i]);
		    } else { 
			if (matrixPad.sequences[i] & (1<<beatIndex)) driver.noteOn(notes[i], voices[i], length[i]);
		    }
		}
		beatCounter++;
	    }
        }
    }
}

