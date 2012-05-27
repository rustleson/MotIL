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
	private var POINTS_EACH_LEVEL:int = 2;

	// variable stats
	private var _pain:VariableStat = new VariableStat(); 
	private var _pleasure:VariableStat = new VariableStat(); 
	protected var _expPool:VariableStat = new VariableStat(); 
	private var _pointPool:VariableStat = new VariableStat(); 

	// experience stats
	private var _level:ExpStat = new ExpStat(); 
	private var _maxPain:ExpStat = new ExpStat(100, 30, 300); 
	private var _maxPleasure:ExpStat = new ExpStat(100, 30, 300); 
	
	// point stats
	private var _constitution:PointStat = new PointStat(1, 50); 
	private var _painResistance:PointStat = new PointStat(1, 0.4); 
	private var _arousalBoost:PointStat = new PointStat(1, 2.5); 
	private var _speed:PointStat = new PointStat(1, 10); 
	
	public static const SPACE_COLOR:Array = [0xDD, 0xD7, 0xD0];
	public static const WATER_COLOR:Array = [0x00, 0x22, 0xCC];
	public static const EARTH_COLOR:Array = [0xD0, 0xB7, 0x00];
	public static const FIRE_COLOR:Array  = [0xDD, 0x11, 0x00];
	public static const AIR_COLOR:Array   = [0x00, 0xCC, 0x11];

	public const PLEASURE_DECREMENT:Number = 0.05;
	public const PAIN_DECREMENT:Number = 0.05;
	public const WIDE_RANGE:Number = 0.1;
	public const HEIGHT_RANGE:Number = 1/3;

	public function GenericStats(){
	    this._expPool.max = 20000;
	    this._pointPool.max = 100;
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
		var ratio:Number = (1 - v) / (this._air + this._fire + this._water + this._earth + 0.0001);
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
		var ratio:Number = (1 - v) / (this._air + this._fire + this._space + this._earth + 0.0001);
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
		var ratio:Number = (1 - v) / (this._water + this._fire + this._space + this._air + 0.0001);
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
		var ratio:Number = (1 - v) / (this._water + this._earth + this._space + this._air + 0.0001);
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
		var ratio:Number = (1 - v) / (this._water + this._fire + this._space + this._earth + 0.0001);
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
	    var l:int = this._level.level;
	    this._level.exp += dExp;
	    this._expPool.value += dExp;
	    this._pointPool.value += (this._level.level - l) * POINTS_EACH_LEVEL;
	}

	public function takePain(dv:Number, stat:ExpStat = null):Boolean {
	    this._pain.value += dv;
	    this._maxPain.exp += this._expPool.leakValue(dv * this._pain.value / this._pain.max);
	    this._pain.max = this._maxPain.value2 * this.wideRatio;
	    return (this._pain.value == this.pain.max);
	}

	public function takePleasure(dv:Number):Boolean {
	    this._pleasure.value += dv;
	    this._maxPleasure.exp += this._expPool.leakValue(dv * this._pleasure.value / this._pleasure.max);
	    this._pleasure.max = this._maxPleasure.value2 * this.heightRatio;
	    return (this._pleasure.value == this.pleasure.max);
	}

	public function timeStep():void {
	    this._pain.incRate = this.sensitivity * this.painResistance * (1 - this._pleasure.value / this._pleasure.max * 1.2);
	    this._pleasure.incRate = this.sensitivity * this.arousalBoost * (1 - this._pain.value / this._pain.max * 1.2);
	    this._pain.decRate = 1 / this.sensitivity;
	    this._pleasure.decRate = 1 / this.sensitivity;
	    this._pain.value -= PAIN_DECREMENT;
	    this._pleasure.value -= PLEASURE_DECREMENT;
	    
	}

	public function get pain():VariableStat {
	    return this._pain;
	}

	public function get pleasure():VariableStat {
	    return this._pleasure;
	}

	public function get exp():ExpStat {
	    return this._level;
	}

	public function get maxPain():ExpStat {
	    return this._maxPain;
	}

	public function get maxPleasure():ExpStat {
	    return this._maxPleasure;
	}

	public function get expPool():Number {
	    return this._expPool.value;
	}

	public function get pointPool():Number {
	    return this._pointPool.value;
	}

	public function set pointPool(v:Number):void {
	    this._pointPool.value = v;
	}

	/* POINT STATS */

	public function get constitution():Number {
	    return this._constitution.value;
	}

	public function get painResistance():Number {
	    return this._painResistance.value;
	}

	public function get arousalBoost():Number {
	    return this._arousalBoost.value;
	}

	public function get speed():Number {
	    return this._speed.value;
	}

	public function get constitutionLevel():Number {
	    return this._constitution.level;
	}

	public function get painResistanceLevel():Number {
	    return this._painResistance.level;
	}

	public function get arousalBoostLevel():Number {
	    return this._arousalBoost.level;
	}

	public function get speedLevel():Number {
	    return this._speed.level;
	}

	public function set constitution(v:Number):void {
	    this._constitution.level = v;
	}

	public function set painResistance(v:Number):void {
	    this._painResistance.level = v;
	}

	public function set arousalBoost(v:Number):void {
	    this._arousalBoost.level = v;
	}

	public function set speed(v:Number):void {
	    this._speed.level = v;
	}

	/* SECONDARY STATS */

	public function get wideRatio():Number {
	    return 1 + ((this.constitution-1) - (this.level-1)/2) / 24.5 * WIDE_RANGE / 2;
	}

	public function get heightRatio():Number {
	    return 1 + (this.level - 1) / 49 * HEIGHT_RANGE;
	}

	public function get sensitivity():Number {
	    return Math.pow(10, (1 - this.wideRatio) * 2);
	}

	public function get mixedElementsColor():uint {
	    var r:uint = Math.min(0xDD, Math.round(SPACE_COLOR[0] * this._space + WATER_COLOR[0] * this._water + EARTH_COLOR[0] * this._earth + FIRE_COLOR[0] * this._fire + AIR_COLOR[0] * this._air));
	    var g:uint = Math.min(0xDD, Math.round(SPACE_COLOR[1] * this._space + WATER_COLOR[1] * this._water + EARTH_COLOR[1] * this._earth * this._earth + FIRE_COLOR[1] * this._fire + AIR_COLOR[1] * this._air)); 
	    var b:uint = Math.min(0xDD, Math.round(SPACE_COLOR[2] * this._space + WATER_COLOR[2] * this._water + EARTH_COLOR[2] * this._earth + FIRE_COLOR[2] * this._fire + AIR_COLOR[2] * this._air)); 
	    return (r << 16) + (g << 8) + b;
	}

	public function get auraColor():uint {
	    if (this._alignment > 0)
		return 0xffffff;
	    if (this._alignment < 0)
		return 0x000000;
	    return 0x787878;
	    
	}

	public function get auraIntencity():Number {
	    if (this._alignment > 0)
		return Math.abs(this._alignment);
	    return Math.abs(this._alignment) * 1.5;
	}

	public static function decodeColor(c:Array):uint {
	    return (c[0] << 16) + (c[1] << 8) + c[2];
	}

    }
	
}