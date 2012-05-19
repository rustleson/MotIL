package Engine.Worlds {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import General.Input;
    import General.Rndm;
    import Engine.Objects.*;
    import Engine.Stats.*;
    import Engine.Dialogs.MainStatsDialog;
    import flash.events.Event;
    import flash.display.*;
    import flash.geom.Matrix;
    import Box2D.Dynamics.Controllers.*;
	
    public class MandalaWorld extends World {
		
	public var bc:b2BuoyancyController = new b2BuoyancyController();
	public var map:Array = new Array();
	public var mapWidth:int = 20;
	public var mapHeight:int = 20;
	public var roomWidth:Number;
	public var roomHeight:Number;
	public var curRoomX:int = -1;
	public var curRoomY:int = -1;

	public function MandalaWorld(stats:ProtagonistStats, seed:uint){
			
	    this.roomWidth = 1000 / this.physScale;
	    this.roomHeight = 1000 / this.physScale;
	    this.stats = stats;
	    this.seed = seed;
	    Rndm.seed = seed;
	    this.buildMap();
	    this.stats.statsDialog = new MainStatsDialog(appWidth, appHeight);
	    this.stats.statsDialog.sprite = Main.statsSprite;
	    this.stats.initStats();
	    this.stats.statsDialog.widgets.map.map = this.map;
	    this.stats.updateStats();
	    this.stats.statsDialog.rebuild();
	    world.SetGravity(new b2Vec2(0, 2.0));
			
	    // backgrounds
	    var c:Sprite = new Sprite();
	    c.graphics.clear();
	    var matrix:Matrix = new Matrix();
	    matrix.createGradientBox(appWidth, appHeight, -Math.PI/2, 0, 0)
	    c.graphics.beginGradientFill(GradientType.LINEAR, [0x333300, 0x111100], [1, 1], [0x0, 0xff], matrix);
	    c.graphics.drawRect(0, 0, appWidth, appHeight);
	    c.graphics.endFill();
	    var bd:BitmapData = new BitmapData(appWidth, appHeight, true, 0x00000000);
	    bd.draw(c);
	    backgrounds.push({ratio: 0, bitmap: bd});
	    c.graphics.clear();
	    c.graphics.lineStyle(1, 0xAAAA00, 0.1); // transparency is our enemy! rid off as soon as possible! (slows severely the whole app)
	    var i:int;
	    for (i = 0; i < 15; i++) {
		c.graphics.drawRect(Math.random() * 188, Math.random() * 188, 10, 10);
	    }
	    var bd1:BitmapData = new BitmapData(200, 200, true, 0x00000000);
	    bd1.draw(c);
	    backgrounds.push({ratio: 0.33, bitmap: bd1});
	    c.graphics.clear();
	    c.graphics.lineStyle(2, 0xAAAA00, 0.2);
	    for (i = 0; i < 10; i++) {
		c.graphics.drawRect(Math.random() * 182, Math.random() * 182, 15, 15);
	    }
	    var bd2:BitmapData = new BitmapData(200, 200, true, 0x00000000);
	    bd2.draw(c);
	    backgrounds.push({ratio: 0.66, bitmap: bd2});
	    c.graphics.clear();
	    c.graphics.lineStyle(3, 0xAAAA00, 0.3);
	    for (i = 0; i < 5; i++) {
		c.graphics.drawRect(Math.random() * 176, Math.random() * 176, 20, 20);
	    }
	    var bd3:BitmapData = new BitmapData(200, 200, true, 0x00000000);
	    bd3.draw(c);
	    backgrounds.push({ratio: 1, bitmap: bd3});
	    stats.space = 1;
	    stats.tribe = ProtagonistStats.DAKINI_TRIBE;
	    //stats.level = 15;
	    stats.hairColor = 0x005500;
	    stats.hairLength = 1.5;
	    //stats.vaginaSlot.stretchedLength.level = 50;
	    //stats.anusSlot.stretchedLength.level = 50;
	    //stats.mouthSlot.stretchedLength.level = 50;

	    // objects
	    /*
	    objects['roomBorder'] = new Room(world, -1000 / physScale, -1000 / physScale, 2000 / physScale, 2000 / physScale, 95 / physScale, 0xDDCC99);
	    objects['leftStaircase'] = new Staircase(world, 0, 200 / physScale, 300 / physScale, 205 / physScale, 10, true, 0xAA9944);
	    objects['rightStaircase'] = new Staircase(world, 0, 200 / physScale, 300 / physScale, 205 / physScale, 10, false, 0xAA9944);
	    objects['altar'] = new Altar(world, -30 / physScale, 130 / physScale, 60 / physScale, 70 / physScale, 15 / physScale, 35 / physScale, 0xEEDD44, 0.7);
	    for (i = 0; i < 10; i++) {
		objects['altar' + i.toString()] = new Altar(world, (Math.random() * 1500 - 750)/ physScale, (Math.random() * 1500 - 750) / physScale, 60 / physScale, 70 / physScale, (i + 3) / physScale, (i + 3) * 3 / physScale, 0xEEDD44, 0.7);
	    }
	    objects['protagonist'] = new Protagonist(world, 150 / physScale, 150 / physScale, 150 / physScale, stats);

	    objectsOrder = ['roomBorder', 'leftStaircase', 'rightStaircase', 'protagonist', 'altar'];
	    for (i = 0; i < 10; i++) {
		objectsOrder.push('altar' + i.toString());
	    
	    }
	    */
	    var startX:int = Rndm.integer(0, this.mapWidth - 1);
	    var startY:int = Rndm.integer(0, this.mapHeight - 1);
	    objects['protagonist'] = new Protagonist(world, startX * this.roomWidth + 250 / physScale, startY * this.roomHeight + 250 / physScale, 150 / physScale, stats);
	    objectsOrder = ['protagonist'];

	    
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
	}

	public override function update():void {
	    var proX:Number = Math.floor(this.objects.protagonist.bodies.chest.GetPosition().x / this.roomWidth);
	    var proY:Number = Math.floor(this.objects.protagonist.bodies.chest.GetPosition().y / this.roomHeight) ;
	    if (proX != this.curRoomX || proY != this.curRoomY) {
		// room is changed, re-building surrounding rooms
		this.curRoomX = proX;
		this.curRoomY = proY;
		for (var j:int = 0; j < this.mapHeight; j++) {
		    for (var i:int = 0; i < this.mapWidth; i++) {
			if (Math.abs(i - this.curRoomX) <= 1 && Math.abs(j - this.curRoomY) <= 1) {
			    this.map[j][i].construct();
			} else {
			    this.map[j][i].deconstruct();
			}
		    }
		}
		this.stats.statsDialog.widgets.map.needUpdate = true;
		this.stats.statsDialog.widgets.map.curX = this.curRoomX;
		this.stats.statsDialog.widgets.map.curY = this.curRoomY;
	    }
	    super.update();
	    //var ts:b2TimeStep = new b2TimeStep();
	    //ts.dt = timeStep;
	    //bc.Step(ts);
	}

	public function buildMap():void {
	    // build room types
	    for (var j:int = 0; j < this.mapHeight; j++) {
		this.map[j] = new Array();
		for (var i:int = 0; i < this.mapWidth; i++) {
		    var types:Array = [WorldRoom.SPACE_TYPE, WorldRoom.WATER_TYPE, WorldRoom.EARTH_TYPE, WorldRoom.FIRE_TYPE, WorldRoom.AIR_TYPE, WorldRoom.CORRUPTION_TYPE, WorldRoom.BALANCE_TYPE, WorldRoom.PURITY_TYPE, ];
		    var prefix:String = "room" + i.toString() + "_" + j.toString() + "_";
		    var room:WorldRoom = new EmptyRoom(this, i * this.roomWidth, j * this.roomHeight, this.roomWidth, this.roomHeight, types[Rndm.integer(0, 7)], prefix, Rndm.integer(1, 10000000));
		    this.map[j].push(room);
		}
	    }
	    // build room transitions
	    for (j = 0; j < this.mapHeight; j++) {
		for (i = 0; i < this.mapWidth; i++) {
		    var rSeed:uint;
		    if (j > 0) {
			rSeed = Rndm.bit(0.5) * Rndm.integer(1, 10000000);
			this.map[j][i].freedomTop = rSeed;
			this.map[j-1][i].freedomBottom = rSeed;
		    }
		    if (j < this.mapHeight - 1) {
			rSeed = Rndm.bit(0.5) * Rndm.integer(1, 10000000);
			this.map[j][i].freedomBottom = rSeed;
			this.map[j+1][i].freedomTop = rSeed;
		    }
		    if (i > 0) {
			rSeed = Rndm.bit(0.5) * Rndm.integer(1, 10000000);
			this.map[j][i].freedomLeft = rSeed;
			this.map[j][i-1].freedomRight = rSeed;
		    }
		    if (i < this.mapWidth - 1) {
			rSeed = Rndm.bit(0.5) * Rndm.integer(1, 10000000);
			this.map[j][i].freedomRight = rSeed;
			this.map[j][i+1].freedomLeft = rSeed;
		    }
		}
	    }
	}

    }
	
}