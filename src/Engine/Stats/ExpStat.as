package Engine.Stats {
	
    public class ExpStat {

	private var _level:int = 1; 
	private var _exp:Number = 0; 
	private var _value:Number; 
	private var _value2:Number; 
	private var _valueFrac:Number; 
	private var _levelFrac:Number; 
	private var _tnl:Number; 
	private var _tnlRatio:Number; 
	private var _fromValue:Number; 
	private var _toValue:Number; 
	private var _progressRate:Number = 100; 

	public function ExpStat(progressRate:Number = 100, fromValue:Number = 1, toValue:Number = 50):void {
	    this.fromValue = fromValue;
	    this.toValue = toValue;
	    this.progressRate = progressRate;
	    this.buildValue();
	}

	public function save():Object {
	    var saveObj:Object = {'level': this._level,
				  'exp': this._exp,
				  'fromValue': this._fromValue,
				  'toValue': this._toValue,
				  'progressRate': this._progressRate
				};
	    return saveObj;
	}

	public function load(saveObj:Object):void {
	    if (saveObj.hasOwnProperty('level')) {
		this._level = saveObj.level;
		this._exp = saveObj.exp;
		this._fromValue = saveObj.fromValue;
		this._toValue = saveObj.toValue;
		this._progressRate = saveObj.progressRate;
		this.buildValue();
	    }
	}

	public function getValue(from:Number, to:Number):Number {
	    return from + (to - from) * (this._level - 1) / 49;
	}

	public function getValue2(from:Number, to:Number):Number {
	    return from + (to - from) * (this._level - 1) * (this._level - 1) / 49 / 49;
	}

	public function get value():Number {
	    return this._value;
	}

	public function get value2():Number {
	    return this._value2;
	}

	public function get valueFrac():Number {
	    return this._valueFrac;
	}

	public function get level():int {
	    return this._level;
	}

	public function get levelFrac():Number {
	    return this._levelFrac;
	}

	public function set level(v:int):void {
	    this.exp = this.lev2exp(v) + 1;
	}

	public function get exp():Number {
	    return this._exp;
	}

	public function set exp(v:Number):void {
	    v = Math.max(0, v);
	    this._exp = v;
	    this._level = this.exp2lev(v);
	    if (this._level >= 50) {
		this._level = 50;
		this._exp = this.lev2exp(50);
	    }
	    this.buildValue();
	}
	
	public function get tnl():Number {
	    return this._tnl;
	}
	
	public function get tnlRatio():Number {
	    return this._tnlRatio;
	}
	
	private function exp2lev(exp:Number):int {
	    return int(Math.log(exp / this.progressRate + 1) * 4 + 1);
	}
	    
	private function exp2levF(exp:Number):Number {
	    return Math.log(exp / this.progressRate + 1) * 4 + 1;
	}
	    
	private function lev2exp(lev:int):Number {
	    return (Math.exp((lev - 1) / 4) - 1) * this.progressRate;
	}
	    
	private function buildValue():void {
	    this._value = this.fromValue + (this.toValue - this.fromValue) * (this.level - 1) / 49;
	    this._value2 = this.fromValue + (this.toValue - this.fromValue) * (this.level - 1) * (this.level - 1) / 49 / 49;
	    this._levelFrac = this.exp2levF(this._exp);
	    this._valueFrac = this.fromValue + (this.toValue - this.fromValue) * (this.levelFrac - 1) / 49;
	    this._tnl = (this._level == 50) ? 0 : (this.lev2exp(this._level + 1) - this.exp);
	    this._tnlRatio = (this._level == 50) ? 1 : ((this.exp - this.lev2exp(this._level)) / (this.lev2exp(this._level + 1) - this.lev2exp(this._level)));
	}

	public function get fromValue():Number {
	    return this._fromValue;
	}

	public function set fromValue(v:Number):void {
	    this._fromValue = v;
	    this.buildValue();
	}

	public function get toValue():Number {
	    return this._toValue;
	}

	public function set toValue(v:Number):void {
	    this._toValue = v;
	    this.buildValue();
	}

	public function get progressRate():Number {
	    return this._progressRate;
	}

	public function set progressRate(v:Number):void {
	    this._progressRate = v;
	    this.buildValue();
	}

    }
	
}