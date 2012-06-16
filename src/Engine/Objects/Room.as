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

    
    public class Room extends WorldObject {

	public static const ROOM_TYPE_OPEN:int = 1;
	public static const ROOM_TYPE_EMPTY:int = 2;
	public static const ROOM_TYPE_TUNNEL:int = 3;
	public static const ROOM_TYPE_RUBBLE:int = 4;
	
	public var birthX:Number;
	public var birthY:Number;

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
	    if (!freedomTop) {
		this.buildWall(world, x, y, width, thickness, 'wallTop', -Math.PI/2);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomTop, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    this.buildWall(world, x, y, holePos - x + roomX, thickness, 'wallTop1', -Math.PI/2);
		    this.buildWall(world, roomX + holePos + holeLen, y, x - roomX + width - holePos - holeLen, thickness, 'wallTop2', -Math.PI/2);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, roomX + holePos - thickness, roomY, thickness, y - roomY, 'tunnelTop1', Math.PI);
		    this.buildWall(world, roomX + holePos + holeLen, roomY, thickness, y - roomY, 'tunnelTop2', Math.PI);
		}
	    }
	    // Right
	    if (!freedomRight) {
		this.buildWall(world, x + width - thickness, y, thickness, height, 'wallRight', 0);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomRight, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    this.buildWall(world, x + width - thickness, y, thickness, holePos - y + roomY, 'wallRight1', 0);
		    this.buildWall(world, x + width - thickness, roomY + holePos + holeLen, thickness, y - roomY + height - holePos - holeLen, 'wallRight2', 0);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, x + width, roomY + holePos - thickness, roomWidth - x + roomX - width, thickness, 'tunnelRight1', -Math.PI/2);
		    this.buildWall(world, x + width, roomY + holePos + holeLen, roomWidth - x + roomX - width, thickness, 'tunnelRight2', -Math.PI/2);
		}
	    } 
	    // Bottom
	    if (!freedomBottom) {
		this.buildWall(world, x, y + height - thickness, width, thickness, 'wallBottom', Math.PI/2);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomBottom, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    this.buildWall(world, x, y + height - thickness, holePos - x + roomX, thickness, 'wallBottom1', -Math.PI/2);
		    this.buildWall(world, roomX + holePos + holeLen, y + height - thickness, x - roomX + width - holePos - holeLen, thickness, 'wallBottom2', -Math.PI/2);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, roomX + holePos - thickness, y + height, thickness, roomHeight - y + roomY - height, 'tunnelBottom1', -Math.PI);
		    this.buildWall(world, roomX + holePos + holeLen, y + height, thickness, roomHeight - y + roomY - height, 'tunnelBottom2', -Math.PI);
		}
	    }
	    // Left
	    if (!freedomLeft) {
		this.buildWall(world, x, y, thickness, height, 'wallLeft', Math.PI);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomLeft, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
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
    }
	
}