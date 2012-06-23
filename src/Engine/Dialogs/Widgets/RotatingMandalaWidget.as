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

    public class RotatingMandalaWidget extends Widget{

	private var N:int = 5;
	private var kdr:Array = [36, 28, 28, 20, 28];
	private var kfi:Array = [-2.5, 3.1, -2.7, 3.2, -2.];
	private var kdx:Array = [-20, 0, 20, -30, -30];
	private var kdy:Array = [-30, -40, 30, -50, -10];
	private var kdfi:Array = [0, 0, 42, 96, 244];
	private var kr:Array = [140, 130, 120, 100, 90];
	private var mcx:Array = [0, 0, 0, 0, 0];
	private var mcy:Array = [0, 0, 0, 0, 0];
	//private var colors:Array = [0xDDD7D0, 0x0022CC, 0xD0B700, 0xDD1100, 0x00CC11];
	private var colors:Array = [0x66BB66, 0x7777BB, 0xEECC44, 0xBB5555, 0xCCCCCC];
	private var titleStrings:Array = ["Mandala", "of", "the", "Interpenetrating", "Lights"];
	private var titleMapping:Array = [0, 3, 4, 1, 2];
	private var counter:int = 0;
	private var titleText:Array;
	private var titleFormat:Array;

	public function RotatingMandalaWidget(x:Number = 0, y:Number = 0):void {
	    super(x, y, '');
	    this.titleText = new Array();
	    this.titleFormat = new Array();
	    for (var i:int = 0; i < N; i++) {
		this.titleFormat[i] = new TextFormat("Huge", 8, colors[titleMapping[i]]);
		this.titleFormat[i].align = TextFieldAutoSize.CENTER;	    
		this.titleText[i] = new TextField();
		this.titleText[i].text = titleStrings[i];
		this.titleText[i].selectable = false;
		this.titleText[i].embedFonts = true;
		this.titleText[i].wordWrap = false;
		this.titleText[i].width = 0;
		this.titleText[i].x = x;
		this.titleText[i].y = y - 180 + i * 20;
		this.titleText[i].setTextFormat(this.titleFormat[i]);
		this.sprite.addChild(this.titleText[i]);
	    }
	}

	public override function update():void {
	    if (this.transValue > 0) {
		this.needUpdate = true;
	    }
	    for (var i:int = 0; i < N; i++) {
		mcx[i] = kdr[i] * Math.cos(kfi[i] * (counter + kdfi[i]) * Math.PI / 180) + kdx[i];
		mcy[i] = -kdr[i] * Math.sin(kfi[i] * (counter + kdfi[i]) * Math.PI / 180) + kdy[i];
	    }
	    counter++;
	    super.update();
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    var zoom:Number = ratio; 
	    var alpha:Number = 0;
	    if (ratio < 1) {
		//alpha = 0;
	    } else {
		zoom = 1;
	    }
	    alpha = ratio / 5;
	    this.sprite.graphics.clear();
	    for (var i:int = 0; i < N; i++) {
		this.sprite.graphics.lineStyle(2, this.colors[i], alpha * 1.5);
		this.sprite.graphics.beginFill(this.colors[i], alpha);
		this.sprite.graphics.drawCircle(mcx[i] + this.x, mcy[i] + this.y, kr[i] * zoom);
		this.sprite.graphics.endFill();
		if (ratio > 1) {
		    this.titleText[i].width = (this.titleText[i].textWidth + 10) * (2 - ratio);
		} else {
		    this.titleText[i].width = (this.titleText[i].textWidth + 10) * zoom;
		}
		this.titleText[i].x = Math.round(mcx[titleMapping[i]] - this.titleText[i].textWidth / 2) + this.x;
	    }
	}

    }
	
}