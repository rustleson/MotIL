package Engine.Worlds {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Main;
    import General.*;
    import flash.utils.getTimer;
    import flash.display.*;
    import Engine.Objects.*;
    import Engine.Stats.*;
    import Engine.Dialogs.MainStatsDialog;
    import flash.events.EventDispatcher;	
    import flash.geom.Matrix;
	
    public class World extends EventDispatcher {
		
	public var world:b2World;
	public var objects:Object;
	public var objectsOrder:Array;
	public var viewport:b2AABB;
	public var mouseJoint:b2MouseJoint;
	public var velocityIterations:int = 10;
	public var positionIterations:int = 10;
	public var timeStep:Number = 1.5/30.0;
	public var physScale:Number = 30;
	public var appWidth:int;
	public var appHeight:int;
	// Sprite to draw in to
	public var sprite:Sprite;
	public var backgrounds:Array;
	public var stats:ProtagonistStats;
	public var seed:uint;
	public var blitSprite:Sprite;
	public var tenorion:Tenorion;

	public function World(){
			
	    sprite = Main.sprite;
	    blitSprite = new Sprite();
	    this.blitSprite.visible = false;
	    sprite.addChild(blitSprite);
	    appWidth = Main.appWidth;
	    appHeight = Main.appHeight;
	    objects = new Array();
	    objectsOrder = new Array();
	    backgrounds = new Array();
	    var worldAABB:b2AABB = new b2AABB();
	    worldAABB.lowerBound.Set(-1000.0, -1000.0);
	    worldAABB.upperBound.Set(1000.0, 1000.0);
			
	    viewport = new b2AABB();
	    setViewport(0, 100);
			
	    // Define the gravity vector
	    var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			
	    // Allow bodies to sleep
	    var doSleep:Boolean = true;
			
	    // Construct a world object
	    world = new b2World(gravity, doSleep);
	    //world.SetBroadPhase(new b2BroadPhase(worldAABB));
	    world.SetWarmStarting(true);
			
	    //addEventListener(HipsMovedEvent.NAME, hipsMovedHandler);
	    var contactListener:ContactListener = new ContactListener();
	    world.SetContactListener(contactListener);
	}
		
	private function hipsMovedHandler(e:HipsMovedEvent):void {
	    this.setViewport(e.center.x, e.center.y);
	}

	public function setViewport(x:int, y:int):void {
	    viewport.lowerBound.Set((x - appWidth / 2) / physScale, (y - appHeight / 2) / physScale);
	    viewport.upperBound.Set((x + appWidth / 2) / physScale, (y + appHeight / 2) / physScale);
	}
    
	public function renderBackgrounds():void {
	    for each (var bg:Object in backgrounds) {
		var matrix:Matrix = new Matrix();
		matrix.translate(-viewport.lowerBound.x * physScale * bg.ratio, -viewport.lowerBound.y * physScale * bg.ratio);
		sprite.graphics.beginBitmapFill(bg.bitmap, matrix.clone(), true);
		sprite.graphics.drawRect(0, 0, appWidth, appHeight);
		sprite.graphics.endFill();
	    }
	}


	public function update():void {

	    for each (var obj:WorldObject in objects) {
		obj.update();
	    }

	    // Update physics
	    var physStart:uint = getTimer();
	    world.Step(timeStep, velocityIterations, positionIterations);
	    world.ClearForces();
			
	    Main.fpsCounter.updatePhys(physStart);
	    var center:b2Vec2 = objects.protagonist.bodies.stomach.GetWorldCenter();
	    setViewport(center.x * physScale, center.y * physScale);
	    sprite.graphics.clear();
	    renderBackgrounds();
	    // render objects
	    var objSprite:Sprite;
	    for each (var objname:String in objectsOrder) {
		obj = objects[objname];
		objSprite = obj.draw(viewport, physScale);
		if (!sprite.contains(objSprite)) {
		    sprite.addChild(objSprite);
		}
	    }
	    if (stats.statsDialog != null)
		stats.updateStats();
	    var painPercent:Number = this.stats.pleasure.value / this.stats.pleasure.max;
	    var pleasurePercent:Number = this.stats.pain.value / this.stats.pain.max;
	    if (painPercent > 0.5 || pleasurePercent > 0.5) {
		this.blitSprite.graphics.clear();
		this.blitSprite.visible = true;
		this.sprite.setChildIndex(this.blitSprite, (this.sprite.numChildren - 1));
		if (painPercent > 0.5) {
		    blitSprite.graphics.beginFill(0xffffff, (painPercent - 0.5) * 1.2 * (painPercent - 0.5) * 1.2);
		    blitSprite.graphics.drawRect(0, 0, appWidth, appHeight);
		    blitSprite.graphics.endFill();
		}
		if (pleasurePercent > 0.5) {
		    blitSprite.graphics.beginFill(0x000000, (pleasurePercent - 0.5) * 2 * (pleasurePercent - 0.5) * 2 * (pleasurePercent - 0.5) * 2);
		    blitSprite.graphics.drawRect(0, 0, appWidth, appHeight);
		    blitSprite.graphics.endFill();
		}
	    } else {
		this.blitSprite.visible = false;
	    }
	}
		
	public function deconstruct():void {

	}		
		
    }
	
}