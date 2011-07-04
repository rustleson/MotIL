package Engine.Dialogs.Widgets {
	
    import Engine.Objects.Utils;
    import flash.geom.Matrix;
    import flash.display.*;
    import flash.text.*;

    public class KarmaWidget extends Widget{

	public var textColor:uint = 0xbbbbbb;
	public var width:Number;
	public var height:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	private var _value:Number = 0;
	public var icon:Function;
	private var valueText:TextField;
	private var titleText:TextField;
	private var format:TextFormat;

	public function KarmaWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, title:String = '', $icon:Function = null, right:Boolean = false, bottom:Boolean = false):void {
	    super(x, y, title);
	    this.width = w;
	    this.height = h;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    this.icon = $icon;
	    // title text
	    this.titleText = new TextField();
	    this.titleText.text = title;
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    format = new TextFormat("Small", 8, this.textColor);
	    format.align = TextFieldAutoSize.RIGHT;	    
	    this.titleText.setTextFormat(format);
	    this.sprite.addChild(this.titleText);
	    // value text
	    this.valueText = new TextField();
	    this.valueText.text = "0  ";
	    this.valueText.selectable = false;
	    this.valueText.embedFonts = true;
	    format = new TextFormat("Small", 8, this.textColor);
	    format.align = TextFieldAutoSize.LEFT;	    
	    this.valueText.setTextFormat(format);
	    this.sprite.addChild(this.valueText);

	    this.titleText.width = 0;
	    this.valueText.width = 0;
	}

	protected override function draw():void {
	    this.sprite.graphics.clear();
	    var ratio:Number = this.transValue2;
	    var w:Number;
	    var h:Number;
	    if (ratio <= 1) {
		w = this.width * ratio;
		h = this.height * ratio;
		this.valueText.width = 0;
		this.valueText.height = 0;
		this.titleText.width = 0;
		this.titleText.height = 0;
	    } else if (ratio <= 2) {
		w = this.width;
		h = this.height;
		this.valueText.width = 33 * (ratio - 1);
		this.valueText.height = this.valueText.textHeight + 2;
		this.valueText.x = w;
		this.valueText.y = h - this.valueText.height + 2;
		this.titleText.width = (this.titleText.textWidth + 13) * (ratio - 1);
		this.titleText.height = this.titleText.textHeight + 2;
		this.titleText.x = - this.titleText.width - 4;
		this.titleText.y = h - this.titleText.height + 2;
	    }
	    var tx:Number = this.x;
	    var ty:Number = this.y;
	    var wPercent:Number = (ratio >= 1 && ratio <= 2) ? (ratio - 1) * this.valueText.width : 0;
	    var wIcon:Number = (this.icon != null) ? h * 2 : 0;
	    var wTitle:Number = (ratio >= 1 && ratio <= 2) ? (ratio - 1) * this.titleText.width : 0;
	    if (this.rightAligned) {
		if (ratio >= 1 && ratio <= 2 ) {
		    tx -= w + wPercent;
		} else {
		    tx -= w;
		}
	    } else {
		tx += wIcon + wTitle;
	    }
	    if (this.bottomAligned) {
		ty -= h;
	    }
	    this.valueText.x = Math.round(tx + this.valueText.x);
	    this.valueText.y = Math.round(ty + this.valueText.y);
	    this.titleText.x = Math.round(tx + this.titleText.x);
	    this.titleText.y = Math.round(ty + this.titleText.y);
	    if (w != 0 || h != 0) {
		var gradMatrix:Matrix = new Matrix();
		gradMatrix.createGradientBox(w, h, 0, tx, ty);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xaaaaaa, 0xffffff], [1, 1], [0x00, 0xff], gradMatrix);
		this.sprite.graphics.drawRoundRect(tx, ty, w, h, h, h);
		this.sprite.graphics.endFill();
		gradMatrix.createGradientBox(w - 2, h - 2, 0, tx + 1, ty + 1);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xeeeeee], [1, 1], [0x00, 0xff], gradMatrix);
		this.sprite.graphics.drawRoundRect(tx + 1, ty + 1, w - 2, h - 2, h - 2, h - 2);
		this.sprite.graphics.endFill();
		
		//this.sprite.graphics.lineStyle(1, 0x666666, 1);
		//this.sprite.graphics.moveTo(tx + h/2 - 1, ty + h);
		//this.sprite.graphics.lineTo(tx + h/2 - 1, ty + h + 4);
		//this.sprite.graphics.moveTo(tx + w/2 - 1, ty + h);
		//this.sprite.graphics.lineTo(tx + w/2 - 1, ty + h + 4);
		//this.sprite.graphics.moveTo(tx + w - h/2 - 1, ty + h);
		//this.sprite.graphics.lineTo(tx + w - h/2 - 1, ty + h + 4);
		//this.sprite.graphics.lineStyle(0, 0, 0);
		this.sprite.graphics.beginFill(0xdddddd, 1);
		this.sprite.graphics.moveTo(tx + h/2 - 3 + (w - h) * (this.value + 1) / 2, ty + 3 + h);
		this.sprite.graphics.lineTo(tx + h/2 + (w - h) * (this.value + 1) / 2, ty + h);
		this.sprite.graphics.lineTo(tx + h/2 + 3 + (w - h) * (this.value + 1) / 2, ty + 3 + h);
		this.sprite.graphics.lineTo(tx + h/2 - 3 + (w - h) * (this.value + 1) / 2, ty + 3 + h);
		this.sprite.graphics.endFill();
		if (this.icon != null) {
		    this.titleText.x -= h;
		    this.icon(this.sprite, tx - h, ty + h/2, h/2, 0x000000, 1);
		}
		var value:int = Math.round(this._value * 100);
		this.valueText.text = value.toString() + "  ";
		if (value > 0)
		    this.valueText.text = "+" + this.valueText.text;
		this.valueText.setTextFormat(this.format);
	    }
	}

	public function set value(v:Number):void {
	    if (this._value != v) {
		this.needUpdate = true;
	    }
	    this._value = v;
	}

	public function get value():Number {
	    return this._value;
	}

    }
	
}