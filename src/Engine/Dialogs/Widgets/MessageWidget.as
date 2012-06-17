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
	
    import General.Input;
    import flash.text.*;
    import Engine.Objects.Utils;

    public class MessageWidget extends Widget{

	public var panelColor:uint;
	public var titleDY:int = 0;
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
	public var icon:Function;
	private var titleText:TextField;
	private var messageText:TextField;
	private var contText:TextField;
	public var titleFormat:TextFormat;
	public var messageFormat:TextFormat;
	private var contFormat:TextFormat;
	private var messageQueue:Array;

	public function MessageWidget(x:Number = 0, y:Number = 0, ws:Number = 0, hs:Number = 0, wl:Number = 0, hl:Number = 0, 
				    c:uint = 0, right:Boolean = false, bottom:Boolean = false):void {
	    super(x, y, title);
	    this.messageQueue = new Array();
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
	    this.titleText.text = '';
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    this.titleFormat = new TextFormat("Medium", 8, this.textColor);
	    this.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.titleText.setTextFormat(this.titleFormat);
	    this.sprite.addChild(this.titleText);
	    // message text
	    this.messageText = new TextField();
	    this.messageText.text = '';
	    this.messageText.selectable = false;
	    this.messageText.embedFonts = true;
	    this.messageText.wordWrap = true;
	    this.messageFormat = new TextFormat("Small", 8, this.textColor);
	    this.messageFormat.align = TextFieldAutoSize.LEFT;	    
	    this.messageText.setTextFormat(this.messageFormat);
	    this.sprite.addChild(this.messageText);
	    // continue text
	    this.contText = new TextField();
	    this.contText.text = 'hit <space> to continue';
	    this.contText.selectable = false;
	    this.contText.embedFonts = true;
	    this.contText.wordWrap = true;
	    this.contFormat = new TextFormat("Tiny", 8, Utils.colorDark(this.textColor,0.3));
	    this.contFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.contText.width = wl - 10;
	    this.contText.x = x;
	    this.contText.y = y;
	    this.contText.setTextFormat(this.contFormat);
	    this.sprite.addChild(this.contText);
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    if (ratio <= 1) {
		this.width = this.widthSmall * ratio;
		this.height = this.heightSmall * ratio;
		this.titleText.width = 0;
		this.titleText.height = 0;
		this.messageText.width = 0;
		this.messageText.height = 0;
		this.contText.width = 0;
		this.contText.height = 0;
	    } else if (ratio <= 2) {
		this.width = this.widthSmall + (this.widthLarge - this.widthSmall) * (ratio - 1);
		this.height = this.heightSmall + (this.heightLarge - this.heightSmall) * (ratio - 1);
		this.titleText.width = (this.titleText.textWidth + 3) * (ratio - 1);
		this.titleText.height = this.titleText.textHeight + 2;
		this.messageText.width = (this.width - 20); // * (ratio - 1);
		this.messageText.height = this.messageText.textHeight + 100;
		this.contText.width = (this.width - 10) * (ratio - 1);
		this.contText.height = this.contText.textHeight + 10;
		this.titleText.x = 15;
		this.titleText.y = -6;
		this.messageText.x = 15;
		if (this.icon != null) {
		    this.messageText.width = (this.width - this.height/2 - 20); // * (ratio - 1);
		    this.messageText.x += this.height/2;
		}
		this.messageText.y = 15;
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
	    this.titleText.y = Math.round(ty + this.titleText.y + this.titleDY);
	    this.messageText.x = Math.round(tx + this.messageText.x);
	    this.messageText.y = Math.round(ty + this.messageText.y);
	    this.contText.x = Math.round(tx);
	    this.contText.y = Math.round(ty + this.height - this.contText.textHeight - 10);
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
		if (this.icon != null) {
		    this.sprite.graphics.lineStyle(2, this.textColor, 0.7);
		    this.sprite.graphics.beginFill(Utils.colorDark(this.textColor, 0.7), 0.7);
		    this.sprite.graphics.drawCircle(tx + this.height/4 + 10, ty + this.height/4 + 15, this.height/4);
		    this.sprite.graphics.endFill();
		    this.icon(this.sprite, tx + this.height/4 + 10, ty + this.height/4 + 15, this.height/4, this.textColor, 2, 0.7);
		}
	    }
	}

	public function show(m:Message):void {
	    this.messageQueue.push(m);
	    this.hidden();
	}

	public override function update():void {
	    if (this.state == 'hidden' && this.transitionComplete && this.messageQueue.length > 0) {
		this.titleText.text = this.messageQueue[0].title;
		this.titleText.setTextFormat(this.titleFormat);
		this.textColor = this.messageQueue[0].color;
		this.messageText.text = this.messageQueue[0].text;
		this.messageText.setTextFormat(this.messageFormat);
		this.icon = this.messageQueue[0].icon;
		this.messageQueue.splice(0, 1);
		this.large();
	    }
	    if (this.state == 'large' && this.transitionComplete && Input.isKeyPressed(32)) {
		this.hidden();
	    }
	    super.update();
	}
    }
	
}