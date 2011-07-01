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

   }
	
}