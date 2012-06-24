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
	
    import flash.events.MouseEvent;
    import Engine.Objects.Utils;
    import flash.text.*;

    public class ButtonWidget extends Widget{

	public var color:uint;
	public var textColor:uint = 0xeeeeee;
	public var width:Number;
	public var height:Number;
	private var _callback:Function;
	private var titleText:TextField;
	public var titleFormat:TextFormat;
	public var cornerRadius:Number = 5;

	public function ButtonWidget(x:Number = 0, y:Number = 0, cb:Function = null, c:uint = 0, title:String = ''):void {
	    super(x, y, title);
	    this.color = c;
	    this.callback = cb;
	    // title text
	    this.titleText = new TextField();
	    this.titleText.text = title;
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    this.titleFormat = new TextFormat("Medium", 8, this.textColor);
	    this.titleFormat.align = TextFieldAutoSize.CENTER;	    
	    this.titleText.setTextFormat(this.titleFormat);
	    this.titleText.width = 0;
	    this.titleText.width = 0;
	    this.width = this.titleText.textWidth + 20;
	    this.height = 25;
	    this.sprite.addChild(this.titleText);
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    var w:Number = this.width;
	    var h:Number = this.height;
	    if (ratio < 1) {
		w *= ratio;
		h *= ratio;
	    } 
	    this.titleText.width = w - 10;
	    this.titleText.height = 15;
	    this.titleText.x = Math.round(this.x + (this.width - w + 10) / 2);
	    this.titleText.y = Math.round(this.y + 5);

	    var tx:Number = this.x;
	    var ty:Number = this.y;
	    this.sprite.graphics.clear();
	    if (w != 0 || h != 0) {
		this.sprite.graphics.lineStyle(0, 0, 0);
		this.sprite.graphics.beginFill(this.color, 1);
		this.sprite.graphics.drawRoundRect(tx, ty, this.width, this.height, this.cornerRadius, this.cornerRadius);
		this.sprite.graphics.endFill();
	    }
	}

	public function set callback(cb:Function):void {
	    this._callback = cb;
	    if (this._callback != null)
		this.sprite.addEventListener(MouseEvent.CLICK, this._callback);

	}

	public function set titleString(t:String):void {
	    this.titleText.text = t;
	    this.titleText.setTextFormat(this.titleFormat);
	    this.width = this.titleText.textWidth + 20;
	    this.height = 25;
	    this.needUpdate = true;
	}

    }
	
}