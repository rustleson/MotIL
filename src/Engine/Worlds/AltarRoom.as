package Engine.Worlds {
	
    import Box2D.Common.*;
    import Engine.Stats.GenericStats;
    import Engine.Objects.Utils;
    import Engine.Objects.*;
    import General.Rndm;
	
    public class AltarRoom extends EmptyRoom {

	public function AltarRoom(world:World, posX:Number, posY:Number, width:Number, height:Number, type:uint, prefix:String, seed:uint){
	    super(world, posX, posY, width, height, type, prefix, seed);
	}

	public override function build():void {
	    super.build();
	    var roomWidth:Number = (this.world as MandalaWorld).roomWidth;
	    var roomHeight:Number = (this.world as MandalaWorld).roomHeight;
	    this.objects[this.prefix + 'leftStaircase'] = new Staircase(this.world.world, this.posX + roomWidth / 2, this.posY + roomHeight / 2 + 200 / this.world.physScale, 300 / this.world.physScale, 205 / this.world.physScale, 10, true, this.type);
	    this.objectsOrder.push(this.prefix + 'leftStaircase');
	    this.objects[this.prefix + 'rightStaircase'] = new Staircase(this.world.world, this.posX + roomWidth / 2, this.posY + roomHeight / 2 + 200 / this.world.physScale, 300 / this.world.physScale, 205 / this.world.physScale, 10, false, this.type);
	    this.objectsOrder.push(this.prefix + 'rightStaircase');
	    this.objects[this.prefix + 'altar'] = new Altar(this.world.world, this.posX + roomWidth / 2 - 30 / this.world.physScale, this.posY + roomHeight / 2 + 130 / this.world.physScale, 60 / this.world.physScale, 70 / this.world.physScale, Rndm.integer(5, 16) / this.world.physScale, Rndm.integer(25, 36) / this.world.physScale, type, 0.7);
	    this.objectsOrder.push(this.prefix + 'altar');
	}

    }
	
}