package Engine.Stats {
	
    import Engine.Dialogs.Widgets.Icons;
    import Engine.Objects.Utils;

    public class ArtefactStat extends ExpStat {

	public var obtained:Boolean = false;
	private var _name:String;
	private var _description:String;
	private var _icon:Function;
	private var _color:uint;
	private var attachedTo:SlotStat = null;
	
	private const DEFAULT_NAME:String = "Nothing";
	private const DEFAULT_ICON:Function = Icons.Empty;
	private const UNKNOWN_ICON:Function = Icons.Question;
	private const DEFAULT_COLOR:uint = 0x666666;

	public function ArtefactStat($name:String = null, $icon:Function = null, $color:uint=0, $description:String = "Nothing attached there."):void {
	    super(5, 0.01/30, 0); // level of use: leaking elemental stat from 1%/s (on level 1) to none at level 50
	    this._name = $name == null ? this.DEFAULT_NAME : $name;
	    this._icon = $icon == null ? this.DEFAULT_ICON : $icon;
	    this._color = $color == 0 ? this.DEFAULT_COLOR : $color;
	    this._description = $description;
	}

	public function set name(n:String):void {
	    this._name = n;
	}

	public function set description(d:String):void {
	    this._description = d;
	}

	public function set icon($f:Function):void {
	    this._icon = $f;
	}

	public function set color(c:uint):void {
	    this._color = c;
	}

	public function get name():String {
	    if (this._name != this.DEFAULT_NAME && !this.obtained) {
		return "???";
	    }
	    return this._name;
	}

	public function get nameReal():String {
	    return this._name;
	}

	public function get description():String {
	    if (this._name != this.DEFAULT_NAME) {
		if (!this.obtained)
		    return "This artefact is not obtained yet. You will see its name and description only when you'll manage to get it.";
		return this._description + "\nLevel of use: " + this.level.toString() + ((this.attachedTo == null) ? "\nCurrently not attached." : ("\nCurrently attached to " + this.attachedTo.name));
	    }
	    return this._description;
	}

	public function get icon():Function {
	    if (this._name != this.DEFAULT_NAME && !this.obtained) {
		return UNKNOWN_ICON;
	    }
	    return this._icon;
	}

	public function get iconReal():Function {
	    return this._icon;
	}

	public function get color():uint {
	    if (this._name != this.DEFAULT_NAME && !this.obtained) {
		return DEFAULT_COLOR;
	    }
	    return Utils.colorLight(this._color, 0.5);
	}

	public function get colorReal():uint {
	    return Utils.colorLight(this._color, 0.5);
	}

	public function get colorRaw():uint {
	    return this._color;
	}

	public function get attached():Boolean {
	    return this.attachedTo != null;
	}

	public function attach(slot:SlotStat):void {
	    slot.artefactAttached.detach();
	    this.attachedTo = slot;
	    slot.artefactAttached = this;
	}

	public function detach():void {
	    if (this.attachedTo != null) {
		this.attachedTo.artefactAttached = new ArtefactStat();
		this.attachedTo = null;
	    }
	}

	public function get levelString():String {
	    if (this.obtained) {
		return this.level.toString() + "L";
	    }
	    return "";
	}

    }
	
}