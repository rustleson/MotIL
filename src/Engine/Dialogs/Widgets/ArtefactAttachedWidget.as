package Engine.Dialogs.Widgets {
	
    import Engine.Objects.Utils;
    import Engine.Stats.SlotStat;
    import flash.text.*;
    import flash.events.*;
    import flash.display.*;

    public class ArtefactAttachedWidget extends Widget{

	public var textColor:uint = 0xeeeeee;
	public var width:Number;
	public var height:Number;
	public var dx:Number;
	public var dy:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	public var slot:SlotStat;
	private var titleText:TextField;
	private var titleFormat:TextFormat;
	private var dragSprite:Sprite;

	public function ArtefactAttachedWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, right:Boolean = false, bottom:Boolean = false, $dx:Number = 0, $dy:Number = 0):void {
	    super(x, y, '');
	    this.width = w;
	    this.height = h;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    this.dx = $dx;
	    this.dy = $dy;
	    // title text
	    this.titleText = new TextField();
	    this.titleText.text = "";
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    this.titleFormat = new TextFormat("Tiny", 8, this.textColor);
	    this.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.titleText.setTextFormat(this.titleFormat);
	    this.sprite.addChild(this.titleText);
	    this.titleText.width = 0;
	    this.dragSprite = new Sprite();
	    this.sprite.addChild(this.dragSprite);
	    this.sprite.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
	    this.sprite.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
	}

	protected override function draw():void {
	    this.sprite.graphics.clear();
	    this.titleText.text = this.slot.artefactAttached.name + " attached";
	    this.titleText.setTextFormat(this.titleFormat);
	    this.setTooltip(this.slot.artefactAttached.description);
	    var ratio:Number = this.transValue2;
	    var w:Number;
	    var h:Number;
	    if (ratio <= 1) {
		w = this.width * ratio;
		h = this.height * ratio;
		this.titleText.width = 0;
		this.titleText.height = 0;
	    } else if (ratio <= 2) {
		w = this.width;
		h = this.height;
		this.titleText.width = (this.width - this.height*0.6) * (ratio - 1);
		this.titleText.height = this.titleText.textHeight + 2;
		this.titleText.x = -w;
		this.titleText.y = h - this.titleText.height + 2;
	    }
	    var tx:Number = this.x;
	    var ty:Number = this.y + ((ratio >=1 && ratio <=2) ? this.dy * (ratio - 1) : 0);
	    this.titleText.x = Math.round(tx + this.titleText.x);
	    this.titleText.y = Math.round(ty + this.titleText.y);
	    if (w != 0 || h != 0) {
		this.sprite.graphics.lineStyle(2, this.textColor, 1);
		this.sprite.graphics.beginFill(Utils.colorDark(this.slot.artefactAttached.color, 0.5), 1);
		this.sprite.graphics.drawCircle(tx - h/7 - 0, ty + this.height/2 - h/10, h/2);
		this.sprite.graphics.endFill();
		this.slot.artefactAttached.icon(this.sprite, tx - h/7 - 0, ty + this.height/2 - h/10, h/2, this.slot.artefactAttached.color, 2);
	    }
	}

	private function mouseDownHandler(event:MouseEvent):void {
	    if (this.slot.artefactAttached.attached) {
		this.dragSprite.graphics.clear();
		this.dragSprite.graphics.lineStyle(2, this.slot.artefactAttached.color, 1);
		this.dragSprite.graphics.beginFill(Utils.colorDark(this.slot.artefactAttached.color, 0.5), 1);
		this.dragSprite.graphics.drawCircle(event.stageX, event.stageY, 15);
		this.dragSprite.graphics.endFill();
		this.slot.artefactAttached.icon(this.dragSprite, event.stageX, event.stageY, 15, this.slot.artefactAttached.color, 2);
		this.dragSprite.startDrag();
	    }
	}
	private function mouseUpHandler(event:MouseEvent):void {
	    if (this.slot.artefactAttached.attached) {
		this.slot.artefactAttached.detach();
		this.dragSprite.stopDrag();
		this.dragSprite.graphics.clear();
		this.dragSprite.x = 0;
		this.dragSprite.y = 0;
		this.needUpdate = true;
	    }
	}

    }
	
}