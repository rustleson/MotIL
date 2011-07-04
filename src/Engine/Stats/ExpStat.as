package Engine.Stats {
	
    public class ExpStat {

	private var _level:int = 1; 
	private var _exp:Number = 0; 
	public var fromValue:Number; 
	public var toValue:Number; 
	public var progressRate:Number = 100; 

	public function ExpStat(progressRate:Number = 100, fromValue:Number = 1, toValue:Number = 50):void {
	    this.fromValue = fromValue;
	    this.toValue = toValue;
	    this.progressRate = progressRate;
	}

	public function getValue(from:Number, to:Number):Number {
	    return from + (to - from) * (this._level - 1) / 49;
	}

	public function getValue2(from:Number, to:Number):Number {
	    return from + (to - from) * (this._level - 1) * (this._level - 1) / 49 / 49;
	}

	public function get value():Number {
	    return this.fromValue + (this.toValue - this.fromValue) * (this._level - 1) / 49;
	}

	public function get value2():Number {
	    return this.fromValue + (this.toValue - this.fromValue) * (this.level - 1) * (this.level - 1) / 49 / 49;
	}

	public function get level():int {
	    return this._level;
	}

	public function set level(v:int):void {
	    this.exp = this.lev2exp(v);
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
	}
	
	public function get tnl():Number {
	    if (this._level == 50)
		return 0;
	    return this.lev2exp(this._level + 1) - this.exp;
	}
	
	public function get tnlRatio():Number {
	    if (this._level == 50)
		return 1;
	    return (this.exp - this.lev2exp(this._level)) / (this.lev2exp(this._level + 1) - this.lev2exp(this._level));
	}
	
	private function exp2lev(exp:Number):int {
	    return int(Math.log(exp / this.progressRate + 1) * 4 + 1);
	}
	    
	private function lev2exp(lev:int):Number {
	    return (Math.exp((lev - 1) / 4) - 1) * this.progressRate;
	}
	    
    }
	
}