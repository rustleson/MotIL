package Engine.Objects {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import General.Input;
    import flash.display.*;
    
    public class Room extends WorldObject {

	public function Room(world:b2World, x:Number, y:Number, width:Number, height:Number, thickness:Number, c:uint = 0xDDEEEE, a:Number = 0.8){
	    
	    var wall:b2PolygonShape= new b2PolygonShape();
	    var wallBd:b2BodyDef = new b2BodyDef();
	    var fixtureDef:b2FixtureDef = new b2FixtureDef();
			
	    color = c;
	    alpha = a;

	    wallBd.type = b2Body.b2_staticBody;
	    fixtureDef.density = 0.0;
	    fixtureDef.friction = 0.4;
	    fixtureDef.restitution = 0.3;
	    fixtureDef.filter.categoryBits = 0x0004;
	    fixtureDef.filter.maskBits = 0x0002;

	    // Left
	    wall.SetAsArray(Utils.getBoxVertices(x, y, thickness, height), 4);
	    fixtureDef.shape = wall;
	    wallBd.userData = {gradientType: GradientType.LINEAR, gradientColors: [0xFFFFFF, color, color], gradientAlphas: [1, 1, alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: 0, curved: false}
	    bodies['wallLeft'] = world.CreateBody(wallBd);
	    bodies['wallLeft'].CreateFixture(fixtureDef);
	    // Right
	    wall.SetAsArray(Utils.getBoxVertices(x + width - thickness, y, thickness, height), 4);
	    fixtureDef.shape = wall;
	    wallBd.userData = {gradientType: GradientType.LINEAR, gradientColors: [0xFFFFFF, color, color], gradientAlphas: [1, 1, alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: Math.PI, curved: false}
	    bodies['wallRight'] = world.CreateBody(wallBd);
	    bodies['wallRight'].CreateFixture(fixtureDef);
	    // Top
	    wall.SetAsArray(Utils.getBoxVertices(x, y, width, thickness), 4);
	    fixtureDef.shape = wall;
	    wallBd.userData = {gradientType: GradientType.LINEAR, gradientColors: [0xFFFFFF, color, color], gradientAlphas: [1, 1, alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: Math.PI/2, curved: false}
	    bodies['wallTop'] = world.CreateBody(wallBd);
	    bodies['wallTop'].CreateFixture(fixtureDef);
	    // Bottom
	    wall.SetAsArray(Utils.getBoxVertices(x, y + height - thickness, width, thickness), 4);
	    fixtureDef.shape = wall;
	    wallBd.userData = {gradientType: GradientType.LINEAR, gradientColors: [0xFFFFFF, color, color], gradientAlphas: [1, 1, alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: -Math.PI/2, curved: false}
	    bodies['wallBottom'] = world.CreateBody(wallBd);
	    bodies['wallBottom'].CreateFixture(fixtureDef);

	    bodiesOrder = ['wallTop', 'wallRight', 'wallBottom', 'wallLeft'];

	}

    }
	
}