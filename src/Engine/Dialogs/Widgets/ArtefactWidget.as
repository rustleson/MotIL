package Engine.Dialogs.Widgets {
	
    import Engine.Objects.Utils;
    import Engine.Stats.*;
    import flash.text.*;
    import flash.events.*;
    import flash.display.*;

    public class ArtefactWidget extends Widget{

	public var artefact:ArtefactStat;
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
	public var stats:ProtagonistStats;
	private var _value:Number = 0;
	private var dragSprite:Sprite;
	public var valueString:String = '1L  ';
	public var progressString:String = '';
	private var valueText:TextField;
	private var titleText:TextField;
	private var valueFormat:TextFormat;
	private var titleFormat:TextFormat;

	public function ArtefactWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0):void {
	    super(x, y, '');
	    this.width = w;
	    this.height = h;
	    this.barColor = 0;
	    this.icon = null;
	    this.rightAligned = false;
	    this.bottomAligned = false;
	    this.noProgress = false;
	    this.dx = 0;
	    this.dy = 0;
	    // title text
	    this.titleText = new TextField();
	    this.titleText.text = '';
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    this.titleFormat = new TextFormat("Small", 8, this.textColor);
	    this.titleFormat.align = TextFieldAutoSize.LEFT;	    
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
	    this.sprite.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
	    this.sprite.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
	    this.titleText.width = 0;
	    this.valueText.width = 0;
	    this.dragSprite = new Sprite();
	    this.sprite.addChild(this.dragSprite);
	}

	protected override function draw():void {
	    this.barColor = this.artefact.color;
	    this.icon = this.artefact.icon;
	    this.titleText.text = this.artefact.name;
	    this.titleText.setTextFormat(this.titleFormat);
	    this._value = this.artefact.level / 50;
	    this.valueString = this.artefact.levelString;
	    this.setTooltip(this.artefact.description);
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
		this.valueText.x = w - this.valueText.width + 4;
		this.valueText.y = h - this.valueText.height + 2;
		if (this.noProgress) {
		    this.valueText.width = (33 + w) * (ratio - 1);
		    this.valueText.x = 0;
		    w += 33;
		}
		this.titleText.width = (this.titleText.textWidth + 13) * (ratio - 1);
		this.titleText.height = this.titleText.textHeight + 2;
		this.titleText.x = 4;
		this.titleText.y = this.titleText.height - 7;
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
		//tx += wIcon + wTitle;
	    }
	    if (this.bottomAligned) {
		ty -= h;
	    }
	    this.valueText.x = Math.round(tx + this.valueText.x);
	    this.valueText.y = Math.round(ty + this.valueText.y);
	    this.titleText.x = Math.round(tx + this.titleText.x);
	    this.titleText.y = Math.round(ty + this.titleText.y);
	    var hV:Number = 7;
	    if (w != 0 || h != 0) {
		if (!this.noProgress) {
		    this.sprite.graphics.beginFill(Utils.colorDark(this.barColor, 0.1), 1);
		    this.sprite.graphics.drawRoundRect(tx + h + 4, ty + h - hV, w - h - this.valueText.width, hV, hV, hV);
		    this.sprite.graphics.endFill();
		    this.sprite.graphics.beginFill(Utils.colorDark(this.barColor, 0.7), 1);
		    this.sprite.graphics.drawRoundRect(tx + 1 + h + 4, ty + 1 + h - hV, w - 2 - h - this.valueText.width, hV - 2, hV - 2, hV - 2);
		    this.sprite.graphics.endFill();
		    this.sprite.graphics.lineStyle(0, 0, 0);
		    this.sprite.graphics.beginFill(Utils.colorDark(this.barColor, 0.3), 1);
		    this.sprite.graphics.drawRoundRect(tx + 1 + h + 4, ty + 1 + h - hV, (w - 2 - h - this.valueText.width) * this.value, hV - 2, hV - 2, hV - 2);
		    this.sprite.graphics.endFill();
		}
		if (this.icon != null) {
		    this.titleText.x += h;
		    this.sprite.graphics.lineStyle(2, this.barColor, 1);
		    this.sprite.graphics.beginFill(Utils.colorDark(this.barColor, 0.5), 1);
		    this.sprite.graphics.drawCircle(tx + h/2, ty + h/2, h/2);
		    this.sprite.graphics.endFill();
		    this.icon(this.sprite, tx + h/2, ty + h/2, h/2, this.barColor, 2);
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

	private function mouseDownHandler(event:MouseEvent):void {
	    if (!this.artefact.attached && this.artefact.obtained) {
		this.dragSprite.graphics.clear();
		this.dragSprite.graphics.lineStyle(2, this.barColor, 1);
		this.dragSprite.graphics.beginFill(Utils.colorDark(this.barColor, 0.5), 1);
		this.dragSprite.graphics.drawCircle(event.stageX, event.stageY, 15);
		this.dragSprite.graphics.endFill();
		this.icon(this.dragSprite, event.stageX, event.stageY, 15, this.barColor, 2);
		this.dragSprite.startDrag();
	    }
	}
	private function mouseUpHandler(event:MouseEvent):void {
	    if (!this.artefact.attached && this.artefact.obtained) {
		// drop coordinates hardcoded!!! (TODO: dynamic determination of the slot dropped into)
		if (Math.abs(211 - event.stageX) < 25 && Math.abs(109 - event.stageY) < 25) {
		    this.artefact.attach(this.stats.rightHandSlot);
		    this.stats.statsDialog.widgets.rhandslot.needUpdate = true;
		    this.needUpdate = true;
		} else if (Math.abs(561 - event.stageX) < 25 && Math.abs(109 - event.stageY) < 25) {
		    this.artefact.attach(this.stats.leftHandSlot);
		    this.stats.statsDialog.widgets.lhandslot.needUpdate = true;
		    this.needUpdate = true;
		} if (Math.abs(386 - event.stageX) < 25 && Math.abs(339 - event.stageY) < 25) {
		    this.artefact.attach(this.stats.vaginaSlot);
		    this.stats.statsDialog.widgets.vaginaslot.needUpdate = true;
		    this.needUpdate = true;
		} if (Math.abs(386 - event.stageX) < 25 && Math.abs(413 - event.stageY) < 25) {
		    this.artefact.attach(this.stats.anusSlot);
		    this.stats.statsDialog.widgets.anusslot.needUpdate = true;
		    this.needUpdate = true;
		} if (Math.abs(386 - event.stageX) < 25 && Math.abs(68 - event.stageY) < 25) {
		    this.artefact.attach(this.stats.mouthSlot);
		    this.stats.statsDialog.widgets.mouthslot.needUpdate = true;
		    this.needUpdate = true;
		}
		this.dragSprite.stopDrag();
		this.dragSprite.graphics.clear();
		this.dragSprite.x = 0;
		this.dragSprite.y = 0;
		this.stats.protagonist.wasUpdated = true;
	    }
	}
    }
	
}