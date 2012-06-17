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

package Engine.Objects {

    import flash.events.Event;
    import Box2D.Common.Math.*;
   
    public class HipsMovedEvent extends Event {
        
	public static const NAME:String = "Engine.Objects.HipsMovedEvent";
       
        public var center:b2Vec2;
       
        public function HipsMovedEvent($type:String, $center:b2Vec2, $bubbles:Boolean = true, $cancelable:Boolean = false) {
            super($type, $bubbles, $cancelable);
           
            this.center = $center;
        }

        public override function clone():Event {
            return new HipsMovedEvent(type, this.center, bubbles, cancelable);
        }
       
        public override function toString():String {
            return formatToString("HipsMovedEvent", "center", "type", "bubbles", "cancelable");
        }
   
    }
}
