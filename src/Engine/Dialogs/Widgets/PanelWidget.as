package Engine.Dialogs.Widgets {
	
    import flash.text.*;

    public class PanelWidget extends Widget{

	public var panelColor:uint;
	public var textColor:uint = 0xeeeeee;
	public var width:Number;
	public var height:Number;
	public var widthSmall:Number;
	public var heightSmall:Number;
	public var widthLarge:Number;
	public var heightLarge:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	public var cornerRadius:Number = 10;
	private var titleText:TextField;
	private var titleFormat:TextFormat;

	public function PanelWidget(x:Number = 0, y:Number = 0, ws:Number = 0, hs:Number = 0, wl:Number = 0, hl:Number = 0, 
				    c:uint = 0, title:String = '', right:Boolean = false, bottom:Boolean = false):void {
	    super(x, y, title);
	    this.widthSmall = ws;
	    this.heightSmall = hs;
	    this.widthLarge = wl;
	    this.heightLarge = hl;
	    this.width = 0;
	    this.height = 0;
	    this.panelColor = c;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    // title text
	    this.titleText = new TextField();
	    this.titleText.text = title;
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    this.titleFormat = new TextFormat("Medium", 8, this.textColor);
	    this.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.titleText.setTextFormat(this.titleFormat);
	    this.sprite.addChild(this.titleText);
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    if (ratio <= 1) {
		this.width = this.widthSmall * ratio;
		this.height = this.heightSmall * ratio;
		this.titleText.width = 0;
		this.titleText.height = 0;
	    } else if (ratio <= 2) {
		this.width = this.widthSmall + (this.widthLarge - this.widthSmall) * (ratio - 1);
		this.height = this.heightSmall + (this.heightLarge - this.heightSmall) * (ratio - 1);
		this.titleText.width = (this.titleText.textWidth + 3) * (ratio - 1);
		this.titleText.height = this.titleText.textHeight + 2;
		this.titleText.x = 10;
		this.titleText.y = -6;
	    }
	    var tx:Number = this.x;
	    var ty:Number = this.y;
	    if (this.rightAligned) {
		tx -= this.width;
	    }
	    if (this.bottomAligned) {
		ty -= this.height;
	    }
	    this.titleText.x = Math.round(tx + this.titleText.x);
	    this.titleText.y = Math.round(ty + this.titleText.y);
	    this.sprite.graphics.clear();
	    if (this.width != 0 || this.height != 0) {
		this.sprite.graphics.lineStyle(2, this.textColor, 0.5);
		this.sprite.graphics.beginFill(this.panelColor, 0.7);
		this.sprite.graphics.drawRoundRect(tx, ty, this.width, this.height, this.cornerRadius, this.cornerRadius);
		this.sprite.graphics.endFill();
		this.sprite.graphics.lineStyle(0, 0, 0);
		this.sprite.graphics.beginFill(this.panelColor, 1);
		this.sprite.graphics.drawRoundRect(this.titleText.x, this.titleText.y + 1, this.titleText.width, this.titleText.height, 5, 5);
		this.sprite.graphics.endFill();
	    }
	}

    }
	
}