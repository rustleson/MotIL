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
