package Engine.Worlds {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import General.Input;
    import Engine.Objects.*;
    import Engine.Stats.*;
    import Engine.Dialogs.*;
    import flash.events.Event;
    import flash.display.*;
    import flash.geom.Matrix;
    import Box2D.Dynamics.Controllers.*;
	
    public class EntranceWorld extends World {
		
	public var bc:b2BuoyancyController = new b2BuoyancyController();
	public var dialog:EntranceDialog;
	//public var finished:Boolean = false; // flag for the Main would know when to destroy this world

	private var backgroundsCache:Object = new Object();
	private var roomTypes:Array = [WorldRoom.SPACE_TYPE, WorldRoom.WATER_TYPE, WorldRoom.EARTH_TYPE, WorldRoom.FIRE_TYPE, WorldRoom.AIR_TYPE, WorldRoom.CORRUPTION_TYPE, WorldRoom.BALANCE_TYPE, WorldRoom.PURITY_TYPE ];

	public function EntranceWorld($stats:ProtagonistStats, seed:uint){
			
	    // backgrounds
	    for each (var type:uint in this.roomTypes) {
		this.backgroundsCache[type] = Utils.buildBackgrounds(type, appWidth, appHeight);
	    }
	    world.SetGravity(new b2Vec2(0, 0));
			
	    objects['protagonist'] = new Protagonist(world, -150 / physScale, 0, 150 / physScale, $stats);
	    objectsOrder = [];
	    
	    for each (var obj:WorldObject in objects) {
		for each (var body:b2Body in obj.bodies) {
		    bc.AddBody(body);
		}
	    }
	    bc.normal.Set(0,-1);
	    bc.offset = 000 / physScale;
	    bc.density = 0.0001;
	    bc.linearDrag = 0.005;
	    bc.angularDrag = 0.005;
	    world.AddController(bc);
	    this.dialog = new EntranceDialog(Main.appWidth, Main.appHeight);
	    this.dialog.sprite = Main.sprite;
	    this.dialog.stats = $stats;
	    this.stats = $stats;
	    if (!stats.ageConfirmed) {
		this.dialog.state = "warning";
	    } else {
		this.dialog.state = "mainMenu";
	    }
	    this.dialog.rebuild();
	}

	public override function update():void {
	    this.dialog.update();
	    super.update();
	}

    }
	
}