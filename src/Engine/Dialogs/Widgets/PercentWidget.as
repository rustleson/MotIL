package Engine.Dialogs.Widgets {
	
    import Engine.Objects.Utils;
    import flash.text.*;

    public class PercentWidget extends Widget{

	public var barColor:uint;
	public var textColor:uint = 0xbbbbbb;
	public var width:Number;
	public var height:Number;
	public var dx:Number;
	public var dy:Number;
	public var icon:Function;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	public var noProgress:Boolean;
	private var _value:Number = 0;
	public var valueString:String = '0%  ';
	public var progressString:String = '';
	private var valueText:TextField;
	private var titleText:TextField;
	private var valueFormat:TextFormat;
	private var titleFormat:TextFormat;

	public function PercentWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, c:uint = 0, title:String = '', $icon:Function = null, right:Boolean = false, bottom:Boolean = false, $dx:Number = 0, $dy:Number = 0, $noProgress:Boolean = false):void {
	    super(x, y, title);
	    this.width = w;
	    this.height = h;
	    this.barColor = Utils.colorLight(c, 0.3);
	    this.icon = $icon;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    this.noProgress = $noProgress;
	    this.dx = $dx;
	    this.dy = $dy;
	    // title text
	    this.titleText = new TextField();
	    this.titleText.text = title;
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    this.titleFormat = new TextFormat("Small", 8, this.textColor);
	    this.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.titleText.setTextFormat(this.titleFormat);
	    this.sprite.addChild(this.titleText);
	    // value text
	    this.valueText = new TextField();
	    this.valueText.selectable = false;
	    this.valueText.embedFonts = true;
	    this.valueFormat = new TextFormat("Small", 8, this.textColor);
	    this.valueFormat.align = TextFieldAutoSize.LEFT;	    
	    this.valueText.setTextFormat(this.valueFormat);
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
		if (this.noProgress) {
		    this.valueText.width = (33 + w) * (ratio - 1);
		    this.valueText.x = 0;
		    w += 33;
		}
		this.titleText.width = (this.titleText.textWidth + 13) * (ratio - 1);
		this.titleText.height = this.titleText.textHeight + 2;
		this.titleText.x = - this.titleText.width - 4;
		this.titleText.y = h - this.titleText.height + 2;
	    }
	    var tx:Number = this.x + ((ratio >=1 && ratio <=2) ? this.dx * (ratio - 1) : 0);
	    var ty:Number = this.y + ((ratio >=1 && ratio <=2) ? this.dy * (ratio - 1) : 0);
	    var wPercent:Number = (ratio >= 1 && ratio <= 2) ? (ratio - 1) * this.valueText.width : 0;
	    var wIcon:Number = (this.icon != null) ? h * 2 : 0;
	    var wTitle:Number = (ratio >= 1 && ratio <= 2) ? (ratio - 1) * this.titleText.width : 0;
	    if (this.rightAligned) {
		if (ratio >= 1 && ratio <= 2 && !this.noProgress) {
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
		if (!this.noProgress) {
		    this.sprite.graphics.beginFill(Utils.colorDark(this.barColor, 0.1), 1);
		    this.sprite.graphics.drawRoundRect(tx, ty, w, h, h, h);
		    this.sprite.graphics.endFill();
		    this.sprite.graphics.beginFill(Utils.colorDark(this.barColor, 0.7), 1);
		    this.sprite.graphics.drawRoundRect(tx + 1, ty + 1, w - 2, h - 2, h - 2, h - 2);
		    this.sprite.graphics.endFill();
		    this.sprite.graphics.lineStyle(0, 0, 0);
		    this.sprite.graphics.beginFill(Utils.colorDark(this.barColor, 0.3), 1);
		    this.sprite.graphics.drawRoundRect(tx + 1, ty + 1, (w - 2) * this.value, h - 2, h - 2, h - 2);
		    this.sprite.graphics.endFill();
		}
		if (this.icon != null) {
		    this.titleText.x -= h;
		    this.icon(this.sprite, tx - h, ty + h/2, h/2, this.barColor, 1);
		}
		this.valueText.text = this.valueString;
		this.valueText.setTextFormat(this.valueFormat);
	    }
	}

	public function set value(v:Number):void {
	    if (this._value != v) {
		this.needUpdate = true;
		var percent:int = Math.round(v * 100);
		this.valueString = percent.toString() + "%  ";
	    }
	    this._value = v;
	}

	public function get value():Number {
	    return this._value;
	}

    }
	
}