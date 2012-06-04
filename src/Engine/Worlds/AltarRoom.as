package Engine.Worlds {
	
    import Box2D.Common.*;
    import Engine.Stats.GenericStats;
    import Engine.Objects.Utils;
    import Engine.Objects.*;
    import General.Rndm;
	
    public class AltarRoom extends EmptyRoom {
	
	public function AltarRoom(world:World, posX:Number, posY:Number, width:Number, height:Number, type:uint, prefix:String, seed:uint, power:int, art:Boolean = false){
	    super(world, posX, posY, width, height, type, prefix, seed);
	    this.power = power;
	    this.isArtefact = art;
	}

	public override function build():void {
	    super.build();
	    var roomWidth:Number = (this.world as MandalaWorld).roomWidth;
	    var roomHeight:Number = (this.world as MandalaWorld).roomHeight;
	    this.objects[this.prefix + 'leftStaircase'] = new Staircase(this.world.world, this.posX + roomWidth / 2, this.posY + roomHeight / 2 + 100 / this.world.physScale, 300 / this.world.physScale, 205 / this.world.physScale, 10, true, this.type);
	    this.objectsOrder.push(this.prefix + 'leftStaircase');
	    this.objects[this.prefix + 'rightStaircase'] = new Staircase(this.world.world, this.posX + roomWidth / 2, this.posY + roomHeight / 2 + 100 / this.world.physScale, 300 / this.world.physScale, 205 / this.world.physScale, 10, false, this.type);
	    this.objectsOrder.push(this.prefix + 'rightStaircase');
	    this.objects[this.prefix + 'altar'] = new Altar(this.world.world, this.posX + roomWidth / 2 - 30 / this.world.physScale, this.posY + roomHeight / 2 + 30 / this.world.physScale, 60 / this.world.physScale, 70 / this.world.physScale, Math.max(5, Math.min(16, Math.floor(this.power / 4))) / this.world.physScale, Math.max(15, Math.min(36, Math.floor(this.power / 1.5))) / this.world.physScale, type, 0.7);
	    if (type == WorldRoom.SPACE_TYPE)
		this.objects[this.prefix + 'altar'].stats.space = 1;
	    if (type == WorldRoom.WATER_TYPE)
		this.objects[this.prefix + 'altar'].stats.water = 1;
	    if (type == WorldRoom.EARTH_TYPE)
		this.objects[this.prefix + 'altar'].stats.earth = 1;
	    if (type == WorldRoom.FIRE_TYPE)
		this.objects[this.prefix + 'altar'].stats.fire = 1;
	    if (type == WorldRoom.AIR_TYPE)
		this.objects[this.prefix + 'altar'].stats.air = 1;
	    if (type == WorldRoom.PURITY_TYPE)
		this.objects[this.prefix + 'altar'].stats.alignment = 1;
	    if (type == WorldRoom.CORRUPTION_TYPE)
		this.objects[this.prefix + 'altar'].stats.alignment = -1;
	    this.objectsOrder.push(this.prefix + 'altar');
	}

    }
	
}