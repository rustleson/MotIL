package Engine.Objects {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import General.Input;
    import flash.events.Event;	
    import flash.display.*;
    import Engine.Stats.ProtagonistStats;
    import flash.geom.Matrix; 
    import flash.geom.Point;
	
    use namespace b2internal;

    public class Protagonist extends WorldObject {

	public var bodyUserData:Object;
	public var headUserData:Object;
	public var handLUserData:Object;
	public var handRUserData:Object;
	public var nippleUserData:Object;
	public var hairUserData:Object;
	private var _hairColor:uint;
	public var numSegments:int;
	public var stats:ProtagonistStats;
	public var headUnit:Number;
	public var initialHeight:Number;
	public var wideRatio:Number;
	public var hairSprite:Sprite;
	public var startX:Number;
	public var startY:Number;
	public var world:b2World;
	public var bodiesPositions:Object;
	public var bodiesAngles:Object;

	public function Protagonist(world:b2World, startX:Number, startY:Number, height:Number, st:ProtagonistStats){

	    timeout = defaultTimeout;
	    this.world = world;
	    this.startX = startX;
	    this.startY = startY;
	    this.stats = st;
	    this.stats.protagonist = this;
	    this.initialHeight = height;
	    this.numSegments = 4;
	    this.bodiesPositions = new Object();
	    this.bodiesAngles = new Object();
	    this.hairSprite = new Sprite(); 
	    targetAngles = {jointHead: 0 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                    jointUpperArmL: 0 / (180/Math.PI), jointUpperArmR: 0 / (180/Math.PI), jointLowerArmL: 0 / (180/Math.PI), jointLowerArmR: 0 / (180/Math.PI),
	                    jointUpperLegL: 0 / (180/Math.PI), jointUpperLegR: 0 / (180/Math.PI), jointLowerLegL: 0 / (180/Math.PI), jointLowerLegR: 0 / (180/Math.PI) };
			
	    this.bodyUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x23, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1, auraIntencity: 0, auraColor: 0xffffff}
	    this.headUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x23, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1, auraIntencity: 0, auraColor: 0xffffff, slot: null}
	    this.handLUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x23, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1, auraIntencity: 0, auraColor: 0xffffff, slot: null}
	    this.handRUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x23, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1, auraIntencity: 0, auraColor: 0xffffff, slot: null}
	    this.nippleUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x33, 0x6b, 0x9b, 0xc1, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1}
	    this.hairUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [1, 1, 1], gradientRatios: [0x00, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1}


	    this.buildBodies();
	    this.buildJoints();

	    bodiesOrder = new Array();

	    var mainOrder1: Array = new Array('hipL', 'hipR', 'stomach', 'chest', 'shoulders', 'breastL', 'nippleL', 'breastR', 'nippleR', 'neck', 'head');
	    for each (var str:String in mainOrder1)
		bodiesOrder.push(str);

	    var mainOrder2: Array = new Array('anus_sym', 'upperLegL', 'lowerLegL', 'footL', 'upperLegR', 'lowerLegR', 'footR', 'vagina_sym', 'upperArmL', 'lowerArmL', 'fistL', 'upperArmR', 'lowerArmR', 'fistR');
	    for each (str in mainOrder2)
		bodiesOrder.push(str);


	}

	public function createOrUpdateBody(bodyID:String, bd:b2BodyDef, x:Number, y:Number, update:Boolean):void {
	    if (update) {
		this.bodiesPositions[bodyID] = new b2Vec2(this.bodies[bodyID].m_xf.position.x, this.bodies[bodyID].m_xf.position.y);
		this.bodiesAngles[bodyID] = this.bodies[bodyID].GetAngle();
		this.bodies[bodyID].DestroyFixture(this.bodies[bodyID].GetFixtureList());
		this.bodies[bodyID].SetPosition(new b2Vec2(x, y));
		this.bodies[bodyID].SetAngle(0);
	    } else {
		bd.position.Set(x, y);
		this.bodies[bodyID] = this.world.CreateBody(bd);
	    }
	}

	public function buildBodies(update:Boolean = false):void {
	    var circ:b2CircleShape; 
	    var box:b2PolygonShape;
	    var bd:b2BodyDef = new b2BodyDef();
	    var fixtureDef:b2FixtureDef = new b2FixtureDef();
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    this.wideRatio = this.stats.wideRatio;
	    this.headUnit = this.initialHeight * this.stats.heightRatio / 8; // head unit height for use in body proportions
	    this.color = stats.mixedElementsColor;
	    this.bodyUserData.auraColor = stats.auraColor;
	    this.headUserData.auraColor = stats.auraColor;
	    this.handLUserData.auraColor = stats.auraColor;
	    this.handRUserData.auraColor = stats.auraColor;
	    this.bodyUserData.auraIntencity = stats.auraIntencity;
	    this.headUserData.auraIntencity = stats.auraIntencity;
	    this.handLUserData.auraIntencity = stats.auraIntencity;
	    this.handRUserData.auraIntencity = stats.auraIntencity;
	    this.hairColor = stats.hairColor;
	    this.alpha = 1;
	    bd.userData = bodyUserData;
	    bd.type = b2Body.b2_dynamicBody;
				
	    // main body properties
	    fixtureDef.density = 0.1;
	    fixtureDef.friction = 0.4;
	    fixtureDef.restitution = 0.1;
	    // Head
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.75 * wideRatio / 2, headUnit / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('head', bd, startX, startY + headUnit / 2, update);
	    bodies['head'].CreateFixture(fixtureDef);
	    bodies['head'].drawingFunction = this.drawHead as Function;

	    // Mouth Sensor
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    this.createOrUpdateBody('mouth', bd, startX, startY + headUnit * 0.875, update);
	    bodies['mouth'].CreateFixture(fixtureDef);
	    if (update) {
		bodies['mouth'].GetUserData()['slot'].localAnchor = new b2Vec2(0, headUnit * 0.375);
		bodies['mouth'].GetUserData()['slot'].sensorFixture = bodies.head.GetFixtureList();
	    } else {
		var mouthSlot:Slot = new Slot(Slot.MOTHER, bodies.head);
		mouthSlot.localAnchor = new b2Vec2(0, headUnit * 0.375);
		mouthSlot.axis = new b2Vec2(0, -1);
		mouthSlot.depth = headUnit;
		mouthSlot.sensorFixture = bodies.head.GetFixtureList();
		mouthSlot.connectionAngle = 181 * Math.PI / 180;
		bodies['mouth'].SetUserData({'slot': mouthSlot});;
		bodies['head'].SetUserData(headUserData);
		bodies['head'].GetUserData()['slot'] = mouthSlot;
		bodies['head'].GetUserData()['buildSlotMask'] = this.buildMouthSlotMask;
		this.stats.mouthSlot.slot = mouthSlot;
	    }

	    // Neck
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.4 * wideRatio / 2, headUnit / 3 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('neck', bd, startX, startY + headUnit * (1 + 1/6), update);
	    bodies['neck'].CreateFixture(fixtureDef);
				
	    // Shoulders
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 1.6 * wideRatio / 2, headUnit * (3/4) / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('shoulders', bd, startX, startY + headUnit * (1 + 1/3 + 3/4 / 2), update);
	    bodies['shoulders'].CreateFixture(fixtureDef);

	    // Chest
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 1.2 * wideRatio / 2, headUnit * 1.4 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('chest', bd, startX, startY + headUnit * (1.5 + 1/3 + 1/2), update);
	    bd.position.Set(startX, startY + headUnit * (1.5 + 1/3 + 1/2));
	    bodies['chest'] = world.CreateBody(bd);
	    bodies['chest'].CreateFixture(fixtureDef);
	    // Breast
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.3 * wideRatio / 2, headUnit * 0.3 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('breastHelperL', bd, startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 - 1/12 * wideRatio), update);
	    bodies['breastHelperL'].CreateFixture(fixtureDef);
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.75 * wideRatio / 2, headUnit * 0.75 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('breastL', bd, startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6), update);
	    bodies['breastL'].CreateFixture(fixtureDef);
	    bodies['breastL'].drawingFunction = this.drawBreastL as Function;
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.3 * wideRatio / 2, headUnit * 0.3 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('breastHelperR', bd, startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 - 1/12 * wideRatio), update);
	    bodies['breastHelperR'].CreateFixture(fixtureDef);
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.75 * wideRatio / 2, headUnit * wideRatio  * 0.75 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('breastR', bd, startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6), update);
	    bodies['breastR'].CreateFixture(fixtureDef);
	    bodies['breastR'].drawingFunction = this.drawBreastR as Function;
	    // Nipple
	    bd.userData = nippleUserData;
	    // L
	    fixtureDef.density = 0.003;
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.5 * wideRatio / 2, headUnit * 0.5 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('nippleHelperL', bd, startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/12 * (wideRatio - 0.4)), update);
	    bodies['nippleHelperL'].CreateFixture(fixtureDef);
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.33 * wideRatio / 2, headUnit * 0.33 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('nippleL', bd, startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/6 * (wideRatio - 0.4)), update);
	    bodies['nippleL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.1 * wideRatio / 2, headUnit * 0.1 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('nippleHelperR', bd, startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/12 * (wideRatio - 0.4)), update);
	    bodies['nippleHelperR'].CreateFixture(fixtureDef);
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.33 * wideRatio / 2, headUnit * 0.33 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('nippleR', bd, startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/6 * (wideRatio - 0.4)), update);
	    bodies['nippleR'].CreateFixture(fixtureDef);
	    fixtureDef.density = 0.1;

	    // Stomach
	    bd.userData = bodyUserData;
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.9 * wideRatio / 2, headUnit * 1.5 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('stomach', bd, startX, startY + headUnit * (3 + 1/6), update);
	    bodies['stomach'].CreateFixture(fixtureDef);

	    // Hips
	    // holder
	    box.SetAsBox(headUnit * 2 * wideRatio / 2, headUnit * 1.1 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('hips', bd, startX, startY + headUnit * 4, update);
	    bodies['hips'].CreateFixture(fixtureDef);
	    // L
	    box.SetAsBox(headUnit * 1 * wideRatio / 2, headUnit * 1.1 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('hipL', bd, startX - headUnit * 0.33, startY + headUnit * 4, update);
	    bodies['hipL'].CreateFixture(fixtureDef);
	    // R
	    box.SetAsBox(headUnit * 1 * wideRatio / 2, headUnit * 1.1 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('hipR', bd, startX + headUnit * 0.33, startY + headUnit * 4, update);
	    bodies['hipR'].CreateFixture(fixtureDef);

	    // Vagina
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('vagina_sym', bd, startX, startY + headUnit * 4.2, update);
	    bodies['vagina_sym'].CreateFixture(fixtureDef);
	    bodies['vagina_sym'].drawingFunction = this.drawVagina as Function;;
	    // Vagina Sensor
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    this.createOrUpdateBody('vagina', bd, startX, startY + headUnit * 4.2, update);
	    bodies['vagina'].CreateFixture(fixtureDef);
	    if (update) {
		bodies['vagina_sym'].GetUserData()['slot'].localAnchor = new b2Vec2(0, headUnit * 0.2);
		bodies['vagina_sym'].GetUserData()['slot'].sensorFixture = bodies.vagina.GetFixtureList();
	    } else {
		var vaginaSlot:Slot = new Slot(Slot.MOTHER, bodies.hips);
		vaginaSlot.localAnchor = new b2Vec2(0, headUnit * 0.2);
		vaginaSlot.axis = new b2Vec2(0, -1);
		vaginaSlot.depth = headUnit;
		vaginaSlot.sensorFixture = bodies.vagina.GetFixtureList();
		bodies['vagina'].SetUserData({'slot': vaginaSlot});
		bodies['vagina_sym'].SetUserData({'slot': vaginaSlot});
		this.stats.vaginaSlot.slot = vaginaSlot;
	    }

	    // Anus
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    box.SetAsBox(headUnit * 0.15 * wideRatio / 2, headUnit * 0.15 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('anus_sym', bd, startX, startY + headUnit * 4.45, update);
	    bodies['anus_sym'].CreateFixture(fixtureDef);
	    bodies['anus_sym'].drawingFunction = this.drawAnus as Function;;
	    // Anus Sensor
	    box.SetAsBox(headUnit * 0.15 * wideRatio / 2, headUnit * 0.15 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    this.createOrUpdateBody('anus', bd, startX, startY + headUnit * 4.45, update);
	    bodies['anus'].CreateFixture(fixtureDef);
	    if (update) {
		bodies['anus_sym'].GetUserData()['slot'].localAnchor = new b2Vec2(0, headUnit * 0.45);
		bodies['anus_sym'].GetUserData()['slot'].sensorFixture = bodies.anus.GetFixtureList();
	    } else {
		var anusSlot:Slot = new Slot(Slot.MOTHER, bodies.hips);
		anusSlot.localAnchor = new b2Vec2(0, headUnit * 0.45);
		anusSlot.axis = new b2Vec2(0, -1);
		anusSlot.depth = headUnit;
		anusSlot.sensorFixture = bodies.anus.GetFixtureList();
		bodies['anus'].SetUserData({'slot': anusSlot});
		bodies['anus_sym'].SetUserData({'slot': anusSlot});
		this.stats.anusSlot.slot = anusSlot;
	    }

	    // UpperArm
	    // L
	    fixtureDef.isSensor = false;
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (1 + 2/3) / 2, headUnit * 0.5 * wideRatio / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('upperArmL', bd, startX - headUnit * (0.75 + (1 + 2/3) / 2), startY + headUnit * (1 + 1/3 + 1/4), update);
	    bodies['upperArmL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (1 + 2/3) / 2, headUnit * 0.5 * wideRatio / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('upperArmR', bd, startX + headUnit * (0.75 + (1 + 2/3) / 2), startY + headUnit * (1 + 1/3 + 1/4), update);
	    bodies['upperArmR'].CreateFixture(fixtureDef);
				
	    // LowerArm
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (1 + 1/3) / 2, headUnit * 0.4 * wideRatio / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('lowerArmL', bd, startX - headUnit * (1.75 + 2/3 + (1 + 1/3) / 2), startY + headUnit * (1 + 1/3 + 1/4), update);
	    bodies['lowerArmL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (1 + 1/3) / 2, headUnit * 0.4 * wideRatio / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('lowerArmR', bd, startX + headUnit * (1.75 + 2/3 + (1 + 1/3) / 2), startY + headUnit * (1 + 1/3 + 1/4), update);
	    bodies['lowerArmR'].CreateFixture(fixtureDef);

	    // Fist
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 1/2 / 2, headUnit * 1/2 * wideRatio / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('fistL', bd, startX - headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4), update);
	    bodies['fistL'].CreateFixture(fixtureDef);
	    bodies['fistL'].drawingFunction = drawFist as Function;
	    // Left hand Sensor
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    this.createOrUpdateBody('fistLsensor', bd, startX - headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4), update);
	    bodies['fistLsensor'].CreateFixture(fixtureDef);
	    if (update) {
		bodies['fistLsensor'].GetUserData()['slot'].localAnchor = new b2Vec2(0, 0);
		bodies['fistLsensor'].GetUserData()['slot'].sensorFixture = bodies.fistLsensor.GetFixtureList();
	    } else {
		var handLSlot:Slot = new Slot(Slot.MOTHER, bodies.fistL);
		handLSlot.localAnchor = new b2Vec2(0, 0);
		handLSlot.axis = new b2Vec2(0, -1);
		handLSlot.depth = headUnit / 3;
		handLSlot.sensorFixture = bodies.fistLsensor.GetFixtureList();
		handLSlot.connectionAngle = 181 * Math.PI / 180;
		bodies['fistLsensor'].SetUserData({'slot': handLSlot});
		bodies['fistL'].SetUserData(handLUserData);
		bodies['fistL'].GetUserData()['slot'] = handLSlot;
		this.stats.leftHandSlot.slot = handLSlot;
	    }
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 1/2 / 2, headUnit * 1/2 * wideRatio / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('fistR', bd, startX + headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4), update);
	    bodies['fistR'].CreateFixture(fixtureDef);
	    bodies['fistR'].drawingFunction = drawFist as Function;
	    // Right hand Sensor
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    this.createOrUpdateBody('fistRsensor', bd, startX + headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4), update);
	    bodies['fistRsensor'].CreateFixture(fixtureDef);
	    if (update) {
		bodies['fistRsensor'].GetUserData()['slot'].localAnchor = new b2Vec2(0, 0);
		bodies['fistRsensor'].GetUserData()['slot'].sensorFixture = bodies.fistRsensor.GetFixtureList();
	    } else {
		var handRSlot:Slot = new Slot(Slot.MOTHER, bodies.fistR);
		handRSlot.localAnchor = new b2Vec2(0, 0);
		handRSlot.axis = new b2Vec2(0, -1);
		handRSlot.depth = headUnit / 3;
		handRSlot.sensorFixture = bodies.fistRsensor.GetFixtureList();
		handRSlot.connectionAngle = 181 * Math.PI / 180;
		bodies['fistRsensor'].SetUserData({'slot': handRSlot});
		bodies['fistR'].SetUserData(handRUserData);
		bodies['fistR'].GetUserData()['slot'] = handRSlot;
		this.stats.rightHandSlot.slot = handRSlot;
	    }
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
				
	    // UpperLeg
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 3.1/4 * wideRatio / 2, headUnit * 2 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('upperLegL', bd, startX - headUnit * 0.4, startY + headUnit * (4 + 2 / 2), update);
	    bodies['upperLegL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 3.1/4 * wideRatio / 2, headUnit * 2 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('upperLegR', bd, startX + headUnit * 0.4, startY + headUnit * (4 + 2 / 2), update);
	    bodies['upperLegR'].CreateFixture(fixtureDef);
				
	    // LowerLeg
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (9.2/16) * wideRatio / 2, headUnit * 2.2 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('lowerLegL', bd, startX - headUnit * 0.4, startY + headUnit * (6 + 2.2 / 2), update);
	    bodies['lowerLegL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (9.2/16) * wideRatio / 2, headUnit * 2.2 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('lowerLegR', bd, startX + headUnit * 0.4, startY + headUnit * (6 + 2.2 / 2), update);
	    bodies['lowerLegR'].CreateFixture(fixtureDef);
				
	    // Foot
	    fixtureDef.friction = 0.9;
	    fixtureDef.restitution = 0.1;
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (3/4) * wideRatio / 2, headUnit * 1/2 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('footL', bd, startX - headUnit * 0.33, startY + headUnit * (8.2 + 1/4), update);
	    bodies['footL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (3/4) * wideRatio / 2, headUnit * 1/2 / 2);
	    fixtureDef.shape = box;
	    this.createOrUpdateBody('footR', bd, startX + headUnit * 0.33, startY + headUnit * (8.2 + 1/4), update);
	    bodies['footR'].CreateFixture(fixtureDef);
	    
	    this.stats.updateSlotParams();

	    fixtureDef.density = 0.05;
	    fixtureDef.friction = 0.03;
	    var headWidth:Number = headUnit * 0.75 * wideRatio;
	    var hairWidth:Number = headWidth / 5;
	    var hairLength:Number = headUnit * stats.hairLength;
	    // back hair
	    if (stats.hairLength > 0) {
		for (var i:int = 0; i <= 8; i++) {
		    for (var j:int = 0; j <= numSegments; j++) {
			var rootX:Number = startX + i * headWidth / 8 - headWidth / 2;
			var rootY:Number = startY - headUnit * 0.25 * (Math.sin(i * Math.PI / 8) - 1) - headUnit * 0.1 + j * hairLength / numSegments;
			var rootPos:Number = rootY - hairLength / numSegments;
			if (j == 0) rootPos = rootY;
			box = new b2PolygonShape();
			box.SetAsBox(hairWidth / 3 * hairLength / 2, hairWidth / 3 * hairLength / 2);
			fixtureDef.shape = box;
			var bodyID:String = 'hair' + i.toString() + j.toString();
			this.createOrUpdateBody(bodyID, bd, rootX, rootY, update);
			bodies[bodyID].CreateFixture(fixtureDef);
			
		    }
		}
	    }

	}

	public function buildJoints(update:Boolean = false):void {
	    // Clear old joints
	    if (update) {
		for each(var joint:b2Joint in this.joints) {
		    this.world.DestroyJoint(joint);
		}
	    }

	    // Create Joints
	    var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
	    var jdh:b2DistanceJointDef = new b2DistanceJointDef();
	    jd.enableLimit = true;
	    jd.enableMotor = true;
	    jd.collideConnected = false;
	    jd.motorSpeed = 0;
	    jd.maxMotorTorque = motorTorture;

	    // Head to neck
	    jd.lowerAngle = -20 / (180/Math.PI);
	    jd.upperAngle = 20 / (180/Math.PI);
	    jd.Initialize(bodies['neck'], bodies['head'], new b2Vec2(startX, startY + headUnit));
	    joints['jointHead'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.lowerAngle = 0;
	    jd.upperAngle = 0;
	    jd.Initialize(bodies['head'], bodies['mouth'], new b2Vec2(startX, startY + headUnit * 0.875));
	    joints['jointMouth'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // Neck to shoulders
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['shoulders'], bodies['head'], new b2Vec2(startX, startY + headUnit * (1 + 1/3)));
	    joints['jointNeck'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // Upper arm to shoulders
	    // L
	    jd.lowerAngle = -85 / (180/Math.PI);
	    jd.upperAngle = 130 / (180/Math.PI);
	    jd.Initialize(bodies['shoulders'], bodies['upperArmL'], new b2Vec2(startX - headUnit * 0.75, startY + headUnit * (1 + 1/3 + 1/4)));
	    joints['jointUpperArmL'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // R
	    jd.lowerAngle = -130 / (180/Math.PI);
	    jd.upperAngle = 85 / (180/Math.PI);
	    jd.Initialize(bodies['shoulders'], bodies['upperArmR'], new b2Vec2(startX + headUnit * 0.75, startY + headUnit * (1 + 1/3 + 1/4)));
	    joints['jointUpperArmR'] = world.CreateJoint(jd) as b2RevoluteJoint;
				
	    // Lower arm to upper arm
	    // L
	    jd.lowerAngle = -130 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['upperArmL'], bodies['lowerArmL'], new b2Vec2(startX - headUnit * (1.75 + 2/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    joints['jointLowerArmL'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // R
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 130 / (180/Math.PI);
	    jd.Initialize(bodies['upperArmR'], bodies['lowerArmR'], new b2Vec2(startX + headUnit * (1.75 + 2/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    joints['jointLowerArmR'] = world.CreateJoint(jd) as b2RevoluteJoint;
				
	    // Fist to Lower arm
	    // L
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['lowerArmL'], bodies['fistL'], new b2Vec2(startX - headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    joints['jointFistL'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.lowerAngle = 0;
	    jd.upperAngle = 0;
	    jd.Initialize(bodies['fistL'], bodies['fistLsensor'], new b2Vec2(startX - headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    joints['jointFistLsensor'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // R
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['lowerArmR'], bodies['fistR'], new b2Vec2(startX + headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    joints['jointFistR'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.lowerAngle = 0;
	    jd.upperAngle = 0;
	    jd.Initialize(bodies['fistR'], bodies['fistRsensor'], new b2Vec2(startX + headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    joints['jointFistRsensor'] = world.CreateJoint(jd) as b2RevoluteJoint;
				
	    // shoulders/chest
	    jd.enableMotor = false;
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['shoulders'], bodies['chest'], new b2Vec2(startX, startY + headUnit * (3 + 1/6 - 3/4)));
	    joints['jointShoulders'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // chest/stomach
	    jd.enableMotor = false;
	    jd.lowerAngle = -30 / (180/Math.PI);
	    jd.upperAngle = 30 / (180/Math.PI);
	    jd.Initialize(bodies['chest'], bodies['stomach'], new b2Vec2(startX, startY + headUnit * (3 + 1/6 - 3/4)));
	    joints['jointStomach'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // chest/breasts
	    //jd.lowerAngle = -90 / (180/Math.PI);
	    //jd.upperAngle = 90 / (180/Math.PI);
	    //var gp:b2Vec2 = new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/12));
	    jdh.Initialize(bodies['chest'], bodies['breastHelperL'], new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 - 1/12 * wideRatio)), new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 - 1/24 * wideRatio)));
	    joints['jointBreastHelperL'] = world.CreateJoint(jdh) as b2DistanceJoint;
	    jdh.Initialize(bodies['breastHelperL'], bodies['breastL'], new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 - 1/24 * wideRatio)), new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6)));
	    joints['jointBreastL'] = world.CreateJoint(jdh) as b2DistanceJoint;
	    jdh.Initialize(bodies['chest'], bodies['breastHelperR'], new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 - 1/12 * wideRatio)), new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 - 1/24 * wideRatio)));
	    joints['jointBreastHelperR'] = world.CreateJoint(jdh) as b2DistanceJoint;
	    jdh.Initialize(bodies['breastHelperR'], bodies['breastR'], new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 - 1/24 * wideRatio)), new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6)));
	    joints['jointBreastR'] = world.CreateJoint(jdh) as b2DistanceJoint;
	    //gp = new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/12));
	    //jd.Initialize(bodies['chest'], bodies['breastR'], gp);
	    //joints['jointBreastR'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    
	    // breasts/nipples
	    //jd.lowerAngle = 0 / (180/Math.PI);
	    //jd.upperAngle = 0 / (180/Math.PI);
	    jdh.Initialize(bodies['breastL'], bodies['nippleHelperL'], new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6)), new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/12 * (wideRatio - 0.4))));
	    joints['jointNippleHelperL'] = world.CreateJoint(jdh) as b2DistanceJoint;
	    jdh.Initialize(bodies['nippleHelperL'], bodies['nippleL'], new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/12 * (wideRatio - 0.4))), new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/6 * (wideRatio - 0.4))));
	    joints['jointNippleL'] = world.CreateJoint(jdh) as b2DistanceJoint;
	    jdh.Initialize(bodies['breastR'], bodies['nippleHelperR'], new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6)), new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/12 * (wideRatio - 0.4))));
	    joints['jointNippleHelperR'] = world.CreateJoint(jdh) as b2DistanceJoint;
	    jdh.Initialize(bodies['nippleHelperR'], bodies['nippleR'], new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/12 * (wideRatio - 0.4))), new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/6 * (wideRatio - 0.4))));
	    joints['jointNippleR'] = world.CreateJoint(jdh) as b2DistanceJoint;
	    // Stomach/hips
	    jd.Initialize(bodies['stomach'], bodies['hips'], new b2Vec2(startX, startY + headUnit * (4 - 1/2)));
	    joints['jointHips'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.lowerAngle = 0 / (180/Math.PI);
	    jd.upperAngle = 0 / (180/Math.PI);
	    jd.Initialize(bodies['hips'], bodies['hipL'], new b2Vec2(startX - headUnit * 0.33, startY + headUnit * (4 - 1/2)));
	    joints['jointHipL'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['hipR'], new b2Vec2(startX + headUnit * 0.33, startY + headUnit * (4 - 1/2)));
	    joints['jointHipR'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['vagina'], new b2Vec2(startX, startY + headUnit * 4.25));
	    joints['jointVagina'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['vagina_sym'], new b2Vec2(startX, startY + headUnit * 4.25));
	    joints['jointVaginaSym'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['anus'], new b2Vec2(startX, startY + headUnit * 4.45));
	    joints['jointAnus'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['anus_sym'], new b2Vec2(startX, startY + headUnit * 4.45));
	    joints['jointAnusSym'] = world.CreateJoint(jd) as b2RevoluteJoint;
				
	    // Hips to upper leg
	    // L
	    jd.enableMotor = true;
	    jd.lowerAngle = -25 / (180/Math.PI);
	    jd.upperAngle = 125 / (180/Math.PI);
	    jd.Initialize(bodies['hips'], bodies['upperLegL'], new b2Vec2(startX - headUnit * 0.4, startY + headUnit * (4 + 1/4)));
	    joints['jointUpperLegL'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // R
	    jd.lowerAngle = -125 / (180/Math.PI);
	    jd.upperAngle = 25 / (180/Math.PI);
	    jd.Initialize(bodies['hips'], bodies['upperLegR'], new b2Vec2(startX + headUnit * 0.4, startY + headUnit * (4 + 1/4)));
	    joints['jointUpperLegR'] = world.CreateJoint(jd) as b2RevoluteJoint;

	    // Upper leg to lower leg
	    // L
	    jd.lowerAngle = -115 / (180/Math.PI);
	    jd.upperAngle = 115 / (180/Math.PI);
	    jd.Initialize(bodies['upperLegL'], bodies['lowerLegL'], new b2Vec2(startX - headUnit * 0.33, startY + headUnit * 6));
	    joints['jointLowerLegL'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // R
	    jd.lowerAngle = -115 / (180/Math.PI);
	    jd.upperAngle = 115 / (180/Math.PI);
	    jd.Initialize(bodies['upperLegR'], bodies['lowerLegR'], new b2Vec2(startX + headUnit * 0.33, startY + headUnit * 6));
	    joints['jointLowerLegR'] = world.CreateJoint(jd) as b2RevoluteJoint;

	    // Lower leg tp foot
	    // L
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['lowerLegL'], bodies['footL'], new b2Vec2(startX - headUnit * 0.33, startY + headUnit * 8.2));
	    joints['jointFootL'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // R
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['lowerLegR'], bodies['footR'], new b2Vec2(startX + headUnit * 0.33, startY + headUnit * 8.2));
	    joints['jointFootR'] = world.CreateJoint(jd) as b2RevoluteJoint;

	    // back hair
	    var headWidth:Number = headUnit * 0.75 * wideRatio;
	    var hairWidth:Number = headWidth / 5;
	    var hairLength:Number = headUnit * stats.hairLength;
	    if (stats.hairLength > 0) {
		for (var i:int = 0; i <= 8; i++) {
		    for (var j:int = 0; j <= numSegments; j++) {
			var rootX:Number = startX + i * headWidth / 8 - headWidth / 2;
			var rootY:Number = startY - headUnit * 0.25 * (Math.sin(i * Math.PI / 8) - 1) - headUnit * 0.1 + j * hairLength / numSegments;
			var rootPos:Number = rootY - hairLength / numSegments;
			var bodyID:String = 'hair' + i.toString() + j.toString();
			if (j == 0) rootPos = rootY;
			if (j == 0) {
			    jd.Initialize(bodies['head'], bodies[bodyID], new b2Vec2(rootX, rootPos));
			    joints['joint' + bodyID] = world.CreateJoint(jd) as b2RevoluteJoint;
			} else {
			    var bodyPrevID:String = 'hair' + i.toString() + (j - 1).toString();
			    jdh.Initialize(bodies[bodyPrevID], bodies[bodyID], new b2Vec2(rootX, rootPos), new b2Vec2(rootX, rootY));
			    joints['joint' + bodyID] = world.CreateJoint(jdh) as b2DistanceJoint;
			}
			
		    }
		}
	    }
	    // return bodies back to their places before update
	    if (update) {
		for (var bid:Object in this.bodiesPositions) {
		    this.bodies[bid].SetPosition(this.bodiesPositions[bid]);
		    this.bodies[bid].SetAngle(this.bodiesAngles[bid]);
		}
	    }

	}

	public function rebuild():void{
	    this.buildBodies(true);
	    this.buildJoints(true);
	    this.wasUpdated = true;
	}

	public override function update():void{
	    var repeatRate:int = 4;
	    if (Input.isKeyPressed(65) || Input.isKeyDown(65) && Input.getKeyHold(65) % repeatRate == 0){ // A
		targetAngles = {jointHead: -10 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                        jointUpperArmL: 45 / (180/Math.PI), jointUpperArmR: 65 / (180/Math.PI), jointLowerArmL: 35 / (180/Math.PI), jointLowerArmR: 120 / (180/Math.PI),
	                        jointUpperLegL: 110 / (180/Math.PI), jointUpperLegR: 10 / (180/Math.PI), jointLowerLegL: -115 / (180/Math.PI), jointLowerLegR: 30 / (180/Math.PI) };
		timeout = defaultTimeout;
		toggleMotors(true);
		bodies.stomach.ApplyImpulse(new b2Vec2(-this.stats.speed, 0), bodies.stomach.GetWorldCenter());
	    }
	    if (Input.isKeyPressed(83) || Input.isKeyDown(83) && Input.getKeyHold(83) % repeatRate == 0){ // S
		targetAngles = {jointHead: 0 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                        jointUpperArmL: 45 / (180/Math.PI), jointUpperArmR: -45 / (180/Math.PI), jointLowerArmL: 35 / (180/Math.PI), jointLowerArmR: -35 / (180/Math.PI),
	                        jointUpperLegL: 110 / (180/Math.PI), jointUpperLegR: -110 / (180/Math.PI), jointLowerLegL: -115 / (180/Math.PI), jointLowerLegR: 115 / (180/Math.PI) };
		timeout = defaultTimeout;
		toggleMotors(true);
		bodies.hips.ApplyImpulse(new b2Vec2(0, this.stats.speed), bodies.hips.GetWorldCenter());
	    }
	    if (Input.isKeyPressed(68) || Input.isKeyDown(68) && Input.getKeyHold(68) % repeatRate == 0){ // D
		targetAngles = {jointHead: 10 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                        jointUpperArmL: -65 / (180/Math.PI), jointUpperArmR: -45 / (180/Math.PI), jointLowerArmL: -120 / (180/Math.PI), jointLowerArmR: -35 / (180/Math.PI),
	                        jointUpperLegL: -10 / (180/Math.PI), jointUpperLegR: -110 / (180/Math.PI), jointLowerLegL: -30 / (180/Math.PI), jointLowerLegR: 115 / (180/Math.PI) };
		timeout = defaultTimeout;
		toggleMotors(true);
		bodies.stomach.ApplyImpulse(new b2Vec2(this.stats.speed, 0), bodies.stomach.GetWorldCenter());
	    }
	    if (Input.isKeyPressed(87) || Input.isKeyDown(87) && Input.getKeyHold(87) % repeatRate == 0){ // W
		targetAngles = {jointHead: -10 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                        jointUpperArmL: -65 / (180/Math.PI), jointUpperArmR: 65 / (180/Math.PI), jointLowerArmL: -25 / (180/Math.PI), jointLowerArmR: 25 / (180/Math.PI),
	                        jointUpperLegL: 10 / (180/Math.PI), jointUpperLegR: -10 / (180/Math.PI), jointLowerLegL: -10 / (180/Math.PI), jointLowerLegR: 10 / (180/Math.PI) };
		timeout = defaultTimeout;
		toggleMotors(true);
		bodies.shoulders.ApplyImpulse(new b2Vec2(0, -this.stats.speed), bodies.shoulders.GetWorldCenter());
	    }
	    if (Input.isKeyPressed(77)){ // M
		if (!this.stats.anusSlot.slot.isFree) {
		    this.stats.anusSlot.slot.disconnect();
		} else {
		    this.stats.anusSlot.slot.isReady = !this.stats.anusSlot.slot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(78)){ // N
		if (!this.stats.vaginaSlot.slot.isFree) {
		    this.stats.vaginaSlot.slot.disconnect();
		} else {
		    this.stats.vaginaSlot.slot.isReady = !this.stats.vaginaSlot.slot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(74)){ // J
		if (!this.stats.mouthSlot.slot.isFree) {
		    this.stats.mouthSlot.slot.disconnect();
		} else {
		    this.stats.mouthSlot.slot.isReady = !this.stats.mouthSlot.slot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(72)){ // H
		if (!this.stats.leftHandSlot.slot.isFree) {
		    this.stats.leftHandSlot.slot.disconnect();
		} else {
		    this.stats.leftHandSlot.slot.isReady = !this.stats.leftHandSlot.slot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(75)){ // K
		if (!this.stats.rightHandSlot.slot.isFree) {
		    this.stats.rightHandSlot.slot.disconnect();
		} else {
		    this.stats.rightHandSlot.slot.isReady = !this.stats.rightHandSlot.slot.isReady;
		}
		this.wasUpdated = true;
	    }
	    var i:int;
	    if (Input.isKeyPressed(73)){ // I
		this.stats.statsDialog.toggleLarge();
	    }
	    if (Input.isKeyPressed(8)){ // Backspace
		this.stats.statsDialog.toggleHide();
	    }
	    if (Input.isKeyPressed(192)){ // ~
		if (this.stats.statsDialog.widgets.log.state == 'small') {
		    this.stats.statsDialog.widgets.log.large();
		} else {
		    this.stats.statsDialog.widgets.log.small();
		}
	    }
	    if (this.stats.buddhaMode) {
		if (Input.isKeyPressed(49)){ // 1
		    for (i = 0; i< 100; i++)
			this.stats.space += 0.0005;
		    this.color = stats.mixedElementsColor;
		    this.wasUpdated = true;
		}
		if (Input.isKeyPressed(50)){ // 2
		    for (i = 0; i< 100; i++)
			this.stats.water += 0.0005;
		    this.color = stats.mixedElementsColor;
		    this.wasUpdated = true;
		}
		if (Input.isKeyPressed(51)){ // 3
		    for (i = 0; i< 100; i++)
			this.stats.earth += 0.0005;
		    this.color = stats.mixedElementsColor;
		    this.wasUpdated = true;
		}
		if (Input.isKeyPressed(52)){ // 4
		    for (i = 0; i< 100; i++)
			this.stats.fire += 0.0005;
		    this.color = stats.mixedElementsColor;
		    this.wasUpdated = true;
		}
		if (Input.isKeyPressed(53)){ // 5
		    for (i = 0; i< 100; i++)
			this.stats.air += 0.0005;
		    this.color = stats.mixedElementsColor;
		    this.wasUpdated = true;
		}
		if (Input.isKeyPressed(54)){ // 6
		    this.stats.alignment -= 0.05;
		    this.bodyUserData.auraColor = stats.auraColor;
		    this.bodyUserData.auraIntencity = stats.auraIntencity;
		    this.headUserData.auraColor = stats.auraColor;
		    this.headUserData.auraIntencity = stats.auraIntencity;
		    this.handLUserData.auraColor = stats.auraColor;
		    this.handLUserData.auraIntencity = stats.auraIntencity;
		    this.handRUserData.auraColor = stats.auraColor;
		    this.handRUserData.auraIntencity = stats.auraIntencity;
		    this.wasUpdated = true;
		}
		if (Input.isKeyPressed(55)){ // 7
		    this.stats.alignment += 0.05;
		    this.bodyUserData.auraColor = stats.auraColor;
		    this.bodyUserData.auraIntencity = stats.auraIntencity;
		    this.headUserData.auraColor = stats.auraColor;
		    this.headUserData.auraIntencity = stats.auraIntencity;
		    this.handLUserData.auraColor = stats.auraColor;
		    this.handLUserData.auraIntencity = stats.auraIntencity;
		    this.handRUserData.auraColor = stats.auraColor;
		    this.handRUserData.auraIntencity = stats.auraIntencity;
		    this.wasUpdated = true;
		}
		if (Input.isKeyPressed(56)){ // 8
		    this.stats.takeExp(this.stats.exp.tnl + 1);
		    this.rebuild();
		}
	    }
	    this.stats.timeStep();
	    super.update();

	}

	public override function draw(viewport:b2AABB, physScale:Number, forceRedraw:Boolean = false):Sprite{
	    var spr:Sprite = super.draw(viewport, physScale, forceRedraw);
	    if (!spr.contains(this.hairSprite)) {
		spr.addChildAt(this.hairSprite, 0);
	    }
	    this.hairSprite.graphics.clear();
	    var xf:b2Transform = this.bodies['head'].m_xf;
	    var prevX:Number = (xf.position.x - viewport.lowerBound.x) * physScale;
	    var prevY:Number = (xf.position.y - viewport.lowerBound.y) * physScale;
	    // Dakini's halo
	    if (stats.tribe == ProtagonistStats.DAKINI_TRIBE) {
		this.hairSprite.graphics.lineStyle(0.3, 0x000000, 0.3);
		this.hairSprite.graphics.beginFill(Utils.colorDark(0xffffff, (-stats.alignment + 1) / 2), 0.2);
		this.hairSprite.graphics.drawCircle(prevX, prevY, headUnit * (1.4 + stats.level/49) / 2 * physScale);
		this.hairSprite.graphics.endFill();
	    }
	    this.hairSprite.graphics.lineStyle(3, this.hairColor, 1);
	    var gradArray:Array = [Utils.colorLight(this.hairColor, 0.1), Utils.colorDark(this.hairColor, 0.1)];
	    for (var i:int = 0; i <= 8; i++) {
		var nullBodyID:String = 'hair' + i.toString() + "0";
		var nullPos:b2Vec2 = this.bodies[nullBodyID].GetPosition();
		xf = this.bodies[nullBodyID].m_xf;
		prevX = (xf.position.x - viewport.lowerBound.x) * physScale;
		prevY = (xf.position.y - viewport.lowerBound.y) * physScale;
		var points:Array = new Array();
		points.push(new Point(prevX, prevY));
		for (var j:int = 1; j <= numSegments; j++) {
		    var bodyID:String = 'hair' + i.toString() + j.toString();
		    var pos:b2Vec2 = this.bodies[bodyID].GetPosition();
		    xf = this.bodies[bodyID].m_xf;
		    var curX:Number = (xf.position.x - viewport.lowerBound.x) * physScale;
		    var curY:Number = (xf.position.y - viewport.lowerBound.y) * physScale;
		    gradArray.reverse();
		    points.push(new Point(curX, curY));
		    //prevX = curX;
		    //prevY = curY;
		}
		var gradientBoxMatrix:Matrix = new Matrix();
		curX = points[3].x;
		curY = points[3].y;
		prevX = points[0].x;
		prevY = points[0].y;
		gradientBoxMatrix.createGradientBox(curX - prevX, curY - prevY, Math.atan2(curX - prevX, curY - prevY), prevX, prevY);
		this.hairSprite.graphics.lineGradientStyle(GradientType.LINEAR, gradArray, [1, 1], [0, 255], gradientBoxMatrix, SpreadMethod.REFLECT);
		Utils.multicurve(this.hairSprite.graphics, points, false);
	    }
	    return spr;
	}


	public override function set color(c:uint):void {
	    super.color = c;
	    this.bodyUserData.gradientColors = [0xFFFFFF, Utils.colorLight(c, 0.5), c, Utils.colorDark(c, 0.5)];
	    this.headUserData.gradientColors = [0xFFFFFF, Utils.colorLight(c, 0.5), c, Utils.colorDark(c, 0.5)];
	    this.handLUserData.gradientColors = [0xFFFFFF, Utils.colorLight(c, 0.5), c, Utils.colorDark(c, 0.5)];
	    this.handRUserData.gradientColors = [0xFFFFFF, Utils.colorLight(c, 0.5), c, Utils.colorDark(c, 0.5)];
	    this.nippleUserData['gradientColors'] = [0xFFFFFF, Utils.colorDark(c, 1-0.45), Utils.colorDark(c, 1-0.21), Utils.colorDark(c, 1-0.56), Utils.colorDark(c, 1-0.58), c];
	}

	public function get hairColor():uint {
	    return this._hairColor;
	}

	public function set hairColor(c:uint):void {
	    this._hairColor = c;
	    this.hairUserData['gradientColors'] = [Utils.colorLight(c, 0.1), c, Utils.colorDark(c, 0.1)];
	}

	public override function set alpha(a:Number):void {
	    super.alpha = a;
	    this.bodyUserData.gradientAlphas = [1, 1, 1, 1];
	    this.headUserData.gradientAlphas = [1, 1, 1, 1];
	    this.handLUserData.gradientAlphas = [1, 1, 1, 1];
	    this.handRUserData.gradientAlphas = [1, 1, 1, 1];
	    this.nippleUserData['gradientAlphas'] = [1, 1, 1, 1, 0.92, 0];
	}

	private function drawHead(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    // head itself
	    super.drawGenericShape(shape, xf, c, drawScale, dx, dy, udata, spr);
	    // eyes
	    var headWidth:Number = headUnit * 3/4 * wideRatio;
	    var eyeCenterX:Number = headWidth / 5 * (wideRatio + 0.15) / wideRatio;
	    var eyeCenterY:Number = 0;
	    var eyeSize:Number = headWidth / 3 / wideRatio;
	    spr.graphics.lineStyle(0.3, 0x000000, 0.3);
	    spr.graphics.beginFill(0xffffff, 0.90);
	    spr.graphics.moveTo((eyeCenterX - eyeSize / 2 + eyeSize / 4 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.curveTo((eyeCenterX - dx) * drawScale, (eyeCenterY + eyeSize / 1.2 * wideRatio - dy) * drawScale, (eyeCenterX + eyeSize / 2 + eyeSize / 8 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.curveTo((eyeCenterX - dx) * drawScale, (eyeCenterY - eyeSize / 1.2 * wideRatio - dy) * drawScale, (eyeCenterX - eyeSize / 2 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(0xffffff, 0.90);
	    spr.graphics.moveTo((-eyeCenterX + eyeSize / 2 - eyeSize / 4 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.curveTo((-eyeCenterX - dx) * drawScale, (eyeCenterY + eyeSize / 1.2 * wideRatio - dy) * drawScale, (-eyeCenterX - eyeSize / 2 - eyeSize / 8 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.curveTo((-eyeCenterX - dx) * drawScale, (eyeCenterY - eyeSize / 1.2 * wideRatio - dy) * drawScale, (-eyeCenterX + eyeSize / 2 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(this.stats.eyesColor, 1);
	    spr.graphics.drawCircle((eyeCenterX - dx) * drawScale, (eyeCenterY - dy) * drawScale, eyeSize / 3 * drawScale);
	    spr.graphics.drawCircle((-eyeCenterX - dx) * drawScale, (eyeCenterY - dy) * drawScale, eyeSize / 3 * drawScale);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(0x000000, 1);
	    spr.graphics.drawCircle((eyeCenterX - dx) * drawScale, (eyeCenterY - dy) * drawScale, eyeSize / 8 * drawScale);
	    spr.graphics.drawCircle((-eyeCenterX - dx) * drawScale, (eyeCenterY - dy) * drawScale, eyeSize / 8 * drawScale);
	    spr.graphics.endFill();


	    // eyelashes
	    spr.graphics.lineStyle(0.7, 0x000000, 0.7);
	    spr.graphics.moveTo((eyeCenterX - eyeSize / 2 + eyeSize / 4 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.curveTo((eyeCenterX - dx) * drawScale, (eyeCenterY - eyeSize / 1.2 * wideRatio - dy) * drawScale, (eyeCenterX + eyeSize / 2 + eyeSize / 8 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.moveTo((-eyeCenterX + eyeSize / 2 - eyeSize / 4 - dx) * drawScale, (eyeCenterY - dy) * drawScale);
	    spr.graphics.curveTo((-eyeCenterX - dx) * drawScale, (eyeCenterY - eyeSize / 1.2 * wideRatio - dy) * drawScale, (-eyeCenterX - eyeSize / 2 - eyeSize / 8 - dx) * drawScale, (eyeCenterY - dy) * drawScale);

	    // brows
	    var browShift:Number = eyeSize * 0.25;
	    spr.graphics.lineStyle(0.7, 0x000000, 0.8);
	    spr.graphics.moveTo((eyeCenterX - eyeSize / 2 - dx) * drawScale, (eyeCenterY - browShift - dy) * drawScale);
	    spr.graphics.curveTo((eyeCenterX - dx) * drawScale, (eyeCenterY - eyeSize / 1.2 * wideRatio - eyeSize / 4 - dy) * drawScale, (eyeCenterX + eyeSize / 2 + eyeSize / 8 - dx) * drawScale, (eyeCenterY - eyeSize / 1.5 - dy) * drawScale);
	    spr.graphics.moveTo((-eyeCenterX + eyeSize / 2 - dx) * drawScale, (eyeCenterY - browShift - dy) * drawScale);
	    spr.graphics.curveTo((-eyeCenterX - dx) * drawScale, (eyeCenterY - eyeSize / 1.2 * wideRatio - eyeSize / 4 - dy) * drawScale, (-eyeCenterX - eyeSize / 2 - eyeSize / 8 - dx) * drawScale, (eyeCenterY - eyeSize / 1.5 - dy) * drawScale);
	    
	    // third eye
	    if (stats.isEnlightened()) {
		eyeCenterX = headUnit * 0.3;
		eyeSize = headWidth / 4 / wideRatio;
		spr.graphics.lineStyle(0.3, 0x000000, 0.3);
		spr.graphics.beginFill(0xffffff, 0.90);
		spr.graphics.moveTo((eyeCenterY - dy) * drawScale, (-eyeCenterX + eyeSize / 2 - dx) * drawScale);
		spr.graphics.curveTo((eyeCenterY + eyeSize / 1.6 * wideRatio - dy) * drawScale, (-eyeCenterX - dx) * drawScale, (eyeCenterY - dy) * drawScale, (-eyeCenterX - eyeSize / 2 - dx) * drawScale);
		spr.graphics.curveTo((eyeCenterY - eyeSize / 1.6 * wideRatio - dy) * drawScale, (-eyeCenterX - dx) * drawScale, (eyeCenterY - dy) * drawScale, (-eyeCenterX + eyeSize / 2 - dx) * drawScale);
		spr.graphics.endFill();
		spr.graphics.beginFill(this.stats.eyesColor, 1);
		spr.graphics.drawCircle((eyeCenterY - dy) * drawScale, (-eyeCenterX - dx) * drawScale, eyeSize / 3.5 * drawScale);
		spr.graphics.endFill();
		spr.graphics.beginFill(0x000000, 1);
		spr.graphics.drawCircle((eyeCenterY - dy) * drawScale, (-eyeCenterX - dx) * drawScale, eyeSize / 8 * drawScale);
		spr.graphics.endFill();
		spr.graphics.lineStyle(0.7, 0x000000, 0.7);
		spr.graphics.moveTo((eyeCenterY - dy) * drawScale, (-eyeCenterX + eyeSize / 2 - dx) * drawScale);
		spr.graphics.curveTo((eyeCenterY - eyeSize / 1.6 * wideRatio - dy) * drawScale, (-eyeCenterX - dx) * drawScale, (eyeCenterY - dy) * drawScale, (-eyeCenterX - eyeSize / 2 - dx) * drawScale);
	    }

	    // nose
	    spr.graphics.lineStyle(0.7, 0x000000, 0.6);
	    var noseWidth:Number = headWidth / 4;
	    var noseShift:Number = headUnit / 20;
	    var noseHeight:Number = headWidth / 4 / wideRatio;
	    var noseProportion:Number = 0.85; // [0, 1]
	    var noseCurveRatio:Number = 0.3; // [0, 1]
	    spr.graphics.moveTo((-dx) * drawScale, (noseShift - dy) * drawScale);
	    spr.graphics.curveTo((noseWidth/2 - noseWidth * noseCurveRatio - dx) * drawScale, ((noseShift + noseHeight) * noseProportion / 2 - dy) * drawScale, (-noseWidth / 2 - dx) * drawScale, ((noseShift + noseHeight) * noseProportion - dy) * drawScale);
	    spr.graphics.curveTo((-noseWidth/2 - dx) * drawScale, ((noseShift + noseHeight) * (1 - noseCurveRatio / 3)  - dy) * drawScale, (- dx) * drawScale, (noseShift + noseHeight - dy) * drawScale);

	    // mouth
	    spr.graphics.lineStyle(0.7, 0x000000, 0.7);
	    var mouthShift:Number = headUnit * 0.75 / 2;
	    var mouthWidth:Number = headWidth * 0.25 * wideRatio;
	    var mouthCurve:Number = headUnit * 0.05;
	    var mouthOpen:Number = headUnit * 0.1 * (udata.slot.isReady ? 1 : 0);
	    if (!udata.slot.isFree && udata.slot.connectedSlot) {
		var depth:Number = udata.slot.joint.GetJointTranslation();
		mouthOpen = udata.slot.connectedSlot.getDiameter(-depth);
		mouthWidth = mouthOpen * 2;
	    }
	    mouthShift -= mouthOpen / 2;
	    spr.graphics.beginFill(0x442222, 1);
	    spr.graphics.moveTo((-mouthWidth / 2 - dx) * drawScale, (mouthShift - dy) * drawScale);
	    spr.graphics.curveTo((-dx) * drawScale, ((mouthShift + mouthCurve + mouthOpen * 2) - dy) * drawScale, (mouthWidth / 2 - dx) * drawScale, (mouthShift - dy) * drawScale);
	    spr.graphics.curveTo((-dx) * drawScale, ((mouthShift + mouthCurve - mouthOpen) - dy) * drawScale, (-mouthWidth / 2 - dx) * drawScale, (mouthShift - dy) * drawScale);
	    spr.graphics.endFill();
	    
	    // front hair
	    if (this.stats.hairLength > 0) {
		spr.graphics.lineStyle(0, 0, 0);
		spr.graphics.beginFill(this.hairColor, 1);
		for (var i:int = 0; i <= 8; i++) {
		    var rootX:Number = (i - 0.5) * headWidth / 8 - headWidth / 2;
		    var rootY:Number = - headUnit * 0.25 * (Math.sin(i * Math.PI / 8) - 1) - headUnit * 0.6;
		    spr.graphics.drawEllipse(rootX * drawScale, rootY * drawScale, headWidth * 0.1 * drawScale, headUnit * 0.2 * drawScale);
		}
		spr.graphics.endFill();
	    }
	    // Yakshini's diadem
	    if (stats.tribe == ProtagonistStats.YAKSHINI_TRIBE) {
		this.drawDiadem(shape, xf, c, drawScale, dx, dy - headUnit * drawScale / 2, udata, spr);
	    }
	    // Rakshasi's horns
	    if (stats.tribe == ProtagonistStats.RAKSHASI_TRIBE) {
		this.drawLHorn(shape, xf, c, drawScale, dx - headWidth * drawScale * 0.5, dy - headUnit * 1.1 * drawScale / 2, udata, spr);
		this.drawRHorn(shape, xf, c, drawScale, dx + headWidth * drawScale * 0.5, dy - headUnit * 1.1 * drawScale / 2, udata, spr);
	    }
	}

	public function buildMouthSlotMask(maskSprite:Sprite, body:b2Body, drawScale:Number):void {
	    maskSprite.graphics.clear();
	    var slot:Slot = body.GetUserData().slot;
	    var depth:Number = slot.joint.GetJointTranslation();
	    var thickness:Number = slot.connectedSlot.getDiameter(-depth);
	    var dx:Number = slot.localAnchor.x;
	    var dy:Number = slot.localAnchor.y;
	    var angle:Number = Math.acos(b2Math.Dot(slot.body.GetWorldVector(slot.axis), slot.connectedSlot.body.GetWorldVector(slot.connectedSlot.axis)));
	    var axis:b2Vec2 = slot.body.GetLocalVector(slot.connectedSlot.axis);
	    //maskSprite.rotation = angle;
	    maskSprite.graphics.lineStyle(thickness * 3 * drawScale, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
	    maskSprite.graphics.moveTo(dx * drawScale, dy * drawScale);
	    maskSprite.graphics.lineTo((-depth * axis.x + dx) * drawScale, (-depth * axis.y + dy) * drawScale);
	    //maskSprite.graphics.lineStyle(depth / 3 * drawScale, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
	    //maskSprite.graphics.moveTo(-(thickness * axis.y + dx) * drawScale, dy * drawScale);
	    //maskSprite.graphics.curveTo(dx * drawScale, -(thickness * 2 * axis.y + dy) * drawScale, (thickness * axis.y + dx) * drawScale, dy * drawScale);
	}

	private function drawHalo(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    spr.graphics.clear();
	    spr.graphics.lineStyle(0.3, 0x000000, 0.3);
	    spr.graphics.beginFill(Utils.colorDark(0xffffff, (-stats.alignment + 1) / 2), 0.2);
	    spr.graphics.drawCircle(0, 0, headUnit * (1.4 + stats.level/49) / 2 * drawScale);
	    spr.graphics.endFill();
	}

	private function drawLHorn(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    //spr.graphics.clear();
	    var hornsLength:Number = headUnit * (0.5 + stats.level/49) / 3;
	    var headWidth:Number = headUnit * 3/4 * wideRatio;
	    var hornsWidth:Number = hornsLength * 3/4 * wideRatio;
            var c:uint = 0xFFFFFF;
            var a:Number = (-stats.alignment + 1) / 2;
	    spr.graphics.lineStyle(1, c, a);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(hornsWidth / 2 * drawScale + dx, hornsLength / 2 * drawScale + dy);
	    spr.graphics.curveTo(-hornsWidth / 2 * drawScale + dx, hornsLength / 2 * drawScale + dy, -hornsWidth / 2 * drawScale + dx, -hornsLength / 2 * drawScale + dy);
	    spr.graphics.curveTo(-hornsWidth / 2 * drawScale + dx, hornsLength / 2 * drawScale + dy, 0 + dx, hornsLength / 2 * drawScale + dy);
	    spr.graphics.lineTo(hornsWidth / 2 * drawScale + dx, hornsLength / 2 * drawScale + dy);
	    spr.graphics.endFill();
	}

	private function drawRHorn(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    //spr.graphics.clear();
	    var hornsLength:Number = headUnit * (0.5 + stats.level/49) / 3;
	    var headWidth:Number = headUnit * 3/4 * wideRatio;
	    var hornsWidth:Number = hornsLength * 3/4 * wideRatio;
            var c:uint = 0xFFFFFF;
            var a:Number = (-stats.alignment + 1) / 2;
	    spr.graphics.lineStyle(1, c, a);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(-hornsWidth / 2 * drawScale + dx, hornsLength / 2 * drawScale + dy);
	    spr.graphics.curveTo(hornsWidth / 2 * drawScale + dx, hornsLength / 2 * drawScale + dy, hornsWidth / 2 * drawScale + dx, -hornsLength / 2 * drawScale + dy);
	    spr.graphics.curveTo(hornsWidth / 2 * drawScale + dx, hornsLength / 2 * drawScale + dy, 0 + dx, hornsLength / 2 * drawScale + dy);
	    spr.graphics.lineTo(-hornsWidth / 2 * drawScale + dx, hornsLength / 2 * drawScale + dy);
	    spr.graphics.endFill();
	}

	private function drawDiadem(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    //spr.graphics.clear();
	    var headWidth:Number = headUnit * 3/4 * wideRatio;
	    var diademLength:Number = headUnit * (1.1 + stats.level/49) / 4;
	    var diademWidth:Number = headWidth * 1.2;
	    var c:uint = 0xAA8800;
            var a:Number = 1;
	    spr.graphics.lineStyle(0.3, 0x000000, 0.2);
	    //spr.graphics.beginFill(c, a);
	    var gradientBoxMatrix:Matrix = new Matrix();
	    gradientBoxMatrix.createGradientBox(diademWidth * drawScale, diademLength * drawScale, 0);
	    spr.graphics.beginGradientFill(GradientType.LINEAR, [Utils.colorLight(c, 0.5), c, Utils.colorDark(c, 0.5), c, Utils.colorLight(c, 0.5)], [1, 1, 1, 1, 1], [0, 0x20, 0x78, 0xdf, 0xff], gradientBoxMatrix, SpreadMethod.REPEAT);
	    spr.graphics.moveTo(diademWidth / 2 * drawScale, diademLength * 0.3 * drawScale + dy);
	    spr.graphics.curveTo(0, diademLength / 4 * drawScale + dy, 0, -diademLength / 2 * drawScale + dy);
	    spr.graphics.curveTo(0, diademLength / 4 * drawScale + dy, -diademWidth * 0.5 * drawScale, diademLength * 0.3 * drawScale + dy);
	    spr.graphics.lineTo(-diademWidth * 0.5 * drawScale, diademLength * 0.5 * drawScale + dy);
	    spr.graphics.curveTo(0, (diademLength / 2 + headWidth / 8) * drawScale + dy, diademWidth / 2 * drawScale, diademLength / 2 * drawScale + dy);
	    spr.graphics.lineTo(diademWidth * 0.5 * drawScale, diademLength * 0.3 * drawScale + dy);
	    spr.graphics.endFill();
	    c = Utils.colorDark(0xffffff, (-stats.alignment + 1) / 2);
	    spr.graphics.lineStyle(0.2, 0x000000, 0.4);
	    spr.graphics.beginFill(c, 0.3);
	    var shiftCenter:Number = diademLength * 0.2 * drawScale; 
	    spr.graphics.moveTo(0, shiftCenter - diademLength * 0.4 * drawScale + dy);
	    spr.graphics.curveTo(0, shiftCenter + dy, -diademLength * 0.4 * drawScale, shiftCenter + dy);
	    spr.graphics.curveTo(0, shiftCenter + dy, 0, shiftCenter + diademLength * 0.4 * drawScale + dy);
	    spr.graphics.curveTo(0, shiftCenter + dy, diademLength * 0.4 * drawScale, shiftCenter + dy);
	    spr.graphics.curveTo(0, shiftCenter + dy, 0, shiftCenter - diademLength * 0.4 * drawScale + dy);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(c, 0.3);
	    spr.graphics.moveTo((-diademWidth / 4 - diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale + dy);
	    spr.graphics.curveTo(-diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale + dy, -diademWidth / 4 * drawScale, (diademLength * 0.4 - diademLength * 1.5 / 5) * drawScale + dy);
	    spr.graphics.curveTo(-diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale + dy, (-diademWidth / 4 + diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale + dy);
	    spr.graphics.curveTo(-diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale + dy, -diademWidth / 4 * drawScale, (diademLength * 0.4 + diademLength * 1.5 / 5) * drawScale + dy);
	    spr.graphics.curveTo(-diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale + dy, (-diademWidth / 4 - diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale + dy);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(c, 0.3);
	    spr.graphics.moveTo((diademWidth / 4 + diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale + dy);
	    spr.graphics.curveTo(diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale + dy, diademWidth / 4 * drawScale, (diademLength * 0.4 - diademLength * 1.5 / 5) * drawScale + dy);
	    spr.graphics.curveTo(diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale + dy, (diademWidth / 4 - diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale + dy);
	    spr.graphics.curveTo(diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale + dy, diademWidth / 4 * drawScale, (diademLength * 0.4 + diademLength * 1.5 / 5) * drawScale + dy);
	    spr.graphics.curveTo(diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale + dy, (diademWidth / 4 + diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale + dy);
	    spr.graphics.endFill();
	}

	private function drawVagina(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    spr.graphics.clear();
	    spr.graphics.lineStyle(0.7, 0x000000, 0.7);
	    var vaginaHeight:Number = headUnit * 0.25;
	    var lipsOpen:Number = headUnit * 0.03 * (udata.slot.isReady ? 1 : 0);
	    if (!udata.slot.isFree && udata.slot.connectedSlot) {
		var depth:Number = udata.slot.joint.GetJointTranslation();
		lipsOpen = udata.slot.connectedSlot.getDiameter(-depth);
	    }
	    if (lipsOpen > vaginaHeight * 10) {
		vaginaHeight = lipsOpen / 10;
	    }
	    spr.graphics.beginFill(0x442222, 1);
	    spr.graphics.moveTo(0, (-vaginaHeight / 2 - dx) * drawScale);
	    spr.graphics.curveTo(((lipsOpen * 2) - dx) * drawScale, (-dy) * drawScale, 0, (vaginaHeight / 2 - dy) * drawScale);
	    spr.graphics.curveTo(((-lipsOpen * 2) - dx) * drawScale, (-dy) * drawScale, 0, (-vaginaHeight / 2 - dy) * drawScale);
	    spr.graphics.endFill();
	}

	private function drawAnus(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    spr.graphics.clear();
	    spr.graphics.lineStyle(0.6, 0x000000, 0.6);
	    var anusHeight:Number = headUnit * 0.05;
	    var lipsOpen:Number = headUnit * 0.03 * (udata.slot.isReady ? 1 : 0.5);
	    if (!udata.slot.isFree && udata.slot.connectedSlot) {
		var depth:Number = udata.slot.joint.GetJointTranslation();
		lipsOpen = udata.slot.connectedSlot.getDiameter(-depth);
	    }
	    if (lipsOpen > anusHeight * 10) {
		anusHeight = lipsOpen / 10;
	    }
	    spr.graphics.beginFill(0x220000, 0.9);
	    spr.graphics.moveTo(0, (-anusHeight / 2 - dx) * drawScale);
	    spr.graphics.curveTo(((lipsOpen * 2) - dx) * drawScale, (-dy) * drawScale, 0, (anusHeight / 2 - dy) * drawScale);
	    spr.graphics.curveTo(((-lipsOpen * 2) - dx) * drawScale, (-dy) * drawScale, 0, (-anusHeight / 2 - dy) * drawScale);
	    spr.graphics.endFill();
	}

	private function drawFist(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    super.drawGenericShape(shape, xf, c, drawScale, dx, dy, udata, spr);
	    if (udata.slot.isReady) {
		spr.graphics.lineStyle(0.2, 0x000000, 0.2);
		spr.graphics.beginFill(0x666666, 0.2);
		spr.graphics.drawCircle(0, 0, headUnit * 0.5 * drawScale);
		spr.graphics.endFill();
	    }
	}

	private function drawBreast(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    var breastSize:Number = headUnit * 0.75 * wideRatio;
	    spr.graphics.clear();
	    spr.graphics.lineStyle(0, 0, 0);
	    var gradientBoxMatrix:Matrix = new Matrix();
	    gradientBoxMatrix.createGradientBox(breastSize * drawScale, breastSize * drawScale, 0, -breastSize / 2 * drawScale, -breastSize / 2 * drawScale);
	    spr.graphics.beginGradientFill(bodyUserData.gradientType, bodyUserData.gradientColors, bodyUserData.gradientAlphas, bodyUserData.gradientRatios, gradientBoxMatrix);
	    spr.graphics.drawCircle(0, 0, breastSize / 2 * drawScale);
	    spr.graphics.endFill();
	    /*
	    var nippleSize:Number = breastSize * 0.4;
	    var nippleVec:b2Vec2 = new b2Vec2(0, breastSize * 0.2 * wideRatio);
	    gradientBoxMatrix.createGradientBox(nippleSize * drawScale, nippleSize * drawScale, 0, (nippleVec.x - nippleSize / 2) * drawScale, (nippleVec.y - nippleSize / 2) * drawScale);
	    spr.graphics.beginGradientFill(nippleUserData.gradientType, nippleUserData.gradientColors, nippleUserData.gradientAlphas, nippleUserData.gradientRatios, gradientBoxMatrix);
	    spr.graphics.drawCircle(nippleVec.x * drawScale, nippleVec.y * drawScale, nippleSize / 2 * drawScale);
	    spr.graphics.endFill();
	    */
	}

	private function drawBreastL(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    drawBreast(shape, xf, c, drawScale, dx, dy, udata, spr);
	}

	private function drawBreastR(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    drawBreast(shape, xf, c, drawScale, dx, dy, udata, spr);
	}

    }
	
}