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

    }
	
}