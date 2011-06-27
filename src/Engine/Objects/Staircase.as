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
	
    public class Staircase extends WorldObject {

	public function Staircase(world:b2World, x:Number, y:Number, width:Number, height:Number, numSteps:int, inverted:Boolean, c:uint = 0xAA9944, a:Number = 0.8){
	    
	    var bd:b2BodyDef = new b2BodyDef();
	    var fixtureDef:b2FixtureDef = new b2FixtureDef();
	    var box:b2PolygonShape= new b2PolygonShape();

	    color = c;
	    alpha = a;
	    //bd.type = b2Body.b2_staticBody;
	    fixtureDef.density = 0.0;
	    fixtureDef.friction = 0.4;
	    fixtureDef.restitution = 0.3;
	    fixtureDef.filter.categoryBits = 0x0004;
	    fixtureDef.filter.maskBits = 0x0002;
	    bd.userData = {gradientType: GradientType.LINEAR, gradientColors: [0xFFFFFF, color, color], gradientAlphas: [1, 1, alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: !inverted ? Math.PI : 0, curved: false}

	    for (var i:int = 0; i < numSteps; i++) {
		box = new b2PolygonShape();
		var w:Number = (i + 1) * width / numSteps;
		var h:Number = height / numSteps;
		if (!inverted) {
		    Utils.setBoxAttributes(box, bd, x, y + i * h, w, h);
		} else {
		    Utils.setBoxAttributes(box, bd, x - w, y + i * h, w, h);
		}
		fixtureDef.shape = box;
		bodies['step' + i.toString()] = world.CreateBody(bd);
		bodies['step' + i.toString()].CreateFixture(fixtureDef);
		bodiesOrder.push('step' + i.toString());
	    }

	}

    }
	
}