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
	
    import Engine.Objects.Utils;
    import flash.geom.*;
    import flash.display.*;
    import flash.text.*;
    import flash.events.MouseEvent;

    public class LengthWidget extends Widget{

	public var textColor:uint = 0xbbbbbb;
	public var width:Number;
	public var height:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	public var dx:Number;
	public var dy:Number;
	private var _value:Number = 1.5;
	public var minValue:Number = 0.3;
	public var maxValue:Number = 3;
	public var icon:Function;
	private var titleText:TextField;
	private var format:TextFormat;
	private var lengthRect:Rectangle;

	public function LengthWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, title:String = '', $icon:Function = null, right:Boolean = false, bottom:Boolean = false, $dx:Number = 0, $dy:Number = 0):void {
	    super(x, y, title);
	    this.width = w;
	    this.height = h;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    this.icon = $icon;
	    this.dx = $dx;
	    this.dy = $dy;
	    // title text
	    this.titleText = new TextField();
	    this.titleText.text = title;
	    this.titleText.selectable = false;
	    this.titleText.embedFonts = true;
	    format = new TextFormat("Small", 8, this.textColor);
	    format.align = TextFieldAutoSize.RIGHT;	    
	    this.titleText.setTextFormat(format);
	    this.sprite.addChild(this.titleText);
	    this.titleText.width = 0;

	    this.sprite.addEventListener(MouseEvent.CLICK, onClick);
	}

	protected override function draw():void {
	    this.sprite.graphics.clear();
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
		this.titleText.width = (this.titleText.textWidth + 13) * (ratio - 1);
		this.titleText.height = this.titleText.textHeight + 2;
		this.titleText.x = - this.titleText.width - 4;
		this.titleText.y = h - this.titleText.height + 2;
	    }
	    var tx:Number = this.x + ((ratio >=1 && ratio <=2) ? this.dx * (ratio - 1) : 0);
	    var ty:Number = this.y + ((ratio >=1 && ratio <=2) ? this.dy * (ratio - 1) : 0);
	    var wIcon:Number = (this.icon != null) ? h * 2 : 0;
	    var wTitle:Number = (ratio >= 1 && ratio <= 2) ? (ratio - 1) * this.titleText.width : 0;
	    if (this.rightAligned) {
		tx -= w;
	    } else {
		tx += wIcon + wTitle;
	    }
	    if (this.bottomAligned) {
		ty -= h;
	    }
	    this.titleText.x = Math.round(tx + this.titleText.x);
	    this.titleText.y = Math.round(ty + this.titleText.y);
	    if (w != 0 || h != 0) {
		var gradMatrix:Matrix = new Matrix();
		gradMatrix.createGradientBox(w, h, 0, tx, ty);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xaaaaaa, 0xffffff], [1, 1], [0x00, 0xff], gradMatrix);
		this.sprite.graphics.drawRoundRect(tx, ty, w, h, h, h);
		this.sprite.graphics.endFill();
		this.lengthRect = new Rectangle(tx, ty, w, h);
		gradMatrix.createGradientBox(w - 2, h - 2, 0, tx + 1, ty + 1);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x0, 0xffffff], [1, 1], [0x0, 0xff], gradMatrix);
		this.sprite.graphics.drawRoundRect(tx + 1, ty + 1, w - 2, h - 2, h - 2, h - 2);
		this.sprite.graphics.endFill();

		var tval:Number;
		tval = (this._value - this.minValue) / (this.maxValue - this.minValue);
		this.sprite.graphics.beginFill(0xdddddd, 1);
		this.sprite.graphics.moveTo(tx + h/2 - 3 + (w - h) * tval, ty + 3 + h);
		this.sprite.graphics.lineTo(tx + h/2 + (w - h) * tval, ty + h);
		this.sprite.graphics.lineTo(tx + h/2 + 3 + (w - h) * tval, ty + 3 + h);
		this.sprite.graphics.lineTo(tx + h/2 - 3 + (w - h) * tval, ty + 3 + h);
		this.sprite.graphics.endFill();
		if (this.icon != null) {
		    this.titleText.x -= h;
		    this.icon(this.sprite, tx - h, ty + h/2, h/2, 0x000000, 1);
		}
	    }
	}

	public function set value(v:Number):void {
	    this._value = v;
	}

	public function get value():Number {
	    return this._value;
	}

	private function onClick(e:MouseEvent):void {
	    var p:Point = new Point(e.stageX, e.stageY);
	    if (this.lengthRect.containsPoint(p)) {
		this._value = (e.stageX - this.lengthRect.x) / this.lengthRect.width * (this.maxValue - this.minValue) + this.minValue;
	    }
	    this.needUpdate = true;
	}

    }
	
}