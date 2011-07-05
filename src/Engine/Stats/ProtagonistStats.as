package Engine.Stats {
	
    import flash.display.*;
    import Engine.Objects.*;
    import Engine.Dialogs.MainStatsDialog;
    import flash.geom.Matrix;
    import mx.utils.StringUtil;
    import flash.events.MouseEvent;

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

	public function initStats():void {
	    this.statsDialog.widgets.space.setTooltip("Your affinity with a Space element. 0% means there is no Space in you, 100% means you are made of pure Space.", -150, 10);
	    this.statsDialog.widgets.water.setTooltip("Your affinity with a Water element. 0% means there is no Water in you, 100% means you are made of pure Water.", -150, 10);
	    this.statsDialog.widgets.earth.setTooltip("Your affinity with an Earth element. 0% means there is no Earth in you, 100% means you are made of pure Earth.", -150, 10);
	    this.statsDialog.widgets.fire.setTooltip("Your affinity with a Fire element. 0% means there is no Fire in you, 100% means you are made of pure Fire.", -150, 10);
	    this.statsDialog.widgets.air.setTooltip("Your affinity with an Air element. 0% means there is no Air in you, 100% means you are made of pure Air.", -150, 10);
	    this.statsDialog.widgets.karma.setTooltip("Your Karma. -100 means you are totally corrupted, +100 means you are totally pure, 0 means pefect balance.", -150, 10);
	    this.statsDialog.widgets.levelup.setTooltip("You've  reached new level and have upgrade points available.", -150, 10);
	    this.statsDialog.widgets.constitutionup.setTooltip("Press to upgrade your constitution.", -150, 10);
	    this.statsDialog.widgets.painresup.setTooltip("Press to upgrade your pain resistance.", -150, 10);
	    this.statsDialog.widgets.arouseup.setTooltip("Press to upgrade your arousal boost.", -150, 10);
	    this.statsDialog.widgets.speedup.setTooltip("Press to upgrade your speed.", -150, 10);
	    this.statsDialog.widgets.painres.setTooltip("Pain resistance. Higher this stat is, slower pain is increasing.", -150, 10);
	    this.statsDialog.widgets.arouse.setTooltip("Asousal boost. Higher this stat is, faster bliss is increasing.", -150, 10);
	    this.statsDialog.widgets.constitution.setTooltip("Constitution. Higher this stat is, more fat and less sensitive you are. Sensitivity means you are sensitive to both pain and bliss, so use this stat wise. If you are thin you must increase it, if you are fat you must avoid increasing.", -150, 10);
	    this.statsDialog.widgets.speed.setTooltip("Speed. Higher this stat is, more quick you are. Be careful, being too quick is not good for a light body, it can become uncontrollable. ", -150, 10);
	    this.statsDialog.widgets.pool.setTooltip("Experience pool. Once you get experience, it goes there. Then, you can reallocate exp from pool to other stats by making certain actions. I.e. when you are taking pain, your Pain Treshold stat is getting experience from pool; when you take pleasure, your Orgasm Point is improvint, etc.", -150, 10);
	    this.statsDialog.widgets.points.setTooltip("Stat points. Once you have level up, you get some points to spend on following stats: Pain Resistance, Arousal Boost, Constitution, Speed. Unallocated points shown there.", -150, 10);
	    this.statsDialog.widgets.constitutionup.callback = this.constitutionUpClickHandler;
	    this.statsDialog.widgets.painresup.callback = this.painResistanceUpClickHandler;
	    this.statsDialog.widgets.arouseup.callback = this.arousalBoostUpClickHandler;
	    this.statsDialog.widgets.speedup.callback = this.speedUpClickHandler;
	}

	public function updateStats():void {
	    this.statsDialog.widgets.space.value = this.space;
	    this.statsDialog.widgets.water.value = this.water;
	    this.statsDialog.widgets.earth.value = this.earth;
	    this.statsDialog.widgets.fire.value = this.fire;
	    this.statsDialog.widgets.air.value = this.air;
	    this.statsDialog.widgets.karma.value = this.alignment;
	    this.statsDialog.widgets.pain.value = this.pain.value / this.pain.max;
	    this.statsDialog.widgets.pain.valueString = int(this.pain.value).toString();
	    this.statsDialog.widgets.pain.setTooltip("A pain you are struggle. Reaching your pain treshold value makes you dead, so keep an eye on this stat well.\nPain treshold: " + Math.ceil(this.pain.max).toString(), -150, 10);
	    this.statsDialog.widgets.pleasure.value = this.pleasure.value / this.pleasure.max;
	    this.statsDialog.widgets.pleasure.valueString = int(this.pleasure.value).toString();
	    this.statsDialog.widgets.pleasure.setTooltip("A bliss you are enjoing. Reaching your orgasm point value cause you to overflow with a bliss ang get experience. More bliss you've accumulated, more experience you get.\nOrgasm point: " + Math.ceil(this.pleasure.max).toString(), -150, 10);
	    this.statsDialog.widgets.level.value = this.exp.tnlRatio;
	    this.statsDialog.widgets.level.valueString = this.exp.level.toString() + "L";
	    var expString:String = "Progress bar shows an experience needed to reach next level (TNL).\nCurrent level: {0}\nTotal experience: {1}\nTNL: {2}";
	    this.statsDialog.widgets.level.setTooltip("Your character experience. With each experience level you will get points to improve yourself.\n" + StringUtil.substitute(expString, this.exp.level.toString(), Math.ceil(this.exp.exp).toString(), Math.ceil(this.exp.tnl).toString()), -150, 10);
	    this.statsDialog.widgets.maxpain.value = this.maxPain.tnlRatio;
	    this.statsDialog.widgets.maxpain.valueString = this.maxPain.level.toString() + "L";
	    this.statsDialog.widgets.maxpain.setTooltip("Pain treshold. Higher this stat is, more pain you can stand before you die.\n" + StringUtil.substitute(expString, this.maxPain.level.toString(), Math.ceil(this.maxPain.exp).toString(), Math.ceil(this.maxPain.tnl).toString()), -150, 10);
	    this.statsDialog.widgets.painres.value = this.painResistanceLevel / 50;
	    this.statsDialog.widgets.painres.valueString = this.painResistanceLevel.toString() + "L";
	    this.statsDialog.widgets.maxpleasure.value = this.maxPleasure.tnlRatio;
	    this.statsDialog.widgets.maxpleasure.valueString = this.maxPleasure.level.toString() + "L";
	    this.statsDialog.widgets.maxpleasure.setTooltip("Orgasm point. Higher this stat is, more bliss you can stand without reaching orgasm.\n" + StringUtil.substitute(expString, this.maxPleasure.level.toString(), Math.ceil(this.maxPleasure.exp).toString(), Math.ceil(this.maxPleasure.tnl).toString()), -150, 10);
	    this.statsDialog.widgets.arouse.value = this.arousalBoostLevel / 50;
	    this.statsDialog.widgets.arouse.valueString = this.arousalBoostLevel.toString() + "L";
	    this.statsDialog.widgets.constitution.value = this.constitutionLevel / 50;
	    this.statsDialog.widgets.constitution.valueString = this.constitutionLevel.toString() + "L";
	    this.statsDialog.widgets.speed.value = this.speedLevel / 50;
	    this.statsDialog.widgets.speed.valueString = this.speedLevel.toString() + "L";
	    this.statsDialog.widgets.pool.valueString = this.expPool;
	    this.statsDialog.widgets.pool.valueString = int(this.expPool).toString();
	    this.statsDialog.widgets.points.value = int(this.pointPool);
	    this.statsDialog.widgets.points.valueString = int(this.pointPool).toString();
	    this.statsDialog.upgradeAvailable = (this.pointPool > 0);
	    this.statsDialog.update();
	}

	private function constitutionUpClickHandler(event:MouseEvent):void {
	    if (this.pointPool > 0) {
		this.constitution = this.constitutionLevel + 1;
		this.pointPool -= 1;
	    }
	}

	private function painResistanceUpClickHandler(event:MouseEvent):void {
	    if (this.pointPool > 0) {
		this.painResistance = this.painResistanceLevel + 1;
		this.pointPool -= 1;
	    }
	}

	private function arousalBoostUpClickHandler(event:MouseEvent):void {
	    if (this.pointPool > 0) {
		this.arousalBoost = this.arousalBoostLevel + 1;
		this.pointPool -= 1;
	    }
	}

	private function speedUpClickHandler(event:MouseEvent):void {
	    if (this.pointPool > 0) {
		this.speed = this.speedLevel + 1;
		this.pointPool -= 1;
	    }
	}


    }
	
}