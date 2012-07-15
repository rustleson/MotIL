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
    import Engine.Worlds.WorldRoom;
    import flash.text.*;
    import flash.geom.Matrix;
    import flash.display.GradientType;

    public class TribesWidget extends Widget{

	private var N:int = 3;
	private var kdr:Array = [5, 5, 5];
	private var kfi:Array = [-2.5, 3.1, -2.7];
	private var kdx:Array = [0, 150, -150];
	private var kdy:Array = [-190, -120, -120];
	private var kdfi:Array = [23, 32, 42];
	private var kr:Array = [30, 30, 30];
	private var mcx:Array = [0, 0, 0];
	private var mcy:Array = [0, 0, 0];
	private var colors:Array = [WorldRoom.PURITY_TYPE, WorldRoom.BALANCE_TYPE, WorldRoom.CORRUPTION_TYPE];
	private var icons:Array = [Icons.Pleasure, Icons.KarmaInversed, Icons.Pain];
	private var titleStrings:Array = ["Dakini", "Yakshini", "Rakshasi"];
	private var titleMapping:Array = [0, 1, 2];
	private var counter:int = 0;
	private var titleText:Array;
	private var titleFormat:Array;
	public var tribeSelected:Boolean;
	public var activeTribe:int = 0;

	public function TribesWidget(x:Number = 0, y:Number = 0):void {
	    super(x, y, '');
	    this.titleText = new Array();
	    this.titleFormat = new Array();
	    for (var i:int = 0; i < N; i++) {
		this.titleFormat[i] = new TextFormat("Medium", 8, 0xaaaaaa);
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
	    this.sprite.addEventListener(MouseEvent.CLICK, onClick);
	    this.sprite.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	    this.sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
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
	    alpha = ratio / 2;
	    this.sprite.graphics.clear();
	    if (ratio > 0) {
		for (var i:int = 0; i < N; i++) {
		    this.sprite.graphics.lineStyle(2, this.colors[i], alpha * 1.5);
		    this.sprite.graphics.beginFill(this.colors[i], alpha);
		    this.sprite.graphics.drawCircle(mcx[i] + this.x, mcy[i] + this.y, kr[i] * zoom);
		    this.sprite.graphics.endFill();
		    this.icons[i](this.sprite, this.getGradX(i), this.getGradY(i), this.getGradR(i) / 2, this.colors[i], this.getGradR(i) / 10, 0.7);
		    this.titleText[i].width = kr[i] * 3 * zoom;
		    this.titleText[i].x = Math.round(mcx[i] - kr[i] * 1.5 * zoom) + this.x;
		    this.titleText[i].y = Math.round(mcy[i] + kr[i] * zoom + 10) + this.y;
		}
	    }
	}

	private function onClick(e:MouseEvent):void {
	    this.onMouseMove(e);
	    if (this.activeTribe > 0) {
		this.tribeSelected = true;
		this.hidden();
	    }
	}

	private function onMouseMove(e:MouseEvent):void {
	    if (this.transValue2 >= 1) {
		for (var i:int = 0; i < N; i++) {
		    var x:Number = this.getGradX(i);
		    var y:Number = this.getGradY(i);
		    var r:Number = this.getGradR(i);
		    if ((e.stageX - x) * (e.stageX - x) + (e.stageY - y) * (e.stageY - y) <= r * r) {
			this.activeTribe = i + 1;
			return;
		    }
		}
	    }
	    if (this.transValue2 < 1 && !this.tribeSelected) {
		this.activeTribe = 0;
	    }
	}
	    
	private function onMouseOut(e:MouseEvent):void {
	    if (!this.tribeSelected) {
		this.activeTribe = 0;
	    }
	}
	 
	private function getGradX(i:int):Number {
	    return mcx[i] + this.x;
	}

	private function getGradY(i:int):Number {
	    return mcy[i] + this.y;
	}

	private function getGradR(i:int):Number {
	    return kr[i] * Math.min(1, this.transValue2);
	}
	
   }
	
}