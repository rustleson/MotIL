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
    
    import Box2D.Collision.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import Engine.Objects.WorldObject;

    use namespace b2internal;

    public class Slot {              

	public static const MOTHER:int = 1;
	public static const FATHER:int = 2;
	public static const HOLDER:int = 3;

	public var connectionDistance:Number = 0.4;
	public var connectionAngle:Number = 25 * Math.PI / 180;

	public var type:int;
	public var body:b2Body;
	public var isFree:Boolean = true;
	public var isReady:Boolean = false;
	public var joint:b2PrismaticJoint;
	public var connectedSlot:Slot;
	public var localAnchor:b2Vec2;
	public var depth:Number;
	public var axis:b2Vec2;
	public var sensorFixture:b2Fixture;
	public var radiuses:Array;
	public var owner:WorldObject;

	public function Slot($type:int = MOTHER, $body:b2Body = null):void {
	    this.type = $type;
	    this.body = $body;
	    this.radiuses = [new b2Vec2()];
        }

	public function connect(slot:Slot):Boolean {
	    var world:b2World = this.body.GetWorld();
	    var jd:b2PrismaticJointDef = new b2PrismaticJointDef();
	    var dist:Number = b2Math.Distance(this.body.GetLocalPoint(slot.body.GetWorldPoint(slot.localAnchor)), this.localAnchor);
	    var vectorThis:b2Vec2 = this.body.GetWorldVector(this.axis);
	    var vectorConnected:b2Vec2 = slot.body.GetWorldVector(slot.axis);
	    var angle:Number = Math.acos(b2Math.Dot(this.body.GetWorldVector(this.axis), slot.body.GetWorldVector(slot.axis)));
	    //trace(angle / Math.PI * 180);

	    if (dist < connectionDistance && angle < connectionAngle) {
		this.body.SetAngle(this.body.GetAngle() - angle);
		this.connectedSlot = slot;
		jd.collideConnected = false;
		jd.enableLimit = true;
		var axisAngle:Number = Math.acos(b2Math.Dot(this.axis, this.connectedSlot.axis));
		var bodiesAngle:Number = this.body.GetAngle() - this.connectedSlot.body.GetAngle();
		jd.lowerTranslation = -this.depth;
		jd.upperTranslation = 0;
		jd.bodyA = this.connectedSlot.body;
		jd.bodyB = this.body;
		jd.localAnchorA = this.connectedSlot.localAnchor;
		jd.localAnchorB = this.localAnchor;
		jd.localAxisA = this.connectedSlot.axis;
		jd.referenceAngle = bodiesAngle; //360 * int(180 / Math.PI * this.body.GetAngle() / 360) * Math.PI / 180 + axisAngle;
		this.joint = world.CreateJoint(jd) as b2PrismaticJoint;
		this.connectedSlot.joint = this.joint;
		this.isReady = false;
		this.isFree = false;
		this.connectedSlot.connectedSlot = this;
		this.connectedSlot.isReady = false;
		this.connectedSlot.isFree = false;
		//if (this.sensorFixture) this.sensorFixture.SetSensor(true);
		Main.tenorion.voices[0] = Main.tenorion.presetVoice['valsound.percus6'];
		return true;
	    } else {
		return false;
	    }
	}

	public function disconnect():Boolean {
	    var dist:Number = b2Math.Distance(this.body.GetLocalPoint(this.connectedSlot.body.GetWorldPoint(this.connectedSlot.localAnchor)), this.localAnchor);
	    if (this.joint.GetJointTranslation() > 0) {
		if (this.joint){
		    var world:b2World = this.body.GetWorld();
		    world.DestroyJoint(this.joint);
		}
		this.joint = null;
		this.isReady = true;
		this.isFree = true;
		this.connectedSlot.joint = null;
		this.connectedSlot.body.sprite.graphics.clear();
		this.connectedSlot.body.sprite = null;
		this.connectedSlot.connectedSlot = null;
		this.connectedSlot.isReady = true;
		this.connectedSlot.isFree = true;
		//this.connectedSlot.owner.wasUpdated = true;
		this.owner.wasUpdated = true;
		this.connectedSlot = null;
		//if (this.sensorFixture) this.sensorFixture.SetSensor(false);
		Main.tenorion.voices[0] = Main.tenorion.presetVoice['valsound.percus3'];
		return true;
	    } else {
		return false;
	    }
	}

	public function getDiameter(x:Number):Number {
	    var d:Number = 0;
	    if (this.type == FATHER) {
		var x0:Number = 0;
		var y0:Number = 0;
		for each (var r:b2Vec2 in this.radiuses) {
		    if (x >= x0 && x <= r.x) {
			d = (y0 + ((x - x0) * r.y - (x - x0) * y0) / (r.x - x0))
			break;
		    }
		    x0 = r.x;
		    y0 = r.y;
		    d = y0;
		}
	    }
	    if (x > x0)
		return d;
	    return 0;
	}

	public function getMaxDiameter():Number {
	    return this.radiuses[this.radiuses.length - 1].y;
	}

    }
}