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
	    for each (var joint:Object in joints) {
		joint.EnableMotor(onoff);
	    }		    
	}
		
	public function update():void{
	    if (timeout > 0) {
		for (var joint:Object in joints) {
		    joints[joint].SetMotorSpeed(-gain * (joints[joint].GetJointAngle() - targetAngles[joint]));;
		}	         
		timeout--;
		if (timeout == 0) {
		    toggleMotors(false);
		}
	    }
	}

	public function draw(viewport:b2AABB, physScale:Number, forceRedraw:Boolean = false):Sprite{
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
			if (!body.sprite || forceRedraw || udata.hasOwnProperty('slot') && !udata.slot.isFree) {
			    if (!body.sprite)
				body.sprite = new Sprite();
			    var drawingFunction:Function = body.drawingFunction as Function ? body.drawingFunction as Function : this.drawGenericShape;
			    drawingFunction(f.GetShape(), xf, color, physScale, bodyPosition.x - xf.position.x, bodyPosition.y - xf.position.y, udata, body.sprite);
			}
			if (!sprite.contains(body.sprite)) {
			    sprite.addChild(body.sprite);
			}
			var bodyRotation:Number = body.GetAngle();
			var matrix:Matrix = new Matrix(); 
			body.sprite.rotation = 0;
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
			auraBounds.lowerBound.x = localBounds.lowerBound.x - drawScale * udata.auraIntencity * 0.01;
			auraBounds.lowerBound.y = localBounds.lowerBound.y - drawScale * udata.auraIntencity * 0.01;
			auraBounds.upperBound.x = localBounds.upperBound.x + drawScale * udata.auraIntencity * 0.01;
			auraBounds.upperBound.y = localBounds.upperBound.y + drawScale * udata.auraIntencity * 0.01;
			spr.graphics.lineStyle(1, c, 0);
			gradMatrix.createGradientBox((auraBounds.upperBound.x - auraBounds.lowerBound.x) * drawScale, (auraBounds.upperBound.y - auraBounds.lowerBound.y) * drawScale, 0, (auraBounds.lowerBound.x - dx) * drawScale, (auraBounds.lowerBound.y - dy) * drawScale);
			spr.graphics.beginGradientFill(GradientType.RADIAL, [udata.auraColor, udata.auraColor], [0.9, 0], [0x00, 0xff], gradMatrix);
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


    }
	
}