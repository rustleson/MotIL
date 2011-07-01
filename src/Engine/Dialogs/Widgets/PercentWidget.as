package Engine.Dialogs.Widgets {
	
    import Engine.Objects.Utils;
    import flash.text.*;

    public class PercentWidget extends Widget{

	[Embed(source="/Assets/Manager.ttf", fontFamily="Small", embedAsCFF = "false", advancedAntiAliasing = "true")]
	public static const SMALL_FONT:String;

	public var barColor:uint;
	public var textColor:uint = 0xbbbbbb;
	public var width:Number;
	public var height:Number;
	public var icon:Function;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	private var _value:Number = 0;
	private var percentText:TextField;
	private var titleText:TextField;
	private var format:TextFormat;

	public function PercentWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, c:uint = 0, title:String = '', $icon:Function = null, right:Boolean = false, bottom:Boolean = false):void {
	    super(x, y, title);
	    this.width = w;
	    this.height = h;
	    this.barColor = c;
	    this.icon = $icon;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    // title text
	    this.titleText = new TextField();
	    this.titleText.text = title;
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    format = new TextFormat("Small", 8, this.textColor);
	    format.align = TextFieldAutoSize.RIGHT;	    
	    this.titleText.setTextFormat(format);
	    this.sprite.addChild(this.titleText);
	    // percent text
	    this.percentText = new TextField();
	    this.percentText.text = "0%  ";
	    this.percentText.selectable = false;
	    this.percentText.embedFonts = true;
	    format = new TextFormat("Small", 8, this.textColor);
	    format.align = TextFieldAutoSize.LEFT;	    
	    this.percentText.setTextFormat(format);
	    this.sprite.addChild(this.percentText);

	    this.titleText.width = 0;
	    this.percentText.width = 0;
	}

	protected override function draw():void {
	    this.sprite.graphics.clear();
	    var ratio:Number = this.transValue2;
	    var w:Number;
	    var h:Number;
	    if (ratio <= 1) {
		w = this.width * ratio;
		h = this.height * ratio;
		this.percentText.width = 0;
		this.percentText.height = 0;
		this.titleText.width = 0;
		this.titleText.height = 0;
	    } else if (ratio <= 2) {
		w = this.width;
		h = this.height;
		this.percentText.width = 33 * (ratio - 1);
		this.percentText.height = this.percentText.textHeight + 2;
		this.percentText.x = w;
		this.percentText.y = h - this.percentText.height + 2;
		this.titleText.width = (this.titleText.textWidth + 13) * (ratio - 1);
		this.titleText.height = this.titleText.textHeight + 2;
		this.titleText.x = - this.titleText.width - 4;
		this.titleText.y = h - this.titleText.height + 2;
	    }
	    var tx:Number = this.x;
	    var ty:Number = this.y;
	    var wPercent:Number = (ratio >= 1 && ratio <= 2) ? (ratio - 1) * this.percentText.width : 0;
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
	    this.percentText.x = Math.round(tx + this.percentText.x);
	    this.percentText.y = Math.round(ty + this.percentText.y);
	    this.titleText.x = Math.round(tx + this.titleText.x);
	    this.titleText.y = Math.round(ty + this.titleText.y);
	    if (w != 0 || h != 0) {
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
		if (this.icon != null) {
		    this.titleText.x -= h;
		    this.icon(this.sprite, tx - h, ty + h/2, h/2, this.barColor, 1);
		}
	    }
	}

	public function set value(v:Number):void {
	    if (this._value != v)
		this.needUpdate = true;
	    var percent:int = Math.round(this._value * 100);
	    this.percentText.text = percent.toString() + "%  ";
	    this.percentText.setTextFormat(this.format);
	    this._value = v;
	}

	public function get value():Number {
	    return this._value;
	}

    }
	
}