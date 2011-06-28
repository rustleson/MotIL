package Engine.Stats {
	
    import flash.display.*;
    import Engine.Objects.*;
    import flash.geom.Matrix;

    public class ProtagonistStats extends GenericStats {

	public static const DAKINI_TRIBE:int = 1; 
	public static const YAKSHINI_TRIBE:int = 2; 
	public static const RAKSHASI_TRIBE:int = 3; 

	public var hairColor:uint = 0xdd44dd;
	public var eyesColor:uint = 0x22CC22;
	public var hairLength:Number = 1.5;

	public var _tribe:int = 0; // no tribe by default

	public var statsSprite:Sprite;
	private var needUpdate:Boolean = true;

	public var vaginaSlot:Slot;
	public var anusSlot:Slot;
	public var mouthSlot:Slot;
	public var leftHandSlot:Slot;
	public var rightHandSlot:Slot;

	public function ProtagonistStats(){
	    statsSprite = new Sprite();
	}

	public override function set space(v:Number):void {
	    super.space = v;
	    this.needUpdate = true;
	}

	public override function set water(v:Number):void {
	    super.water = v;
	    this.needUpdate = true;
	}

	public override function set earth(v:Number):void {
	    super.earth = v;
	    this.needUpdate = true;
	}

	public override function set air(v:Number):void {
	    super.air = v;
	    this.needUpdate = true;
	}

	public override function set fire(v:Number):void {
	    super.fire = v;
	    this.needUpdate = true;
	}

	public override function set alignment(v:Number):void {
	    super.alignment = v;
	    this.needUpdate = true;
	}

	public function get tribe():int {
	    return this._tribe;
	}

	public function set tribe(tr:int):void {
	    switch (tr) {
	      case DAKINI_TRIBE: 
		  this.alignmentTendency = 1;
		  this.tendencyRatio = 0.7;
		  this.alignment = 0.2;
		  break;
	      case YAKSHINI_TRIBE: 
		  this.alignmentTendency = 0;
		  this.tendencyRatio = 0.7;
		  this.alignment = 0;
		  break;
	      case RAKSHASI_TRIBE:
		  this.alignmentTendency = -1;
		  this.tendencyRatio = 0.7;
		  this.alignment = -0.2;
		  break;
	      default:
		  break;
	    }
	    this._tribe = tr;
	}

	public override function get wideRatio():Number {
	    var dr:Number = super.wideRatio - 1;
	    switch (this.tribe) {
	      case DAKINI_TRIBE: 
		  return 1 + dr ;
	      case YAKSHINI_TRIBE: 
		  return 1.25 + dr;
	      case RAKSHASI_TRIBE: 
		  return 0.85 + dr;
	      default:
		  return 1 + dr;
	    }
	}

	public function isEnlightened():Boolean {
	    return true; // TODO: dependent of artifacts occured
	}

	public function renderStats(appWidth:int):void {
	    if (this.needUpdate) {
		var c:uint;
		this.statsSprite.graphics.clear();
		this.statsSprite.graphics.beginFill(0, 0.5);
		this.statsSprite.graphics.drawRect(appWidth - 117, 5, 112, 65);
		this.statsSprite.graphics.endFill();
		c = (this.SPACE_COLOR[0] << 16) + (this.SPACE_COLOR[1] << 8) + this.SPACE_COLOR[2];
		this.statsSprite.graphics.beginFill(c, 0.3);
		this.statsSprite.graphics.drawRect(appWidth - 112, 10, 102, 5);
		this.statsSprite.graphics.endFill();
		this.statsSprite.graphics.beginFill(c, 0.8);
		this.statsSprite.graphics.drawRect(appWidth - 111, 11, 100 * this.space, 3);
		this.statsSprite.graphics.drawRect(appWidth - 111 + 100 * this.space, 9, 2, 7);
		this.statsSprite.graphics.endFill();
		c = (this.WATER_COLOR[0] << 16) + (this.WATER_COLOR[1] << 8) + this.WATER_COLOR[2];
		this.statsSprite.graphics.beginFill(c, 0.3);
		this.statsSprite.graphics.drawRect(appWidth - 112, 20, 102, 5);
		this.statsSprite.graphics.endFill();
		this.statsSprite.graphics.beginFill(c, 0.8);
		this.statsSprite.graphics.drawRect(appWidth - 111, 21, 100 * this.water, 3);
		this.statsSprite.graphics.drawRect(appWidth - 111 + 100 * this.water, 19, 2, 7);
		this.statsSprite.graphics.endFill();
		c = (this.EARTH_COLOR[0] << 16) + (this.EARTH_COLOR[1] << 8) + this.EARTH_COLOR[2];
		this.statsSprite.graphics.beginFill(c, 0.3);
		this.statsSprite.graphics.drawRect(appWidth - 112, 30, 102, 5);
		this.statsSprite.graphics.endFill();
		this.statsSprite.graphics.beginFill(c, 0.8);
		this.statsSprite.graphics.drawRect(appWidth - 111, 31, 100 * this.earth, 3);
		this.statsSprite.graphics.drawRect(appWidth - 111 + 100 * this.earth, 29, 2, 7);
		this.statsSprite.graphics.endFill();
		c = (this.FIRE_COLOR[0] << 16) + (this.FIRE_COLOR[1] << 8) + this.FIRE_COLOR[2];
		this.statsSprite.graphics.beginFill(c, 0.3);
		this.statsSprite.graphics.drawRect(appWidth - 112, 40, 102, 5);
		this.statsSprite.graphics.endFill();
		this.statsSprite.graphics.beginFill(c, 0.8);
		this.statsSprite.graphics.drawRect(appWidth - 111, 41, 100 * this.fire, 3);
		this.statsSprite.graphics.drawRect(appWidth - 111 + 100 * this.fire, 39, 2, 7);
		this.statsSprite.graphics.endFill();
		c = (this.AIR_COLOR[0] << 16) + (this.AIR_COLOR[1] << 8) + this.AIR_COLOR[2];
		this.statsSprite.graphics.beginFill(c, 0.3);
		this.statsSprite.graphics.drawRect(appWidth - 112, 50, 102, 5);
		this.statsSprite.graphics.endFill();
		this.statsSprite.graphics.beginFill(c, 0.8);
		this.statsSprite.graphics.drawRect(appWidth - 111, 51, 100 * this.air, 3);
		this.statsSprite.graphics.drawRect(appWidth - 111 + 100 * this.air, 49, 2, 7);
		this.statsSprite.graphics.endFill();

		var gradMatrix:Matrix = new Matrix();
		gradMatrix.createGradientBox(102, 5, 0, appWidth - 112, 60);
		this.statsSprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xffffff], [0.7, 0.7], [0x00, 0xff], gradMatrix);
		this.statsSprite.graphics.drawRect(appWidth - 112, 60, 102, 5);
		this.statsSprite.graphics.endFill();
		if (this.alignment > 0) {
		    this.statsSprite.graphics.lineStyle(0.3, Utils.colorDark(0x787878, this.alignment), 1);
		    this.statsSprite.graphics.beginFill(Utils.colorLight(0x787878, this.alignment), 1);
		    this.statsSprite.graphics.drawRect(appWidth - 113 + 50 + 100 * (this.alignment / 2), 59, 2, 7);
		} else {
		    this.statsSprite.graphics.lineStyle(0.3, Utils.colorLight(0x787878, -this.alignment), 1);
		    this.statsSprite.graphics.beginFill(Utils.colorDark(0x787878, -this.alignment), 1);
		    this.statsSprite.graphics.drawRect(appWidth - 113 + 50 + 100 * (this.alignment / 2), 59, 2, 7);
		}
		this.statsSprite.graphics.endFill();
	    }
	    
	}

    }
	
}