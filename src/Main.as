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

	    public function Main() {
		addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		sprite = new Sprite();
		statsSprite = new Sprite();
		addChild(sprite);
		addChild(statsSprite);
		fpsCounter.x = 7;
		fpsCounter.y = 5;
		addChild(fpsCounter);
		input = new Input(sprite);
		appWidth = stage.stageWidth;
		appHeight = stage.stageHeight;
	    }
		
	    public function update(e:Event):void{
		sprite.graphics.clear();
		if (!currWorld){
		    currWorld = new EntranceWorld();
		}
		currWorld.update();
		Input.update();
		fpsCounter.update();
		FRateLimiter.limitFrame(30);
	    }

	}

}