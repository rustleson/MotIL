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
	
    import Engine.Stats.GenericStats;
    import Engine.Dialogs.Widgets.*;
    import flash.events.MouseEvent;

    public class HelpDialog extends Dialog{

	private var _state:String = 'hidden';
	public var topics:Array = new Array();
	public var activeTopic:int = 5;
	private var manual:Manual = new Manual();

	public function HelpDialog(w:Number, h:Number):void {
	    super(w, h);
	    this.sprite = Main.helpSprite;
	    this.widgets['panel'] = new PanelWidget(5, 7, w - 10, h - 10, w - 10, h - 10, 0x222222, 'Hyper Enlightened Liberty Prerequisites (HELP)');
	    this.widgets['topic'] = new TopicWidget(15, 36, w - 30, h - 40, w - 30, h - 50, 0x111111);
	    // parse manual
	    var lines:Array = this.manual.toString().split(/\n/);
	    var topicIndex:int = -1;
	    for (var i:int = 0; i < lines.length; i++) {
		if (lines[i].substr(0, 3) == '===') {
		    // topic detected
		    topicIndex++;
		    var topic:Object = new Object();
		    topic['title'] = lines[i + 1];
		    topic['content'] = '';
		    this.topics.push(topic);
		    i += 4;
		}
		if (topicIndex >= 0) {
		    this.topics[topicIndex].content += lines[i] + "\n";
		}
	    }
	    this.widgets['topicswitch'] = new TopicSwitchWidget(this, 15, 25, w, h, 0x999999, false);
	    this.widgetsOrder = ['panel', 'topicswitch', 'topic' ];
	    //this.toggleHide();
	}

	private function trim(s:String):String {
	    return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
	}

	public function toggleHide():void {
	    if (!this.widgets.panel.transitionComplete)
	    	return;
	    var widget:Widget;
	    var widgetName:String;
	    if (this._state == 'hidden') {
		this._state = 'visible';
		this.widgets.panel.large();
		this.widgets.topicswitch.large();
		this.widgets.topic.show(new Message(this.topics[this.activeTopic].content, this.topics[this.activeTopic].title));
	    } else {
		this._state = 'hidden';
		for each (widgetName in this.widgetsOrder) {
		    widget = widgets[widgetName];
		    widget.hidden();
		}		
	    }
	}

	public function get state():String {
	    return this._state;
	}

    }
	
}