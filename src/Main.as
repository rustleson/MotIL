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
    import Engine.Worlds.*;
    import Engine.Dialogs.*;
    import Engine.Stats.*;
    import Engine.Dialogs.Widgets.*;
    import flash.geom.Matrix; 
    import flash.display.MovieClip;

    [SWF(width='640', height='480', backgroundColor='#000000', frameRate='30')]
	
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
		currWorld = new MandalaWorld(stats, seed);
	    }
		
	    public function update(e:Event):void{
		sprite.graphics.clear();
		if (stats.death){
		    currWorld.deconstruct();
		    stats = new ProtagonistStats();
		    currWorld = new MandalaWorld(stats, seed);
		    this.stats.statsDialog.widgets.message.show(new Message("You have been died and reborn again. Be careful this time. Good luck!", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Question));
		}
		currWorld.update();
		Input.update();
		fpsCounter.update();
		FRateLimiter.limitFrame(30);
	    }

	}

}
