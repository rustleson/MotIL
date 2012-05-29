package Engine.Dialogs.Widgets {
	
    import flash.display.*;
    import Engine.Objects.Utils;

    public final class Icons {

	public static function Empty(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, Utils.colorDark(c, 0.4), a);
	    spr.graphics.moveTo(x - r/2, y);
	    spr.graphics.lineTo(x - r/2, y + r/8);
	    spr.graphics.lineTo(x + r/2, y + r/8);
	    spr.graphics.lineTo(x + r/2, y);
	    spr.graphics.lineStyle(0, 0, 0);
	}

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

	public static function Question(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var ra:Number = r * 0.5;
	    spr.graphics.moveTo(x - ra*0.6, y - ra * 2/4);
	    spr.graphics.curveTo(x - ra*0.6, y - ra, x, y - ra);
	    spr.graphics.curveTo(x + ra*0.6, y - ra, x + ra*0.6, y - ra * 2/4);
	    spr.graphics.curveTo(x + ra*0.6, y + ra * 0/4, x + ra*0.6 / 2, y + ra * 0/4);
	    spr.graphics.curveTo(x, y + ra * 0/4, x, y + ra * 2/4);
	    spr.graphics.lineStyle(0, 0, 0);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.drawCircle(x, y + ra, t/1.5);
	    spr.graphics.endFill();
	}

	public static function Wheel(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var ri:Number = 0.3 * r;
	    var ro:Number = 0.8 * r;
	    spr.graphics.drawCircle(x, y, ro * 0.8);
	    spr.graphics.drawCircle(x, y, ri);
	    spr.graphics.moveTo(x, y + ri);
	    spr.graphics.lineTo(x, y + ro);
	    spr.graphics.moveTo(x, y - ri);
	    spr.graphics.lineTo(x, y - ro);
	    spr.graphics.moveTo(x + ri, y);
	    spr.graphics.lineTo(x + ro, y);
	    spr.graphics.moveTo(x - ri, y);
	    spr.graphics.lineTo(x - ro, y);
	    spr.graphics.moveTo(x - ri/Math.sqrt(2), y - ri/Math.sqrt(2));
	    spr.graphics.lineTo(x - ro/Math.sqrt(2), y - ro/Math.sqrt(2));
	    spr.graphics.moveTo(x + ri/Math.sqrt(2), y + ri/Math.sqrt(2));
	    spr.graphics.lineTo(x + ro/Math.sqrt(2), y + ro/Math.sqrt(2));
	    spr.graphics.moveTo(x - ri/Math.sqrt(2), y + ri/Math.sqrt(2));
	    spr.graphics.lineTo(x - ro/Math.sqrt(2), y + ro/Math.sqrt(2));
	    spr.graphics.moveTo(x + ri/Math.sqrt(2), y - ri/Math.sqrt(2));
	    spr.graphics.lineTo(x + ro/Math.sqrt(2), y - ro/Math.sqrt(2));
	}

	public static function Vajra(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var ri:Number = 0.6 * r;
	    var ro:Number = 0.8 * r;
	    spr.graphics.moveTo(x, y + ro);
	    spr.graphics.lineTo(x, y - ro);
	    spr.graphics.moveTo(x, y);
	    spr.graphics.curveTo(x - r/2, y + ro, x, y + ri);
	    spr.graphics.moveTo(x, y);
	    spr.graphics.curveTo(x + r/2, y + ro, x, y + ri);
	    spr.graphics.moveTo(x, y);
	    spr.graphics.curveTo(x - r/2, y - ro, x, y - ri);
	    spr.graphics.moveTo(x, y);
	    spr.graphics.curveTo(x + r/2, y - ro, x, y - ri);
	    spr.graphics.lineStyle(0, 0, 0);
	    spr.graphics.beginFill(c, a);
	    spr.graphics.drawCircle(x, y, r * 0.2);
	    spr.graphics.drawCircle(x, y + ro, r * 0.1);
	    spr.graphics.drawCircle(x, y - ro, r * 0.1);
	    spr.graphics.endFill();
	}

	public static function Jewel(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var ri:Number = 0.5 * r;
	    var ro:Number = 0.7 * r;
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.moveTo(x - ri, y);
	    spr.graphics.lineTo(x - ri/4, y - ro);
	    spr.graphics.lineTo(x + ri/4, y - ro);
	    spr.graphics.lineTo(x + ri, y);
	    spr.graphics.lineTo(x + ri/4, y + ro);
	    spr.graphics.lineTo(x - ri/4, y + ro);
	    spr.graphics.lineTo(x - ri, y);
	    spr.graphics.lineTo(x + ri, y);
	    spr.graphics.endFill();
	    spr.graphics.lineStyle(t/2, c, a);
	    spr.graphics.moveTo(x, y - ro);
	    spr.graphics.lineTo(x - ri/3, y);
	    spr.graphics.lineTo(x, y + ro);
	    spr.graphics.moveTo(x, y - ro);
	    spr.graphics.lineTo(x + ri/3, y);
	    spr.graphics.lineTo(x, y + ro);
	}

	public static function Lotus(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var ri:Number = 0.5 * r;
	    var ro:Number = 0.7 * r;
	    spr.graphics.moveTo(x, y + ri);
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.curveTo(x - ro/3, y, x, y - ri);
	    spr.graphics.curveTo(x + ro/3, y, x, y + ri);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.moveTo(x, y + ri);
	    spr.graphics.curveTo(x - ro/1.5, y, x - ro/1.5, y - ri*0.7);
	    spr.graphics.curveTo(x, y - ri/1.5, x, y + ri);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.moveTo(x, y + ri);
	    spr.graphics.curveTo(x + ro/1.5, y, x + ro/1.5, y - ri*0.7);
	    spr.graphics.curveTo(x, y - ri/1.5, x, y + ri);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.moveTo(x, y + ri);
	    spr.graphics.curveTo(x - ro/1.5, y + ro, x - ro, y);
	    spr.graphics.curveTo(x, y + ri/3, x, y + ri);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.moveTo(x, y + ri);
	    spr.graphics.curveTo(x + ro/1.5, y + ro, x + ro, y);
	    spr.graphics.curveTo(x, y + ri/3, x, y + ri);
	    spr.graphics.endFill();
	}

	public static function Sword(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(0, 0, 0);
	    var ri:Number = 0.2 * r;
	    var ro:Number = 0.7 * r;
	    spr.graphics.beginFill(c, a);
	    spr.graphics.drawCircle(x, y + ro, t/1.5);
	    spr.graphics.endFill();
	    spr.graphics.lineStyle(t, c, a);
	    spr.graphics.moveTo(x - ri, y + ro*0.6);
	    spr.graphics.lineTo(x + ri, y + ro*0.6);
	    spr.graphics.moveTo(x, y + ro);
	    spr.graphics.lineTo(x, y + ro*0.7);
	    spr.graphics.lineTo(x - ri, y - ro*0.6);
	    spr.graphics.lineTo(x, y - ro);
	    spr.graphics.lineTo(x + ri, y - ro*0.6);
	    spr.graphics.lineTo(x, y + ro*0.7);
	    spr.graphics.lineStyle(t/2, c, a);
	    spr.graphics.lineTo(x, y - ro);
	}

	public static function Pacifier(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var ri:Number = 0.5 * r;
	    var ro:Number = 0.6 * r;
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.drawEllipse(x - ri, y + ro*0.6, ri*2, ro*0.6);
	    spr.graphics.endFill();
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.moveTo(x - ri/6, y + ro*0.8);
	    spr.graphics.curveTo(x - ri, y - ro, x, y - ro);
	    spr.graphics.curveTo(x + ri, y - ro, x + ri/6, y + ro*0.8);
	    spr.graphics.lineTo(x - ri/6, y + ro*0.8);
	    spr.graphics.endFill();
	}

	public static function ChastityBelt(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t, c, a);
	    var ri:Number = 0.5 * r;
	    var ro:Number = 0.7 * r;
	    spr.graphics.moveTo(x - ri, y);
	    spr.graphics.curveTo(x - ro, y - ri/2, x, y - ri);
	    spr.graphics.curveTo(x + ro, y - ri/2, x + ri, y);
	    spr.graphics.beginFill(Utils.colorDark(c, 0.3), a);
	    spr.graphics.moveTo(x - ri, y);
	    spr.graphics.curveTo(x, y, x, y - ro/3);
	    spr.graphics.curveTo(x, y, x + ri, y);
	    spr.graphics.curveTo(x, y, x, y + ro);
	    spr.graphics.curveTo(x, y, x - ri, y);
	    spr.graphics.endFill();
	}

	public static function AnalTentacle(spr:Sprite, x:Number, y:Number, r:Number, c:uint, t:Number = 1, a:Number = 1):void {
	    spr.graphics.lineStyle(t/2, c, a);
	    var ri:Number = 0.5 * r;
	    var ro:Number = 0.65 * r;
	    spr.graphics.drawCircle(x, y - ro, t)
	    spr.graphics.lineStyle(t, c, a);
	    spr.graphics.moveTo(x, y - ro);
	    spr.graphics.curveTo(x - ro/2, y - ri/2, x, y - ri/2);
	    spr.graphics.curveTo(x + ro, y - ri/2, x + ri, y);
	    spr.graphics.curveTo(x, y, x, y);
	    spr.graphics.curveTo(x - ri, y, x, y + ro);
	    spr.graphics.curveTo(x, y, x + ri/2, y + ro*0.7);
	}

   }
	
}