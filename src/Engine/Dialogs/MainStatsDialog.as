package Engine.Dialogs {
	
    import Engine.Stats.GenericStats;
    import Engine.Dialogs.Widgets.*;

    public class MainStatsDialog extends Dialog{

	private var _mode:String = 'hide';
	private var _state:String = 'small';

	public function MainStatsDialog(w:Number, h:Number):void {
	    super(w, h);
	    this.widgets['panel'] = new PanelWidget(w - 5, 5, 127, 82, w - 10, h - 10, 0x444444, 'Main Stats', true);
	    this.widgets['space'] = new PercentWidget(w - 12, 12, 102, 6, GenericStats.decodeColor(GenericStats.SPACE_COLOR), 'Space', Icons.Space, true);
	    this.widgets['water'] = new PercentWidget(w - 12, 24, 102, 6, GenericStats.decodeColor(GenericStats.WATER_COLOR), 'Water', Icons.Water, true);
	    this.widgets['earth'] = new PercentWidget(w - 12, 36, 102, 6, GenericStats.decodeColor(GenericStats.EARTH_COLOR), 'Earth', Icons.Earth, true);
	    this.widgets['fire'] = new PercentWidget(w - 12, 48, 102, 6, GenericStats.decodeColor(GenericStats.FIRE_COLOR), 'Fire', Icons.Fire, true);
	    this.widgets['air'] = new PercentWidget(w - 12, 60, 102, 6, GenericStats.decodeColor(GenericStats.AIR_COLOR), 'Air', Icons.Air, true);
	    this.widgets['karma'] = new KarmaWidget(w - 12, 72, 102, 6, 'Karma', true);
	    this.widgetsOrder = ['panel', 'space', 'water', 'earth', 'fire', 'air', 'karma'];
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
			if (widgetName == 'panel')
			    widget.small();
			else
			    widget.small(10);
		    } else {
			if (widgetName == 'panel')
			    widget.large();
			else
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
			else
			    widget.small();
		    }
		}
	    } else {
		this._state = 'large';
		for each (widgetName in this.widgetsOrder) {
		    widget = widgets[widgetName];
		    if (widgetName == 'panel')
			widget.large();
		    else
			widget.large(10);
		}		
	    }
	}


    }
	
}