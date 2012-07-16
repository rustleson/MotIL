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

    public class ColorWidget extends Widget{

	public var textColor:uint = 0xbbbbbb;
	public var width:Number;
	public var height:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	public var dx:Number;
	public var dy:Number;
	private var _color:uint = 0;
	private var _hue:int = 0;
	private var _brightness:Number = 0.1;
	public var minBrightness:Number = 0.1;
	public var maxBrightness:Number = 0.7;
	public var icon:Function;
	private var hueText:TextField;
	private var brightnessText:TextField;
	private var format:TextFormat;
	private var hueRect:Rectangle;
	private var brightnessRect:Rectangle;

	public function ColorWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, title:String = '', $icon:Function = null, right:Boolean = false, bottom:Boolean = false, $dx:Number = 0, $dy:Number = 0):void {
	    super(x, y, title);
	    this.width = w;
	    this.height = h;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    this.icon = $icon;
	    this.dx = $dx;
	    this.dy = $dy;
	    // hue text
	    this.hueText = new TextField();
	    this.hueText.text = title + " Color";
	    this.hueText.selectable = false;
	    this.hueText.embedFonts = true;
	    format = new TextFormat("Small", 8, this.textColor);
	    format.align = TextFieldAutoSize.RIGHT;	    
	    this.hueText.setTextFormat(format);
	    this.sprite.addChild(this.hueText);
	    // value text
	    this.brightnessText = new TextField();
	    this.brightnessText.text = "Brightness";
	    this.brightnessText.selectable = false;
	    this.brightnessText.embedFonts = true;
	    format = new TextFormat("Small", 8, this.textColor);
	    format.align = TextFieldAutoSize.RIGHT;	    
	    this.brightnessText.setTextFormat(format);
	    this.sprite.addChild(this.brightnessText);

	    this.hueText.width = 0;
	    this.brightnessText.width = 0;

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
		this.brightnessText.width = 0;
		this.brightnessText.height = 0;
		this.hueText.width = 0;
		this.hueText.height = 0;
	    } else if (ratio <= 2) {
		w = this.width;
		h = this.height;
		this.hueText.width = (this.hueText.textWidth + 13) * (ratio - 1);
		this.hueText.height = this.hueText.textHeight + 2;
		this.hueText.x = - this.hueText.width - 4;
		this.hueText.y = h - this.hueText.height + 2;
		this.brightnessText.width = (this.brightnessText.textWidth + 13) * (ratio - 1);
		this.brightnessText.height = this.brightnessText.textHeight + 2;
		this.brightnessText.x = - this.brightnessText.width - 4;
		this.brightnessText.y = h - this.brightnessText.height + 2 + 15;
	    }
	    var tx:Number = this.x + ((ratio >=1 && ratio <=2) ? this.dx * (ratio - 1) : 0);
	    var ty:Number = this.y + ((ratio >=1 && ratio <=2) ? this.dy * (ratio - 1) : 0);
	    var wIcon:Number = (this.icon != null) ? h * 2 : 0;
	    var wHue:Number = (ratio >= 1 && ratio <= 2) ? (ratio - 1) * this.hueText.width : 0;
	    var wBrightness:Number = (ratio >= 1 && ratio <= 2) ? (ratio - 1) * this.brightnessText.width : 0;
	    if (this.rightAligned) {
		tx -= w;
	    } else {
		tx += wIcon + Math.max(wHue, wBrightness);
	    }
	    if (this.bottomAligned) {
		ty -= h;
	    }
	    this.brightnessText.x = Math.round(tx + this.brightnessText.x);
	    this.brightnessText.y = Math.round(ty + this.brightnessText.y);
	    this.hueText.x = Math.round(tx + this.hueText.x);
	    this.hueText.y = Math.round(ty + this.hueText.y);
	    if (w != 0 || h != 0) {
		var gradMatrix:Matrix = new Matrix();
		gradMatrix.createGradientBox(w, h, 0, tx, ty);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xaaaaaa, 0xffffff], [1, 1], [0x00, 0xff], gradMatrix);
		this.sprite.graphics.drawRoundRect(tx, ty, w, h, h, h);
		this.sprite.graphics.endFill();
		this.hueRect = new Rectangle(tx, ty, w, h);
		gradMatrix.createGradientBox(w - 2, h - 2, 0, tx + 1, ty + 1);
		var gradColors:Array = new Array();
		var gradRatios:Array = new Array();
		for (var i:int = 0; i <= 6; i++) {
		    gradColors.push(Utils.HSLtoRGB(i * 60, 0.85, 0.5));
		    gradRatios.push(Math.round(0xff * i / 6));
		}
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, gradColors, [1, 1, 1, 1, 1, 1, 1], gradRatios, gradMatrix);
		this.sprite.graphics.drawRoundRect(tx + 1, ty + 1, w - 2, h - 2, h - 2, h - 2);
		this.sprite.graphics.endFill();

		gradMatrix = new Matrix();
		gradMatrix.createGradientBox(w, h, 0, tx, ty);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xaaaaaa, 0xffffff], [1, 1], [0x00, 0xff], gradMatrix);
		this.sprite.graphics.drawRoundRect(tx, ty + 15, w, h, h, h);
		this.sprite.graphics.endFill();
		this.brightnessRect = new Rectangle(tx, ty + 15, w, h);
		gradMatrix.createGradientBox(w - 2, h - 2, 0, tx + 1, ty + 1);
		this.sprite.graphics.beginGradientFill(GradientType.LINEAR, [Utils.HSLtoRGB(this._hue, 0.85, this.minBrightness), Utils.HSLtoRGB(this._hue, 0.85, 0.5), Utils.HSLtoRGB(this._hue, 0.85, this.maxBrightness)], [1, 1, 1], [0x00, 0x7f, 0xff], gradMatrix);
		this.sprite.graphics.drawRoundRect(tx + 1, ty + 1 + 15, w - 2, h - 2, h - 2, h - 2);
		this.sprite.graphics.endFill();
		
		var tval:Number;
		tval = this._hue / 360;
		this.sprite.graphics.beginFill(0xdddddd, 1);
		this.sprite.graphics.moveTo(tx + h/2 - 3 + (w - h) * tval, ty + 3 + h);
		this.sprite.graphics.lineTo(tx + h/2 + (w - h) * tval, ty + h);
		this.sprite.graphics.lineTo(tx + h/2 + 3 + (w - h) * tval, ty + 3 + h);
		this.sprite.graphics.lineTo(tx + h/2 - 3 + (w - h) * tval, ty + 3 + h);
		this.sprite.graphics.endFill();
		tval = (this._brightness - this.minBrightness) / (this.maxBrightness - this.minBrightness);
		this.sprite.graphics.beginFill(0xdddddd, 1);
		this.sprite.graphics.moveTo(tx + h/2 - 3 + (w - h) * tval, ty + 3 + h + 15);
		this.sprite.graphics.lineTo(tx + h/2 + (w - h) * tval, ty + h + 15);
		this.sprite.graphics.lineTo(tx + h/2 + 3 + (w - h) * tval, ty + 3 + h + 15);
		this.sprite.graphics.lineTo(tx + h/2 - 3 + (w - h) * tval, ty + 3 + h + 15);
		this.sprite.graphics.endFill();
		if (this.icon != null) {
		    this.hueText.x -= h;
		    this.icon(this.sprite, tx - h, ty + h/2, h/2, 0x000000, 1);
		}
	    }
	}

	public function set color(v:uint):void {
	    // TODO parse hue/brightness from uint
	}

	public function set hue(v:int):void {
	    this._hue = v;
	    this._color = Utils.HSLtoRGB(this._hue, 0.85, this._brightness);
	}

	public function set brightness(v:Number):void {
	    this._brightness = v;
	    this._color = Utils.HSLtoRGB(this._hue, 0.85, this._brightness);
	}

	public function get color():uint {
	    return this._color;
	}

	private function onClick(e:MouseEvent):void {
	    var p:Point = new Point(e.stageX, e.stageY);
	    if (this.hueRect.containsPoint(p)) {
		this._hue = Math.round((e.stageX - this.hueRect.x) / this.hueRect.width * 360);
	    } else if (this.brightnessRect.containsPoint(p)) {
		this._brightness = (e.stageX - this.hueRect.x) / this.hueRect.width * (this.maxBrightness - this.minBrightness) + this.minBrightness;
	    }
	    this._color = Utils.HSLtoRGB(this._hue, 0.85, this._brightness);
	    this.needUpdate = true;
	}

    }
	
}