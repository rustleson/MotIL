package Engine.Worlds {
	
    import Box2D.Common.*;
    import Engine.Stats.GenericStats;
    import Engine.Objects.Utils;
    import Engine.Objects.Room;
    import General.Rndm;
	
    public class EmptyRoom extends WorldRoom {

	public function EmptyRoom(world:World, posX:Number, posY:Number, width:Number, height:Number, type:uint, prefix:String, seed:uint){
	    super(world, posX, posY, width, height, type, prefix, seed);
	}

	public override function build():void {
	    this.objects[this.prefix + 'roomBorder'] = new Room(this.world.world, this.posX, this.posY, this.width, this.height, 95 / this.world.physScale, this.type, 1, this.freedomTop, this.freedomBottom, this.freedomLeft, this.freedomRight);
	    this.objectsOrder = [this.prefix + 'roomBorder'];
	}

    }
	
}