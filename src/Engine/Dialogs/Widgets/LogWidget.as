//---------------------------------------------------------------------------
//
//    Copyright 2011-2012 Reyna D "rustleson"
//
//---------------------------------------------------------------------------
//
//    This file is part of MotIL.
//
//    MotIL is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    MotIL is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with MotIL.  If not, see <http://www.gnu.org/licenses/>.
//
//---------------------------------------------------------------------------

package Engine.Dialogs.Widgets {
	
    import flash.text.*;
    import flash.display.*;
    import flash.geom.Matrix;
    import Engine.Objects.Utils;

    public class LogWidget extends Widget{

	public var textColor:uint = 0xeeeeee;
	public var width:Number;
	public var height:Number;
	public var widthSmall:Number;
	public var heightSmall:Number;
	public var widthLarge:Number;
	public var heightLarge:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	public var cornerRadius:Number = 5;
	private var logText:TextField;
	private var logFormat:TextFormat;
	private var messageQueue:Array;
	private const maxMessages:int = 40;
	private var logMask:Sprite;

	public function LogWidget(x:Number = 0, y:Number = 0, ws:Number = 0, hs:Number = 0, wl:Number = 0, hl:Number = 0, 
				      c:uint = 0, right:Boolean = false, bottom:Boolean = false):void {
	    super(x, y, title);
	    this.messageQueue = new Array();
	    this.widthSmall = ws;
	    this.heightSmall = hs;
	    this.widthLarge = wl;
	    this.heightLarge = hl;
	    this.width = 0;
	    this.height = 0;
	    this.textColor = c;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    // log text
	    this.logText = new TextField();
	    this.logText.blendMode = BlendMode.LAYER;
	    this.logText.text = '';
	    this.logText.selectable = false;
	    this.logText.embedFonts = true;
	    this.logText.wordWrap = true;
	    this.logFormat = new TextFormat("Tiny", 8, this.textColor);
	    this.logFormat.align = TextFieldAutoSize.LEFT;	    
	    this.logText.setTextFormat(this.logFormat);
	    this.sprite.addChild(this.logText);
	    this.logMask = new Sprite();
	    this.sprite.addChild(this.logMask);
	    this.logText.cacheAsBitmap = true;
	    this.logMask.cacheAsBitmap = true;
	    this.logMask.blendMode = BlendMode.LAYER;
	    this.logText.mask = this.logMask;
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    if (ratio <= 1) {
		this.width = this.widthSmall;
		this.height = this.heightSmall * ratio;
		this.logText.width = this.width - 10;
		this.logText.height = this.height;
		this.logText.alpha = 1;
	    } else if (ratio <= 2) {
		this.width = this.widthSmall + (this.widthLarge - this.widthSmall) * (ratio - 1);
		this.height = this.heightSmall + (this.heightLarge - this.heightSmall) * (ratio - 1);
		this.logText.width = this.width - 10;
		this.logText.height = this.height;
		this.logText.x = 5;
		this.logText.y = 5;
	    }
	    var tx:Number = this.x;
	    var ty:Number = this.y;
	    if (this.rightAligned) {
		tx -= this.width;
	    }
	    if (this.bottomAligned) {
		ty -= this.height;
	    }
	    this.logText.x = Math.round(tx + 5);
	    this.logText.y = Math.round(ty + 5);
	    this.sprite.graphics.clear();
	    if (this.width != 0 || this.height != 0) {
		var gradMatrix:Matrix = new Matrix();
		gradMatrix.createGradientBox(this.width, this.height, Math.PI/2, tx, ty);
		this.sprite.graphics.lineStyle(0, 0, 0);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x0, 0x0], [0.8 * ratio, Math.max(0, (ratio - 1) * 0.8)], [0, 0xff], gradMatrix);
		this.sprite.graphics.drawRoundRect(tx, ty, this.width, this.height, this.cornerRadius, this.cornerRadius);
		this.sprite.graphics.endFill();
		this.logMask.graphics.clear();
		gradMatrix = new Matrix();
		gradMatrix.createGradientBox(this.width, this.height, Math.PI/2, tx, ty);
		this.logMask.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xffffff], [1, 0.4], [0, 0xff], gradMatrix);
		this.logMask.graphics.drawRect(tx, ty, this.width, this.height);
		this.logMask.graphics.endFill();
	    }
	}

	public function show(m:String):void {
	    if (this.messageQueue.length == 0 || this.messageQueue[this.messageQueue.length - 1].message != m){
		this.messageQueue.push({'message': m, 'count': 1});
		if (this.messageQueue.length > this.maxMessages)
		    this.messageQueue.splice(0, 1); 
	    } else {
		this.messageQueue[this.messageQueue.length - 1].count++;
	    }
	    this.needUpdate = true;
	    this.logText.text = '';
	    for (var i:int = this.messageQueue.length - 1; i >= 0; i--) {
		this.logText.appendText(this.messageQueue[i].message + ((this.messageQueue[i].count > 1) ? (" (x" + this.messageQueue[i].count.toString() + ")\n") : "\n"));
	    }
	    this.logText.setTextFormat(this.logFormat);
	}

    }

}