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

    public class MainStatsDialog extends Dialog{

	private var _mode:String = 'hide';
	private var _state:String = 'small';
	private var visibleWidgets:Array;
	private var levelupWidgets:Array;
	private var _upgradeAvailable:Boolean = false;

	public function MainStatsDialog(w:Number, h:Number):void {
	    super(w, h);
	    this.widgets['panel'] = new PanelWidget(w - 5, 5, 124, 96, w - 10, h - 10, 0x333333, '', true);
	    this.widgets['panel'].rBlend = 400;
	    this.widgets['space'] = new PercentWidget(w - 12, 24, 102, 6, GenericStats.decodeColor(GenericStats.SPACE_COLOR), 'Space', Icons.Space, true, false, 0, 172);
	    this.widgets['water'] = new PercentWidget(w - 12, 36, 102, 6, GenericStats.decodeColor(GenericStats.WATER_COLOR), 'Water', Icons.Water, true, false, 0, 172);
	    this.widgets['earth'] = new PercentWidget(w - 12, 48, 102, 6, GenericStats.decodeColor(GenericStats.EARTH_COLOR), 'Earth', Icons.Earth, true, false, 0, 172);
	    this.widgets['fire'] = new PercentWidget(w - 12, 60, 102, 6, GenericStats.decodeColor(GenericStats.FIRE_COLOR), 'Fire', Icons.Fire, true, false, 0, 172);
	    this.widgets['air'] = new PercentWidget(w - 12, 72, 102, 6, GenericStats.decodeColor(GenericStats.AIR_COLOR), 'Air', Icons.Air, true, false, 0, 172);
	    this.widgets['karma'] = new KarmaWidget(w - 12, 84, 102, 6, 'Karma', Icons.Karma, true, false, 0, 172);
	    this.widgets['pain'] = new PercentWidget(w - 150, 12, 102, 6, 0x8855ff, 'Pain', Icons.Pain, true, false, -60);
	    this.widgets['pleasure'] = new PercentWidget(w - 280, 12, 102, 6, 0xff55dd, 'Bliss', Icons.Pleasure, true, false, -140);
	    this.widgets['level'] = new PercentWidget(w - 12, 12, 102, 6, 0xffdd55, 'Exp', Icons.Experience, true, false, 0);
	    this.widgets['levelup'] = new LevelUpWidget(w - 12, 10, 10, 10, levelupHandler, 0xffdd55, 'Level Up', true, false, -33);
	    this.widgets['maxpain'] = new PercentWidget(w - 210, 24, 102, 6, 0x8855ff, 'Treshold', Icons.Pain, true);
	    this.widgets['painres'] = new PercentWidget(w - 210, 36, 102, 6, 0x8855ff, 'Resist', Icons.Pain, true);
	    this.widgets['maxpleasure'] = new PercentWidget(w - 420, 24, 102, 6, 0xff55dd, 'Orgasm', Icons.Pleasure, true);
	    this.widgets['painresup'] = new LevelUpWidget(w - 210, 34, 10, 10, null, 0x8855ff, 'Level Up', true, false, -33);
	    this.widgets['arouse'] = new PercentWidget(w - 420, 36, 102, 6, 0xff55dd, 'Arouse', Icons.Pleasure, true);
	    this.widgets['arouseup'] = new LevelUpWidget(w - 420, 34, 10, 10, null, 0xff55dd, 'Level Up', true, false, -33);
	    this.widgets['constitution'] = new PercentWidget(w - 12, 24, 102, 6, 0xffdd55, 'Const', Icons.Experience, true);
	    this.widgets['constitutionup'] = new LevelUpWidget(w - 12, 22, 10, 10, null, 0xffdd55, 'Level Up', true, false, -33);
	    this.widgets['speed'] = new PercentWidget(w - 12, 36, 102, 6, 0xffdd55, 'Speed', Icons.Experience, true);
	    this.widgets['speedup'] = new LevelUpWidget(w - 12, 34, 10, 10, null, 0xffdd55, 'Level Up', true, false, -33);
	    this.widgets['pool'] = new PercentWidget(w - 12, 48, 102, 6, 0xffdd55, 'Pool', Icons.Experience, true, false, 0, 0, true);
	    this.widgets['points'] = new PercentWidget(w - 12, 60, 102, 6, 0xffdd55, 'Points', Icons.Experience, true, false, 0, 0, true);
	    this.widgets['age'] = new PercentWidget(w - 12, 72, 102, 6, 0xffdd55, 'Age', Icons.Experience, true, false, 0, 0, true);
	    this.widgets['mouthpanel'] = new PanelWidget(w - 255, 70, 130, 50, 130, 50, 0x474444, 'Mouth', true);
	    this.widgets['mouthslot'] = new ArtefactAttachedWidget(w - 250, 56, 130, 30);
	    this.widgets['mouthd'] = new PercentWidget(w - 255, 96, 75, 6, 0x552211, 'D:', null, true);
	    this.widgets['mouthl'] = new PercentWidget(w - 255, 108, 75, 6, 0x552211, 'L:', null, true);
	    this.widgets['vaginapanel'] = new PanelWidget(w - 255, 340, 130, 50, 130, 50, 0x474444, 'Vagina', true);
	    this.widgets['vaginaslot'] = new ArtefactAttachedWidget(w - 250, 326, 130, 30);
	    this.widgets['vaginad'] = new PercentWidget(w - 255, 366, 75, 6, 0x552211, 'D:', null, true);
	    this.widgets['vaginal'] = new PercentWidget(w - 255, 378, 75, 6, 0x552211, 'L:', null, true);
	    this.widgets['anuspanel'] = new PanelWidget(w - 255, 415, 130, 50, 130, 50, 0x474444, 'Anus', true);
	    this.widgets['anusslot'] = new ArtefactAttachedWidget(w - 250, 401, 130, 30);
	    this.widgets['anusd'] = new PercentWidget(w - 255, 441, 75, 6, 0x552211, 'D:', null, true);
	    this.widgets['anusl'] = new PercentWidget(w - 255, 453, 75, 6, 0x552211, 'L:', null, true);
	    this.widgets['rhandpanel'] = new PanelWidget(w - 430, 110, 130, 50, 130, 50, 0x474444, 'Right Hand', true);
	    this.widgets['rhandslot'] = new ArtefactAttachedWidget(w - 425, 96, 130, 30);
	    this.widgets['lhandpanel'] = new PanelWidget(430, 110, 130, 50, 130, 50, 0x474444, 'Left Hand', false);
	    this.widgets['lhandslot'] = new ArtefactAttachedWidget(565, 96, 130, 30);
	    this.widgets['artpanel'] = new PanelWidget(15, h - 15, 185, 260, 185, 260, 0x282828, 'Artefacts', false, true );
	    this.widgets['artpanel'].textColor = 0xbbbbbb;
	    this.widgets['mappanel'] = new PanelWidget(w - 10, h - 10, 70, 70, 190, 190, 0x111111, 'Map', true, true);
	    this.widgets['mappanel'].textColor = 0x999999;
	    this.widgets['map'] = new MapWidget(w - 15, h - 15, 60, 60, 180, 180, true, true);
	    this.widgets['wheel'] = new ArtefactWidget(25, 215, 175, 24);
	    this.widgets['vajra'] = new ArtefactWidget(25, 245, 175, 24);
	    this.widgets['jewel'] = new ArtefactWidget(25, 275, 175, 24);
	    this.widgets['lotus'] = new ArtefactWidget(25, 305, 175, 24);
	    this.widgets['sword'] = new ArtefactWidget(25, 335, 175, 24);
	    this.widgets['chastityBelt'] = new ArtefactWidget(25, 375, 175, 24);
	    this.widgets['pacifier'] = new ArtefactWidget(25, 405, 175, 24);
	    this.widgets['analTentacle'] = new ArtefactWidget(25, 435, 175, 24);
	    this.widgets['message'] = new MessageWidget(10, h - 10, 540, 70, 540, 70, 0x111111, false, true);
	    this.widgets['log'] = new LogWidget(5, 5, 225, 95, 500, 380, 0x888888);
	    this.widgets['close'] = new CloseWidget(w - 8, 8, 13, 13, this.closeClick, 0xeeeeee);
	    this.widgetsOrder = ['message', 'log', 'panel', 'space', 'water', 'earth', 'fire', 'air', 'karma', 'pain', 'pleasure', 'level', 'maxpain', 'maxpleasure', 'painres', 'arouse', 'constitution', 'speed', 'pool', 'points', 'age', 'levelup', 'painresup', 'arouseup', 'constitutionup', 'speedup', 'mouthpanel', 'mouthslot', 'mouthd', 'mouthl', 'vaginapanel', 'vaginaslot', 'vaginad', 'vaginal', 'anuspanel', 'anusslot', 'anusd', 'anusl', 'mappanel', 'map', 'rhandpanel', 'rhandslot', 'lhandpanel', 'lhandslot', 'artpanel', 'wheel', 'vajra', 'jewel', 'lotus', 'sword', 'chastityBelt', 'pacifier', 'analTentacle', 'close'];
	    this.visibleWidgets = ['log', 'panel', 'space', 'water', 'earth', 'fire', 'air', 'karma', 'pain', 'pleasure', 'level', 'mappanel', 'map'];
	    this.levelupWidgets = ['painresup', 'arouseup', 'constitutionup', 'speedup'];
	    this.toggleHide();
	    this.widgets.message.hidden();
	    this.widgets.log.small();
	}

	public function toggleHide():void {
	    if (!this.widgets.panel.transitionComplete || !this.widgets.space.transitionComplete)
		return;
	    var widgetName:String;
	    var widget:Widget;
	    if (this._mode == 'hide') {
		this._mode = 'visible';
		for each (widgetName in this.widgetsOrder) {
		    if (widgetName == 'message' || widgetName == 'log')
			continue;
		    widget = widgets[widgetName];
		    if (this._state == 'small') {
			if (widgetName == 'levelup') {
			    if (this.upgradeAvailable)
				widget.small(10);
			} else if (widgetName == 'panel')
			    widget.small();
			else if (visibleWidgets.indexOf(widgetName) > 0)
			    widget.small(10);
		    } else {
			if (widgetName == 'panel')
			    widget.large();
			else if ((levelupWidgets.indexOf(widgetName) < 0 || this.upgradeAvailable) && widgetName != 'levelup')
			    widget.large(10);
		    }
		}
	    } else {
		this._mode = 'hide';
		for each (widgetName in this.widgetsOrder) {
		    if (widgetName == 'message' || widgetName == 'log')
			continue;
		    widget = widgets[widgetName];
		    if (widgetName == 'panel')
			widget.hidden(10);
		    else
			widget.hidden();
		}		
	    }
	}

	public function toggleLarge():void {
	    if (!this.widgets.panel.transitionComplete || !this.widgets.space.transitionComplete)
		return;
	    var widgetName:String;
	    var widget:Widget;
	    if (this._state == 'large') {
		this._state = 'small';
		for each (widgetName in this.widgetsOrder) {
		    if (widgetName == 'message' || widgetName == 'log')
			continue;
		    widget = widgets[widgetName];
		    if (this._mode == 'hide') {
			if (widgetName == 'panel')
			    widget.hidden(10);
			else
			    widget.hidden();
		    } else {
			if (widgetName == 'panel')
			    widget.small(15);
			else if (widgetName == 'space' || widgetName == 'water' || widgetName == 'earth' || widgetName == 'fire' || widgetName == 'air' || widgetName == 'karma')
			    widget.small(10);
			else if (visibleWidgets.indexOf(widgetName) > 0)
			    widget.small();
			else
			    widget.hidden();
			if (this.upgradeAvailable)
			    this.widgets.levelup.small();
		    }
		}
	    } else {
		this._state = 'large';
		for each (widgetName in this.widgetsOrder) {
		    if (widgetName == 'message' || widgetName == 'log')
			continue;
		    widget = widgets[widgetName];
		    if (widgetName == 'levelup')
			widget.hidden();
		    else if (widgetName == 'panel')
			widget.large();
		    else if (widgetName == 'artpanel')
			widget.large(20);
		    else if (levelupWidgets.indexOf(widgetName) < 0 || this.upgradeAvailable)
			widget.large(10);
		}
	    }
	}

	public function get upgradeAvailable():Boolean {
	    return this._upgradeAvailable;
	}

	public function set upgradeAvailable(v:Boolean):void {
	    if (v != this._upgradeAvailable) {
		if (this._state == 'large') {
		    for each (var widgetName:String in this.levelupWidgets) {
			var widget:Widget = widgets[widgetName];
			if (v)
			    widget.large();
			else
			    widget.hidden();
		    }
		} else if (this._state == 'small') {
		    if (v)
			this.widgets.levelup.small();
		    else
			this.widgets.levelup.hidden();
		}
		this._upgradeAvailable = v;
	    }
	}

	private function levelupHandler(event:MouseEvent):void {
	    this.toggleLarge();
	}

	private function closeClick(e:MouseEvent):void {
	    this.toggleLarge();
	}

    }
	
}