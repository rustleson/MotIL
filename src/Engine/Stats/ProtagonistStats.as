package Engine.Stats {
	
    import flash.display.*;
    import Engine.Objects.*;
    import Engine.Dialogs.MainStatsDialog;
    import flash.geom.Matrix;

    public class ProtagonistStats extends GenericStats {

	public static const DAKINI_TRIBE:int = 1; 
	public static const YAKSHINI_TRIBE:int = 2; 
	public static const RAKSHASI_TRIBE:int = 3; 

	public var hairColor:uint = 0xdd44dd;
	public var eyesColor:uint = 0x22CC22;
	public var hairLength:Number = 1.5;

	public var _tribe:int = 0; // no tribe by default

	public var statsDialog:MainStatsDialog;

	public var vaginaSlot:Slot;
	public var anusSlot:Slot;
	public var mouthSlot:Slot;
	public var leftHandSlot:Slot;
	public var rightHandSlot:Slot;

	public function ProtagonistStats(){

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

	public function updateStats():void {
	    this.statsDialog.widgets.space.value = this.space;
	    this.statsDialog.widgets.water.value = this.water;
	    this.statsDialog.widgets.earth.value = this.earth;
	    this.statsDialog.widgets.fire.value = this.fire;
	    this.statsDialog.widgets.air.value = this.air;
	    this.statsDialog.widgets.karma.value = this.alignment;
	    this.statsDialog.update();
	}

    }
	
}