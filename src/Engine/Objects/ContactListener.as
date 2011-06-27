package Engine.Objects {
    
    import Box2D.Collision.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Contacts.*;

    public class ContactListener extends b2ContactListener {              

	public override function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void {
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