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

package Engine.Objects {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import General.Input;
    import General.Rndm;
    import flash.display.*;
    import Engine.Objects.Utils;
    import Engine.Worlds.*;

    
    public class Room extends WorldObject {

	public static const ROOM_TYPE_OPEN:int = 1;
	public static const ROOM_TYPE_EMPTY:int = 2;
	public static const ROOM_TYPE_TUNNEL:int = 3;
	public static const ROOM_TYPE_RUBBLE:int = 4;
	
	public var birthX:Number;
	public var birthY:Number;

	public var map:Array = new Array();
	public var mapWidth:int = 4;
	public var mapHeight:int = 4;

	public function Room(world:b2World, x:Number, y:Number, width:Number, height:Number, thickness:Number, c:uint = 0xDDEEEE, a:Number = 0.8, freedomTop:uint = 0, freedomBottom:uint = 0, freedomLeft:uint = 0, freedomRight:uint = 0, roomType:int = 2){
			
	    this.color = c;
	    this.alpha = a;
	    var holePos:Number;
	    var holeLen:Number;
	    var minSize:Number = width / 4;

	    // remember whole room size
	    var roomX:Number = x;
	    var roomY:Number = y;
	    var roomWidth:Number = width;
	    var roomHeight:Number = width;
	    if (roomType == Room.ROOM_TYPE_TUNNEL) {
		var minX:Number = x + width;
		var minY:Number = y + height;
		var maxX:Number = x;
		var maxY:Number = y;
		// calculate minimized room border
		if (freedomTop) {
		    holeLen = getHoleLen(freedomTop, width);
		    holePos = getHolePos(width, holeLen);
		    if (x + holePos < minX)
			minX = x + holePos;
		    if (x + holePos + holeLen > maxX)
			maxX = x + holePos + holeLen;
		}
		if (freedomBottom) {
		    holeLen = getHoleLen(freedomBottom, width);
		    holePos = getHolePos(width, holeLen);
		    if (x + holePos < minX)
			minX = x + holePos;
		    if (x + holePos + holeLen > maxX)
			maxX = x + holePos + holeLen;
		}
		if (freedomRight) {
		    holeLen = getHoleLen(freedomRight, height);
		    holePos = getHolePos(height, holeLen);
		    if (y + holePos < minY)
			minY = y + holePos;
		    if (y + holePos + holeLen > maxY)
			maxY = y + holePos + holeLen;
		}
		if (freedomLeft) {
		    holeLen = getHoleLen(freedomLeft, height);
		    holePos = getHolePos(height, holeLen);
		    if (y + holePos < minY)
			minY = y + holePos;
		    if (y + holePos + holeLen > maxY)
			maxY = y + holePos + holeLen;
		}
		// prevent room from being lesser than allowed min size
		if (maxX - minX < minSize) {
		    var midX:Number = (minX + maxX) / 2;
		    minX = midX - minSize / 2;
		    maxX = midX + minSize / 2;
		}
		if (maxY - minY < minSize) {
		    var midY:Number = (minY + maxY) / 2;
		    minY = midY - minSize / 2;
		    maxY = midY + minSize / 2;
		}
		// adjust border thickness 
		minX = Math.max(roomX, minX - thickness);
		minY = Math.max(roomY, minY - thickness);
		maxX = Math.min(roomX + roomWidth, maxX + thickness);
		maxY = Math.min(roomY + roomHeight, maxY + thickness);
		x = minX;
		y = minY;
		width = maxX - minX;
		height = maxY - minY;
	    }

	    // Top
	    var topHoleX1:Number = -1;
	    var topHoleX2:Number = -1;
	    if (!freedomTop) {
		this.buildWall(world, x, y, width, thickness, 'wallTop', -Math.PI/2);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomTop, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    topHoleX1 = holePos;
		    topHoleX2 = holePos + holeLen;
		    this.buildWall(world, x, y, holePos - x + roomX, thickness, 'wallTop1', -Math.PI/2);
		    this.buildWall(world, roomX + holePos + holeLen, y, x - roomX + width - holePos - holeLen, thickness, 'wallTop2', -Math.PI/2);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, roomX + holePos - thickness, roomY, thickness, y - roomY, 'tunnelTop1', Math.PI);
		    this.buildWall(world, roomX + holePos + holeLen, roomY, thickness, y - roomY, 'tunnelTop2', Math.PI);
		}
	    }
	    // Right
	    var rightHoleY1:Number = -1;
	    var rightHoleY2:Number = -1;
	    if (!freedomRight) {
		this.buildWall(world, x + width - thickness, y, thickness, height, 'wallRight', 0);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomRight, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    rightHoleY1 = holePos;
		    rightHoleY2 = holePos + holeLen;
		    this.buildWall(world, x + width - thickness, y, thickness, holePos - y + roomY, 'wallRight1', 0);
		    this.buildWall(world, x + width - thickness, roomY + holePos + holeLen, thickness, y - roomY + height - holePos - holeLen, 'wallRight2', 0);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, x + width, roomY + holePos - thickness, roomWidth - x + roomX - width, thickness, 'tunnelRight1', -Math.PI/2);
		    this.buildWall(world, x + width, roomY + holePos + holeLen, roomWidth - x + roomX - width, thickness, 'tunnelRight2', -Math.PI/2);
		}
	    } 
	    // Bottom
	    var bottomHoleX1:Number = -1;
	    var bottomHoleX2:Number = -1;
	    if (!freedomBottom) {
		this.buildWall(world, x, y + height - thickness, width, thickness, 'wallBottom', Math.PI/2);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomBottom, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    bottomHoleX1 = holePos;
		    bottomHoleX2 = holePos + holeLen;
		    this.buildWall(world, x, y + height - thickness, holePos - x + roomX, thickness, 'wallBottom1', -Math.PI/2);
		    this.buildWall(world, roomX + holePos + holeLen, y + height - thickness, x - roomX + width - holePos - holeLen, thickness, 'wallBottom2', -Math.PI/2);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, roomX + holePos - thickness, y + height, thickness, roomHeight - y + roomY - height, 'tunnelBottom1', -Math.PI);
		    this.buildWall(world, roomX + holePos + holeLen, y + height, thickness, roomHeight - y + roomY - height, 'tunnelBottom2', -Math.PI);
		}
	    }
	    // Left
	    var leftHoleY1:Number = -1;
	    var leftHoleY2:Number = -1;
	    if (!freedomLeft) {
		this.buildWall(world, x, y, thickness, height, 'wallLeft', Math.PI);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomLeft, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    leftHoleY1 = holePos;
		    leftHoleY2 = holePos + holeLen;
		    this.buildWall(world, x, y, thickness, holePos - y + roomY, 'wallLeft1', 0);
		    this.buildWall(world, x, roomY + holePos + holeLen, thickness, y - roomY + height - holePos - holeLen, 'wallLeft2', 0);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, roomX, roomY + holePos - thickness, x - roomX, thickness, 'tunnelLeft1', Math.PI/2);
		    this.buildWall(world, roomX, roomY + holePos + holeLen, x - roomX, thickness, 'tunnelLeft2', Math.PI/2);
		}
	    } 

	    this.birthX = x + width / 2;
	    this.birthY = y + height / 2;

	    if (roomType == Room.ROOM_TYPE_RUBBLE) {
		// build rubble
		for (var j:int = 0; j < this.mapHeight; j++) {
		    this.map[j] = new Array();
		    for (var i:int = 0; i < this.mapWidth; i++) {
			var room:WorldRoom = new EmptyRoom(null, 0, 0, 0, 0, 0, "", 0);
			this.map[j].push(room);
		    }
		}
		this.generateDFSMaze(0, 0);
		var cellWidth:Number = roomWidth / this.mapWidth;
		var cellHeight:Number = roomHeight / this.mapHeight;
		for (j = 0; j < this.mapHeight; j++) {
		    for (i = 0; i < this.mapWidth; i++) {
			if (!this.map[j][i].freedomRight && i < this.mapWidth - 1 &&
			    !(j == 0 && ((i + 1) * cellWidth) > topHoleX1 - thickness && ((i + 1) * cellWidth) < topHoleX2) &&
			    !(j == this.mapHeight - 1 && ((i + 1) * cellWidth) > bottomHoleX1 - thickness && ((i + 1) * cellWidth) < bottomHoleX2) ) {
			    this.buildWall(world, roomX + (i + 1) * cellWidth, roomY + j * cellHeight, thickness, cellHeight + (j == this.mapHeight - 1 ? 0 : thickness), 'rubbleWallRight' + j.toString() + "-" + i.toString(), Math.PI);    
			}
			if (!this.map[j][i].freedomBottom && j < this.mapHeight - 1 &&
			    !(i == 0 && ((j + 1) * cellHeight) > leftHoleY1 - thickness && ((j + 1) * cellHeight) < leftHoleY2) &&
			    !(i == this.mapWidth - 1 && ((j + 1) * cellHeight) > rightHoleY1 - thickness && ((j + 1) * cellHeight) < rightHoleY2) ) {
			    this.buildWall(world, roomX + i * cellWidth, roomY + (j + 1) * cellHeight, cellWidth, thickness, 'rubbleWallBottom' + j.toString() + "-" + i.toString(), Math.PI/2);    
			}
		    }
		}		
		this.birthX -= cellWidth / 2;
		this.birthY -= cellHeight / 2;
	    }
	    
	}

	private function buildWall(world:b2World, x:Number, y:Number, width:Number, height:Number, name:String, gradientRot:Number):void {
	    if (width > 0 && height > 0 ) {
		var wall:b2PolygonShape= new b2PolygonShape();
		var wallBd:b2BodyDef = new b2BodyDef();
		var fixtureDef:b2FixtureDef = new b2FixtureDef();
		wallBd.type = b2Body.b2_staticBody;
		fixtureDef.density = 0.0;
		fixtureDef.friction = 0.4;
		fixtureDef.restitution = 0.3;
		fixtureDef.filter.categoryBits = 0x0004;
		fixtureDef.filter.maskBits = 0x0002;
		wall.SetAsArray(Utils.getBoxVertices(x, y, width, height), 4);
		fixtureDef.shape = wall;
		wallBd.userData = {gradientType: GradientType.LINEAR, gradientColors: [Utils.colorLight(this.color, 0.5), this.color, Utils.colorDark(this.color, 0.3)], gradientAlphas: [1, 1, this.alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: gradientRot, curved: false}
		bodies[name] = world.CreateBody(wallBd);
		bodies[name].CreateFixture(fixtureDef);
		bodiesOrder.push(name);
	    }	    
	}
	    
	private function getHoleLen(seed:uint, lengthTotal:Number):Number {
	    Rndm.seed = seed;
	    return Rndm.float(lengthTotal * 0.1, lengthTotal * 0.4);
	}

	private function getHolePos(lengthTotal:Number, lengthHole:Number):Number {
	    return Rndm.float(lengthTotal * 0.03, lengthTotal * 0.97 - lengthHole);
	}

	private function generateDFSMaze(x:int, y:int):void {
	    var curX:int = x;
	    var curY:int = y;
	    var cellStackX:Array = new Array();
	    var cellStackY:Array = new Array();
	    while (true) {
		this.map[curY][curX].visited = true;
		// calculate unvisited neighbours
		var neighbours:Array = new Array();
		if (!this.cellVisited(curX - 1, curY)) {
		    neighbours.push({x: curX - 1, y: curY, curAttr: "freedomLeft", nextAttr: "freedomRight"});
		}
		if (!this.cellVisited(curX + 1, curY)) {
		    neighbours.push({x: curX + 1, y: curY, curAttr: "freedomRight", nextAttr: "freedomLeft"});
		}
		if (!this.cellVisited(curX, curY - 1)) {
		    neighbours.push({x: curX, y: curY - 1, curAttr: "freedomTop", nextAttr: "freedomBottom"});
		}
		if (!this.cellVisited(curX, curY + 1)) {
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

	private function cellVisited(x:int, y:int):Boolean {
	    
	    if (x < 0 || x > this.mapWidth - 1 || y < 0 || y > this.mapHeight - 1)
		return true;
	    if (this.map[y][x].visited)
		return true;
	    return false;
	}

    }
	
}