package Engine.Dialogs.Widgets {
	
    import flash.display.*;

    public class Widget {

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

	public function Widget($x:Number = 0, $y:Number = 0, $title:String = ''):void {
	    this.sprite = new Sprite();
	    this.needUpdate = true;
	    this.x = $x;
	    this.y = $y;
	    this.title = $title;
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
	    return this._transitionTo + this._transition * this._transition / this._transitionSteps / this._transitionSteps * (this._transitionFrom - this._transitionTo);
	}

	protected function get state():String {
	    return this._state;
	}

	public function hidden(timeout:int = 0):void {
	    if (this.state == 'large')
		this.transition('hidden', 30, 2, 0, timeout);
	    if (this.state == 'small')
		this.transition('hidden', 15, 1, 0, timeout);
	}

	public function small(timeout:int = 0):void {
	    if (this.state == 'large')
		this.transition('small', 20, 2, 1, timeout);
	    if (this.state == 'hidden' || this.state == '')
		this.transition('small', 15, 0, 1, timeout);
	}

	public function large(timeout:int = 0):void {
	    if (this.state == 'hidden' || this.state == '')
		this.transition('large', 30, 0, 2, timeout);
	    if (this.state == 'small')
		this.transition('large', 20, 1, 2, timeout);
	}

	public function get transitionComplete():Boolean {
	    return (this._transition == 0 && this._timeout == 0);
	}
	    
    }
	
}