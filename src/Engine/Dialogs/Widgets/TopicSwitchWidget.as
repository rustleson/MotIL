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
    import Engine.Dialogs.HelpDialog;
    import flash.events.MouseEvent;

    public class TopicSwitchWidget extends Widget{

	public var dialog:HelpDialog;
	public var widthLarge:Number;
	public var heightLarge:Number;
	public var rightAligned:Boolean;
	public var bottomAligned:Boolean;
	public var cornerRadius:Number = 10;
	private var topicTexts:Array = new Array();
	private var titleFormat:TextFormat;
	private var activeTitleFormat:TextFormat;
	public var bgColor:uint;
	public var activeColor:uint;
	public var textColor:uint = 0xeeeeee;

	public function TopicSwitchWidget(d:HelpDialog, x:Number = 0, y:Number = 0, w:int = 0, h:int = 0, c:uint = 0, right:Boolean = false, bottom:Boolean = false):void {
	    super(x, y, '');
	    this.dialog = d;
	    this.widthLarge = w;
	    this.heightLarge = h;
	    this.textColor = c;
	    this.rightAligned = right;
	    this.bottomAligned = bottom;
	    this.bgColor = Utils.colorDark(c, 0.5);
	    this.activeColor = Utils.colorLight(c, 0.5);
	    this.titleFormat = new TextFormat("Large", 8, this.textColor);
	    this.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.activeTitleFormat = new TextFormat("Large", 8, this.activeColor);
	    this.activeTitleFormat.align = TextFieldAutoSize.RIGHT;	    
	    for (var i:int = 0; i < this.dialog.topics.length; i++) {
		var titleText:TextField = new TextField();
		titleText.text = this.dialog.topics[i].title;
		titleText.selectable = false;
		titleText.embedFonts = true;
		titleText.setTextFormat(this.titleFormat);
		this.topicTexts.push(titleText);
		this.sprite.addChild(this.topicTexts[i]);
		this.topicTexts[i].addEventListener(MouseEvent.CLICK, onClick);
	    }
	}

	protected override function draw():void {
	    var ratio:Number = this.transValue2;
	    var tx:int = this.x;
	    var ty:int = this.y;
	    var curX:int = 4;
	    var i:int = 0;
	    for each (var titleText:TextField in this.topicTexts) {
		titleText.width = (titleText.textWidth + 3) * ratio / 2;
		titleText.height = titleText.textHeight + 2;
		titleText.x = curX;
		titleText.y = -6;
		curX += titleText.width + 9;
		if (i == this.dialog.activeTopic) {
		    titleText.setTextFormat(this.activeTitleFormat);
		} else {
		    titleText.setTextFormat(this.titleFormat);
		}
		i++;
	    }
	    var width:Number = curX;
	    var height:Number = titleText.textHeight + 2;
	    if (this.rightAligned) {
		tx -= width;
	    }
	    if (this.bottomAligned) {
		ty -= height;
	    }
	    this.sprite.graphics.clear();
	    i = 0;
	    for each (titleText in this.topicTexts) {
		if (titleText.width > 0) {
		    titleText.x = Math.round(tx + titleText.x + 2);
		    titleText.y = Math.round(ty + titleText.y);
		    this.sprite.graphics.lineStyle(0, 0, 0);
		    if (i == this.dialog.activeTopic) {
			this.sprite.graphics.beginFill(Utils.colorLight(this.bgColor, 0.1), 1);
			this.sprite.graphics.drawRoundRect(titleText.x - 2, titleText.y + 1, titleText.width + 4, titleText.height + 4, 5, 5);
		    } else {
			this.sprite.graphics.beginFill(this.bgColor, 1);
			this.sprite.graphics.drawRoundRect(titleText.x - 2, titleText.y + 1, titleText.width + 4, titleText.height, 5, 5);
		    }
		    this.sprite.graphics.endFill();
		}
		i++
	    }
	}

	private function onClick(e:MouseEvent):void {
	    var i:int = 0;
	    for each (var topic:Object in this.dialog.topics) {
		if (topic.title == e.target.text) {
		    this.dialog.activeTopic = i;
		    break;
		}
		i++;
	    }
	    this.dialog.widgets.topic.show(new Message(this.dialog.topics[this.dialog.activeTopic].content, this.dialog.topics[this.dialog.activeTopic].title));
	    this.needUpdate = true;
	}


    }

}