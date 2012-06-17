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
    
    import Box2D.Collision.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Contacts.*;

    public class ContactListener extends b2ContactListener {              

	public override function BeginContact(contact:b2Contact):void {
	    var obj1:Object = contact.GetFixtureA().GetBody().GetUserData();
	    var obj2:Object = contact.GetFixtureB().GetBody().GetUserData();
	    var body1:Object = contact.GetFixtureA().GetBody();
	    var body2:Object = contact.GetFixtureB().GetBody();
	    var world:b2World = body1.GetWorld();

	    if (obj1.hasOwnProperty('slot') && obj2.hasOwnProperty('slot')) {
		if (obj1.slot.type == Slot.MOTHER && obj2.slot.type == Slot.FATHER && obj1.slot.isFree && obj1.slot.isReady && obj2.slot.isFree) {
		    obj1.slot.connect(obj2.slot);
		}
		if (obj2.slot.type == Slot.MOTHER && obj1.slot.type == Slot.FATHER && obj2.slot.isFree && obj2.slot.isReady && obj1.slot.isFree) {
		    obj2.slot.connect(obj1.slot);
		}
	    }
        }
    }
}