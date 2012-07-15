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
	private var rex:Array = [0, 150, 180, -180, -150];
	private var rey:Array = [-180, -90, 70, 70, -90];
	private var reR:Number = 50;
	private var reRB:Number = 120;
	//private var colors:Array = [0xDDD7D0, 0x0022CC, 0xD0B700, 0xDD1100, 0x00CC11];
	private var colors:Array = [0x66BB66, 0x7777BB, 0xEECC44, 0xBB5555, 0xCCCCCC];
	private var types:Array = [WorldRoom.AIR_TYPE, WorldRoom.WATER_TYPE, WorldRoom.EARTH_TYPE, WorldRoom.FIRE_TYPE, WorldRoom.SPACE_TYPE];
	private var icons:Array = [Icons.Air, Icons.Water, Icons.Earth, Icons.Fire, Icons.Space];
	private var titleStrings:Array = ["Mandala", "of", "the", "Interpenetrating", "Lights"];
	private var titleMapping:Array = [0, 3, 4, 1, 2];
	private var counter:int = 0;
	private var titleText:Array;
	private var titleFormat:Array;
	public var realmSelected:Boolean;
	public var activeRealm:int = -1;

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
	    alpha = ratio / 5;
	    this.sprite.graphics.clear();
	    if (this.activeRealm >= 0 && ratio >= 3) {
		var gradMatrix:Matrix = new Matrix();
		var gradX:Number = this.getGradX(this.activeRealm);
		var gradY:Number = this.getGradY(this.activeRealm);
		var gradR:Number = this.getGradR(this.activeRealm);
		gradMatrix.createGradientBox(gradR * 2, gradR * 2, 0, gradX - gradR, gradY - gradR);
		this.sprite.graphics.beginGradientFill(GradientType.RADIAL, [0x0, 0x0, 0x0], [0, 0, 1], [0, 0xfd, 0xff], gradMatrix);
	    } else {
		this.sprite.graphics.beginFill(0x0, 1);
	    }
	    this.sprite.graphics.drawRect(0, 0, Main.appWidth, Main.appHeight);
	    this.sprite.graphics.endFill();
	    for (var i:int = 0; i < N; i++) {
		this.sprite.graphics.lineStyle(2, this.colors[i], alpha * 1.5);
		if (ratio <= 3) {
		    this.sprite.graphics.beginFill(this.colors[i], alpha * ((this.activeRealm >= 0 && i == this.activeRealm) ? 0.5 : 1));
		} else {
		    this.sprite.graphics.beginFill(this.colors[i], alpha * (4 - ratio));
		}
		if (ratio <= 2) {
		    this.sprite.graphics.drawCircle(mcx[i] + this.x, mcy[i] + this.y, kr[i] * zoom);
		} else if (ratio <= 4) {
		    this.sprite.graphics.drawCircle(this.getGradX(i), this.getGradY(i), this.getGradR(i));
		}
		this.sprite.graphics.endFill();
		if (ratio == 3) {
		    this.icons[i](this.sprite, this.getGradX(i), this.getGradY(i), this.getGradR(i) / 2, this.colors[i], this.getGradR(i) / 10, 0.7);
		}
		if (ratio > 1) {
		    this.titleText[i].width = (this.titleText[i].textWidth + 10) * (2 - ratio);
		} else {
		    this.titleText[i].width = (this.titleText[i].textWidth + 10) * zoom;
		}
		if (ratio >= 2) {
		    this.titleText[i].visible = false;
		} else {
		    this.titleText[i].visible = true;
		}
		this.titleText[i].x = Math.round(mcx[titleMapping[i]] - this.titleText[i].textWidth / 2) + this.x;
	    }
	}

	public override function hidden(timeout:int = 0):void {
	    if (this.state == 'realm')
		this.transition('hidden', 20, 3, 0, timeout);
	    if (this.state == 'tribe')
		this.transition('hidden', 40, 4, 0, timeout);
	    super.hidden();
	}

 	public override function large(timeout:int = 0):void {
	    if (this.state == 'hidden' || this.state == '')
		this.transition('large', 20, 0, 2, timeout);
	    if (this.state == 'small')
		this.transition('large', 15, 1, 2, timeout);
	    if (this.state == 'realm')
		this.transition('large', 15, 3, 2, timeout);
	}

 	public function realm(timeout:int = 0):void {
	    if (this.state == 'small')
		this.transition('realm', 15, 2, 3, timeout);
	    if (this.state == 'large')
		this.transition('realm', 15, 2, 3, timeout);
	    if (this.state == 'tribe')
		this.transition('realm', 15, 4, 3, timeout);
	}

 	public function tribe(timeout:int = 0):void {
	    if (this.state == 'realm')
		this.transition('tribe', 15, 3, 4, timeout);
	}

 	public function fadeout(timeout:int = 0):void {
	    if (this.state == 'tribe')
		this.transition('fadeout', 15, 4, 5, timeout);
	}

	private function onClick(e:MouseEvent):void {
	    this.onMouseMove(e);
	    if (this.activeRealm >= 0) {
		this.realmSelected = true;
		this.tribe();
	    }
	}

	private function onMouseMove(e:MouseEvent):void {
	    if (this.transValue2 >= 3) {
		for (var i:int = 0; i < N; i++) {
		    var x:Number = this.getGradX(i);
		    var y:Number = this.getGradY(i);
		    var r:Number = this.getGradR(i);
		    if ((e.stageX - x) * (e.stageX - x) + (e.stageY - y) * (e.stageY - y) <= r * r) {
			this.activeRealm = i;
			return;
		    }
		}
	    }
	    if (this.transValue2 <= 3) {
		this.activeRealm = -1;
	    }
	}
	    
	private function onMouseOut(e:MouseEvent):void {
	    if (!this.realmSelected && this.transValue2 <= 3) {
		this.activeRealm = -1;
	    }
	}
	 
	private function getGradX(i:int):Number {
	    var ratio:Number = this.transValue2;
	    if (ratio <= 3) {
		return (rex[i] - mcx[i]) * (ratio - 2.1) + mcx[i] + this.x;
	    } else if (ratio <= 4 && this.activeRealm == i) {
		return ((rex[i] - mcx[i]) * 0.9 + mcx[i] + this.x - Main.appWidth/2) * (4 - ratio) + Main.appWidth/2;
	    } else if (ratio > 4) {
		return Main.appWidth/2;
	    } else {
		return (rex[i] - mcx[i]) * 0.9 + mcx[i] + this.x;
	    }
	}

	private function getGradY(i:int):Number {
	    var ratio:Number = this.transValue2;
	    if (ratio <= 3) {
		return (rey[i] - mcy[i]) * (ratio - 2.1) + mcy[i] + this.y;
	    } else if (ratio <= 4 && this.activeRealm == i) {
		return ((rey[i] - mcy[i]) * 0.9 + mcy[i] + this.y - Main.appHeight/2) * (4 - ratio) + Main.appHeight/2;
	    } else if (ratio > 4) {
		return Main.appHeight/2;
	    } else {
		return (rey[i] - mcy[i]) * 0.9 + mcy[i] + this.y;
	    }
	}

	private function getGradR(i:int):Number {
	    var ratio:Number = this.transValue2;
	    if (ratio <= 3) {
		return (reR - kr[i]) * (ratio - 2) + kr[i];
	    } else if (ratio <= 4 && this.activeRealm == i) {
		return (reR - reRB) * (4 - ratio) + reRB;
	    } else if (ratio <= 5 && this.activeRealm == i) {
		return reRB * (5 - ratio);
	    } else {
		return reR * (4 - ratio);
	    }
	}
	
	public function get realmType():uint {
	    if (this.activeRealm >= 0) {
		return this.types[this.activeRealm];
	    }
	    return 0;
	}

   }
	
}