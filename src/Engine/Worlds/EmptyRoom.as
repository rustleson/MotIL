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
	    Rndm.seed = seed;
	    var roomType:int;
	    switch (this.type) {
	      case WorldRoom.SPACE_TYPE:
		  roomType = Room.ROOM_TYPE_OPEN;
		  break;
	      case WorldRoom.WATER_TYPE:
		  roomType = Room.ROOM_TYPE_EMPTY + Rndm.bit(0.13);
		  break;
	      case WorldRoom.EARTH_TYPE:
		  roomType = Room.ROOM_TYPE_TUNNEL - Rndm.bit(0.23);
		  break;
	      case WorldRoom.FIRE_TYPE:
		  roomType = Room.ROOM_TYPE_EMPTY + Rndm.integer(3);
		  break;
	      case WorldRoom.AIR_TYPE:
		  roomType = Room.ROOM_TYPE_EMPTY - Rndm.bit(0.5);
		  break;
	      case WorldRoom.PURITY_TYPE:
		  roomType = Room.ROOM_TYPE_OPEN + Rndm.bit(0.1);
		  break;
	      case WorldRoom.BALANCE_TYPE:
		  roomType = Rndm.integer(1, 5);
		  break;
	      case WorldRoom.CORRUPTION_TYPE:
		  roomType = Room.ROOM_TYPE_RUBBLE - Rndm.bit(0.23);
		  break;
	      default:
		  roomType = Room.ROOM_TYPE_EMPTY;
	    }
	    this.objects[this.prefix + 'roomBorder'] = new Room(this.world.world, this.posX, this.posY, this.width, this.height, 35 / this.world.physScale, this.type, 1, this.freedomTop, this.freedomBottom, this.freedomLeft, this.freedomRight, roomType);
	    this.objectsOrder = [this.prefix + 'roomBorder'];
	}

	public function get birthX():Number {
	    return this.objects[this.prefix + 'roomBorder'].birthX;
	}

	public function get birthY():Number {
	    return this.objects[this.prefix + 'roomBorder'].birthY;
	}

    }
	
}