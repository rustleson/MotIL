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
    import Engine.Dialogs.*;
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
	private var realmDifficulties:Array = [20, 23, 25, 27, 22, 40, 33, 30];
	private var realmDifficulty:Object = new Object();
	private var realmArtefactsValues:Array = ["wheel", "vajra", "jewel", "lotus", "sword", "analTentacle", "pacifier", "chastityBelt"];
	private var realmArtefacts:Object = new Object();
	private var roomSongTendenciesValues:Array = [21, 6, 2, 10, 14, 8, 17, 23];
	public var roomSongTendencies:Object = new Object();
	private var startingPositions:Object = new Object();
	private var terrHeights:Array = new Array();
	private var interRealmTransitions:Object = new Object();
	public var helpDialog:HelpDialog;

	public function MandalaWorld(stats:ProtagonistStats, seed:uint){
			
	    secondaryBgSprite = new Sprite();
	    secondaryBgSprite.cacheAsBitmap = true; // doesn't improve performance, is it really necessary?
	    sprite.addChild(secondaryBgSprite);
	    primaryBgSprite = new Sprite();
	    primaryBgSprite.cacheAsBitmap = true; // doesn't improve performance, is it really necessary?
	    sprite.addChild(primaryBgSprite);
	    for (var i:int = 0; i < this.roomTypes.length; i++) {
		this.realmArtefacts[this.roomTypes[i]] = realmArtefactsValues[i];
		this.roomSongTendencies[this.roomTypes[i]] = roomSongTendenciesValues[i];
		this.realmDifficulty[this.roomTypes[i]] = this.realmDifficulties[i];
	    }
	    this.roomWidth = 1000 / this.physScale;
	    this.roomHeight = 1000 / this.physScale;
	    this.stats = stats;
	    this.seed = seed;
	    Rndm.seed = seed;
	    this.stats.statsDialog = new MainStatsDialog(appWidth, appHeight);
	    this.stats.statsDialog.sprite = Main.statsSprite;
	    this.stats.initStats();
	    this.buildMap();
	    this.stats.statsDialog.widgets.map.map = this.map;
	    this.stats.updateStats();
	    this.stats.statsDialog.rebuild();
	    this.helpDialog = new HelpDialog(appWidth, appHeight);
	    //this.helpDialog.sprite = Main.helpSprite;
	    this.helpDialog.rebuild();
	    //this.helpDialog.toggleHide();
	    world.SetGravity(new b2Vec2(0, 2.0));
			
	    // backgrounds
	    for each (var type:uint in this.roomTypes) {
		this.backgroundsCache[type] = Utils.buildBackgrounds(type, appWidth, appHeight);
	    }

	    var sType: uint = this.startType;

	    var startMessage:String = "Born as " + this.stats.TribesStrings[this.stats.tribe] + " of the " + this.stats.ElementalStrings[sType] + " Realm.";
	    objects['protagonist'] = new Protagonist(world, this.startingPositions[sType].x * this.roomWidth + 250 / physScale, this.startingPositions[sType].y * this.roomHeight + 250 / physScale, 150 / physScale, stats);
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

	public function get startType():uint {
	    if (this.stats.space == 1) {
		return WorldRoom.SPACE_TYPE;
	    }
	    if (this.stats.water == 1) {
		return WorldRoom.WATER_TYPE;
	    }
	    if (this.stats.earth == 1) {
		return WorldRoom.EARTH_TYPE;
	    }
	    if (this.stats.fire == 1) {
		return WorldRoom.FIRE_TYPE;
	    }
	    if (this.stats.air == 1) {
		return WorldRoom.AIR_TYPE;
	    }
	    return 0;
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
		if (this.tenorion != null) {
		    this.tenorion.matrixPad.tendence = this.roomSongTendencies[this.map[proY][proX].type];
		    this.tenorion.needRebuild = true;
		    if (this.curRoomX >= 0 && this.map[proY][proX].type != this.map[this.curRoomY][this.curRoomX].type) {
			this.tenorion.matrixPad.generateUniversalSong();
		    }
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
	    if (this.tenorion != null && Input.isKeyReleased(220)) { // key "\"
		this.tenorion.muteSound = !this.tenorion.muteSound;
		if (this.tenorion.muteSound)
		    this.tenorion.driver.stop();
		else
		    this.tenorion.driver.play();
	    }
	    if (this.tenorion != null && Input.isKeyReleased(219)) { // key "["
		this.tenorion.driver.volume = Math.max(0, this.tenorion.driver.volume - 0.1);
	    }
	    if (this.tenorion != null && Input.isKeyReleased(221)) { // key "]"
		this.tenorion.driver.volume = Math.min(1, this.tenorion.driver.volume + 0.1);
	    }
	    this.helpDialog.update();
	    if (Input.isKeyPressed(191) && Input.getKeyHold(16) > 0 || Input.isKeyPressed(27) && this.helpDialog.state == 'visible') {
		this.helpDialog.toggleHide();
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
	    // build starting positions for each realm
	    for each(t in this.roomTypes) {
		do {
		    var startX:int = Rndm.integer(0, this.mapWidth - 1);
		    var startY:int = Rndm.integer(0, this.mapHeight - 1);
		} while (this.map[startY][startX].type != t);
		this.startingPositions[t] = {'x': startX, 'y': startY};
	    }
	    // build specific rooms
	    var maxPowers:Object = this.buildRoomPowers(this.startingPositions[WorldRoom.AIR_TYPE].x, this.startingPositions[WorldRoom.AIR_TYPE].y);
	    for each(t in this.roomTypes) {
		var maxPower:int = maxPowers[t].max;
		var minPower:int = maxPowers[t].min;
		var isAltar:Boolean = false;
		for (j = this.mapHeight - 1; j >= 0 ; j--) {
		    for (i = this.mapWidth - 1; i >= 0 ; i--) {
			if (this.map[j][i].type == t) {
			    var isArtefact:Boolean = false;
			    if (this.map[j][i].power == maxPower && !isAltar) {
				isArtefact = true;
				isAltar = true;
			    }
			    // build altar/artefact room
			    if (isArtefact || this.map[j][i].power % 4 == 0) {
				var r:AltarRoom = new AltarRoom(this, this.map[j][i].posX, this.map[j][i].posY, this.map[j][i].width, this.map[j][i].height, this.map[j][i].type, this.map[j][i].prefix, this.map[j][i].seed, Math.floor(23 * (this.map[j][i].power - minPower) / (maxPower - minPower)) + this.realmDifficulty[t], isArtefact);
				if (isArtefact) {
				    r.artefact = this.stats.artefacts[this.realmArtefacts[t]];
				}
				r.freedomTop = this.map[j][i].freedomTop;
				r.freedomBottom = this.map[j][i].freedomBottom;
				r.freedomLeft = this.map[j][i].freedomLeft;
				r.freedomRight = this.map[j][i].freedomRight;
				r.visited = true;
				delete this.map[j][i];
				this.map[j][i] = r;
			    }
			}
		    }
		}
	    }

	}

	public override function renderBackgrounds():void {
	    this.primaryBgSprite.graphics.clear();
	    this.secondaryBgSprite.graphics.clear();
	    var type:uint = this.map[this.curRoomY][this.curRoomX].type;
	    var i:int = 0;
	    for each (var bg:Object in this.backgroundsCache[type]) {
		if (i > 0 || i >= this.stats.backgroundDetails) {
		    var matrix:Matrix = new Matrix();
		    matrix.translate(-viewport.lowerBound.x * physScale * bg.ratio, -viewport.lowerBound.y * physScale * bg.ratio);
		    this.primaryBgSprite.graphics.beginBitmapFill(bg.bitmap, matrix.clone(), true);
		    this.primaryBgSprite.graphics.drawRect(0, 0, appWidth, appHeight);
		    this.primaryBgSprite.graphics.endFill();
		}
		i++;
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
		i = 0;
		for each (bg in this.backgroundsCache[nearestType]) {
		    if (i > 0 || i >= this.stats.backgroundDetails) {
			matrix = new Matrix();
			matrix.translate(-viewport.lowerBound.x * physScale * bg.ratio, -viewport.lowerBound.y * physScale * bg.ratio);
			this.secondaryBgSprite.graphics.beginBitmapFill(bg.bitmap, matrix.clone(), true);
			this.secondaryBgSprite.graphics.drawRect(0, 0, appWidth, appHeight);
			this.secondaryBgSprite.graphics.endFill();
		    }
		    i++;
		}
		this.primaryBgSprite.alpha = nearestWall / this.roomWidth / 0.8 + 0.5;
		this.secondaryBgSprite.alpha = 1 - this.primaryBgSprite.alpha;
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
		} else if (cellStackX.length > 0) {
		    // no neighbours, back to previous cell
		    curX = cellStackX.pop();
		    curY = cellStackY.pop();
		} else {
		    // generation finished
		    break;
		}
	    }
	}

	private function cellVisited(x:int, y:int, type:uint = 0, curX:int = 0, curY:int = 0, curAttr:String = "", nextAttr:String = ""):Boolean {
	    
	    if (x < 0 || x > this.mapWidth - 1 || y < 0 || y > this.mapHeight - 1)
		return true;
	    if (type > 0 && this.map[y][x].type != type) {
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

	private function cellPowerVisited(x:int, y:int):Boolean {
	    if (x < 0 || x > this.mapWidth - 1 || y < 0 || y > this.mapHeight - 1)
		return true;
	    if (this.map[y][x].power > 0)
		return true;
	    return false;
	}

	private function buildRoomPowers(x:int, y:int, type:uint = 0):Object {
	    var maxPowers:Object = new Object();
	    for each(var t:uint in this.roomTypes) {
		maxPowers[t] = {'max':0, 'min':this.mapWidth * this.mapHeight};
	    }
	    var curX:int = x;
	    var curY:int = y;
	    var cellStackX:Array = new Array();
	    var cellStackY:Array = new Array();
	    var isAltar:Boolean = false;
	    for (var j:int = 0; j < this.mapHeight; j++) {
		for (var i:int = 0; i < this.mapWidth; i++) {
		    this.map[j][i].power = 0;
		}
	    }
	    // using similar to DFS algorithm
	    while (true) {
		this.map[curY][curX].power = cellStackX.length;
		if (this.map[curY][curX].power > maxPowers[this.map[curY][curX].type].max) {
		    maxPowers[this.map[curY][curX].type].max = this.map[curY][curX].power;
		}
		if (this.map[curY][curX].power < maxPowers[this.map[curY][curX].type].min) {
		    maxPowers[this.map[curY][curX].type].min = this.map[curY][curX].power;
		}
		// calculate unvisited neighbours
		var neighbours:Array = new Array();
		if (this.map[curY][curX].freedomLeft && !this.cellPowerVisited(curX - 1, curY)) {
		    neighbours.push({x: curX - 1, y: curY});
		}
		if (this.map[curY][curX].freedomRight && !this.cellPowerVisited(curX + 1, curY)) {
		    neighbours.push({x: curX + 1, y: curY});
		}
		if (this.map[curY][curX].freedomTop && !this.cellPowerVisited(curX, curY - 1)) {
		    neighbours.push({x: curX, y: curY - 1});
		}
		if (this.map[curY][curX].freedomBottom && !this.cellPowerVisited(curX, curY + 1)) {
		    neighbours.push({x: curX, y: curY + 1});
		}
		if (neighbours.length > 0) {
		    // move to first unvisited neighbour
		    var nextX:int = neighbours[0].x;
		    var nextY:int = neighbours[0].y;
		    cellStackX.push(curX);
		    cellStackY.push(curY);
		    curX = nextX;
		    curY = nextY;
		} else if (cellStackX.length > 0) {
		    // no neighbours, back to previous cell
		    curX = cellStackX.pop();
		    curY = cellStackY.pop();
		} else {
		    break;
		}
	    }
	    return maxPowers;
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