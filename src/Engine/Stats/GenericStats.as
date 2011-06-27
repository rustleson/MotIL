package Engine.Stats {
	
    public class GenericStats {

	private var _space:Number = 0; // [0, 1]
	private var _water:Number = 0; // [0, 1]
	private var _earth:Number = 0; // [0, 1]
	private var _fire:Number = 0; // [0, 1]
	private var _air:Number = 0; // [0, 1]
	private var _alignment:Number = 0; // [-1, 1] 
	private var _alignmentTendency: Number = 0; // [-1, 1]
	private var _tendencyRatio: Number = 1; // must be > 0 

	// variable stats
	private var _pain:VariableStat = new VariableStat(); 
	private var _pleasure:VariableStat = new VariableStat(); 
	private var _expPool:VariableStat = new VariableStat(); 

	// experience stats
	private var _level:ExpStat = new ExpStat(); 
	private var _maxPain:ExpStat = new ExpStat(30, 300); 
	private var _maxPleasure:ExpStat = new ExpStat(30, 300); 
	
	// point stats
	private var _sensitivity:PointStat = new PointStat(0.1, 1); 
	private var _painResistance:PointStat = new PointStat(0.1, 1); 
	private var _arousalBoost:PointStat = new PointStat(0.1, 1); 
	private var _speed:PointStat = new PointStat(0.1, 1); 
	
	public const SPACE_COLOR:Array = [0xDD, 0xD7, 0xD0];
	public const WATER_COLOR:Array = [0x00, 0x22, 0xCC];
	public const EARTH_COLOR:Array = [0xD0, 0xB7, 0x00];
	public const FIRE_COLOR:Array  = [0xDD, 0x11, 0x00];
	public const AIR_COLOR:Array   = [0x00, 0xCC, 0x11];

	public const PLEASURE_DECREMENT:Number = 0.05;
	public const PAIN_DECREMENT:Number = 0.05;

	public function GenericStats(){
	    this._expPool.max = 20000;
	    this.takeExp(0);
	    this.takePain(0);
	    this.takePleasure(0);
	}

	/* ELEMENTAL STATS */

	public function get space():Number {
	    return this._space;
	}

	public function set space(v:Number):void {
	    v = Math.max(0, Math.min(1, v));
	    if (v > this._space) {
		var ratio:Number = 1 - v * v;
		this._water *= ratio;
		this._earth *= ratio;
		this._fire *= ratio;
		this._air *= ratio;
	    }
	    this._space = v;
	}

	public function get water():Number {
	    return this._water;
	}

	public function set water(v:Number):void {
	    v = Math.max(0, Math.min(1, v));
	    if (v > this._water) {
		var ratio:Number = 1 - v * v;
		this._space *= ratio;
		this._earth *= ratio;
		this._fire *= ratio;
		this._air *= ratio;
	    }
	    this._water = v;
	}

	public function get earth():Number {
	    return this._earth;
	}

	public function set earth(v:Number):void {
	    v = Math.max(0, Math.min(1, v));
	    if (v > this._earth) {
		var ratio:Number = 1 - v * v;
		this._water *= ratio;
		this._space *= ratio;
		this._fire *= ratio;
		this._air *= ratio;
	    }
	    this._earth = v;
	}

	public function get fire():Number {
	    return this._fire;
	}

	public function set fire(v:Number):void {
	    v = Math.max(0, Math.min(1, v));
	    if (v > this._fire) {
		var ratio:Number = 1 - v * v;
		this._water *= ratio;
		this._earth *= ratio;
		this._space *= ratio;
		this._air *= ratio;
	    }
	    this._fire = v;
	}

	public function get air():Number {
	    return this._air;
	}

	public function set air(v:Number):void {
	    v = Math.max(0, Math.min(1, v));
	    if (v > this._air) {
		var ratio:Number = 1 - v * v;
		this._water *= ratio;
		this._earth *= ratio;
		this._fire *= ratio;
		this._space *= ratio;
	    }
	    this._air = v;
	}

	/* ALIGNMENT STATS */

	public function get alignmentTendency():Number {
	    return this._alignmentTendency;
	}

	public function set alignmentTendency(v:Number):void {
	    v = Math.max(-1, Math.min(1, v));
	    this._alignmentTendency = v;
	}

	public function get tendencyRatio():Number {
	    return this._tendencyRatio;
	}

	public function set tendencyRatio(v:Number):void {
	    if (v <= 0) {
		v = 0.001;
	    }
	    this._tendencyRatio = v;
	}

	public function get alignment():Number {
	    return this._alignment;
	}

	public function set alignment(v:Number):void {
	    var dv:Number = v - this._alignment;
	    if (Math.abs(this._alignmentTendency - v) > Math.abs(this._alignmentTendency - this._alignment)) {
		dv *= tendencyRatio;
	    } else {
		dv /= tendencyRatio;
	    }
	    v = this._alignment + dv;
	    v = Math.max(-1, Math.min(1, v));
	    this._alignment = v;
	}

	/* EXPERIENCE STATS */

	public function get level():int {
	    return this._level.level;
	}

	public function set level(lev:int):void {
	    this._level.level = lev;
	}

	public function takeExp(dExp:Number):void {
	    this._level.exp += dExp;
	    this._expPool.value += dExp;
	}

	public function takePain(dv:Number):void {
	    this._pain.value += dv;
	    this._maxPain.exp += this._expPool.leakValue(this._pain.value);
	    this._pain.max = this._maxPain.value2;
	}

	public function takePleasure(dv:Number):void {
	    this._pleasure.value += dv;
	    this._maxPleasure.exp += this._expPool.leakValue(this._pleasure.value);
	    this._pleasure.max = this._maxPleasure.value2;
	}

	public function timeStep():void {
	    this._pain.incRate = 1 - this._pleasure.value / this._pleasure.max * 1.3;
	    this._pleasure.incRate = 1 - this._pain.value / this._pain.max * 1.3;
	    this._pain.decRate = 1 / this._sensitivity.value;
	    this._pleasure.decRate = 1 / this._sensitivity.value;
	    this._pain.value -= PAIN_DECREMENT;
	    this._pleasure.value -= PLEASURE_DECREMENT;
	    
	}

	/* UTIL FUNCTIONS */

	public function mixedElementsColor():uint {
	    var r:uint = Math.min(0xDD, Math.round(SPACE_COLOR[0] * this._space + WATER_COLOR[0] * this._water + EARTH_COLOR[0] * this._earth + FIRE_COLOR[0] * this._fire + AIR_COLOR[0] * this._air));
	    var g:uint = Math.min(0xDD, Math.round(SPACE_COLOR[1] * this._space + WATER_COLOR[1] * this._water + EARTH_COLOR[1] * this._earth * this._earth + FIRE_COLOR[1] * this._fire + AIR_COLOR[1] * this._air)); 
	    var b:uint = Math.min(0xDD, Math.round(SPACE_COLOR[2] * this._space + WATER_COLOR[2] * this._water + EARTH_COLOR[2] * this._earth + FIRE_COLOR[2] * this._fire + AIR_COLOR[2] * this._air)); 
	    return (r << 16) + (g << 8) + b;
	}

	public function getAuraColor():uint {
	    if (this._alignment > 0)
		return 0xffffff;
	    if (this._alignment < 0)
		return 0x000000;
	    return 0x787878;
	    
	}

	public function getAuraIntencity():Number {
	    if (this._alignment > 0)
		return Math.abs(this._alignment);
	    return Math.abs(this._alignment) * 1.5;
	}

    }
	
}