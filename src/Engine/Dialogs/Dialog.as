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

package Engine.Dialogs {
	
    import Engine.Dialogs.Widgets.Widget;
    import flash.display.*;

    public class Dialog {

	public var sprite:Sprite; 
	public var widgets:Object; 
	public var widgetsOrder:Array; 
	public var appWidth:Number; 
	public var appHeight:Number; 

	public function Dialog(w:Number, h:Number):void {
	    this.sprite = new Sprite();
	    this.widgets = new Object();
	    this.widgetsOrder = new Array();
	    this.appWidth = w;
	    this.appHeight = h;
	}

	public function update():void {
	    for each (var widgetName:String in this.widgetsOrder) {
		var widget:Widget = this.widgets[widgetName];
		widget.update();
		widget.sprite.visible = (widget.state != '' && (widget.state != 'hidden' || !widget.transitionComplete));
	    }
	}

	public function rebuild():void {
	    for each (var widgetName:String in this.widgetsOrder) {
		var widget:Widget = widgets[widgetName];
		widget.update();
		widget.sprite.visible = true;
		if (!this.sprite.contains(widget.sprite)) {
		    this.sprite.addChild(widget.sprite);
		}
	    }
	    for each (widgetName in this.widgetsOrder) {
		widget = widgets[widgetName];
		if (!this.sprite.contains(widget.tooltipSprite)) {
		    this.sprite.addChild(widget.tooltipSprite);
		}
	    }
	}

	public function destroy():void {
	    this.sprite.graphics.clear();
	    for each (var widgetName:String in this.widgetsOrder) {
		this.widgets[widgetName].destroy();
		delete this.widgets[widgetName];
	    }
	    while(this.sprite.numChildren > 0) {   
		this.sprite.removeChildAt(0); 
	    }
	}

    }
	
}