package Engine.Worlds {
	
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Engine.Stats.*;
    import Engine.Objects.Utils;
    import Engine.Objects.*;
    import General.Rndm;
	
    public class AltarRoom extends EmptyRoom {
	
	public var artefact:ArtefactStat;

	public function AltarRoom(world:World, posX:Number, posY:Number, width:Number, height:Number, type:uint, prefix:String, seed:uint, power:int, art:Boolean = false){
	    super(world, posX, posY, width, height, type, prefix, seed);
	    this.power = power;
	    this.isArtefact = art;
	}

	public override function build():void {
	    super.build();
	    var roomWidth:Number = (this.world as MandalaWorld).roomWidth;
	    var roomHeight:Number = (this.world as MandalaWorld).roomHeight;
	    var stairNum:int = (this.artefact == null) ? 5 : 10;
	    var dy:Number = this.height / 2 - 20.5 * stairNum / this.world.physScale - 135 / this.world.physScale;
	    this.objects[this.prefix + 'leftStaircase'] = new Staircase(this.world.world, this.posX + roomWidth / 2, this.posY + roomHeight / 2 + 100 / this.world.physScale + dy, 30 * stairNum / this.world.physScale, 20.5 * stairNum / this.world.physScale, stairNum, true, this.type);
	    this.objectsOrder.push(this.prefix + 'leftStaircase');
	    this.objects[this.prefix + 'rightStaircase'] = new Staircase(this.world.world, this.posX + roomWidth / 2, this.posY + roomHeight / 2 + 100 / this.world.physScale + dy, 30 * stairNum / this.world.physScale, 20.5 * stairNum / this.world.physScale, stairNum, false, this.type);
	    this.objectsOrder.push(this.prefix + 'rightStaircase');
	    this.objects[this.prefix + 'altar'] = new Altar(this.world.world, this.posX + roomWidth / 2 - 30 / this.world.physScale, this.posY + roomHeight / 2 + 30 / this.world.physScale + dy, 60 / this.world.physScale, 70 / this.world.physScale, Math.max(5, Math.min(16, Math.floor(this.power / 4))) / this.world.physScale, Math.max(15, Math.min(36, Math.floor(this.power / 1.5))) / this.world.physScale, type, 0.7);
	    if (this.artefact != null) {
		this.objects[this.prefix + 'altar'].artefact = this.artefact;
	    }
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

	    var a:Number = 0;
	    if (!this.freedomBottom)
		a = 0;
	    else if (!this.freedomRight)
		a = -Math.PI / 2;
	    else if (!this.freedomLeft)
		a = Math.PI / 2;
	    else if (!this.freedomTop)
		a = Math.PI;
	    for (var objName:String in this.objects) {
		if (objName != this.prefix + 'roomBorder') {
		    for each(var body:b2Body in this.objects[objName].bodies) {
			var x:Number = body.GetPosition().x - this.posX - this.width / 2;
			var y:Number = body.GetPosition().y - this.posY - this.height / 2;
		        var xtemp:Number = x * Math.cos(a) - y * Math.sin(a);
		        y = x * Math.sin(a) + y * Math.cos(a) + this.posY + this.height / 2;
			x = xtemp + this.posX + this.width / 2;
			body.SetPositionAndAngle(new b2Vec2(x, y), a);
		    }
		}
	    }
	}

    }
	
}