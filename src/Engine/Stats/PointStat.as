//---------------------------------------------------------------------------
//
//    Copyright 2011-2012 Reyna D "rustleson"
//
//---------------------------------------------------------------------------
//
//    This file is part of MotIL.
//
//    MotIL is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    MotIL is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with MotIL.  If not, see <http://www.gnu.org/licenses/>.
//
//---------------------------------------------------------------------------

package Engine.Stats {
	
    public class PointStat {

	private var _level:int = 1; 
	private var _value:Number; 
	private var _value2:Number; 
	public var _fromValue:Number; 
	public var _toValue:Number; 

	public function PointStat(fromValue:Number = 1, toValue:Number = 50):void {
	    this.fromValue = fromValue;
	    this.toValue = toValue;
	    this.buildValue();
	}

	public function save():Object {
	    var saveObj:Object = {'level': this._level,
				  'fromValue': this._fromValue,
				  'toValue': this._toValue
				};
	    return saveObj;
	}

	public function load(saveObj:Object):void {
	    if (saveObj.hasOwnProperty('level')) {
		this._level = saveObj.level;
		this._fromValue = saveObj.fromValue;
		this._toValue = saveObj.toValue;
		this.buildValue();
	    }
	}

	public function get value():Number {
	    return this._value;
	}

	public function get value2():Number {
	    return this._value2;
	}

	public function get level():Number {
	    return this._level;
	}

	public function set level(v:Number):void {
	    this._level = Math.max(1, Math.min(v, 50));
	    this.buildValue();
	}

	private function buildValue():void {
	    this._value = this.fromValue + (this.toValue - this.fromValue) * (this.level - 1) / 49;
	    this._value2 = this.fromValue + (this.toValue - this.fromValue) * (this.level - 1) * (this.level - 1) / 49 / 49;
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

    }
	
}