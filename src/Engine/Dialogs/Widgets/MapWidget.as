package Engine.Dialogs.Widgets {
	
    import flash.text.*;
    import flash.geom.Rectangle;
    import Engine.Objects.Utils;
    import Math;

    public class MapWidget extends Widget{

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
	public var curX:int;
	public var curY:int;
	public var map:Array;
	private var titleText:TextField;
	private var titleFormat:TextFormat;

	public function MapWidget(x:Number = 0, y:Number = 0, ws:Number = 0, hs:Number = 0, wl:Number = 0, hl:Number = 0, 
				    right:Boolean = false, bottom:Boolean = false):void {
	    super(x, y, title);
	    this.widthSmall = ws;
	    this.heightSmall = hs;
	    this.widthLarge = wl;
	    this.heightLarge = hl;
	    this.width = 0;
	    this.height = 0;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    if (ratio <= 1) {
		this.width = this.widthSmall * ratio;
		this.height = this.heightSmall * ratio;
	    } else if (ratio <= 2) {
		this.width = this.widthSmall + (this.widthLarge - this.widthSmall) * (ratio - 1);
		this.height = this.heightSmall + (this.heightLarge - this.heightSmall) * (ratio - 1);
	    }
	    var tx:Number = this.x;
	    var ty:Number = this.y;
	    if (this.rightAligned) {
		tx -= this.width;
	    }
	    if (this.bottomAligned) {
		ty -= this.height;
	    }
	    this.sprite.graphics.clear();
	    if (this.width != 0 || this.height != 0) {
		var mapHeight:int = this.map.length;
		var cellHeight:Number = this.heightLarge / mapHeight;
		if (mapHeight > 0) {
		    var mapWidth:int = this.map[j].length;
		    var cellWidth:Number = this.widthLarge / mapWidth;
		}
		this.sprite.scrollRect = new Rectangle(Math.min(Math.max(tx, tx + (this.curX) * cellWidth - this.width / 2), tx + this.widthLarge - this.width), 
						       Math.min(Math.max(ty, ty + (this.curY) * cellHeight - this.height / 2), ty + this.heightLarge - this.height), 
						       this.width, this.height);
		this.sprite.x = tx;
		this.sprite.y = ty;
		for (var j:int = 0; j < mapHeight; j++) {
		    for (var i:int = 0; i < mapWidth; i++) {
			if (true || this.map[j][i].explored) {
			    // draw room
			    this.sprite.graphics.lineStyle(0, 0, 0);
			    this.sprite.graphics.beginFill(Utils.colorDark(this.map[j][i].type, 0.4), 1);
			    this.sprite.graphics.drawRect(tx + i * cellWidth, ty + j * cellHeight, cellWidth, cellHeight);
			    this.sprite.graphics.endFill();
			    // draw borders
			    this.sprite.graphics.lineStyle(1, Utils.colorLight(this.map[j][i].type, 0.3), 1);
			    if (!this.map[j][i].freedomTop) {
				this.sprite.graphics.moveTo(tx + i * cellWidth, ty + j * cellHeight);
				this.sprite.graphics.lineTo(tx + (i + 1) * cellWidth, ty + j * cellHeight);
			    }
			    if (!this.map[j][i].freedomBottom) {
				this.sprite.graphics.moveTo(tx + i * cellWidth, ty + (j + 1) * cellHeight - 1);
				this.sprite.graphics.lineTo(tx + (i + 1) * cellWidth, ty + (j + 1) * cellHeight - 1);
			    }
			    if (!this.map[j][i].freedomLeft) {
				this.sprite.graphics.moveTo(tx + i * cellWidth, ty + j * cellHeight);
				this.sprite.graphics.lineTo(tx + i * cellWidth, ty + (j + 1) * cellHeight);
			    }
			    if (!this.map[j][i].freedomRight) {
				this.sprite.graphics.moveTo(tx + (i + 1) * cellWidth - 1, ty + j * cellHeight);
				this.sprite.graphics.lineTo(tx + (i + 1) * cellWidth - 1, ty + (j + 1) * cellHeight);
			    }
			}
		    }
		}
		// draw current position
		this.sprite.graphics.lineStyle(0, 0, 0);
		this.sprite.graphics.beginFill(0xEEEEEE, 1);
		this.sprite.graphics.drawCircle(tx + (this.curX + 0.5) * cellWidth, ty + (this.curY + 0.5) * cellHeight, cellWidth / 5);
		this.sprite.graphics.endFill();
	    }
	}

    }
	
}