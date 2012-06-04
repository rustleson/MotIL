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
    import General.*;
    import Engine.Objects.Utils;
    import Engine.Worlds.*;
    import Engine.Dialogs.*;
    import Engine.Stats.*;
    import Engine.Dialogs.Widgets.*;
    import flash.geom.Matrix; 
    import flash.display.MovieClip;

    [SWF(width='640', height='480', backgroundColor='#000000', frameRate='30')] // ???frameRate='25' is more smoother???
	
	public class Main extends MovieClip{

	    static public var fpsCounter:FpsCounter = new FpsCounter();
	    public var currId:int = 0;
	    static public var currWorld:World;
	    static public var sprite:Sprite;
	    static public var statsSprite:Sprite;
	    static public var aboutText:TextField;
	    static public var appWidth:int;
	    static public var appHeight:int;
	    public var input:Input;
	    public var stats:ProtagonistStats;
	    public var seed:uint;
	    public var tenorion:Tenorion = new Tenorion(); // just uncomment to build with sound support

	    public function Main() {
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		sprite = new Sprite();
		statsSprite = new Sprite();
		addChild(sprite);
		addChild(statsSprite);
		fpsCounter.x = 7;
		fpsCounter.y = 430;
		addChild(fpsCounter);
		input = new Input(sprite);
		appWidth = stage.stageWidth;
		appHeight = stage.stageHeight;
		seed = 2547235893;
		stats = new ProtagonistStats();
		this.autoRebirth();
		currWorld = new MandalaWorld(stats, seed);
		currWorld.tenorion = this.tenorion;
		this.stats.statsDialog.widgets.message.show(new Message("Welcome to the Mandala of the Interpenetrating lights, spirit!", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial));
		//this.stats.statsDialog.widgets.message.show(new Message("You can meditate on this world's sacred book called \n\"Hyper Enlightened Liberty Prerequisites\" (HELP) \njust by pressing <?> at any time. ", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial)); // Uncomment when HELP will be ready
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
		//space = 0;
		//fire = 1; // for testing
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
		stats = new ProtagonistStats();
		stats.space = space;
		stats.water = water;
		stats.earth = earth;
		stats.fire = fire;
		stats.air = air;
		stats.tribe = tribe;
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
		    currWorld = new MandalaWorld(stats, seed);
		    currWorld.tenorion = this.tenorion;
		    this.stats.statsDialog.widgets.message.show(new Message("You have been died and reborn again. Be careful this time. Good luck!", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial));
		}
		currWorld.update();
		Input.update();
		fpsCounter.update();
		FRateLimiter.limitFrame(30);
	    }

	}

}
