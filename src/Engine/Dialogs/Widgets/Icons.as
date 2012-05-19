package Engine.Dialogs.Widgets {
	
    import flash.display.*;

    public final class Icons {

	public static function Space(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.beginFill(c, a);
	    spr.graphics.lineStyle(0, 0, 0);
	    spr.graphics.drawCircle(x, y, t);
	    spr.graphics.endFill();
	}

	public static function Water(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    spr.graphics.drawCircle(x, y, r * 0.9);
	}

	public static function Earth(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var a:Number = r * 0.8;
	    spr.graphics.drawRect(x - a, y - a, a * 2, a * 2);
	}

	public static function Fire(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var a:Number = r * 0.9;
	    spr.graphics.moveTo(x, y - a);
	    spr.graphics.lineTo(x + a * Math.sin(Math.PI/3), y + a * Math.sin(Math.PI/3));
	    spr.graphics.lineTo(x - a * Math.sin(Math.PI/3), y + a * Math.sin(Math.PI/3));
	    spr.graphics.lineTo(x, y - a);
	}

	public static function Air(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var a:Number = r * 0.8;
	    spr.graphics.moveTo(x - a, y - a * 0.8);
	    spr.graphics.curveTo(x - a, y + a * 0.8, x, y + a * 0.8);
	    spr.graphics.curveTo(x + a, y + a * 0.8, x + a, y - a * 0.8);
	    spr.graphics.curveTo(x, y + a * 0.8, x - a, y - a * 0.8);
	}

	public static function Karma(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(0, 0, 0);
	    spr.graphics.beginFill(0xffffff, a);
	    spr.graphics.moveTo(x, y - r);
	    spr.graphics.curveTo(x + r * 2, y, x, y + r);
	    spr.graphics.curveTo(x - r * 2 / 2, y + r/2, x, y);
	    spr.graphics.curveTo(x + r * 2 / 2, y - r/2, x, y - r);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(x, y + r);
	    spr.graphics.curveTo(x - r * 2, y, x, y - r);
	    spr.graphics.curveTo(x + r * 2 / 2, y - r/2, x, y);
	    spr.graphics.curveTo(x - r * 2 / 2, y + r/2, x, y + r);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(c, a);
	    spr.graphics.drawCircle(x, y + r/2, t/2);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(0xffffff, a);
	    spr.graphics.drawCircle(x, y - r/2, t/2);
	    spr.graphics.endFill();
	    
	}

	public static function KarmaInversed(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(0, 0, 0);
	    spr.graphics.beginFill(0x000000, a);
	    spr.graphics.moveTo(x, y - r);
	    spr.graphics.curveTo(x + r * 2, y, x, y + r);
	    spr.graphics.curveTo(x - r * 2 / 2, y + r/2, x, y);
	    spr.graphics.curveTo(x + r * 2 / 2, y - r/2, x, y - r);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(x, y + r);
	    spr.graphics.curveTo(x - r * 2, y, x, y - r);
	    spr.graphics.curveTo(x + r * 2 / 2, y - r/2, x, y);
	    spr.graphics.curveTo(x - r * 2 / 2, y + r/2, x, y + r);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(c, a);
	    spr.graphics.drawCircle(x, y + r/2, t/2);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(0x000000, a);
	    spr.graphics.drawCircle(x, y - r/2, t/2);
	    spr.graphics.endFill();
	    
	}

	public static function Pain(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(0, 0, 0);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(x + r/2, y - r);
	    spr.graphics.lineTo(x - r/4, y - r);
	    spr.graphics.lineTo(x - r, y);
	    spr.graphics.lineTo(x - r/4, y);
	    spr.graphics.lineTo(x - r, y + r);
	    spr.graphics.lineTo(x + r, y - r/4);
	    spr.graphics.lineTo(x, y - r/4);
	    spr.graphics.lineTo(x + r/2, y - r);
	    spr.graphics.endFill();
	}

	public static function Pleasure(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(0, 0, 0);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.moveTo(x - r * 3/4, y - r * 1/4);
	    spr.graphics.curveTo(x - r * 3/8, y - r, x, y);
	    spr.graphics.curveTo(x + r * 3/8, y - r, x + r * 3/4, y - r * 1/4);
	    spr.graphics.lineTo(x, y + r)
	    spr.graphics.lineTo(x - r * 3/4, y - r * 1/4);
	    spr.graphics.endFill();
	}

	public static function Experience(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var ra:Number = r * 0.7;
	    spr.graphics.beginFill(c, a);
	    spr.graphics.drawRect(x - ra, y - 0.25, ra * 2, 0.5);
	    spr.graphics.drawRect(x - 0.25, y - ra, 0.5, ra * 2);
	    spr.graphics.endFill();
	}

   }
	
}