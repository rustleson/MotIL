package Engine.Worlds {
	
    import Box2D.Dynamics.*;
    import Engine.Stats.GenericStats;
    import Engine.Objects.Utils;
    import General.Rndm;
	
    public class WorldRoom {
		
	public var world:World; 
	public var objects:Object;
	public var objectsOrder:Array;
	public var seed:uint;
	public var constructed:Boolean = false;
	public var explored:Boolean = false;
	public var visited:Boolean = false;
	public var power:int = 0;
	public var isArtefact:Boolean = false;
	public var prefix:String = "";
	public var type:uint = 0;
	public var freedomTop:uint = 0;
	public var freedomBottom:uint = 0;
	public var freedomLeft:uint = 0;
	public var freedomRight:uint = 0;
	public var posX:Number;
	public var posY:Number;
	public var width:Number;
	public var height:Number;

	public static const SPACE_TYPE:uint = GenericStats.decodeColor(GenericStats.SPACE_COLOR);
	public static const WATER_TYPE:uint = GenericStats.decodeColor(GenericStats.WATER_COLOR);
	public static const EARTH_TYPE:uint = GenericStats.decodeColor(GenericStats.EARTH_COLOR);
	public static const FIRE_TYPE:uint = GenericStats.decodeColor(GenericStats.FIRE_COLOR);
	public static const AIR_TYPE:uint = GenericStats.decodeColor(GenericStats.AIR_COLOR);
	public static const CORRUPTION_TYPE:uint = 0xA022D0;
	public static const BALANCE_TYPE:uint = 0xA0D070;
	public static const PURITY_TYPE:uint = 0x77D0BB;

	public function WorldRoom(world:World, posX:Number, posY:Number, width:Number, height:Number, type:uint, prefix:String, seed:uint){
	    this.world = world;
	    this.posX = posX;
	    this.posY = posY;
	    this.width = width;
	    this.height = height;
	    this.type = type;
	    this.prefix = prefix;
	    this.seed = seed;
	    this.objects = new Object();
	    this.objectsOrder = new Array();
	    this.init();
	}

	public function construct():void {
	    if (!this.constructed) {
		Rndm.seed = this.seed;
		this.build();
		for each (var objname:String in this.objectsOrder) {
		    this.world.objects[objname] = this.objects[objname];
		    this.world.objectsOrder.push(objname);
		}
		this.constructed = true;
		this.explored = true; 
	    }
	}

	public function deconstruct():void {
	    if (this.constructed) {
		// delete all room objects
		for each (var objname:String in this.objectsOrder) {
		    this.objects[objname].clearStuff();
		    delete this.objects[objname];
		    delete this.world.objects[objname];
		}
		// ...and its order arrays
		this.objectsOrder = new Array();
		for(var i:int = this.world.objectsOrder.length - 1; i >= 0; i--) {
		    if(this.world.objectsOrder[i].substr(0, this.prefix.length) == this.prefix) {
			this.world.objectsOrder.splice(i, 1);
		    }
		}
		this.constructed = false;
	    }
	}

	public function build():void {
	    // main function to override. Each object name *should* be unique starting from this.prefix
	}

	public function init():void {
	    // secondary function to override if you wanna put some additional init stuff
	}

	public function save():Object {
	    var saveObj:Object = {'explored': this.explored,
				  'visited': this.visited
				};
	    return saveObj;
	}

	public function load(saveObj:Object):void {
	    if (saveObj.hasOwnProperty('explored')) {
		this.explored = saveObj.explored;
		this.visited = saveObj.visited;
	    }
	}

    }
	
}