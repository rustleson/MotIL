package Engine.Dialogs.Widgets {
	
    import Engine.Objects.Utils;
    import flash.geom.Matrix;
    import flash.display.*;

    public class KarmaWidget extends Widget{

	public var textColor:uint = 0xeeeeee;
	public var width:Number;
	public var height:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	private var _value:Number = 0;

	public function KarmaWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, title:String = '', right:Boolean = false, bottom:Boolean = false):void {
	    super(x, y, title);
	    this.width = w;
	    this.height = h;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	}

	protected override function draw():void {
	    this.sprite.graphics.clear();
	    var ratio:Number = this.transValue2;
	    var w:Number;
	    var h:Number;
	    if (ratio <= 1) {
		w = this.width * ratio;
		h = this.height * ratio;
	    } else if (ratio <= 2) {
		w = this.width + 50 * (ratio - 1);
		h = this.height;
	    }
	    var tx:Number = this.x;
	    var ty:Number = this.y;
	    if (this.rightAligned) {
		tx -= w;
	    }
	    if (this.bottomAligned) {
		ty -= w;
	    }
	    if (w != 0 || h != 0) {
		var gradMatrix:Matrix = new Matrix();
		gradMatrix.createGradientBox(w, h, 0, tx, ty);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xffffff], [0.7, 0.7], [0x00, 0xff], gradMatrix);
		this.sprite.graphics.drawRect(tx, ty, w, h);
		this.sprite.graphics.endFill();
		if (this.value > 0) {
		    this.sprite.graphics.lineStyle(0.3, Utils.colorDark(0x787878, this.value), 1);
		    this.sprite.graphics.beginFill(Utils.colorLight(0x787878, this.value), 1);
		    this.sprite.graphics.drawRect(tx - 1 + (w - 2) * (this.value + 1) / 2, ty - 1, 2, h + 2);
		} else {
		    this.sprite.graphics.lineStyle(0.3, Utils.colorLight(0x787878, -this.value), 1);
		    this.sprite.graphics.beginFill(Utils.colorDark(0x787878, -this.value), 1);
		    this.sprite.graphics.drawRect(tx - 1 + (this. width - 2) * (this.value + 1) / 2, ty - 1, 2, h + 2);
		}
		this.sprite.graphics.endFill();
	    }
	}

	public function set value(v:Number):void {
	    if (this._value != v)
		this.needUpdate = true;
	    this._value = v;
	}

	public function get value():Number {
	    return this._value;
	}

    }
	
}