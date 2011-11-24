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
	    this.widgets['panel'] = new PanelWidget(w - 5, 5, 124, 96, w - 10, h - 10, 0x444444, '', true);
	    this.widgets['space'] = new PercentWidget(w - 12, 24, 102, 6, GenericStats.decodeColor(GenericStats.SPACE_COLOR), 'Space', Icons.Space, true, false, 0, 72);
	    this.widgets['water'] = new PercentWidget(w - 12, 36, 102, 6, GenericStats.decodeColor(GenericStats.WATER_COLOR), 'Water', Icons.Water, true, false, 0, 72);
	    this.widgets['earth'] = new PercentWidget(w - 12, 48, 102, 6, GenericStats.decodeColor(GenericStats.EARTH_COLOR), 'Earth', Icons.Earth, true, false, 0, 72);
	    this.widgets['fire'] = new PercentWidget(w - 12, 60, 102, 6, GenericStats.decodeColor(GenericStats.FIRE_COLOR), 'Fire', Icons.Fire, true, false, 0, 72);
	    this.widgets['air'] = new PercentWidget(w - 12, 72, 102, 6, GenericStats.decodeColor(GenericStats.AIR_COLOR), 'Air', Icons.Air, true, false, 0, 72);
	    this.widgets['karma'] = new KarmaWidget(w - 12, 84, 102, 6, 'Karma', Icons.Karma, true, false, 0, 72);
	    this.widgets['pain'] = new PercentWidget(w - 155, 12, 102, 6, 0x8855ff, 'Pain', Icons.Pain, true, false, -55);
	    this.widgets['pleasure'] = new PercentWidget(w - 290, 12, 102, 6, 0xff55dd, 'Bliss', Icons.Pleasure, true, false, -130);
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
	    this.widgets['mouthpanel'] = new PanelWidget(w - 245, 70, 130, 50, 130, 50, 0x474444, 'Mouth', true);
	    this.widgets['mouthd'] = new PercentWidget(w - 250, 96, 70, 6, 0x552211, 'D:', null, true);
	    this.widgets['mouthl'] = new PercentWidget(w - 250, 108, 70, 6, 0x552211, 'L:', null, true);
	    this.widgets['vaginapanel'] = new PanelWidget(w - 245, 130, 130, 50, 130, 50, 0x474444, 'Vagina', true);
	    this.widgets['vaginad'] = new PercentWidget(w - 250, 156, 70, 6, 0x552211, 'D:', null, true);
	    this.widgets['vaginal'] = new PercentWidget(w - 250, 168, 70, 6, 0x552211, 'L:', null, true);
	    this.widgets['anuspanel'] = new PanelWidget(w - 245, 190, 130, 50, 130, 50, 0x474444, 'anus', true);
	    this.widgets['anusd'] = new PercentWidget(w - 250, 216, 70, 6, 0x552211, 'D:', null, true);
	    this.widgets['anusl'] = new PercentWidget(w - 250, 228, 70, 6, 0x552211, 'L:', null, true);
	    this.widgetsOrder = ['panel', 'space', 'water', 'earth', 'fire', 'air', 'karma', 'pain', 'pleasure', 'level', 'maxpain', 'maxpleasure', 'painres', 'arouse', 'constitution', 'speed', 'pool', 'points', 'levelup', 'painresup', 'arouseup', 'constitutionup', 'speedup', 'mouthpanel', 'mouthd', 'mouthl', 'vaginapanel', 'vaginad', 'vaginal', 'anuspanel', 'anusd', 'anusl'];
	    this.visibleWidgets = ['panel', 'space', 'water', 'earth', 'fire', 'air', 'karma', 'pain', 'pleasure', 'level'];
	    this.levelupWidgets = ['painresup', 'arouseup', 'constitutionup', 'speedup'];
	    this.toggleHide();
	}

	public function toggleHide():void {
	    if (!this.widgets.panel.transitionComplete || !this.widgets.space.transitionComplete)
		return;
	    var widgetName:String;
	    var widget:Widget;
	    if (this._mode == 'hide') {
		this._mode = 'visible';
		for each (widgetName in this.widgetsOrder) {
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
		    widget = widgets[widgetName];
		    if (this._mode == 'hide') {
			if (widgetName == 'panel')
			    widget.hidden(10);
			else
			    widget.hidden();
		    } else {
			if (widgetName == 'panel')
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
		    widget = widgets[widgetName];
		    if (widgetName == 'levelup')
			widget.hidden();
		    else if (widgetName == 'panel')
			widget.large();
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
		}
		this._upgradeAvailable = v;
	    }
	}

	private function levelupHandler(event:MouseEvent):void {
	    this.toggleLarge();
	}

    }
	
}