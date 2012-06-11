package Engine.Stats {
	
    public class VariableStat {

	private var _curValue:Number = 0; // [0, maxValue]
	private var _maxValue:Number = 0; // [0, inf]
	public var decRate:Number = 1; // <0 - inverse, =0 - none, <1 - slower; =1 - normal; >1 - faster
	public var incRate:Number = 1; // <0 - inverse, =0 - none, <1 - slower; =1 - normal; >1 - faster

	public function VariableStat(curValue:Number = 0, maxValue:Number = 1):void {
	    this._curValue = curValue;
	    this._maxValue = maxValue;
	}

	public function get value():Number {
	    return this._curValue;
	}

	public function set value(v:Number):void {
	    if (v > this._curValue) {
		this._curValue += (v - this._curValue) * this.incRate;
	    } else {
		this._curValue -= (this._curValue - v) * this.decRate;
	    }
	    this._curValue = Math.max(0, Math.min(this._maxValue, this._curValue));
	}

	public function set exactValue(v:Number):void {
	    this._curValue = v;
	}

	public function get max():Number {
	    return this._maxValue;
	}

	public function set max(v:Number):void {
	    this._maxValue = Math.max(0, v);
	}

	public function leakValue(v:Number):Number {
	    v = Math.max(0, Math.min(v, this._curValue));
	    this.value -= v;
	    return v;
	}

	public function save():Object {
	    var saveObj:Object = {'curValue': this._curValue,
				  'maxValue': this._maxValue,
				  'decRate': this.decRate,
				  'incRate': this.incRate
				};
	    return saveObj;
	}

	public function load(saveObj:Object):void {
	    if (saveObj.hasOwnProperty('curValue')) {
		this._curValue = saveObj.curValue;
		this._maxValue = saveObj.maxValue;
		this.decRate = saveObj.decRate;
		this.incRate = saveObj.incRate;
	    }
	}

    }
	
}