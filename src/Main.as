//---------------------------------------------------------------------------
//
//    Copyright 2011-2012 Reyna D "rustleson"
//
//---------------------------------------------------------------------------
//
//    This file is part of MotIL.
//
//    MotIL is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    MotIL is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with MotIL.  If not, see <http://www.gnu.org/licenses/>.
//
//---------------------------------------------------------------------------

package{

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.Math.*;
    import flash.events.Event;
    import flash.display.*;
    import flash.text.*;
    import flash.net.SharedObject;
    import General.*;
    import Engine.Objects.Utils;
    import Engine.Worlds.*;
    import Engine.Dialogs.*;
    import Engine.Stats.*;
    import Engine.Dialogs.Widgets.*;
    import flash.geom.Matrix; 
    import flash.display.*;

    [SWF(width='640', height='480', backgroundColor='#000000', frameRate='30')] // ???frameRate='25' is more smoother???
	
	public class Main extends MovieClip{

	    static public var fpsCounter:FpsCounter = new FpsCounter();
	    public var currId:int = 0;
	    static public var currWorld:World;
	    static public var sprite:Sprite;
	    static public var statsSprite:Sprite;
	    static public var helpSprite:Sprite;
	    static public var aboutText:TextField;
	    static public var appWidth:int;
	    static public var appHeight:int;
	    public var input:Input;
	    public var stats:ProtagonistStats;
	    static public var seed:uint;
	    static public var version:String = "0.0.5-alpha";
	    static public var tenorion:Tenorion = new Tenorion(); 
	    static public var save:SharedObject = SharedObject.getLocal('MotIL', '/');
	    private var autoRebirthNeeded:Boolean = false;

	    public function Main() {
		//stage.scaleMode = StageScaleMode.NO_SCALE;
		//stage.quality = StageQuality.MEDIUM;
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		addEventListener(Event.CLOSE, onClose);
		sprite = new Sprite();
		statsSprite = new Sprite();
		helpSprite = new Sprite();
		addChild(sprite);
		fpsCounter.x = 510;
		fpsCounter.y = 110;
		addChild(fpsCounter);
		fpsCounter.visible = false;
		addChild(statsSprite);
		addChild(helpSprite);
		input = new Input(sprite);
		appWidth = stage.stageWidth;
		appHeight = stage.stageHeight;
		seed = 2547235893;
		stats = new ProtagonistStats();
		if (!stats.load()) {
		    this.autoRebirthNeeded = true;
		}
		currWorld = new EntranceWorld(stats, seed);
		currWorld.tenorion = tenorion;
		// if (stats.muteSound) { }
	    }

	    private function autoRebirth():void {
		var space:Number = 0;
		var water:Number = 0;
		var earth:Number = 0;
		var fire:Number = 0;
		var air:Number = 0;
		var tribe:int = 0;
		var maxElement:Number = Math.max(stats.space, stats.water, stats.earth, stats.fire, stats.air);
		// you will be born in a realm of the element you have maximum affinity with
		if (stats.space >= maxElement) {
		    space = 1;
		} else if (stats.water >= maxElement) {
		    water = 1;
		} else if (stats.fire >= maxElement) {
		    fire = 1;
		} else if (stats.earth >= maxElement) {
		    earth = 1;
		} else if (stats.air >= maxElement) {
		    air = 1;
		}  
		// space = 0; air = 1; // for testing
		var vaginaValue:Number = this.stats.vaginaSlot.stretchedDiameter.levelFrac * this.stats.vaginaSlot.stretchedLength.levelFrac;
		var anusValue:Number = this.stats.anusSlot.stretchedDiameter.levelFrac * this.stats.anusSlot.stretchedLength.levelFrac;
		var mouthValue:Number = this.stats.mouthSlot.stretchedDiameter.levelFrac * this.stats.mouthSlot.stretchedLength.levelFrac;
		// your future tribe depends on which hole you're most skilled with
		if (vaginaValue >= anusValue && vaginaValue >= mouthValue) {
		    tribe = ProtagonistStats.DAKINI_TRIBE;
		} else if (anusValue >= vaginaValue && anusValue >= mouthValue) {
		    tribe = ProtagonistStats.RAKSHASI_TRIBE;
		} else if (mouthValue >= anusValue && mouthValue >= vaginaValue) {
		    tribe = ProtagonistStats.YAKSHINI_TRIBE;
		}
		var ageConfirmed:Boolean = this.stats.ageConfirmed;
		stats = new ProtagonistStats();
		stats.space = space;
		stats.water = water;
		stats.earth = earth;
		stats.fire = fire;
		stats.air = air;
		stats.tribe = tribe;
		stats.ageConfirmed = ageConfirmed;
		// your appearance will be semi-random, depending on last room's PRNG state 
		// death in the same room should guarantee same appearance each time
		stats.hairColor = Utils.HSLtoRGB(Rndm.integer(0, 360), 0.5, Rndm.float(0.1, 0.6));
		stats.eyesColor = Utils.HSLtoRGB(Rndm.integer(0, 360), 0.5, 0.5);
		stats.hairLength = Rndm.float(0.5, 2.5);
	    }
		
	    public function update(e:Event):void{
		sprite.graphics.clear();
		if (stats.death){
		    currWorld.deconstruct();
		    this.autoRebirth();
		    currWorld = new MandalaWorld(stats, seed, tenorion, false);
		    currWorld.tenorion = tenorion;
		    currWorld.tenorion.matrixPad.tendence = (currWorld as MandalaWorld).roomSongTendencies[(currWorld as MandalaWorld).startType];
		    currWorld.tenorion.matrixPad.generateUniversalSong();
		    currWorld.tenorion.voices[0] = Main.tenorion.presetVoice['valsound.percus3'];
		    this.stats.statsDialog.widgets.message.show(new Message("You have been died and reborn again. Be careful this time. Good luck!", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial));
		    stats.save();
		}
		if (stats.generated) {
		    currWorld.deconstruct();
		    if (this.autoRebirthNeeded) {
			this.autoRebirth();
			this.autoRebirthNeeded = false;
			currWorld = new MandalaWorld(stats, seed, tenorion, false);
			this.stats.statsDialog.widgets.message.show(new Message("Welcome to the Mandala of the Interpenetrating lights! \nWe are always glad to see the young spirit coming.", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial));
			this.stats.statsDialog.widgets.message.show(new Message("You can meditate on this world's sacred book called \n\"Hyper Enlightened Liberty Prerequisites\" (HELP) \njust by pressing <?> at any time. ", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial)); 
		    } else {
			currWorld = new MandalaWorld(stats, seed, tenorion);
			this.stats.statsDialog.widgets.message.show(new Message("Welcome back to the Mandala of the Interpenetrating lights! \nWe are always glad to see your growing spirit again.", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial));
			this.stats.statsDialog.widgets.message.show(new Message("You can meditate on this world's sacred book called \n\"Hyper Enlightened Liberty Prerequisites\" (HELP) \njust by pressing <?> at any time. ", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial)); 
		    }
		    currWorld.tenorion = tenorion;
		    currWorld.tenorion.matrixPad.tendence = (currWorld as MandalaWorld).roomSongTendencies[(currWorld as MandalaWorld).startType];
		    currWorld.tenorion.matrixPad.generateUniversalSong();
		    this.stats.generated = false;
		    stats.save();
		}
		currWorld.update();
		Input.update();
		fpsCounter.update();
		FRateLimiter.limitFrame(30);
	    }

	    private function onClose():void {
		this.stats.save();
	    }
	    
	}

}
