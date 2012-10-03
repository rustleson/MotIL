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
    import flash.display.*;
    import flash.events.EventDispatcher;	
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.text.*;
    import Engine.Stats.*;
    
    use namespace b2internal;
	
    public class WorldObject extends EventDispatcher {
		
	public var bodies:Object;
	public var bodiesOrder:Array;
	public var joints:Object;
	public var gain:Number;
	public var targetAngles:Object;
	public var timeout:int;
	public var defaultTimeout:int;
	public var motorTorture:int;
	private var _color:uint;
	private var _alpha:Number;
	public var sprite:Sprite;
	public var wasUpdated:Boolean;
	[Embed(source="/Assets/NeostandardExtended.ttf", fontFamily="Tiny", embedAsCFF = "false", advancedAntiAliasing = "true")]
	public static const TINY_FONT:String;

	public function WorldObject() {

	    gain = 1;
	    defaultTimeout = 30;
	    motorTorture = 50;
	    timeout = 0;
	    bodies = new Object();
	    joints = new Object();
	    targetAngles = new Object();
	    bodiesOrder = new Array();
	    _color = 0xffffff;
	    _alpha = 0.5;
	    sprite = new Sprite();
	    sprite.blendMode = BlendMode.NORMAL;
	    sprite.alpha = 1;
	    wasUpdated = true;
	}

	public function toggleMotors(onoff:Boolean):void {
	    if (Input.getKeyHold(88) <= 0) {
		for (var joint:Object in joints) {
		    if (targetAngles.hasOwnProperty(joint))
			joints[joint].EnableMotor(onoff);
		}		    
	    }
	}
		
	public function update():void{
	    if (timeout > 0 || Input.getKeyHold(88) <= 0) {
		for (var joint:Object in joints) {
		    if (targetAngles.hasOwnProperty(joint))
			joints[joint].SetMotorSpeed(-gain * (joints[joint].GetJointAngle() - targetAngles[joint]));
		}	         
		timeout--;
		if (timeout <= 0) {
		    toggleMotors(false);
		}
	    }
	}

	public function draw(viewport:b2AABB, physScale:Number, forceRedraw:Boolean = false, stats:ProtagonistStats = null):Sprite{
	    var xf:b2Transform;
	    if (this.wasUpdated) {
		forceRedraw = true;
		this.wasUpdated = false;
	    }
	    if (forceRedraw)
		while(sprite.numChildren > 0) {   
		    sprite.removeChildAt(0); 
		}
	    //var needRedraw:Boolean = sprite.numChildren == 0 ? true : false;
	    //if (needRedraw) sprite.graphics.clear();
	    for each (var bodyname:String in bodiesOrder) {
		var body:b2Body = bodies[bodyname];
		xf = body.m_xf;
		var udata:Object = body.GetUserData();
		for (var f:b2Fixture = body.GetFixtureList(); f != null; f = f.GetNext()){
		    if (viewport.TestOverlap(f.GetAABB())) {
			var bodyPosition:b2Vec2 = body.GetPosition();
			var bodyRotation:Number = body.GetAngle();
			var matrix:Matrix = new Matrix(); 
			if (!body.sprite || forceRedraw || udata.hasOwnProperty('slot') && !udata.slot.isFree || udata.hasOwnProperty('alwaysUpdate') || udata.hasOwnProperty('slot') && udata.slot.type == Slot.FATHER) {
			    if (!body.sprite)
				body.sprite = new Sprite();
			    var drawingFunction:Function = body.drawingFunction as Function ? body.drawingFunction as Function : this.drawGenericShape;
			    if (udata.hasOwnProperty('slot') && udata.slot.type == Slot.FATHER && udata.slot.connectedSlot != null) {
				body.sprite.graphics.clear();
			    } else {
				drawingFunction(f.GetShape(), xf, color, physScale, bodyPosition.x - xf.position.x, bodyPosition.y - xf.position.y, udata, body.sprite);
				if (udata.hasOwnProperty('slot') && udata.slot.type == Slot.FATHER) {
				    drawSafetyIndicator(body.sprite, physScale, udata, stats);
				}
				if (udata.hasOwnProperty('slot')) {
				    if (udata.slot.type == Slot.MOTHER && udata.slot.connectedSlot != null) {
					var spr:Sprite;
					var maskSprite:Sprite;
					if (body.sprite.numChildren == 0) {
					    spr = new Sprite();
					    body.sprite.addChild(spr);
					    maskSprite = new Sprite();
					    spr.addChild(maskSprite);
					} else {
					    spr = body.sprite.getChildAt(0) as Sprite;
					    maskSprite = spr.getChildAt(0) as Sprite;
					}
					spr.blendMode = BlendMode.LAYER;
					maskSprite.blendMode = BlendMode.ERASE;
					drawingFunction = udata.slot.connectedSlot.body.drawingFunction as Function ? udata.slot.connectedSlot.body.drawingFunction as Function : this.drawGenericShape;
				    
					drawingFunction(udata.slot.connectedSlot.body.GetFixtureList().GetShape(), udata.slot.connectedSlot.body.m_xf, color, physScale, udata.slot.connectedSlot.body.GetPosition().x - udata.slot.connectedSlot.body.m_xf.position.x, udata.slot.connectedSlot.body.GetPosition().y - udata.slot.connectedSlot.body.m_xf.position.y, udata.slot.connectedSlot.body.GetUserData(), spr);
					matrix = new Matrix();
					matrix.rotate(udata.slot.connectedSlot.body.GetAngle());
					matrix.tx = (-bodyPosition.x + udata.slot.connectedSlot.body.GetPosition().x) * physScale;
					matrix.ty = (-bodyPosition.y + udata.slot.connectedSlot.body.GetPosition().y) * physScale;
					matrix.rotate(-bodyRotation);
					spr.transform.matrix = matrix;
					var buildSlotMask:Function = udata.slot.body.GetUserData().hasOwnProperty("buildSlotMask") ? udata.slot.body.GetUserData().buildSlotMask : this.buildGenericSlotMask;
					buildSlotMask(maskSprite, body, physScale);
					matrix = new Matrix();
					matrix.rotate(bodyRotation);
					matrix.tx = -(-bodyPosition.x + udata.slot.connectedSlot.body.GetPosition().x) * physScale;
					matrix.ty = -(-bodyPosition.y + udata.slot.connectedSlot.body.GetPosition().y) * physScale;
					matrix.rotate(-udata.slot.connectedSlot.body.GetAngle());
					maskSprite.transform.matrix = matrix;
				    } else {
					while (body.sprite.numChildren > 0) {
					    body.sprite.removeChildAt(0);
					}
				    }
				}
			    }
			}
			if (!sprite.contains(body.sprite)) {
			    sprite.addChild(body.sprite);
			}
			body.sprite.rotation = 0;
			matrix = new Matrix();
			matrix.rotate(bodyRotation);
			matrix.tx = (bodyPosition.x - viewport.lowerBound.x) * physScale;
			matrix.ty = (bodyPosition.y - viewport.lowerBound.y) * physScale;
			body.sprite.transform.matrix = matrix;
		    } else if (body.sprite && sprite.contains(body.sprite)) {
			sprite.removeChild(body.sprite);
			body.sprite = null;
		    }
		}
	    }
	    sprite.alpha = alpha;
	    return sprite;
	}

        public function drawGenericShape(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void{
               
	    var gradMatrix:Matrix = new Matrix();
	    spr.graphics.clear();
	    switch (shape.m_type) {
	    case b2Shape.e_circleShape:
		{
		    var circle:b2CircleShape = (shape as b2CircleShape);
		    
		    var center:b2Vec2 = circle.m_p;
		    var radius:Number = circle.m_radius;
		    var axis:b2Vec2 = xf.R.col1;
                    
		    spr.graphics.lineStyle(1, c, 0);
		    spr.graphics.moveTo(0,0);
		    gradMatrix.createGradientBox(radius * drawScale * 2, radius * drawScale * 2, udata.gradientRot, (center.x - radius - dx) * drawScale, (center.y - radius - dy) * drawScale);
		    spr.graphics.beginGradientFill(udata.gradientType, udata.gradientColors, udata.gradientAlphas, udata.gradientRatios, gradMatrix);
		    spr.graphics.drawCircle((center.x - dx) * drawScale, (center.y - dy) * drawScale, radius * drawScale);
		    spr.graphics.endFill();
		}
		break;
                
	    case b2Shape.e_polygonShape:
		{
		    var i:int;
		    var poly:b2PolygonShape = (shape as b2PolygonShape);
		    var vertexCount:int = poly.GetVertexCount();
			
		    var orig_vertices:Vector.<b2Vec2> = poly.GetVertices();
		    var vertices:Vector.<b2Vec2> = new Vector.<b2Vec2>(vertexCount);
		    if (udata.curved) {
			for (i = 0; i < vertexCount; i++){
			    vertices[i] = new b2Vec2(orig_vertices[i].x * udata.curveAdjust, orig_vertices[i].y * udata.curveAdjust);
			}
		    } else {
			vertices = orig_vertices;
		    }
		    
		    var localBounds:b2AABB = new b2AABB();
		    var auraBounds:b2AABB = new b2AABB();
		    localBounds.lowerBound = new b2Vec2(vertices[0].x, vertices[0].y);
		    localBounds.upperBound = new b2Vec2(vertices[0].x, vertices[0].y);
		    for (i = 1; i < vertexCount; i++){
			if (vertices[i].x < localBounds.lowerBound.x) localBounds.lowerBound.x = vertices[i].x;
			if (vertices[i].y < localBounds.lowerBound.y) localBounds.lowerBound.y = vertices[i].y;
			if (vertices[i].x > localBounds.upperBound.x) localBounds.upperBound.x = vertices[i].x;
			if (vertices[i].y > localBounds.upperBound.y) localBounds.upperBound.y = vertices[i].y;
		    }
		    if (udata.hasOwnProperty('auraIntencity') && udata.auraIntencity) {
			auraBounds.lowerBound.x = localBounds.lowerBound.x - drawScale * 0.01;
			auraBounds.lowerBound.y = localBounds.lowerBound.y - drawScale * 0.01;
			auraBounds.upperBound.x = localBounds.upperBound.x + drawScale * 0.01;
			auraBounds.upperBound.y = localBounds.upperBound.y + drawScale * 0.01;
			spr.graphics.lineStyle(1, c, 0);
			gradMatrix.createGradientBox((auraBounds.upperBound.x - auraBounds.lowerBound.x) * drawScale, (auraBounds.upperBound.y - auraBounds.lowerBound.y) * drawScale, 0, (auraBounds.lowerBound.x - dx) * drawScale, (auraBounds.lowerBound.y - dy) * drawScale);
			spr.graphics.beginGradientFill(GradientType.RADIAL, [0, udata.auraColor, udata.auraColor, udata.auraColor], [0, udata.auraIntencity/10, udata.auraIntencity/7, 0], [0x00, 0xbb, 0xdd, 0xff], gradMatrix);
			spr.graphics.drawRect((auraBounds.lowerBound.x - dx) * drawScale, (auraBounds.lowerBound.y - dy) * drawScale, (auraBounds.upperBound.x - auraBounds.lowerBound.x) * drawScale, (auraBounds.upperBound.y - auraBounds.lowerBound.y) * drawScale);
			spr.graphics.endFill();
		    }
                                        
		    spr.graphics.lineStyle(1, c, 0);
		    if (!udata.curved) {
			spr.graphics.moveTo((vertices[0].x - dx) * drawScale, (vertices[0].y - dy) * drawScale);
		    } else {
			spr.graphics.moveTo(((vertices[vertexCount-1].x + vertices[0].x) / 2 - dx) * drawScale, ((vertices[vertexCount-1].y + vertices[0].y) / 2 - dy) * drawScale);
		    }
		    gradMatrix.createGradientBox((localBounds.upperBound.x - localBounds.lowerBound.x) * drawScale, (localBounds.upperBound.y - localBounds.lowerBound.y) * drawScale, udata.gradientRot, (localBounds.lowerBound.x - dx) * drawScale, (localBounds.lowerBound.y - dy) * drawScale);
		    spr.graphics.beginGradientFill(udata.gradientType, udata.gradientColors, udata.gradientAlphas, udata.gradientRatios, gradMatrix);
		    for (i = 1; i < vertexCount; i++){
			if (!udata.curved) {
			    spr.graphics.lineTo((vertices[i].x - dx) * drawScale, (vertices[i].y - dy) * drawScale);
			} else {
			    spr.graphics.curveTo((vertices[i-1].x - dx) * drawScale, (vertices[i-1].y - dy) * drawScale, ((vertices[i-1].x + vertices[i].x) / 2 - dx) * drawScale, ((vertices[i-1].y + vertices[i].y) / 2 - dy) * drawScale);
			}
		    }
		    if (!udata.curved) {
			spr.graphics.lineTo((vertices[0].x - dx) * drawScale, (vertices[0].y - dy) * drawScale);
		    } else {
			spr.graphics.curveTo((vertices[i-1].x - dx) * drawScale, (vertices[i-1].y - dy) * drawScale, ((vertices[vertexCount-1].x + vertices[0].x) / 2 - dx) * drawScale, ((vertices[vertexCount-1].y + vertices[0].y) / 2 - dy) * drawScale);
		    }
		    spr.graphics.endFill();

		}
		break;                  
                                
	    case b2Shape.e_edgeShape:
		{
		    var edge: b2EdgeShape = shape as b2EdgeShape;
		    
		    var p1:b2Vec2 = b2Math.MulX(xf, edge.GetVertex1());
		    var p2:b2Vec2 = b2Math.MulX(xf, edge.GetVertex2());
		    spr.graphics.lineStyle(1, c, alpha);
		    spr.graphics.moveTo((p1.x - dx) * drawScale, (p1.y - dy) * drawScale);
		    spr.graphics.lineTo((p2.x - dx) * drawScale, (p2.y - dy) * drawScale);
                    
		}               
		break;
	    }                               

	    //return spr;

        }

	public function drawSafetyIndicator(spr:Sprite, drawScale:Number, udata:Object, stats:ProtagonistStats):void {
	    var scalingFactor:Number = 30;
	    var maxRadius:Number = udata.slot.getMaxDiameter();
	    var maxLength:Number = udata.slot.depth;
            var vaginaPain:Number = Math.max(0, stats.vaginaSlot.getPainD(udata.slot.getDiameter(stats.vaginaSlot.stretchedLength.valueFrac)) * stats.pain.incRate * scalingFactor);
            var vaginaSafety:Number = Math.min(1, vaginaPain / stats.maxPain.value);
            var vaginaSafetyColor:uint = (Math.round(Math.min(0.5, vaginaSafety) * 2 * 0xff) << 16) + (Math.round((1 - (Math.max(0.5, vaginaSafety) - 0.5) * 2) * 0xff) << 8);
            var mouthPain:Number = Math.max(0, stats.mouthSlot.getPainD(udata.slot.getDiameter(stats.mouthSlot.stretchedLength.valueFrac)) * stats.pain.incRate * scalingFactor);
            var mouthSafety:Number = Math.min(1, mouthPain / stats.maxPain.value);
            var mouthSafetyColor:uint = (Math.round(Math.min(0.5, mouthSafety) * 2 * 0xff) << 16) + (Math.round((1 - (Math.max(0.5, mouthSafety) - 0.5) * 2) * 0xff) << 8);
            var anusPain:Number = Math.max(0, stats.anusSlot.getPainD(udata.slot.getDiameter(stats.anusSlot.stretchedLength.valueFrac)) * stats.pain.incRate * scalingFactor);
            var anusSafety:Number = Math.min(1, anusPain / stats.maxPain.value);
            var anusSafetyColor:uint = (Math.round(Math.min(0.5, anusSafety) * 2 * 0xff) << 16) + (Math.round((1 - (Math.max(0.5, anusSafety) - 0.5) * 2) * 0xff) << 8);
	    spr.graphics.lineStyle(2, 0xcccccc, 0.8);
	    spr.graphics.beginFill(0x000000, 0.8);
	    var indX:Number = Math.round(maxRadius * drawScale + 2);
	    var indY:Number = Math.round(-maxLength * drawScale);
	    spr.graphics.drawRoundRect(indX, indY, 12, 10, 3, 3);
	    spr.graphics.endFill();
	    spr.graphics.lineStyle(2, mouthSafetyColor, 0.8);
	    spr.graphics.moveTo(indX + 3, indY + 3);
	    spr.graphics.lineTo(indX + 3, indY + 7);
	    spr.graphics.lineStyle(2, vaginaSafetyColor, 0.8);
	    spr.graphics.moveTo(indX + 6, indY + 3);
	    spr.graphics.lineTo(indX + 6, indY + 7);
	    spr.graphics.lineStyle(2, anusSafetyColor, 0.8);
	    spr.graphics.moveTo(indX + 9, indY + 3);
	    spr.graphics.lineTo(indX + 9, indY + 7);
	    var titleText:TextField = new TextField();
	    titleText.text = udata.title;
	    //titleText.width = 150;
	    titleText.selectable = false;
	    titleText.embedFonts = true;
	    titleText.wordWrap = true;
	    titleText.width = 1000;
	    var titleFormat:TextFormat = new TextFormat("Tiny", 8, 0xdddddd);
	    titleFormat.align = TextFieldAutoSize.LEFT;	    
	    titleText.setTextFormat(titleFormat);
	    spr.graphics.lineStyle(0, 0, 0);
	    spr.graphics.beginFill(0x000000, 0.8);
	    spr.graphics.drawRoundRect(indX + 15, indY, titleText.textWidth + 10, 10, 3, 3);
	    spr.graphics.endFill();
	    var textBitmap:BitmapData = new BitmapData(titleText.textWidth + 10, 15, true, 0x000000ff);
	    textBitmap.draw(titleText);
	    var matrix:Matrix = new Matrix();
	    matrix.translate(15 + indX, -5 + indY % 15);
	    spr.graphics.beginBitmapFill(textBitmap, matrix.clone(), true);
	    spr.graphics.drawRect(indX + 15, indY, titleText.textWidth + 10, 10);
	    spr.graphics.endFill();
	}


	public function buildGenericSlotMask(maskSprite:Sprite, body:b2Body, drawScale:Number):void {
	    maskSprite.graphics.clear();
	    var slot:Slot = body.GetUserData().slot;
	    var depth:Number = slot.joint.GetJointTranslation() * drawScale;
	    var thickness:Number = slot.connectedSlot.getMaxDiameter() * 1.1 * 1.5 * drawScale;
	    maskSprite.graphics.beginFill(0xffffff, 1);
	    //maskSprite.graphics.drawRect(-thickness / 2, 0, thickness,  depth);
	    maskSprite.graphics.moveTo(-thickness * 3.5 / 2, -depth);
	    maskSprite.graphics.curveTo(-thickness * 2 / 2, 0, -thickness / 2, 0);
	    maskSprite.graphics.lineTo(thickness / 2, 0);
	    maskSprite.graphics.curveTo(thickness * 2 / 2, 0, thickness * 3.5 / 2, -depth);
	    maskSprite.graphics.lineTo(thickness * 3.5 / 2, depth);
	    maskSprite.graphics.lineTo(-thickness * 3.5 / 2, depth);
	    maskSprite.graphics.lineTo(-thickness * 3.5 / 2, 0);
	    maskSprite.graphics.endFill();
	}

	public function set color(c:uint):void {
	    this._color = c;
	}

	public function set alpha(a:Number):void {
	    this._alpha = a;
	}

	public function get color():uint {
	    return this._color;
	}

	public function get alpha():Number {
	    return this._alpha;
	}

	public function clearStuff():void {
	    this.sprite.graphics.clear();
	    while(sprite.numChildren > 0) {   
		sprite.removeChildAt(0); 
	    }
	    if (this.bodiesOrder.length > 0) {
		var world:b2World = this.bodies[this.bodiesOrder[0]].GetWorld();
		for each(var joint:b2Joint in this.joints) {
		    world.DestroyJoint(joint);
		}
		for each(var body:b2Body in this.bodies) {
		    world.DestroyBody(body);
		}
	    }
	}

    }
	
}