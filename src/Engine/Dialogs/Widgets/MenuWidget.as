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
    import flash.display.*;
    import flash.events.MouseEvent;
    import Engine.Objects.Utils;

    public class MenuWidget extends Widget{

	public var panelColor:uint;
	public var panelAlpha:uint;
	public var titleDY:int = 0;
	public var textColor:uint = 0xeeeeee;
	public var width:Number;
	public var height:Number;
	public var widthSmall:Number;
	public var heightSmall:Number;
	public var widthLarge:Number;
	public var heightLarge:Number;
	public var cornerRadius:Number = 10;
	public var chosenItem:String;
	private var items:Array;
	private var menuFormat:TextFormat;
	public var submitted:Boolean = false;
	public var highlightSprite:Sprite;

	public function MenuWidget(x:Number = 0, y:Number = 0, wl:Number = 0, hl:Number = 0, c:uint = 0, a:Number = 0.5, $items:Array = null):void {
	    super(x, y, title);
	    this.widthLarge = wl;
	    this.heightLarge = $items.length * 15 + 10;
	    this.width = 0;
	    this.height = 0;
	    this.panelColor = c;
	    this.panelAlpha = a;
	    this.highlightSprite = new Sprite();
	    this.sprite.addChild(this.highlightSprite);
	    // build items
	    this.menuFormat = new TextFormat("Medium", 8, Utils.colorLight(this.textColor,0.5));
	    this.menuFormat.align = TextFieldAutoSize.CENTER;	    
	    this.items = new Array();
	    for (var i:int = 0; i < $items.length; i++) {
		this.items[i] = new TextField();
		this.items[i].text = $items[i];
		this.items[i].selectable = false;
		this.items[i].embedFonts = true;
		this.items[i].wordWrap = false;
		this.items[i].width = 0;
		this.items[i].x = x + 5;
		this.items[i].y = y + i * 15 + 5;
		this.items[i].setTextFormat(this.menuFormat);
		this.items[i].addEventListener(MouseEvent.CLICK, onMenuClick);
		this.items[i].addEventListener(MouseEvent.MOUSE_OVER, onMenuOver);
		this.items[i].addEventListener(MouseEvent.MOUSE_OUT, onMenuOut);
		this.sprite.addChild(this.items[i]);
	    }
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    this.width = this.widthLarge * ratio / 2;
	    this.height = this.heightLarge * ratio / 2;
	    for (var i:int = 0; i < this.items.length; i++) {
		this.items[i].width = this.width - 10;
		this.items[i].height = 15;
		this.items[i].x = Math.round(this.x + (this.widthLarge - this.width + 10) / 2);
	    }
	    var tx:Number = this.x;
	    var ty:Number = this.y;
	    this.sprite.graphics.clear();
	    if (this.width != 0 || this.height != 0) {
		this.sprite.graphics.lineStyle(2, this.textColor, 0.5);
		this.sprite.graphics.beginFill(this.panelColor, 0.5);
		this.sprite.graphics.drawRoundRect(tx + (this.widthLarge - this.width) / 2, ty + (this.heightLarge - this.height) / 2, this.width, this.height, this.cornerRadius, this.cornerRadius);
		this.sprite.graphics.endFill();
	    }
	}

	private function onMenuClick(e:MouseEvent):void {
	    this.submitted = true;
	    this.chosenItem = e.target.text;
	    this.highlightSprite.graphics.clear();
	    this.hidden();
	}

	private function onMenuOver(e:MouseEvent):void {
	    this.highlightSprite.graphics.clear();
	    if (!this.submitted && this.transitionComplete) {
		this.highlightSprite.graphics.lineStyle(0, 0, 0);
		this.highlightSprite.graphics.beginFill(Utils.colorLight(this.panelColor, 0.5), 0.5);
		this.highlightSprite.graphics.drawRoundRect(e.target.x - 2, e.target.y - 2, e.target.width + 4, e.target.height + 4, this.cornerRadius / 2, this.cornerRadius / 2);
		this.highlightSprite.graphics.endFill();
	    }
	}

	private function onMenuOut(e:MouseEvent):void {
	    this.highlightSprite.graphics.clear();
	}

    }
	
}