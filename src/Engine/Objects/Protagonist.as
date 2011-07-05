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
	
    public class Protagonist extends WorldObject {

	public var bodyUserData:Object;
	public var headUserData:Object;
	public var handLUserData:Object;
	public var handRUserData:Object;
	public var nippleUserData:Object;
	public var hairUserData:Object;
	private var _hairColor:uint;
	public var stats:ProtagonistStats;
	public var headUnit:Number;
	public var wideRatio:Number;

	public function Protagonist(world:b2World, startX:Number, startY:Number, height:Number, st:ProtagonistStats){

	    timeout = defaultTimeout;
	    this.headUnit = height / 8; // head unit height for use in body proportions
	    var circ:b2CircleShape; 
	    var box:b2PolygonShape;
	    var bd:b2BodyDef = new b2BodyDef();
	    var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
	    var fixtureDef:b2FixtureDef = new b2FixtureDef();
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    targetAngles = {jointHead: 0 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                    jointUpperArmL: 0 / (180/Math.PI), jointUpperArmR: 0 / (180/Math.PI), jointLowerArmL: 0 / (180/Math.PI), jointLowerArmR: 0 / (180/Math.PI),
	                    jointUpperLegL: 0 / (180/Math.PI), jointUpperLegR: 0 / (180/Math.PI), jointLowerLegL: 0 / (180/Math.PI), jointLowerLegR: 0 / (180/Math.PI) };
			
	    bodyUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x23, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1, auraIntencity: 0, auraColor: 0xffffff}
	    headUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x23, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1, auraIntencity: 0, auraColor: 0xffffff, slot: null}
	    handLUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x23, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1, auraIntencity: 0, auraColor: 0xffffff, slot: null}
	    handRUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x23, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1, auraIntencity: 0, auraColor: 0xffffff, slot: null}
	    nippleUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [], gradientRatios: [0x00, 0x33, 0x6b, 0x9b, 0xc1, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1}
	    hairUserData = {gradientType: GradientType.RADIAL, gradientColors: [], gradientAlphas: [1, 1, 1], gradientRatios: [0x00, 0x78, 0xFF], gradientRot: 0, curved: true, curveAdjust: 1.1}
	    this.stats = st;
	    this.wideRatio = this.stats.wideRatio;
	    this.headUnit *= this.stats.heightRatio;
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
	    bd.position.Set(startX, startY + headUnit / 2);
	    bodies['head'] = world.CreateBody(bd);
	    bodies['head'].CreateFixture(fixtureDef);
	    bodies['head'].drawingFunction = this.drawHead as Function;
				
	    // Mouth Sensor
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    bd.position.Set(startX, startY + headUnit * 0.875);
	    bodies['mouth'] = world.CreateBody(bd);
	    bodies['mouth'].CreateFixture(fixtureDef);
	    var mouthSlot:Slot = new Slot(Slot.MOTHER, bodies.head);
	    mouthSlot.localAnchor = new b2Vec2(0, headUnit * 0.375);
	    mouthSlot.axis = new b2Vec2(0, -1);
	    mouthSlot.depth = headUnit;
	    mouthSlot.sensorFixture = bodies.head.GetFixtureList();
	    mouthSlot.connectionAngle = 181 * Math.PI / 180;
	    bodies['mouth'].SetUserData({'slot': mouthSlot});;
	    bodies['head'].SetUserData(headUserData);
	    bodies['head'].GetUserData()['slot'] = mouthSlot;
	    this.stats.mouthSlot = mouthSlot;

	    // Neck
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.4 * wideRatio / 2, headUnit / 3 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX, startY + headUnit * (1 + 1/6));
	    bodies['neck'] = world.CreateBody(bd);
	    bodies['neck'].CreateFixture(fixtureDef);
				
	    // Shoulders
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 1.6 * wideRatio / 2, headUnit * (3/4) / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX, startY + headUnit * (1 + 1/3 + 3/4 / 2));
	    bodies['shoulders'] = world.CreateBody(bd);
	    bodies['shoulders'].CreateFixture(fixtureDef);

	    // Chest
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 1.2 * wideRatio / 2, headUnit * 1.4 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX, startY + headUnit * (1.5 + 1/3 + 1/2));
	    bodies['chest'] = world.CreateBody(bd);
	    bodies['chest'].CreateFixture(fixtureDef);
	    // Breast
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.75 * wideRatio / 2, headUnit * 0.75 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6));
	    bodies['breastL'] = world.CreateBody(bd);
	    bodies['breastL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.75 * wideRatio / 2, headUnit * wideRatio  * 0.75 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6));
	    bodies['breastR'] = world.CreateBody(bd);
	    bodies['breastR'].CreateFixture(fixtureDef);
	    // Nipple
	    bd.userData = nippleUserData;
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.33 * wideRatio / 2, headUnit * 0.33 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/6));
	    bodies['nippleL'] = world.CreateBody(bd);
	    bodies['nippleL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.33 * wideRatio / 2, headUnit * 0.33 * wideRatio  / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/6 + 1/6));
	    bodies['nippleR'] = world.CreateBody(bd);
	    bodies['nippleR'].CreateFixture(fixtureDef);

	    // Stomach
	    bd.userData = bodyUserData;
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 0.9 * wideRatio / 2, headUnit * 1.5 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX, startY + headUnit * (3 + 1/6));
	    bodies['stomach'] = world.CreateBody(bd);
	    bodies['stomach'].CreateFixture(fixtureDef);

	    // Hips
	    // holder
	    box.SetAsBox(headUnit * 2 * wideRatio / 2, headUnit * 1.1 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX, startY + headUnit * 4);
	    bodies['hips'] = world.CreateBody(bd);
	    bodies['hips'].CreateFixture(fixtureDef);
	    // L
	    box.SetAsBox(headUnit * 1 * wideRatio / 2, headUnit * 1.1 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * 0.33, startY + headUnit * 4);
	    bodies['hipL'] = world.CreateBody(bd);
	    bodies['hipL'].CreateFixture(fixtureDef);
	    // R
	    box.SetAsBox(headUnit * 1 * wideRatio / 2, headUnit * 1.1 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * 0.33, startY + headUnit * 4);
	    bodies['hipR'] = world.CreateBody(bd);
	    bodies['hipR'].CreateFixture(fixtureDef);

	    // Vagina
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX, startY + headUnit * 4.2);
	    bodies['vagina_sym'] = world.CreateBody(bd);
	    bodies['vagina_sym'].CreateFixture(fixtureDef);
	    bodies['vagina_sym'].drawingFunction = this.drawVagina as Function;;
	    // Vagina Sensor
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    bd.position.Set(startX, startY + headUnit * 4.2);
	    bodies['vagina'] = world.CreateBody(bd);
	    bodies['vagina'].CreateFixture(fixtureDef);
	    var vaginaSlot:Slot = new Slot(Slot.MOTHER, bodies.hips);
	    vaginaSlot.localAnchor = new b2Vec2(0, headUnit * 0.2);
	    vaginaSlot.axis = new b2Vec2(0, -1);
	    vaginaSlot.depth = headUnit;
	    vaginaSlot.sensorFixture = bodies.vagina.GetFixtureList();
	    bodies['vagina'].SetUserData({'slot': vaginaSlot});
	    bodies['vagina_sym'].SetUserData({'slot': vaginaSlot});
	    this.stats.vaginaSlot = vaginaSlot;

	    // Anus
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    box.SetAsBox(headUnit * 0.15 * wideRatio / 2, headUnit * 0.15 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX, startY + headUnit * 4.45);
	    bodies['anus_sym'] = world.CreateBody(bd);
	    bodies['anus_sym'].CreateFixture(fixtureDef);
	    bodies['anus_sym'].drawingFunction = this.drawAnus as Function;;
	    // Anus Sensor
	    box.SetAsBox(headUnit * 0.15 * wideRatio / 2, headUnit * 0.15 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    bd.position.Set(startX, startY + headUnit * 4.45);
	    bodies['anus'] = world.CreateBody(bd);
	    bodies['anus'].CreateFixture(fixtureDef);
	    var anusSlot:Slot = new Slot(Slot.MOTHER, bodies.hips);
	    anusSlot.localAnchor = new b2Vec2(0, headUnit * 0.45);
	    anusSlot.axis = new b2Vec2(0, -1);
	    anusSlot.depth = headUnit;
	    anusSlot.sensorFixture = bodies.anus.GetFixtureList();
	    bodies['anus'].SetUserData({'slot': anusSlot});
	    bodies['anus_sym'].SetUserData({'slot': anusSlot});
	    this.stats.anusSlot = anusSlot;

	    // UpperArm
	    // L
	    fixtureDef.isSensor = false;
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (1 + 2/3) / 2, headUnit * 0.5 * wideRatio / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * (0.75 + (1 + 2/3) / 2), startY + headUnit * (1 + 1/3 + 1/4));
	    bodies['upperArmL'] = world.CreateBody(bd);
	    bodies['upperArmL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (1 + 2/3) / 2, headUnit * 0.5 * wideRatio / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * (0.75 + (1 + 2/3) / 2), startY + headUnit * (1 + 1/3 + 1/4));
	    bodies['upperArmR'] = world.CreateBody(bd);
	    bodies['upperArmR'].CreateFixture(fixtureDef);
				
	    // LowerArm
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (1 + 1/3) / 2, headUnit * 0.4 * wideRatio / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * (1.75 + 2/3 + (1 + 1/3) / 2), startY + headUnit * (1 + 1/3 + 1/4));
	    bodies['lowerArmL'] = world.CreateBody(bd);
	    bodies['lowerArmL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (1 + 1/3) / 2, headUnit * 0.4 * wideRatio / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * (1.75 + 2/3 + (1 + 1/3) / 2), startY + headUnit * (1 + 1/3 + 1/4));
	    bodies['lowerArmR'] = world.CreateBody(bd);
	    bodies['lowerArmR'].CreateFixture(fixtureDef);

	    // Fist
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 1/2 / 2, headUnit * 1/2 * wideRatio / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4));
	    bodies['fistL'] = world.CreateBody(bd);
	    bodies['fistL'].CreateFixture(fixtureDef);
	    bodies['fistL'].drawingFunction = drawFist as Function;
	    // Left hand Sensor
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    bd.position.Set(startX - headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4));
	    bodies['fistLsensor'] = world.CreateBody(bd);
	    bodies['fistLsensor'].CreateFixture(fixtureDef);
	    var handLSlot:Slot = new Slot(Slot.MOTHER, bodies.fistL);
	    handLSlot.localAnchor = new b2Vec2(0, 0);
	    handLSlot.axis = new b2Vec2(0, -1);
	    handLSlot.depth = headUnit / 3;
	    handLSlot.sensorFixture = bodies.fistLsensor.GetFixtureList();
	    handLSlot.connectionAngle = 181 * Math.PI / 180;
	    bodies['fistLsensor'].SetUserData({'slot': handLSlot});
	    bodies['fistL'].SetUserData(handLUserData);
	    bodies['fistL'].GetUserData()['slot'] = handLSlot;
	    this.stats.leftHandSlot = handLSlot;
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 1/2 / 2, headUnit * 1/2 * wideRatio / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4));
	    bodies['fistR'] = world.CreateBody(bd);
	    bodies['fistR'].CreateFixture(fixtureDef);
	    bodies['fistR'].drawingFunction = drawFist as Function;
	    // Right hand Sensor
	    box.SetAsBox(headUnit * 0.25 * wideRatio / 2, headUnit * 0.25 / 2);
	    fixtureDef.shape = box;
	    fixtureDef.filter.categoryBits = 0x0008;
	    fixtureDef.filter.maskBits = 0x0008;
	    bd.position.Set(startX + headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4));
	    bodies['fistRsensor'] = world.CreateBody(bd);
	    bodies['fistRsensor'].CreateFixture(fixtureDef);
	    var handRSlot:Slot = new Slot(Slot.MOTHER, bodies.fistR);
	    handRSlot.localAnchor = new b2Vec2(0, 0);
	    handRSlot.axis = new b2Vec2(0, -1);
	    handRSlot.depth = headUnit / 3;
	    handRSlot.sensorFixture = bodies.fistRsensor.GetFixtureList();
	    handRSlot.connectionAngle = 181 * Math.PI / 180;
	    bodies['fistRsensor'].SetUserData({'slot': handRSlot});
	    bodies['fistR'].SetUserData(handRUserData);
	    bodies['fistR'].GetUserData()['slot'] = handRSlot;
	    this.stats.rightHandSlot = handRSlot;
	    fixtureDef.filter.categoryBits = 0x0002;
	    fixtureDef.filter.maskBits = 0x0004;
				
	    // UpperLeg
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 3.1/4 * wideRatio / 2, headUnit * 2 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * 0.4, startY + headUnit * (4 + 2 / 2));
	    bodies['upperLegL'] = world.CreateBody(bd);
	    bodies['upperLegL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * 3.1/4 * wideRatio / 2, headUnit * 2 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * 0.4, startY + headUnit * (4 + 2 / 2));
	    bodies['upperLegR'] = world.CreateBody(bd);
	    bodies['upperLegR'].CreateFixture(fixtureDef);
				
	    // LowerLeg
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (9.2/16) * wideRatio / 2, headUnit * 2.2 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * 0.4, startY + headUnit * (6 + 2.2 / 2));
	    bodies['lowerLegL'] = world.CreateBody(bd);
	    bodies['lowerLegL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (9.2/16) * wideRatio / 2, headUnit * 2.2 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * 0.4, startY + headUnit * (6 + 2.2 / 2));
	    bodies['lowerLegR'] = world.CreateBody(bd);
	    bodies['lowerLegR'].CreateFixture(fixtureDef);
				
	    // Foot
	    fixtureDef.friction = 0.9;
	    fixtureDef.restitution = 0.1;
	    // L
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (3/4) * wideRatio / 2, headUnit * 1/2 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX - headUnit * 0.33, startY + headUnit * (8.2 + 1/4));
	    bodies['footL'] = world.CreateBody(bd);
	    bodies['footL'].CreateFixture(fixtureDef);
	    // R
	    box = new b2PolygonShape();
	    box.SetAsBox(headUnit * (3/4) * wideRatio / 2, headUnit * 1/2 / 2);
	    fixtureDef.shape = box;
	    bd.position.Set(startX + headUnit * 0.33, startY + headUnit * (8.2 + 1/4));
	    bodies['footR'] = world.CreateBody(bd);
	    bodies['footR'].CreateFixture(fixtureDef);

	    // JOINTS
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
	    world.CreateJoint(jd) as b2RevoluteJoint;
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
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.lowerAngle = 0;
	    jd.upperAngle = 0;
	    jd.Initialize(bodies['fistL'], bodies['fistLsensor'], new b2Vec2(startX - headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    // R
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['lowerArmR'], bodies['fistR'], new b2Vec2(startX + headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.lowerAngle = 0;
	    jd.upperAngle = 0;
	    jd.Initialize(bodies['fistR'], bodies['fistRsensor'], new b2Vec2(startX + headUnit * (1.75 + 2/3 + 1 + 1/3), startY + headUnit * (1 + 1/3 + 1/4)));
	    world.CreateJoint(jd) as b2RevoluteJoint;
				
	    // shoulders/chest
	    jd.enableMotor = false;
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['shoulders'], bodies['chest'], new b2Vec2(startX, startY + headUnit * (3 + 1/6 - 3/4)));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    // chest/stomach
	    jd.enableMotor = false;
	    jd.lowerAngle = -30 / (180/Math.PI);
	    jd.upperAngle = 30 / (180/Math.PI);
	    jd.Initialize(bodies['chest'], bodies['stomach'], new b2Vec2(startX, startY + headUnit * (3 + 1/6 - 3/4)));
	    joints['jointStomach'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    // chest/breasts
	    jd.lowerAngle = -90 / (180/Math.PI);
	    jd.upperAngle = 90 / (180/Math.PI);
	    var gp:b2Vec2 = new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * (2 + 1/12));
	    jd.Initialize(bodies['chest'], bodies['breastL'], gp);
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    gp = new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * (2 + 1/12));
	    jd.Initialize(bodies['chest'], bodies['breastR'], gp);
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    // breasts/nipples
	    jd.lowerAngle = 0 / (180/Math.PI);
	    jd.upperAngle = 0 / (180/Math.PI);
	    jd.Initialize(bodies['breastL'], bodies['nippleL'], new b2Vec2(startX - headUnit * 0.8 / 2, startY + headUnit * 2));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['breastR'], bodies['nippleR'], new b2Vec2(startX + headUnit * 0.8 / 2, startY + headUnit * 2));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    // Stomach/hips
	    jd.Initialize(bodies['stomach'], bodies['hips'], new b2Vec2(startX, startY + headUnit * (4 - 1/2)));
	    joints['jointHips'] = world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.lowerAngle = 0 / (180/Math.PI);
	    jd.upperAngle = 0 / (180/Math.PI);
	    jd.Initialize(bodies['hips'], bodies['hipL'], new b2Vec2(startX - headUnit * 0.33, startY + headUnit * (4 - 1/2)));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['hipR'], new b2Vec2(startX + headUnit * 0.33, startY + headUnit * (4 - 1/2)));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['vagina'], new b2Vec2(startX, startY + headUnit * 4.25));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['vagina_sym'], new b2Vec2(startX, startY + headUnit * 4.25));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['anus'], new b2Vec2(startX, startY + headUnit * 4.45));
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    jd.Initialize(bodies['hips'], bodies['anus_sym'], new b2Vec2(startX, startY + headUnit * 4.45));
	    world.CreateJoint(jd) as b2RevoluteJoint;
				
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
	    world.CreateJoint(jd) as b2RevoluteJoint;
	    // R
	    jd.lowerAngle = -10 / (180/Math.PI);
	    jd.upperAngle = 10 / (180/Math.PI);
	    jd.Initialize(bodies['lowerLegR'], bodies['footR'], new b2Vec2(startX + headUnit * 0.33, startY + headUnit * 8.2));
	    world.CreateJoint(jd) as b2RevoluteJoint;

	    bodiesOrder = new Array();

	    // Hair & tribe attributes
	    bd.userData = hairUserData;
	    //fixtureDef.filter.maskBits = 0;
	    //fixtureDef.filter.categoryBits = 0;
	    jd.enableMotor = false;
	    jd.motorSpeed = 0.1;
	    jd.maxMotorTorque = 10;
	    jd.referenceAngle = Math.PI;
	    jd.enableLimit = false;
	    fixtureDef.density = 0.05;
	    fixtureDef.friction = 0.03;
	    var headWidth:Number = headUnit * 0.75 * wideRatio;
	    var hairWidth:Number = headWidth / 5;
	    var hairLength:Number = headUnit * stats.hairLength;

	    // Dakini's halo
	    if (stats.tribe == ProtagonistStats.DAKINI_TRIBE) {
		var haloRadius:Number = headUnit * (1.1 + stats.level/49) / 2;
		jd.enableLimit = true;
		jd.lowerAngle = 0 / (180/Math.PI);
		jd.upperAngle = 0 / (180/Math.PI);
		box = new b2PolygonShape();
		box.SetAsBox(haloRadius, haloRadius);
		fixtureDef.shape = box;
		fixtureDef.filter.maskBits = 0;
		fixtureDef.filter.categoryBits = 0;
		fixtureDef.density = 0.005;
		bd.position.Set(startX, startY + headUnit / 2);
		bodies['halo'] = world.CreateBody(bd);
		bodies['halo'].CreateFixture(fixtureDef);
		bodies['halo'].drawingFunction = this.drawHalo as Function;
		bodiesOrder.push('halo');
		jd.Initialize(bodies['head'], bodies['halo'], new b2Vec2(startX, startY + headUnit / 2));
		world.CreateJoint(jd) as b2FrictionJoint;
		fixtureDef.filter.categoryBits = 0x0002;
		fixtureDef.filter.maskBits = 0x0005;
		fixtureDef.density = 0.05;
		jd.enableLimit = false;
	    }

	    // back hair
	    if (stats.hairLength > 0) {
		for (var i:int = 0; i <= 4; i++) {
		    var rootX:Number = startX + i * headWidth / 4 - headWidth / 2;
		    var rootY:Number = startY - headUnit * 0.2 * (Math.sin(i * Math.PI / 4) - 1);
		    jd.lowerAngle = -180 / (180/Math.PI);
		    jd.upperAngle = 180 / (180/Math.PI);
		    box = new b2PolygonShape();
		    box.SetAsBox(hairWidth * 1.5 / 2, hairLength / 2);
		    fixtureDef.shape = box;
		    bd.position.Set(rootX, rootY + 0.5 * hairLength);
		    var bodyID:String = 'hair' + i.toString();
		    bodies[bodyID] = world.CreateBody(bd);
		    bodies[bodyID].CreateFixture(fixtureDef);
		    bodiesOrder.push(bodyID);
		    jd.Initialize(bodies['head'], bodies[bodyID], new b2Vec2(rootX, rootY));
		    world.CreateJoint(jd) as b2FrictionJoint;
		}
	    }

	    var mainOrder1: Array = new Array('hipL', 'hipR', 'stomach', 'chest', 'shoulders', 'breastL', 'nippleL', 'breastR', 'nippleR', 'neck', 'head');
	    for each (var str:String in mainOrder1)
		bodiesOrder.push(str);

	    // Rakshasi's horns
	    if (stats.tribe == ProtagonistStats.RAKSHASI_TRIBE) {
		var hornsLength:Number = headUnit * (1.1 + stats.level/49) / 3;
		var hornsWidth:Number = hornsLength * 3/4 * wideRatio;
		jd.enableLimit = true;
		jd.lowerAngle = 0 / (180/Math.PI);
		jd.upperAngle = 0 / (180/Math.PI);
		fixtureDef.shape = box;
		fixtureDef.filter.maskBits = 0;
		fixtureDef.filter.categoryBits = 0;
		fixtureDef.density = 0.005;
		// L
		box = new b2PolygonShape();
		box.SetAsBox(hornsWidth, hornsLength);
		bd.position.Set(startX - headWidth / 2, startY + headUnit / 6 - hornsLength / 2);
		bodies['hornL'] = world.CreateBody(bd);
		bodies['hornL'].CreateFixture(fixtureDef);
		bodies['hornL'].drawingFunction = this.drawLHorn as Function;
		bodiesOrder.push('hornL');
		jd.Initialize(bodies['head'], bodies['hornL'], new b2Vec2(startX, startY));
		world.CreateJoint(jd) as b2FrictionJoint;
		// R
		box = new b2PolygonShape();
		box.SetAsBox(hornsWidth, hornsLength);
		bd.position.Set(startX + headWidth / 2, startY + headUnit / 6 - hornsLength / 2);
		bodies['hornR'] = world.CreateBody(bd);
		bodies['hornR'].CreateFixture(fixtureDef);
		bodies['hornR'].drawingFunction = this.drawRHorn as Function;
		bodiesOrder.push('hornR');
		jd.Initialize(bodies['head'], bodies['hornR'], new b2Vec2(startX, startY));
		world.CreateJoint(jd) as b2FrictionJoint;
		fixtureDef.filter.categoryBits = 0x0002;
		fixtureDef.filter.maskBits = 0x0005;
		fixtureDef.density = 0.05;
		jd.enableLimit = false;
	    }

	    // front hair
	    if (stats.hairLength > 0) {
		for (i = 0; i <= 4; i++) {
		    rootX = startX + i * headWidth / 4 - headWidth / 2;
		    rootY = startY - headUnit * 0.25 * (Math.sin(i * Math.PI / 4) - 1) - headUnit * 0.1;
		    jd.lowerAngle = -180 / (180/Math.PI);
		    jd.upperAngle = 180 / (180/Math.PI);
		    box = new b2PolygonShape();
		    box.SetAsBox(hairWidth * 1.5 / 2, headUnit * 0.3 / 2);
		    fixtureDef.shape = box;
		    bd.position.Set(rootX, rootY);
		    bodyID = 'hair' + (i + 5).toString();
		    bodies[bodyID] = world.CreateBody(bd);
		    bodies[bodyID].CreateFixture(fixtureDef);
		    bodiesOrder.push(bodyID);
		    jd.Initialize(bodies['head'], bodies[bodyID], new b2Vec2(rootX, rootY));
		    world.CreateJoint(jd) as b2RevoluteJoint;
		}
	    }

	    // Yakshini's diadem
	    if (stats.tribe == ProtagonistStats.YAKSHINI_TRIBE) {
		var diademLength:Number = headUnit * (1.1 + stats.level/49) / 6;
		var diademWidth:Number = headWidth * 1.1;
		jd.enableLimit = true;
		jd.lowerAngle = 0 / (180/Math.PI);
		jd.upperAngle = 0 / (180/Math.PI);
		fixtureDef.shape = box;
		fixtureDef.filter.maskBits = 0;
		fixtureDef.filter.categoryBits = 0;
		fixtureDef.density = 0.005;
		box = new b2PolygonShape();
		box.SetAsBox(diademWidth, diademLength);
		bd.position.Set(startX, startY - diademLength / 2);
		bodies['diadem'] = world.CreateBody(bd);
		bodies['diadem'].CreateFixture(fixtureDef);
		bodies['diadem'].drawingFunction = this.drawDiadem as Function;
		bodiesOrder.push('diadem');
		jd.Initialize(bodies['head'], bodies['diadem'], new b2Vec2(startX, startY));
		world.CreateJoint(jd) as b2RevoluteJoint;
		fixtureDef.filter.categoryBits = 0x0002;
		fixtureDef.filter.maskBits = 0x0005;
		fixtureDef.density = 0.05;
		jd.enableLimit = false;
	    }

	    var mainOrder2: Array = new Array('anus_sym', 'upperLegL', 'lowerLegL', 'footL', 'upperLegR', 'lowerLegR', 'footR', 'vagina_sym', 'upperArmL', 'lowerArmL', 'fistL', 'upperArmR', 'lowerArmR', 'fistR');
	    for each (str in mainOrder2)
		bodiesOrder.push(str);


	}

	public override function update():void{
	    
	    if (Input.isKeyPressed(65)){ // A
		targetAngles = {jointHead: -10 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                        jointUpperArmL: 45 / (180/Math.PI), jointUpperArmR: 65 / (180/Math.PI), jointLowerArmL: 35 / (180/Math.PI), jointLowerArmR: 120 / (180/Math.PI),
	                        jointUpperLegL: 110 / (180/Math.PI), jointUpperLegR: 10 / (180/Math.PI), jointLowerLegL: -115 / (180/Math.PI), jointLowerLegR: 30 / (180/Math.PI) };
		timeout = defaultTimeout;
		toggleMotors(true);
		bodies.stomach.ApplyImpulse(new b2Vec2(-this.stats.speed, 0), bodies.stomach.GetWorldCenter());
	    }
	    if (Input.isKeyPressed(83)){ // S
		targetAngles = {jointHead: 0 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                        jointUpperArmL: 45 / (180/Math.PI), jointUpperArmR: -45 / (180/Math.PI), jointLowerArmL: 35 / (180/Math.PI), jointLowerArmR: -35 / (180/Math.PI),
	                        jointUpperLegL: 110 / (180/Math.PI), jointUpperLegR: -110 / (180/Math.PI), jointLowerLegL: -115 / (180/Math.PI), jointLowerLegR: 115 / (180/Math.PI) };
		timeout = defaultTimeout;
		toggleMotors(true);
		bodies.hips.ApplyImpulse(new b2Vec2(0, this.stats.speed), bodies.hips.GetWorldCenter());
	    }
	    if (Input.isKeyPressed(68)){ // D
		targetAngles = {jointHead: 10 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                        jointUpperArmL: -65 / (180/Math.PI), jointUpperArmR: -45 / (180/Math.PI), jointLowerArmL: -120 / (180/Math.PI), jointLowerArmR: -35 / (180/Math.PI),
	                        jointUpperLegL: -10 / (180/Math.PI), jointUpperLegR: -110 / (180/Math.PI), jointLowerLegL: -30 / (180/Math.PI), jointLowerLegR: 115 / (180/Math.PI) };
		timeout = defaultTimeout;
		toggleMotors(true);
		bodies.stomach.ApplyImpulse(new b2Vec2(this.stats.speed, 0), bodies.stomach.GetWorldCenter());
	    }
	    if (Input.isKeyPressed(87)){ // W
		targetAngles = {jointHead: -10 / (180/Math.PI), jointNeck: 0 / (180/Math.PI), jointStomach: 0 / (180/Math.PI), jointHips: 0 / (180/Math.PI),
	                        jointUpperArmL: -65 / (180/Math.PI), jointUpperArmR: 65 / (180/Math.PI), jointLowerArmL: -25 / (180/Math.PI), jointLowerArmR: 25 / (180/Math.PI),
	                        jointUpperLegL: 10 / (180/Math.PI), jointUpperLegR: -10 / (180/Math.PI), jointLowerLegL: -10 / (180/Math.PI), jointLowerLegR: 10 / (180/Math.PI) };
		timeout = defaultTimeout;
		toggleMotors(true);
		bodies.shoulders.ApplyImpulse(new b2Vec2(0, -this.stats.speed), bodies.shoulders.GetWorldCenter());
	    }
	    if (Input.isKeyPressed(77)){ // M
		if (!this.stats.anusSlot.isFree) {
		    this.stats.anusSlot.disconnect();
		} else {
		    this.stats.anusSlot.isReady = !this.stats.anusSlot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(78)){ // N
		if (!this.stats.vaginaSlot.isFree) {
		    this.stats.vaginaSlot.disconnect();
		} else {
		    this.stats.vaginaSlot.isReady = !this.stats.vaginaSlot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(74)){ // J
		if (!this.stats.mouthSlot.isFree) {
		    this.stats.mouthSlot.disconnect();
		} else {
		    this.stats.mouthSlot.isReady = !this.stats.mouthSlot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(72)){ // H
		if (!this.stats.leftHandSlot.isFree) {
		    this.stats.leftHandSlot.disconnect();
		} else {
		    this.stats.leftHandSlot.isReady = !this.stats.leftHandSlot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(75)){ // K
		if (!this.stats.rightHandSlot.isFree) {
		    this.stats.rightHandSlot.disconnect();
		} else {
		    this.stats.rightHandSlot.isReady = !this.stats.rightHandSlot.isReady;
		}
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(73)){ // I
		this.stats.statsDialog.toggleLarge();
	    }
	    if (Input.isKeyPressed(8)){ // Backspace
		this.stats.statsDialog.toggleHide();
	    }
	    if (Input.isKeyPressed(49)){ // 1
		this.stats.space += 0.05;
		this.color = stats.mixedElementsColor;
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(50)){ // 2
		this.stats.water += 0.05;
		this.color = stats.mixedElementsColor;
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(51)){ // 3
		this.stats.earth += 0.05;
		this.color = stats.mixedElementsColor;
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(52)){ // 4
		this.stats.fire += 0.05;
		this.color = stats.mixedElementsColor;
		this.wasUpdated = true;
	    }
	    if (Input.isKeyPressed(53)){ // 5
		this.stats.air += 0.05;
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
	    this.stats.timeStep();
	    super.update();

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
	    var headWidth:Number = headUnit * 3/4;
	    var eyeCenterX:Number = headWidth / 5 * (wideRatio + 0.15);
	    var eyeCenterY:Number = 0;
	    var eyeSize:Number = headWidth / 3;
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
		eyeSize = headWidth / 4;
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
	    var noseWidth:Number = headWidth / 4 * wideRatio;
	    var noseShift:Number = headUnit / 20;
	    var noseHeight:Number = headWidth / 4;
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
	    
	}

	private function drawHalo(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    spr.graphics.clear();
	    spr.graphics.lineStyle(0.3, 0x000000, 0.3);
	    spr.graphics.beginFill(Utils.colorDark(0xffffff, (-stats.alignment + 1) / 2), 0.2);
	    spr.graphics.drawCircle(0, 0, headUnit * (1.4 + stats.level/49) / 2 * drawScale);
	    spr.graphics.endFill();
	}

	private function drawLHorn(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    spr.graphics.clear();
	    var hornsLength:Number = headUnit * (1.1 + stats.level/49) / 3;
	    var headWidth:Number = headUnit * 3/4 * wideRatio;
	    var hornsWidth:Number = hornsLength * 3/4 * wideRatio;
            var c:uint = 0xFFFFFF;
            var a:Number = (-stats.alignment + 1) / 2;
	    spr.graphics.lineStyle(1, c, a);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(hornsWidth / 2 * drawScale, hornsLength / 2 * drawScale);
	    spr.graphics.curveTo(-hornsWidth / 2 * drawScale, hornsLength / 2 * drawScale, -hornsWidth / 2 * drawScale, -hornsLength / 2 * drawScale);
	    spr.graphics.curveTo(-hornsWidth / 2 * drawScale, hornsLength / 2 * drawScale, 0, hornsLength / 2 * drawScale);
	    spr.graphics.lineTo(hornsWidth / 2 * drawScale, hornsLength / 2 * drawScale);
	    spr.graphics.endFill();
	}

	private function drawRHorn(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    spr.graphics.clear();
	    var hornsLength:Number = headUnit * (1.1 + stats.level/49) / 3;
	    var headWidth:Number = headUnit * 3/4 * wideRatio;
	    var hornsWidth:Number = hornsLength * 3/4 * wideRatio;
            var c:uint = 0xFFFFFF;
            var a:Number = (-stats.alignment + 1) / 2;
	    spr.graphics.lineStyle(1, c, a);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(-hornsWidth / 2 * drawScale, hornsLength / 2 * drawScale);
	    spr.graphics.curveTo(hornsWidth / 2 * drawScale, hornsLength / 2 * drawScale, hornsWidth / 2 * drawScale, -hornsLength / 2 * drawScale);
	    spr.graphics.curveTo(hornsWidth / 2 * drawScale, hornsLength / 2 * drawScale, 0, hornsLength / 2 * drawScale);
	    spr.graphics.lineTo(-hornsWidth / 2 * drawScale, hornsLength / 2 * drawScale);
	    spr.graphics.endFill();
	}

	private function drawDiadem(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void {
	    spr.graphics.clear();
	    var headWidth:Number = headUnit * 3/4 * wideRatio;
	    var diademLength:Number = headUnit * (1.1 + stats.level/49) / 4;
	    var diademWidth:Number = headWidth * 1.1;
	    var c:uint = 0xAA8800;
            var a:Number = 1;
	    spr.graphics.lineStyle(0.3, 0x000000, 0.2);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(diademWidth / 2 * drawScale, diademLength / 2 * drawScale);
	    spr.graphics.curveTo(0, diademLength / 4 * drawScale, 0, -diademLength / 2 * drawScale);
	    spr.graphics.curveTo(0, diademLength / 4 * drawScale, -diademWidth / 2 * drawScale, diademLength / 2 * drawScale);
	    spr.graphics.curveTo(0, (diademLength / 2 + headWidth / 8) * drawScale, diademWidth / 2 * drawScale, diademLength / 2 * drawScale);
	    spr.graphics.endFill();
	    c = Utils.colorDark(0xffffff, (-stats.alignment + 1) / 2);
	    spr.graphics.lineStyle(0.2, c, 0.5);
	    spr.graphics.beginFill(0xffffff, 0.4);
	    spr.graphics.moveTo(0, -diademLength * 0.6 * drawScale);
	    spr.graphics.curveTo(0, 0, -diademLength * 0.5 * drawScale, 0);
	    spr.graphics.curveTo(0, 0, 0, diademLength * 0.6 * drawScale);
	    spr.graphics.curveTo(0, 0, diademLength * 0.5 * drawScale, 0);
	    spr.graphics.curveTo(0, 0, 0, -diademLength * 0.6 * drawScale);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(0xffffff, 0.4);
	    spr.graphics.moveTo((-diademWidth / 4 - diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale);
	    spr.graphics.curveTo(-diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale, -diademWidth / 4 * drawScale, (diademLength * 0.4 - diademLength * 1.5 / 5) * drawScale);
	    spr.graphics.curveTo(-diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale, (-diademWidth / 4 + diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale);
	    spr.graphics.curveTo(-diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale, -diademWidth / 4 * drawScale, (diademLength * 0.4 + diademLength * 1.5 / 5) * drawScale);
	    spr.graphics.curveTo(-diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale, (-diademWidth / 4 - diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(0xffffff, 0.4);
	    spr.graphics.moveTo((diademWidth / 4 + diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale);
	    spr.graphics.curveTo(diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale, diademWidth / 4 * drawScale, (diademLength * 0.4 - diademLength * 1.5 / 5) * drawScale);
	    spr.graphics.curveTo(diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale, (diademWidth / 4 - diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale);
	    spr.graphics.curveTo(diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale, diademWidth / 4 * drawScale, (diademLength * 0.4 + diademLength * 1.5 / 5) * drawScale);
	    spr.graphics.curveTo(diademWidth / 4 * drawScale, diademLength * 0.4 * drawScale, (diademWidth / 4 + diademLength * 1.5 / 6) * drawScale, diademLength * 0.4 * drawScale);
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

    }
	
}