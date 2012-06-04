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
    import Engine.Stats.*;
	
    public class Altar extends WorldObject {

	public var thickness:Number;
	public var length:Number;
	public var stats:GenericStats = new GenericStats();
	public var artefact:ArtefactStat;
	public var blissDonated:Number = 0;
	public var blissToObtain:Number = 523;

	public function Altar(world:b2World, x:Number, y:Number, width:Number, height:Number, $thickness:Number, $length:Number, c:uint = 0xEEDD44, a:Number = 0.8, $artefact:ArtefactStat = null){
	    
	    this.thickness = $thickness;
	    this.length = $length;
	    this.artefact = $artefact;
	    var bd:b2BodyDef = new b2BodyDef();
	    var fixtureDef:b2FixtureDef = new b2FixtureDef();
	    var box:b2PolygonShape= new b2PolygonShape();

	    color = c;
	    alpha = a;
	    bd.type = b2Body.b2_staticBody;
	    fixtureDef.density = 0.00;
	    fixtureDef.friction = 0.4;
	    fixtureDef.restitution = 0.3;
	    fixtureDef.filter.categoryBits = 0x0004;
	    fixtureDef.filter.maskBits = 0x0002;

	    // altar
	    box = new b2PolygonShape();
	    Utils.setBoxAttributes(box, bd, x, y, width, height);
	    fixtureDef.shape = box;
	    bd.userData = {gradientType: GradientType.LINEAR, gradientColors: [0xFFFFFF, color, color], gradientAlphas: [1, 1, alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: 0, curved: false}
	    bodies['altar'] = world.CreateBody(bd);
	    bodies['altar'].CreateFixture(fixtureDef);

	    // linga
	    box = new b2PolygonShape();
	    Utils.setBoxAttributes(box, bd, x + width / 2 - thickness / 2, y - length * 1.5  + thickness, thickness, length + thickness);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    bd.userData = {gradientType: GradientType.RADIAL, gradientColors: [0xFFFFFF, color, color], gradientAlphas: [1, 1, alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1}
	    bodies['linga'] = world.CreateBody(bd);
	    bodies['linga'].CreateFixture(fixtureDef);
	    var headSlot:Slot = new Slot(Slot.FATHER, bodies.linga);
	    headSlot.axis = new b2Vec2(0, -1);
	    headSlot.localAnchor = new b2Vec2(0, -(length + thickness) / 2);
	    headSlot.radiuses = new Array();
	    headSlot.owner = this;
	    for (var i:int = 0; i <= 10; i++) {
		headSlot.radiuses.push(new b2Vec2(length * i / 10 / 2, (Math.sqrt(i) / Math.sqrt(10) * thickness / 2)));
	    }
	    bodies['linga'].GetUserData()['slot'] = headSlot;
	    bodies['linga'].drawingFunction = this.drawLinga as Function;
	    bodiesOrder = ['linga', 'altar'];

	}

	private function drawLinga(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    super.drawGenericShape(shape, xf, c, drawScale, dx, dy, udata, spr);
	    if (this.artefact != null && !this.artefact.obtained) {
		var transValue:Number = (this.length * drawScale + 25) * this.blissDonated / this.blissToObtain;
		var scaleValue:Number = 1 - this.blissDonated / this.blissToObtain;
		spr.graphics.lineStyle(2 * scaleValue, this.artefact.colorReal, 1);
		spr.graphics.beginFill(Utils.colorDark(this.artefact.colorReal, 0.5), 1);
		spr.graphics.drawCircle(0, this.length / 2 * drawScale + 25 - transValue, 15 * scaleValue);
		spr.graphics.endFill();
		this.artefact.iconReal(spr, 0, this.length / 2 * drawScale + 25 - transValue, 15 * scaleValue, this.artefact.colorReal, 2 * scaleValue);
	    }
	}

    }
	
}