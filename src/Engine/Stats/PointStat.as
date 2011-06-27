package Engine.Stats {
	
    public class PointStat {

	private var _level:int = 1; 
	public var fromValue:Number; 
	public var toValue:Number; 

	public function PointStat(fromValue:Number = 1, toValue:Number = 50):void {
	    this.fromValue = fromValue;
	    this.toValue = toValue;
	}

	public function get value():Number {
	    return this.fromValue + (this.toValue - this.fromValue) * (this.level - 1) / 49;
	}

	public function get value2():Number {
	    return this.fromValue + (this.toValue - this.fromValue) * (this.level - 1) * (this.level - 1) / 49 / 49;
	}

	public function get level():Number {
	    return this._level;
	}

	public function set level(v:Number):void {
	    this._level = Math.max(1, Math.min(v, 50));
	}

    }
	
}