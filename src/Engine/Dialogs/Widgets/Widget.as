package Engine.Dialogs.Widgets {
	
    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class Widget {

	[Embed(source="/Assets/Sailor.ttf", fontFamily="Huge", embedAsCFF = "false", advancedAntiAliasing = "true")]
	public static const HUGE_FONT:String;

	[Embed(source="/Assets/Reaction.ttf", fontFamily="Large", embedAsCFF = "false", advancedAntiAliasing = "true")]
	public static const LARGE_FONT:String;

	[Embed(source="/Assets/GalaxyEB.ttf", fontFamily="Medium", embedAsCFF = "false", advancedAntiAliasing = "true")]
	public static const MEDIUM_FONT:String;

	[Embed(source="/Assets/Galaxy.ttf", fontFamily="Small", embedAsCFF = "false", advancedAntiAliasing = "true")]
	public static const SMALL_FONT:String;

	[Embed(source="/Assets/NeostandardExtended.ttf", fontFamily="Tiny", embedAsCFF = "false", advancedAntiAliasing = "true")]
	public static const TINY_FONT:String;

	public var sprite:Sprite; 
	public var needUpdate:Boolean; 
	public var x:Number; 
	public var y:Number; 
	public var title:String; 
	private var _state:String = ''; 
	private var _timeout:int = 0; 
	private var _transition:int = 0; 
	private var _transitionSteps:int = 0; 
	private var _transitionFrom:Number = 0; 
	private var _transitionTo:Number = 0; 
	public var tooltipText:TextField;
	public var tooltipSprite:Sprite;
	public var tooltipFormat:TextFormat;

	public function Widget($x:Number = 0, $y:Number = 0, $title:String = ''):void {
	    this.sprite = new Sprite();
	    this.needUpdate = true;
	    this.x = $x;
	    this.y = $y;
	    this.title = $title;
	    // tooltip text
	    this.tooltipText = new TextField();
	    this.tooltipText.text = '';
	    this.tooltipText.width = 150;
	    this.tooltipText.selectable = false;
	    this.tooltipText.embedFonts = true;
	    this.tooltipText.wordWrap = true;
	    this.tooltipFormat = new TextFormat("Tiny", 8, 0xdddddd);
	    this.tooltipFormat.align = TextFieldAutoSize.LEFT;	    
	    this.tooltipText.setTextFormat(this.tooltipFormat);
	    this.tooltipSprite = new Sprite();
	    this.tooltipSprite.addChild(this.tooltipText);
	    //this.sprite.addChild(this.tooltipSprite);
	    this.tooltipSprite.alpha = 0.8;
	    this.tooltipSprite.visible = false;
	    this.sprite.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
	    this.sprite.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
	}

	public function update():void {
	    if (this.needUpdate){ 
		if (this._timeout > 0) {
		    this._timeout--;
		} else { 
		    this.draw();
		    if (this._transition > 0) 
			this._transition--;
		    else {
			this.needUpdate = false;
		    }
		}
	    }
	}

	protected function draw():void {
	    this.sprite.graphics.clear();
	}

	public function transition(state:String = '', steps:int = 0, from:Number = 0, to:Number = 0, timeout:int = 0):void {
	    this._state = state;
	    this._timeout = timeout;
	    this._transition = steps;
	    this._transitionSteps = steps;
	    this._transitionFrom = from;
	    this._transitionTo = to;
	    this.needUpdate = true;
	}
	
	protected function get transValue():Number {
	    if (this._transitionSteps == 0)
		return this._transitionTo;
	    return this._transitionTo + this._transition / this._transitionSteps * (this._transitionFrom - this._transitionTo);
	}

	protected function get transValue2():Number {
	    if (this._transitionSteps == 0)
		return this._transitionTo;
	    if (this._transitionTo < this._transitionFrom)
		return this._transitionTo + this._transition / this._transitionSteps * (this._transitionFrom - this._transitionTo);
		//return this._transitionTo + Math.max(0, 1 - (1 - this._transition / this._transitionSteps) * 2) * (this._transitionFrom - this._transitionTo);
	    return this._transitionTo + this._transition * this._transition / this._transitionSteps / this._transitionSteps * (this._transitionFrom - this._transitionTo);
	}

	public function get state():String {
	    return this._state;
	}

	public function hidden(timeout:int = 0):void {
	    if (this.state == 'large')
		this.transition('hidden', 15, 2, 0, timeout);
	    if (this.state == 'small')
		this.transition('hidden', 15, 1, 0, timeout);
	    if (this.state == '')
		this._state = 'hidden';
	}

	public function small(timeout:int = 0):void {
	    if (this.state == 'large')
		this.transition('small', 10, 2, 1, timeout);
	    if (this.state == 'hidden' || this.state == '')
		this.transition('small', 15, 0, 1, timeout);
	}

	public function large(timeout:int = 0):void {
	    if (this.state == 'hidden' || this.state == '')
		this.transition('large', 20, 0, 2, timeout);
	    if (this.state == 'small')
		this.transition('large', 15, 1, 2, timeout);
	}

	public function get transitionComplete():Boolean {
	    return (this._transition == 0 && this._timeout == 0);
	}

	public function setTooltip(text:String):void {
	    if (text != this.tooltipText.text) {
		this.tooltipText.text = text;
		this.tooltipText.x = 0;
		this.tooltipText.y = 0;
		this.tooltipText.setTextFormat(this.tooltipFormat);
		this.tooltipText.width = 150;
		this.tooltipText.height = this.tooltipText.textHeight + 10;
		this.tooltipSprite.graphics.clear();
		this.tooltipSprite.graphics.lineStyle(0, 0, 0);
		this.tooltipSprite.graphics.beginFill(0x000000, 1);
		this.tooltipSprite.graphics.drawRoundRect(-3, 0, 156, this.tooltipText.textHeight + 4, 10, 10);
		this.tooltipSprite.graphics.endFill();
	    }
	}
	    
	private function mouseOverHandler(event:MouseEvent):void {
	    if (this.tooltipText.text) {
		var x:Number = event.stageX - this.tooltipSprite.width - 1;
		var y:Number = event.stageY - this.tooltipSprite.height - 1;
		if (x < 0)
		    x += this.tooltipSprite.width + 20;
		if (y < 0)
		    y += this.tooltipSprite.height + 20;
		this.tooltipSprite.x = x;
		this.tooltipSprite.y = y;
		//this.tooltipText.text = "x: " + event.stageX.toString() + ", y: " + event.stageY.toString();
		//this.tooltipText.setTextFormat(this.tooltipFormat);
		this.tooltipSprite.visible = true;
	    }
	}

	private function mouseOutHandler(event:MouseEvent):void {
	    this.tooltipSprite.visible = false;
	}
	
	public function destroy():void {
	    this.sprite.graphics.clear();
	    while(this.sprite.numChildren > 0) {   
		this.sprite.removeChildAt(0); 
	    }
	    this.tooltipSprite.graphics.clear();
	    while(this.tooltipSprite.numChildren > 0) {   
		this.tooltipSprite.removeChildAt(0); 
	    }
	}

    }
	
}