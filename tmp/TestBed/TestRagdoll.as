/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/


package TestBed{
	
	
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import General.Input;
	
	
	
	public class TestRagdoll extends Test{
		
		public function TestRagdoll(){
			
			// Set Text field
			Main.m_aboutText.text = "Ragdolls";
			m_world.SetGravity(new b2Vec2(0, 2.0));
			gain = 3;
			defaultTimeout = 30;
			motorTorture = 50;
			timeout = defaultTimeout;
			targetAngles = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			
			var circ:b2CircleShape; 
			var box:b2PolygonShape;
			var bd:b2BodyDef = new b2BodyDef();
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.filter.categoryBits = 0x0002;
			fixtureDef.filter.maskBits = 0x0005;
			
			// Add 5 ragdolls along the top
			for (var i:int = 0; i < 1; i++){
			    var startX:Number = 70;// + Math.random() * 20 + 480 * i;
			    var startY:Number = 20;// + Math.random() * 50;
				
				// BODIES
				// Set these to dynamic bodies
				bd.type = b2Body.b2_dynamicBody;
				
				// Head
				circ = new b2CircleShape( 12.5 / m_physScale );
				fixtureDef.shape = circ;
				fixtureDef.density = 0.01;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.3;
				bd.position.Set(startX / m_physScale, startY / m_physScale);
				var head:b2Body = m_world.CreateBody(bd);
				head.CreateFixture(fixtureDef);
				//if (i == 0){
					head.ApplyImpulse(new b2Vec2(Math.random() * 100 - 50, Math.random() * 100 - 50), head.GetWorldCenter());
				//}
				
				// Torso1
				box = new b2PolygonShape();
				box.SetAsBox(15 / m_physScale, 10 / m_physScale);
				fixtureDef.shape = box;
				fixtureDef.density = 0.01;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				bd.position.Set(startX / m_physScale, (startY + 28) / m_physScale);
				var torso1:b2Body = m_world.CreateBody(bd);
				torso1.CreateFixture(fixtureDef);
				// Torso2
				box = new b2PolygonShape();
				box.SetAsBox(8 / m_physScale, 10 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set(startX / m_physScale, (startY + 43) / m_physScale);
				var torso2:b2Body = m_world.CreateBody(bd);
				torso2.CreateFixture(fixtureDef);
				// Torso3
				box.SetAsBox(15 / m_physScale, 10 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set(startX / m_physScale, (startY + 58) / m_physScale);
				var torso3:b2Body = m_world.CreateBody(bd);
				torso3.CreateFixture(fixtureDef);
				
				// UpperArm
				fixtureDef.density = 0.01;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				// L
				box = new b2PolygonShape();
				box.SetAsBox(18 / m_physScale, 6.5 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((startX - 30) / m_physScale, (startY + 20) / m_physScale);
				var upperArmL:b2Body = m_world.CreateBody(bd);
				upperArmL.CreateFixture(fixtureDef);
				// R
				box = new b2PolygonShape();
				box.SetAsBox(18 / m_physScale, 6.5 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((startX + 30) / m_physScale, (startY + 20) / m_physScale);
				var upperArmR:b2Body = m_world.CreateBody(bd);
				upperArmR.CreateFixture(fixtureDef);
				
				// LowerArm
				fixtureDef.density = 0.01;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				// L
				box = new b2PolygonShape();
				box.SetAsBox(17 / m_physScale, 6 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((startX - 57) / m_physScale, (startY + 20) / m_physScale);
				var lowerArmL:b2Body = m_world.CreateBody(bd);
				lowerArmL.CreateFixture(fixtureDef);
				// R
				box = new b2PolygonShape();
				box.SetAsBox(17 / m_physScale, 6 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((startX + 57) / m_physScale, (startY + 20) / m_physScale);
				var lowerArmR:b2Body = m_world.CreateBody(bd);
				lowerArmR.CreateFixture(fixtureDef);
				
				// UpperLeg
				fixtureDef.density = 0.01;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				// L
				box = new b2PolygonShape();
				box.SetAsBox(7.5 / m_physScale, 22 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((startX - 8) / m_physScale, (startY + 85) / m_physScale);
				var upperLegL:b2Body = m_world.CreateBody(bd);
				upperLegL.CreateFixture(fixtureDef);
				// R
				box = new b2PolygonShape();
				box.SetAsBox(7.5 / m_physScale, 22 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((startX + 8) / m_physScale, (startY + 85) / m_physScale);
				var upperLegR:b2Body = m_world.CreateBody(bd);
				upperLegR.CreateFixture(fixtureDef);
				
				// LowerLeg
				fixtureDef.density = 0.01;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				// L
				box = new b2PolygonShape();
				box.SetAsBox(6 / m_physScale, 30 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((startX - 8) / m_physScale, (startY + 130) / m_physScale);
				var lowerLegL:b2Body = m_world.CreateBody(bd);
				lowerLegL.CreateFixture(fixtureDef);
				// R
				box = new b2PolygonShape();
				box.SetAsBox(6 / m_physScale, 30 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((startX + 8) / m_physScale, (startY + 130) / m_physScale);
				var lowerLegR:b2Body = m_world.CreateBody(bd);
				lowerLegR.CreateFixture(fixtureDef);
				
				
				// JOINTS
				jd.enableLimit = true;
				jd.enableMotor = true;
				jd.collideConnected = false;
				jd.motorSpeed = 0;
				jd.maxMotorTorque = motorTorture;
				// Head to shoulders
				jd.lowerAngle = -40 / (180/Math.PI);
				jd.upperAngle = 40 / (180/Math.PI);
				jd.Initialize(torso1, head, new b2Vec2(startX / m_physScale, (startY + 15) / m_physScale));
				jointHead = m_world.CreateJoint(jd) as b2RevoluteJoint;
				
				// Upper arm to shoulders
				// L
				jd.lowerAngle = -85 / (180/Math.PI);
				jd.upperAngle = 130 / (180/Math.PI);
				jd.Initialize(torso1, upperArmL, new b2Vec2((startX - 18) / m_physScale, (startY + 20) / m_physScale));
				jointUpperArmL = m_world.CreateJoint(jd) as b2RevoluteJoint;
				// R
				jd.lowerAngle = -130 / (180/Math.PI);
				jd.upperAngle = 85 / (180/Math.PI);
				jd.Initialize(torso1, upperArmR, new b2Vec2((startX + 18) / m_physScale, (startY + 20) / m_physScale));
				jointUpperArmR = m_world.CreateJoint(jd) as b2RevoluteJoint;
				
				// Lower arm to upper arm
				// L
				jd.lowerAngle = -130 / (180/Math.PI);
				jd.upperAngle = 10 / (180/Math.PI);
				jd.Initialize(upperArmL, lowerArmL, new b2Vec2((startX - 45) / m_physScale, (startY + 20) / m_physScale));
				jointLowerArmL = m_world.CreateJoint(jd) as b2RevoluteJoint;
				// R
				jd.lowerAngle = -10 / (180/Math.PI);
				jd.upperAngle = 130 / (180/Math.PI);
				jd.Initialize(upperArmR, lowerArmR, new b2Vec2((startX + 45) / m_physScale, (startY + 20) / m_physScale));
				jointLowerArmR = m_world.CreateJoint(jd) as b2RevoluteJoint;
				
				// Shoulders/stomach
				jd.enableMotor = false;
				jd.lowerAngle = -30 / (180/Math.PI);
				jd.upperAngle = 30 / (180/Math.PI);
				jd.Initialize(torso1, torso2, new b2Vec2(startX / m_physScale, (startY + 35) / m_physScale));
				jointStomach = m_world.CreateJoint(jd) as b2RevoluteJoint;
				// Stomach/hips
				jd.Initialize(torso2, torso3, new b2Vec2(startX / m_physScale, (startY + 50) / m_physScale));
				jointHips = m_world.CreateJoint(jd) as b2RevoluteJoint;
				
				// Torso to upper leg
				// L
				jd.enableMotor = true;
				jd.lowerAngle = -25 / (180/Math.PI);
				jd.upperAngle = 125 / (180/Math.PI);
				jd.Initialize(torso3, upperLegL, new b2Vec2((startX - 8) / m_physScale, (startY + 72) / m_physScale));
				jointUpperLegL = m_world.CreateJoint(jd) as b2RevoluteJoint;
				// R
				jd.lowerAngle = -125 / (180/Math.PI);
				jd.upperAngle = 25 / (180/Math.PI);
				jd.Initialize(torso3, upperLegR, new b2Vec2((startX + 8) / m_physScale, (startY + 72) / m_physScale));
				jointUpperLegR = m_world.CreateJoint(jd) as b2RevoluteJoint;
				
				// Upper leg to lower leg
				// L
				jd.lowerAngle = -115 / (180/Math.PI);
				jd.upperAngle = 115 / (180/Math.PI);
				jd.Initialize(upperLegL, lowerLegL, new b2Vec2((startX - 8) / m_physScale, (startY + 105) / m_physScale));
				jointLowerLegL = m_world.CreateJoint(jd) as b2RevoluteJoint;
				// R
				jd.lowerAngle = -115 / (180/Math.PI);
				jd.upperAngle = 115 / (180/Math.PI);
				jd.Initialize(upperLegR, lowerLegR, new b2Vec2((startX + 8) / m_physScale, (startY + 105) / m_physScale));
				jointLowerLegR = m_world.CreateJoint(jd) as b2RevoluteJoint;
				
			}
			
			
			// Add stairs on the left, these are static bodies so set the type accordingly
			bd.type = b2Body.b2_staticBody;
			fixtureDef.density = 0.0;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.3;
			fixtureDef.filter.categoryBits = 0x0004;
			fixtureDef.filter.maskBits = 0x0002;
			for (var j:int = 1; j <= 10; j++) {
				box = new b2PolygonShape();
				box.SetAsBox((10*j) / m_physScale, 10 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((10*j) / m_physScale, (150 + 20*j) / m_physScale);
				head = m_world.CreateBody(bd);
				head.CreateFixture(fixtureDef);
			}
			
			// Add stairs on the right
			for (var k:int = 1; k <= 10; k++){
				box = new b2PolygonShape();
				box.SetAsBox((10 * k) / m_physScale, 10 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((640-10*k) / m_physScale, (150 + 20*k) / m_physScale);
				head = m_world.CreateBody(bd);
				head.CreateFixture(fixtureDef);
			}
			
			box = new b2PolygonShape();
			box.SetAsBox(30 / m_physScale, 40 / m_physScale);
			fixtureDef.shape = box;
			bd.position.Set(320 / m_physScale, 320 / m_physScale);
			head = m_world.CreateBody(bd);
			head.CreateFixture(fixtureDef);
			
			
		}
		
	    private function toggleMotors(onoff:Boolean):void {
		    jointHead.EnableMotor(onoff);
		    jointStomach.EnableMotor(onoff);
		    jointHips.EnableMotor(onoff);
		    jointUpperArmL.EnableMotor(onoff);
		    jointUpperArmR.EnableMotor(onoff);
		    jointLowerArmL.EnableMotor(onoff);
		    jointLowerArmR.EnableMotor(onoff);
		    jointUpperLegL.EnableMotor(onoff);
		    jointUpperLegR.EnableMotor(onoff);
		    jointLowerLegL.EnableMotor(onoff);
		    jointLowerLegR.EnableMotor(onoff);
		    
		}
		
		public override function Update():void{
			
			//case 'a':
			if (Input.isKeyPressed(65)){ // A
			    targetAngles = new Array(-10 / (180/Math.PI), 0, 0,
						     45 / (180/Math.PI), 65 / (180/Math.PI), 35 / (180/Math.PI), 120 / (180/Math.PI), 
						     110 / (180/Math.PI), 10 / (180/Math.PI), -115 / (180/Math.PI), 30 / (180/Math.PI));
			    timeout = defaultTimeout;
			    toggleMotors(true);
			}
			//case 's':
			if (Input.isKeyPressed(83)){ // S
			    targetAngles = new Array(0 / (180/Math.PI), 0, 0, 
						     45 / (180/Math.PI), -45 / (180/Math.PI), 35 / (180/Math.PI), -35 / (180/Math.PI), 
						     110 / (180/Math.PI), -110 / (180/Math.PI), -115 / (180/Math.PI), 115 / (180/Math.PI));
			    timeout = defaultTimeout;
			    toggleMotors(true);
			}
			//case 'd':
			if (Input.isKeyPressed(68)){ // D
			    targetAngles = new Array(10 / (180/Math.PI), 0, 0, 
						     -65 / (180/Math.PI), -45 / (180/Math.PI), -120 / (180/Math.PI), -35 / (180/Math.PI), 
						     -10 / (180/Math.PI), -110 / (180/Math.PI), -30 / (180/Math.PI), 115 / (180/Math.PI));
			    timeout = defaultTimeout;
			    toggleMotors(true);
			}
			//case 'w':
			if (Input.isKeyPressed(87)){ // W
			    targetAngles = new Array(-10 / (180/Math.PI), 0, 0, 
						     -65 / (180/Math.PI), 65 / (180/Math.PI), -25 / (180/Math.PI), 25 / (180/Math.PI), 
						     10 / (180/Math.PI), -10 / (180/Math.PI), -10 / (180/Math.PI), 10 / (180/Math.PI));
			    timeout = defaultTimeout;
			    toggleMotors(true);
			}
			//case 'm':
			if (Input.isKeyPressed(77)){ // M
			    toggleMotors(true);
			}
			
			// set joint motor speeds
			jointHead.SetMotorSpeed(-gain * (jointHead.GetJointAngle() - targetAngles[0]));
			jointStomach.SetMotorSpeed(-gain / 3 * (jointStomach.GetJointAngle() - targetAngles[1]));
			jointHips.SetMotorSpeed(-gain / 3 * (jointHips.GetJointAngle() - targetAngles[2]));
			jointUpperArmL.SetMotorSpeed(-gain * (jointUpperArmL.GetJointAngle() - targetAngles[3]));
			jointUpperArmR.SetMotorSpeed(-gain * (jointUpperArmR.GetJointAngle() - targetAngles[4]));
			jointLowerArmL.SetMotorSpeed(-gain * (jointLowerArmL.GetJointAngle() - targetAngles[5]));
			jointLowerArmR.SetMotorSpeed(-gain * (jointLowerArmR.GetJointAngle() - targetAngles[6]));
			jointUpperLegL.SetMotorSpeed(-gain * (jointUpperLegL.GetJointAngle() - targetAngles[7]));
			jointUpperLegR.SetMotorSpeed(-gain * (jointUpperLegR.GetJointAngle() - targetAngles[8]));
			jointLowerLegL.SetMotorSpeed(-gain * (jointLowerLegL.GetJointAngle() - targetAngles[9]));
			jointLowerLegR.SetMotorSpeed(-gain * (jointLowerLegR.GetJointAngle() - targetAngles[10]));
			if (timeout > 0) {
			    timeout--;
			    if (timeout == 0) {
				toggleMotors(false);
			    }
			}
			// Finally update super class
			super.Update();
		}

		//======================
		// Member Data 
		//======================
		private var jointHead:b2RevoluteJoint;
		private var jointUpperArmL:b2RevoluteJoint;
		private var jointUpperArmR:b2RevoluteJoint;
		private var jointLowerArmL:b2RevoluteJoint;
		private var jointLowerArmR:b2RevoluteJoint;
		private var jointStomach:b2RevoluteJoint;
		private var jointHips:b2RevoluteJoint;
		private var jointUpperLegL:b2RevoluteJoint;
		private var jointUpperLegR:b2RevoluteJoint;
		private var jointLowerLegL:b2RevoluteJoint;
		private var jointLowerLegR:b2RevoluteJoint;
		private var gain:Number;
	        private var targetAngles:Array;
		private var timeout:int;
		private var defaultTimeout:int;
		private var motorTorture:int;
	}
	
}