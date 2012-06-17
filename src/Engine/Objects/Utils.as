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
    import flash.geom.Matrix;
    import flash.geom.Point;
    import Engine.Worlds.WorldRoom;
    import Engine.Dialogs.Widgets.Icons;
	
    public final class Utils {

	public static function getBoxVertices(x:Number, y:Number, width:Number, height:Number):Array {
	    var vertices:Array = new Array();
	    vertices[0] = new b2Vec2(x, y);
	    vertices[1] = new b2Vec2(x + width, y);
	    vertices[2] = new b2Vec2(x + width, y + height);
	    vertices[3] = new b2Vec2(x, y + height);
	    return vertices;
	}

	public static function setBoxAttributes(box:b2PolygonShape, bd:b2BodyDef, x:Number, y:Number, width:Number, height:Number):void {
	    box.SetAsBox(width / 2, height / 2);
	    bd.position.Set(width / 2 + x, height / 2 + y);
	}

	public static function HSLtoRGB(hue:Number=0, saturation:Number=0.5, lightness:Number=1):uint {
	    saturation = Math.max(0, Math.min(1, saturation));
	    lightness = Math.max(0, Math.min(1, lightness));
	    hue = hue % 360;
	    if (hue < 0) hue += 360;
	    hue /= 60;
	    var C:Number = (1 - Math.abs(2 * lightness - 1)) * saturation;
	    var X:Number = C * (1 - Math.abs((hue % 2) - 1));
	    var m:Number = lightness - 0.5 * C;
	    C = (C + m) * 255;
	    X = (X + m) * 255;
	    m *= 255;
	    if (hue < 1) return (C << 16) + (X << 8) + m;
	    if (hue < 2) return (X << 16) + (C << 8) + m;
	    if (hue < 3) return (m << 16) + (C << 8) + X;
	    if (hue < 4) return (m << 16) + (X << 8) + C;
	    if (hue < 5) return (X << 16) + (m << 8) + C;
	    return (C << 16) + (m << 8) + X;
	}

	public static function HSLtoRGBA(a:Number=1, hue:Number=0, saturation:Number=0.5, lightness:Number=1):uint {
	    a = Math.max(0, Math.min(1, a));
	    var hsl:uint = HSLtoRGB(hue, saturation, lightness);
	    return (Math.round(a * 255) << 24) + hsl;
	}

	public static function colorLight(c:uint, percent:Number):uint {
	    var r: uint = (c & 0xFF0000) >> 16;
	    var g: uint = (c & 0xFF00) >> 8;
	    var b: uint = c & 0xFF;
	    r += (0xff - r) * percent;
	    g += (0xff - g) * percent;
	    b += (0xff - b) * percent;
            return (r << 16) + (g << 8) + b;
	}

	public static function colorDark(c:uint, percent:Number):uint {
	    var r: uint = (c & 0xFF0000) >> 16;
	    var g: uint = (c & 0xFF00) >> 8;
	    var b: uint = c & 0xFF;
	    r -= (r - 0) * percent;
	    g -= (g - 0) * percent;
	    b -= (b - 0) * percent;
            return (r << 16) + (g << 8) + b;
	}

	public static function multicurve(g: Graphics, args: Array, closed: Boolean): void {                       
                var mid: Array = args.slice();  //make dublicate
                var i: uint;
                var point: Point;
                var nextPoint: Point;
                var numPoints: uint = mid.length;

                if (numPoints == 2) {
                    g.moveTo(mid[0].x, mid[0].y);
                    g.lineTo(mid[1].x, mid[1].y);
                    return;
                }

                var Xpoint: Array = new Array();
                var Ypoint: Array = new Array();
                for (i = 1; i < numPoints - 2; i++) {
		    point = mid[i];
		    nextPoint = mid[i+1];
		    Xpoint[i] = 0.5*(nextPoint.x + point.x);
		    Ypoint[i] = 0.5*(nextPoint.y + point.y);
                }
                if (closed) {
		    Xpoint[0] = 0.5*(mid[1].x + mid[0].x);
		    Ypoint[0] = 0.5*(mid[1].y + mid[0].y);
		    Xpoint[i] = 0.5*(mid[i+1].x + mid[i].x);
		    Ypoint[i] = 0.5*(mid[i+1].y + mid[i].y);
		    Xpoint[i+1] = 0.5*(mid[i+1].x + mid[0].x);
		    Ypoint[i+1] = 0.5*(mid[i+1].y + mid[0].y);
		    mid.push(new Point(mid[0].x, mid[0].y));
		    Xpoint[i+2] = Xpoint[0];
		    Ypoint[i+2] = Ypoint[0];
                } else {
		    Xpoint[0] = mid[0].x;
		    Ypoint[0] = mid[0].y;
		    Xpoint[i] = mid[i+1].x;
		    Ypoint[i] = mid[i+1].y;
		    mid.pop();
		    numPoints--;
                }
                g.moveTo(Xpoint[0], Ypoint[0]);
                for (i = 1; i < numPoints; i++) {
		    point = mid[i];
		    g.curveTo(point.x, point.y, Xpoint[i], Ypoint[i]);
                }
                if (closed) {
		    g.curveTo(mid[0].x, mid[0].y, Xpoint[i], Ypoint[i]);
                }
        }

	public static function buildBackgrounds(type:uint, appWidth:int, appHeight:int):Array {
	    var icons:Object = new Object();
	    icons[WorldRoom.SPACE_TYPE] = Icons.Space;
	    icons[WorldRoom.WATER_TYPE] = Icons.Water;
	    icons[WorldRoom.EARTH_TYPE] = Icons.Earth;
	    icons[WorldRoom.FIRE_TYPE] = Icons.Fire;
	    icons[WorldRoom.AIR_TYPE] = Icons.Air;
	    icons[WorldRoom.CORRUPTION_TYPE] = Icons.Pain;
	    icons[WorldRoom.BALANCE_TYPE] = Icons.KarmaInversed;
	    icons[WorldRoom.PURITY_TYPE] = Icons.Pleasure;
	    var backgrounds:Array = new Array();
	    var i: int;
	    var c:Sprite = new Sprite();
	    c.graphics.clear();
	    var matrix:Matrix = new Matrix();
	    matrix.createGradientBox(appWidth, appHeight, -Math.PI/2, 0, 0);
	    c.graphics.beginGradientFill(GradientType.LINEAR, [colorDark(type, 0.85), colorDark(type, 0.95)], [1, 1], [0x0, 0xff], matrix);
	    c.graphics.drawRect(0, 0, appWidth, appHeight);
	    c.graphics.endFill();
	    backgrounds.push({ratio: 0, bitmap: new BitmapData(appWidth, appHeight, true, 0x00000000)});
	    backgrounds[0].bitmap.draw(c);
	    for (var j:int = 1; j <= 3; j++) {
		c.graphics.clear();
		var r:Number = 5 + (j - 1) * 2.5;
		for (i = 0; i < 15; i++) {
		    icons[type](c, Math.random() * (200 - r * 2) + r, Math.random() * (200 - r * 2) + r, r, colorDark(type, 0.8 - (j - 1) * 0.1), j, 1);
		}
		backgrounds.push({ratio: 1./3 * j, bitmap: new BitmapData(200, 200, true, 0x00000000)});
		backgrounds[j].bitmap.draw(c);
	    }
	    return backgrounds;
	}

  }
	
}