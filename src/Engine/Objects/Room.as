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

	public function Room(world:b2World, x:Number, y:Number, width:Number, height:Number, thickness:Number, c:uint = 0xDDEEEE, a:Number = 0.8, freedomTop:uint = 0, freedomBottom:uint = 0, freedomLeft:uint = 0, freedomRight:uint = 0){
			
	    this.color = c;
	    this.alpha = a;
	    var holePos:Number;
	    var holeLen:Number;
	    // Top
	    if (!freedomTop) {
		this.buildWall(world, x, y, width, thickness, 'wallTop', -Math.PI/2);
	    } else {
		holeLen = getHoleLen(freedomTop, width);
		holePos = getHolePos(width, holeLen);
		this.buildWall(world, x, y, holePos, thickness, 'wallTop1', -Math.PI/2);
		this.buildWall(world, x + holePos + holeLen, y, width - holePos - holeLen, thickness, 'wallTop2', -Math.PI/2);
	    }
	    // Right
	    if (!freedomRight) {
		this.buildWall(world, x + width - thickness, y, thickness, height, 'wallRight', 0);
	    } else {
		holeLen = getHoleLen(freedomRight, width);
		holePos = getHolePos(width, holeLen);
		this.buildWall(world, x + width - thickness, y, thickness, holePos, 'wallRight1', 0);
		this.buildWall(world, x + width - thickness, y + holePos + holeLen, thickness, height - holePos - holeLen, 'wallRight2', 0);
	    } 
	    // Bottom
	    if (!freedomBottom) {
		this.buildWall(world, x, y + height - thickness, width, thickness, 'wallBottom', Math.PI/2);
	    } else {
		holeLen = getHoleLen(freedomBottom, width);
		holePos = getHolePos(width, holeLen);
		this.buildWall(world, x, y + height - thickness, holePos, thickness, 'wallBottom1', -Math.PI/2);
		this.buildWall(world, x + holePos + holeLen, y + height - thickness, width - holePos - holeLen, thickness, 'wallBottom2', -Math.PI/2);
	    }
	    // Left
	    if (!freedomLeft) {
		this.buildWall(world, x, y, thickness, height, 'wallLeft', Math.PI);
	    } else {
		holeLen = getHoleLen(freedomLeft, width);
		holePos = getHolePos(width, holeLen);
		this.buildWall(world, x, y, thickness, holePos, 'wallLeft1', 0);
		this.buildWall(world, x, y + holePos + holeLen, thickness, height - holePos - holeLen, 'wallLeft2', 0);
	    } 

	}

	private function buildWall(world:b2World, x:Number, y:Number, width:Number, height:Number, name:String, gradientRot:Number):void {
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
	    
	private function getHoleLen(seed:uint, lengthTotal:Number):Number {
	    Rndm.seed = seed;
	    return Rndm.float(lengthTotal * 0.1, lengthTotal * 0.4);
	}

	private function getHolePos(lengthTotal:Number, lengthHole:Number):Number {
	    return Rndm.float(lengthTotal * 0.03, lengthTotal * 0.97 - lengthHole);
	}
    }
	
}