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
    import Engine.Dialogs.Widgets.MapWidget;
    import Engine.Objects.*;
    import Engine.Stats.*;
    import Engine.Dialogs.MainStatsDialog;
    import Engine.Dialogs.Widgets.*;
    import flash.events.Event;
    import flash.display.*;
    import flash.geom.Matrix;
    import Box2D.Dynamics.Controllers.*;
	
    public class MandalaWorld extends World {
		
	public var primaryBgSprite:Sprite;
	public var secondaryBgSprite:Sprite;
	public var bc:b2BuoyancyController = new b2BuoyancyController();
	public var map:Array = new Array();
	public var mapWidth:int = 20;
	public var mapHeight:int = 20;
	public var roomWidth:Number;
	public var roomHeight:Number;
	public var curRoomX:int = -1;
	public var curRoomY:int = -1;
	private var backgroundsCache:Object = new Object();
	private var roomTypes:Array = [WorldRoom.SPACE_TYPE, WorldRoom.WATER_TYPE, WorldRoom.EARTH_TYPE, WorldRoom.FIRE_TYPE, WorldRoom.AIR_TYPE, WorldRoom.CORRUPTION_TYPE, WorldRoom.BALANCE_TYPE, WorldRoom.PURITY_TYPE ];
	private var terrHeights:Array = new Array();
	private var interRealmTransitions:Object = new Object();

	public function MandalaWorld(stats:ProtagonistStats, seed:uint){
			
	    secondaryBgSprite = new Sprite();
	    secondaryBgSprite.cacheAsBitmap = true;
	    sprite.addChild(secondaryBgSprite);
	    primaryBgSprite = new Sprite();
	    primaryBgSprite.cacheAsBitmap = true;
	    sprite.addChild(primaryBgSprite);
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
	    for each (var type:uint in this.roomTypes) {
		this.backgroundsCache[type] = Utils.buildBackgrounds(type, appWidth, appHeight);
	    }

	    var startType:uint;
	    if (this.stats.space == 1) {
		startType = WorldRoom.SPACE_TYPE;
	    }
	    if (this.stats.water == 1) {
		startType = WorldRoom.WATER_TYPE;
	    }
	    if (this.stats.earth == 1) {
		startType = WorldRoom.EARTH_TYPE;
	    }
	    if (this.stats.fire == 1) {
		startType = WorldRoom.FIRE_TYPE;
	    }
	    if (this.stats.air == 1) {
		startType = WorldRoom.AIR_TYPE;
	    }
	    var startMessage:String = "Born as " + this.stats.TribesStrings[this.stats.tribe] + " of the " + this.stats.ElementalStrings[startType] + " Realm.";
	    do {
		var startX:int = Rndm.integer(0, this.mapWidth - 1);
		var startY:int = Rndm.integer(0, this.mapHeight - 1);
	    } while (this.map[startY][startX].type != startType);
	    objects['protagonist'] = new Protagonist(world, startX * this.roomWidth + 250 / physScale, startY * this.roomHeight + 250 / physScale, 150 / physScale, stats);
	    objectsOrder = ['protagonist'];
	    this.stats.statsDialog.widgets.log.show(startMessage);
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
	    var proY:Number = Math.floor(this.objects.protagonist.bodies.chest.GetPosition().y / this.roomHeight);
	    var i:int;
	    var j:int;
	    if (proX != this.curRoomX || proY != this.curRoomY) {
		// room is changed, re-building surrounding rooms
		if (this.curRoomX >= 0 && this.map[proY][proX].type != this.map[this.curRoomY][this.curRoomX].type) {
		    this.stats.statsDialog.widgets.log.show("Entered Realm of " + this.stats.ElementalStrings[this.map[proY][proX].type]);
		}
		this.curRoomX = proX;
		this.curRoomY = proY;
		for (j = 0; j < this.mapHeight; j++) {
		    for (i = 0; i < this.mapWidth; i++) {
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
	    if (!this.stats.buddhaMode && Input.getKeyStroke(30) == "ARAHCEK") {
		this.stats.statsDialog.widgets.message.show(new Message("Buddha mode is activated! Since you are immortal and know all the things now, there is no need for you to save your progress anymore. Deal with it.", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial));
		this.stats.statsDialog.widgets.log.show("Buddha mode activated.");
		this.stats.buddhaMode = true;
		for (j = 0; j < this.mapHeight; j++) {
		    for (i = 0; i < this.mapWidth; i++) {
			this.map[j][i].explored = true;
		    }
		}
		for each (var artefact:ArtefactStat in this.stats.artefacts) {
		    artefact.obtained = true;
		}
		this.stats.statsDialog.widgets.map.needUpdate = true;
		this.stats.statsDialog.widgets.wheel.needUpdate = true;
		this.stats.statsDialog.widgets.vajra.needUpdate = true;
		this.stats.statsDialog.widgets.jewel.needUpdate = true;
		this.stats.statsDialog.widgets.lotus.needUpdate = true;
		this.stats.statsDialog.widgets.sword.needUpdate = true;
		this.stats.statsDialog.widgets.chastityBelt.needUpdate = true;
		this.stats.statsDialog.widgets.pacifier.needUpdate = true;
		this.stats.statsDialog.widgets.analTentacle.needUpdate = true;
	    }
	}

	public function buildMap():void {
	    // build terrain heigths
	    this.terrHeights = new Array();
	    var meruPos:int = Rndm.integer(Math.floor(this.mapWidth * 0.2), Math.floor(this.mapWidth * 0.8));
	    var meruHeight:int = Rndm.integer(Math.floor(this.mapHeight * 0.3), Math.floor(this.mapHeight * 0.4));
	    var seaDepth:int = Rndm.integer(Math.floor(this.mapHeight * 0.7), Math.floor(this.mapHeight * 0.9));
	    this.buildFractalTerrain(0, Math.floor(meruPos / 2), Rndm.integer(Math.floor(this.mapHeight * 0.5), Math.floor(this.mapHeight * 0.7)), seaDepth);
	    this.buildFractalTerrain(Math.floor(meruPos / 2), meruPos, seaDepth, meruHeight);
	    this.buildFractalTerrain(meruPos, Math.floor((this.mapWidth + meruPos) / 2), meruHeight, seaDepth);
	    this.buildFractalTerrain(Math.floor((this.mapWidth + meruPos) / 2), this.mapWidth, seaDepth, Rndm.integer(Math.floor(this.mapHeight * 0.5), Math.floor(this.mapHeight * 0.7)));
	    // build terrain with elements
	    for (var j:int = 0; j < this.mapHeight; j++) {
		this.map[j] = new Array();
		for (var i:int = 0; i < this.mapWidth; i++) {
		    var prefix:String = "room" + i.toString() + "_" + j.toString() + "_";
		    var roomType:uint;
		    if (j >= this.terrHeights[i] * 1.7 || j > this.terrHeights[i]+1 && j >= this.mapHeight * 0.8 || i == meruPos && j >= this.terrHeights[meruPos]) {
			roomType = WorldRoom.FIRE_TYPE;
		    } else if (j >= this.terrHeights[i]) {
			roomType = WorldRoom.EARTH_TYPE;
		    } else if (j >= this.mapHeight * 0.5) {
			roomType = WorldRoom.WATER_TYPE;
		    } else if (j >= this.mapHeight * 0.25) {
			roomType = WorldRoom.AIR_TYPE;
		    } else {
			roomType = WorldRoom.SPACE_TYPE;
		    }
		    var room:WorldRoom = new EmptyRoom(this, i * this.roomWidth, j * this.roomHeight, this.roomWidth, this.roomHeight, roomType, prefix, Rndm.integer(1, 10000000));
		    this.map[j].push(room);
		}
	    }
	    // build alignment realms
	    for (j = 0; j < this.mapHeight; j++) {
		// purity realm
		var purityH:int = Math.min(5, Math.floor((this.mapWidth - Math.abs(meruPos - j)) / this.mapWidth * 5));
		purityH = Rndm.integer(Math.max(1, purityH - 2), Math.max(1, purityH));
		for (i = 0; i < purityH; i++) {
		    if (Math.abs(this.mapWidth / 2 - j) < this.mapWidth * 0.35)
			this.map[i][j].type = WorldRoom.PURITY_TYPE;
		}
		// corruption realm
		var corrH:int = Math.min(4, Math.floor((this.mapWidth - Math.abs(meruPos - j)) / this.mapWidth * 4));
		corrH = Rndm.integer(Math.max(1, corrH - 1), Math.max(1, corrH));
		for (i = 0; i < corrH; i++) {
		    if (Math.abs(this.mapWidth / 2 - j) < this.mapWidth * 0.35)
			this.map[this.mapHeight - 1 - i][j].type = WorldRoom.CORRUPTION_TYPE;
		}
		// balance realm
		var balH:int = Math.min(4, Math.floor((this.mapHeight - Math.abs(meruPos - j)) / this.mapHeight * 4));
		balH = Rndm.integer(Math.max(1, balH - 1), Math.max(1, balH));
		for (i = 0; i < balH; i++) {
		    if (j >= this.mapHeight * 0.25 && j < this.terrHeights[0])
			this.map[j][i].type = WorldRoom.BALANCE_TYPE;
		    if (j >= this.mapHeight * 0.25 && j < this.terrHeights[this.mapWidth - 1])
			this.map[j][this.mapWidth - 1 - i].type = WorldRoom.BALANCE_TYPE;
		}
	    }
	    // build room transitions
	    for (j = this.mapHeight - 1; j >= 0 ; j--) {
		for (i = this.mapWidth - 1; i >= 0 ; i--) {
		    if (!this.map[j][i].visited) {
			for each (var t:uint in this.roomTypes) {
			    this.interRealmTransitions[t] = new Object();
			    for each (var t1:uint in this.roomTypes) {
				this.interRealmTransitions[t][t1] = false;
			    }
			}
			this.interRealmTransitions[WorldRoom.EARTH_TYPE][WorldRoom.WATER_TYPE] = true;
			this.interRealmTransitions[WorldRoom.FIRE_TYPE][WorldRoom.EARTH_TYPE] = true;
			this.interRealmTransitions[WorldRoom.BALANCE_TYPE][WorldRoom.EARTH_TYPE] = true;
			this.interRealmTransitions[WorldRoom.AIR_TYPE][WorldRoom.FIRE_TYPE] = true;
			this.interRealmTransitions[WorldRoom.CORRUPTION_TYPE][WorldRoom.FIRE_TYPE] = true;
			this.interRealmTransitions[WorldRoom.SPACE_TYPE][WorldRoom.AIR_TYPE] = true;
			this.interRealmTransitions[WorldRoom.PURITY_TYPE][WorldRoom.SPACE_TYPE] = true;
			this.generateDFSMaze(i, j);
		    }
		}
	    }
	}

	public override function renderBackgrounds():void {
	    this.primaryBgSprite.graphics.clear();
	    this.secondaryBgSprite.graphics.clear();
	    var type:uint = this.map[this.curRoomY][this.curRoomX].type;
	    for each (var bg:Object in this.backgroundsCache[type]) {
		var matrix:Matrix = new Matrix();
		matrix.translate(-viewport.lowerBound.x * physScale * bg.ratio, -viewport.lowerBound.y * physScale * bg.ratio);
		this.primaryBgSprite.graphics.beginBitmapFill(bg.bitmap, matrix.clone(), true);
		this.primaryBgSprite.graphics.drawRect(0, 0, appWidth, appHeight);
		this.primaryBgSprite.graphics.endFill();
	    }
	    var nearestWall:Number = this.roomWidth;
	    var nearestType:uint = 0;
	    var dist:Number;
	    var proX:Number = this.objects.protagonist.bodies.chest.GetPosition().x;
	    var proY:Number = this.objects.protagonist.bodies.chest.GetPosition().y;
	    if (this.curRoomX > 0 && this.map[this.curRoomY][this.curRoomX - 1].type != type) {
		dist = Math.abs(proX - this.curRoomX * this.roomWidth);
		if (dist < nearestWall) {
		    nearestWall = dist;
		    nearestType = this.map[this.curRoomY][this.curRoomX - 1].type;
		}
	    }
	    if (this.curRoomX < this.mapWidth - 1 && this.map[this.curRoomY][this.curRoomX + 1].type != type) {
		dist = Math.abs((this.curRoomX + 1) * this.roomWidth - proX);
		if (dist < nearestWall) {
		    nearestWall = dist;
		    nearestType = this.map[this.curRoomY][this.curRoomX + 1].type;
		}
	    }
	    if (this.curRoomY > 0 && this.map[this.curRoomY - 1][this.curRoomX].type != type) {
		dist = Math.abs(proY - this.curRoomY * this.roomHeight);
		if (dist < nearestWall) {
		    nearestWall = dist;
		    nearestType = this.map[this.curRoomY - 1][this.curRoomX].type;
		}
	    }
	    if (this.curRoomY < this.mapHeight - 1 && this.map[this.curRoomY + 1][this.curRoomX].type != type) {
		dist = Math.abs((this.curRoomY + 1) * this.roomHeight - proY);
		if (dist < nearestWall) {
		    nearestWall = dist;
		    nearestType = this.map[this.curRoomY + 1][this.curRoomX].type;
		}
	    }
	    if (nearestWall <= this.roomWidth * 0.4) {
		for each (bg in this.backgroundsCache[nearestType]) {
		    matrix = new Matrix();
		    matrix.translate(-viewport.lowerBound.x * physScale * bg.ratio, -viewport.lowerBound.y * physScale * bg.ratio);
		    this.secondaryBgSprite.graphics.beginBitmapFill(bg.bitmap, matrix.clone(), true);
		    this.secondaryBgSprite.graphics.drawRect(0, 0, appWidth, appHeight);
		    this.secondaryBgSprite.graphics.endFill();
		}
		this.primaryBgSprite.alpha = nearestWall / this.roomWidth / 0.8 + 0.5;
		this.secondaryBgSprite.alpha = 1 - this.primaryBgSprite.alpha + 0.5;
	    } else {
		this.primaryBgSprite.alpha = 1;
		this.secondaryBgSprite.alpha = 0;
	    }
	}

	private function buildFractalTerrain(p1:int, p2:int, h1:int, h2:int):void {
	    this.terrHeights[p1] = h1;
	    this.terrHeights[p2] = h2;
	    if (p2 - p1 > 1) {
		var pm:int = Math.floor((p2 + p1) / 2);
		var d:int = Math.floor(Math.abs((h2 - h1) / 3));
		var hm:int = Math.min(Math.floor((h2 + h1) / 2) + Rndm.integer(-d, d+1), Math.floor(this.mapHeight * 0.9));
		this.buildFractalTerrain(p1, pm, h1, hm);
		this.buildFractalTerrain(pm, p2, hm, h2);
	    }
	}
	
	private function generateDFSMaze(x:int, y:int):void {
	    var curType:uint = this.map[y][x].type;
	    var curX:int = x;
	    var curY:int = y;
	    var cellStackX:Array = new Array();
	    var cellStackY:Array = new Array();
	    var isAltar:Boolean = false;
	    while (true) {
		this.map[curY][curX].visited = true;
		// calculate unvisited neighbours
		var neighbours:Array = new Array();
		if (!this.cellVisited(curX - 1, curY, curType, curX, curY, "freedomLeft", "freedomRight")) {
		    neighbours.push({x: curX - 1, y: curY, curAttr: "freedomLeft", nextAttr: "freedomRight"});
		}
		if (!this.cellVisited(curX + 1, curY, curType, curX, curY, "freedomRight", "freedomLeft")) {
		    neighbours.push({x: curX + 1, y: curY, curAttr: "freedomRight", nextAttr: "freedomLeft"});
		}
		if (!this.cellVisited(curX, curY - 1, curType, curX, curY, "freedomTop", "freedomBottom")) {
		    neighbours.push({x: curX, y: curY - 1, curAttr: "freedomTop", nextAttr: "freedomBottom"});
		}
		if (!this.cellVisited(curX, curY + 1, curType, curX, curY, "freedomBottom", "freedomTop")) {
		    neighbours.push({x: curX, y: curY + 1, curAttr: "freedomBottom", nextAttr: "freedomTop"});
		}
		if (neighbours.length > 0) {
		    // move to random unvisited neighbour
		    var rn:int = Rndm.integer(0, neighbours.length);
		    var nextX:int = neighbours[rn].x;
		    var nextY:int = neighbours[rn].y;
		    cellStackX.push(curX);
		    cellStackY.push(curY);
		    var rSeed:uint = Rndm.integer(1, 10000000);
		    this.map[curY][curX][neighbours[rn].curAttr] = rSeed;
		    this.map[nextY][nextX][neighbours[rn].nextAttr] = rSeed;
		    curX = nextX;
		    curY = nextY;
		    isAltar = true;
		} else if (cellStackX.length > 0) {
		    // no neighbours, back to previous cell
		    if (isAltar) {
			var r:AltarRoom = new AltarRoom(this, this.map[curY][curX].posX, this.map[curY][curX].posY, this.map[curY][curX].width, this.map[curY][curX].height, this.map[curY][curX].type, this.map[curY][curX].prefix, this.map[curY][curX].seed, cellStackX.length);
			r.freedomTop = this.map[curY][curX].freedomTop;
			r.freedomBottom = this.map[curY][curX].freedomBottom;
			r.freedomLeft = this.map[curY][curX].freedomLeft;
			r.freedomRight = this.map[curY][curX].freedomRight;
			r.visited = true;
			delete this.map[curY][curX];
			this.map[curY][curX] = r;
			isAltar = false;
		    }
		    curX = cellStackX.pop();
		    curY = cellStackY.pop();
		} else {
		    // generation finished
		    break;
		}
	    }
	}

	private function cellVisited(x:int, y:int, type:uint, curX:int, curY:int, curAttr:String, nextAttr:String):Boolean {
	    
	    if (x < 0 || x > this.mapWidth - 1 || y < 0 || y > this.mapHeight - 1)
		return true;
	    if (this.map[y][x].type != type) {
		if (this.interRealmTransitions[this.map[y][x].type][type]) {
		    this.interRealmTransitions[this.map[y][x].type][type] = false;
		    var rSeed:uint = Rndm.integer(1, 10000000);
		    this.map[curY][curX][curAttr] = rSeed;
		    this.map[y][x][nextAttr] = rSeed;
		}
		return true;
	    }
	    if (this.map[y][x].visited)
		return true;
	    return false;
	}

	public override function deconstruct():void {
	    for (var j:int = 0; j < this.mapHeight; j++) {
		for (var i:int = 0; i < this.mapWidth; i++) {
		    this.map[j][i].deconstruct();
		}
	    }	    
	    for each (var objName:String in this.objectsOrder) {
		this.objects[objName].clearStuff();
		delete this.objects[objName];
	    }
	    this.primaryBgSprite.graphics.clear();
	    this.secondaryBgSprite.graphics.clear();
	    this.sprite.graphics.clear();
	    while(this.sprite.numChildren > 0) {   
		this.sprite.removeChildAt(0); 
	    }
	    this.stats.statsDialog.destroy();
	}

    }
	
}