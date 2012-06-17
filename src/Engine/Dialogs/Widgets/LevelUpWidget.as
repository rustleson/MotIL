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

    public class LevelUpWidget extends Widget{

	public var color:uint;
	public var width:Number;
	public var height:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	private var _callback:Function;
	public var dx:Number;
	public var dy:Number;

	public function LevelUpWidget(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, cb:Function = null,
				    c:uint = 0, title:String = '', right:Boolean = false, bottom:Boolean = false, $dx:Number = 0, $dy:Number = 0):void {
	    super(x, y, title);
	    this.width = w;
	    this.height = h;
	    this.color = c;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    this.callback = cb;
	    this.dx = $dx;
	    this.dy = $dy;
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    var w:Number = this.width;
	    var h:Number = this.height;
	    if (ratio < 1) {
		w *= ratio;
		h *= ratio;
	    } 
	    var tx:Number = this.x + ((ratio >=1 && ratio <=2) ? this.dx * (ratio - 1) : 0);
	    var ty:Number = this.y + ((ratio >=1 && ratio <=2) ? this.dy * (ratio - 1) : 0);
	    if (this.rightAligned) {
		tx -= w;
	    }
	    if (this.bottomAligned) {
		ty -= h;
	    }
	    this.sprite.graphics.clear();
	    if (this.width != 0 || this.height != 0) {
		this.sprite.graphics.lineStyle(1, this.color, 1);
		this.sprite.graphics.beginFill(Utils.colorDark(this.color, 0.5), 1);
		this.sprite.graphics.drawEllipse(tx, ty , w, h);
		this.sprite.graphics.endFill();
		this.sprite.graphics.lineStyle(0, 0, 0);
		this.sprite.graphics.beginFill(this.color, 1);
		this.sprite.graphics.drawRect(tx + w/2 - 0.5, ty + h/2 - h*2.5/8, 1, h*2.5/4);
		this.sprite.graphics.endFill();
		this.sprite.graphics.beginFill(this.color, 1);
		this.sprite.graphics.drawRect(tx + w/2 - w*2.5/8, ty + h/2 - 0.5, w*2.5/4, 1);
		this.sprite.graphics.endFill();
	    }
	}

	public function set callback(cb:Function):void {
	    this._callback = cb;
	    if (this._callback != null)
		this.sprite.addEventListener(MouseEvent.CLICK, this._callback);

	}

    }
	
}