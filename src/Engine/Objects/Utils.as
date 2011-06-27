package Engine.Objects {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import General.Input;
    
	
	
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

   }
	
}