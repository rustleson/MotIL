//---------------------------------------------------------------------------
//
//    Copyright 2011-2012 Reyna D "rustleson"
//
//---------------------------------------------------------------------------
//
//    This file is part of MotIL.
//
//    MotIL is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    MotIL is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with MotIL.  If not, see <http://www.gnu.org/licenses/>.
//
//---------------------------------------------------------------------------

package Engine.Stats {
	
    import flash.display.*;
    import Engine.Objects.*;
    import Engine.Worlds.WorldRoom;
    import Engine.Dialogs.MainStatsDialog;
    import Engine.Dialogs.Widgets.*;
    import flash.geom.Matrix;
    import mx.utils.StringUtil;
    import flash.events.MouseEvent;

    public class ProtagonistStats extends GenericStats {

	public static const DAKINI_TRIBE:int = 1; 
	public static const YAKSHINI_TRIBE:int = 2; 
	public static const RAKSHASI_TRIBE:int = 3; 
	public static const BG_LOW:int = 3; 
	public static const BG_MEDIUM:int = 2; 
	public static const BG_HIGH:int = 1; 
	public var TribesStrings:Object = new Object(); 
	public var ElementalStrings:Object = new Object(); 

	public var hairColor:uint = 0xdd44dd;
	public var eyesColor:uint = 0x22CC22;
	public var hairLength:Number = 1.5;

	public var _tribe:int = 0; // no tribe by default

	public var statsDialog:MainStatsDialog;

	public var vaginaSlot:SlotStat;
	public var anusSlot:SlotStat;
	public var mouthSlot:SlotStat;
	public var leftHandSlot:SlotStat;
	public var rightHandSlot:SlotStat;
	public var protagonist:Protagonist;
	public var artefacts:Object = new Object();
	public var death:Boolean = false;
	public var buddhaMode:Boolean = false;
	public var backgroundDetails:int = BG_HIGH; 
	public var ageConfirmed:Boolean = false; 
	public var generated:Boolean = false; 
	public var age:uint = 0;
	public var name:String = "";
	public var wasUpdated:Boolean = false;

	public function ProtagonistStats(){
	    this.vaginaSlot = new SlotStat();
	    this.anusSlot = new SlotStat();
	    this.mouthSlot = new SlotStat();
	    this.leftHandSlot = new SlotStat();
	    this.rightHandSlot = new SlotStat();
	    this.artefacts['wheel'] = new ArtefactStat("Wheel", Icons.Wheel, WorldRoom.SPACE_TYPE, "Wheel is the artefact of the Realm of Space. It gives you ability to teleport instantly to another place. Although, because spell is very complex, you unable to control exact destination place.");
	    this.artefacts['vajra'] = new ArtefactStat("Vajra", Icons.Vajra, WorldRoom.WATER_TYPE, "Vajra is the artefact of the Realm of Water. It gives you ability to stun your enemies. Although, it will not work distantly, but only if you will touch enemy with the Vajra.");
	    this.artefacts['jewel'] = new ArtefactStat("Jewel", Icons.Jewel, WorldRoom.EARTH_TYPE, "Jewel is the artefact of the Realm of Earth. It gives you ability to pass through walls made of rocks. You should touch a wall with the Jewel to make it temporarily transparent.");
	    this.artefacts['lotus'] = new ArtefactStat("Lotus", Icons.Lotus, WorldRoom.FIRE_TYPE, "Lotus is the artefact of the Realm of Fire. It gives you ability to arouse monsters which are not interested in you. You should touch a monster with the Lotus to arouse it.");
	    this.artefacts['sword'] = new ArtefactStat("Sword", Icons.Sword, WorldRoom.AIR_TYPE, "Sword is the artefact of the Realm of Air. It gives you ability to cut through bondages and will set you free if you've been constricted by a monster. You should touch a monster with the Lotus to free of it.");
	    this.artefacts['chastityBelt'] = new ArtefactStat("Chastity Belt", Icons.ChastityBelt, WorldRoom.PURITY_TYPE, "Chastity Belt is the artefact of the Realm of Purity. It gives you ability to purify monsters who are trying to rape you, and also helps to keep vaginal chastity to Heruka. You should attach it to vagina slot to take effect.");
	    this.artefacts['pacifier'] = new ArtefactStat("Pacifier", Icons.Pacifier, WorldRoom.BALANCE_TYPE, "Pacifier is the artefact of the Realm of Balance. It gives you ability to pacify monsters who are trying to rape you. You should attach it to mouth slot to take effect.");
	    this.artefacts['analTentacle'] = new ArtefactStat("Anal Tentacle", Icons.AnalTentacle, WorldRoom.CORRUPTION_TYPE, "Anal Tentacle is the artefact of the Realm of Corruption. It gives you ability to corrupt other monsters by raping them. You should attach it to anus slot to take effect. As a side effect, you're constantly raping youself with this artefact attached.");
	    TribesStrings[ProtagonistStats.DAKINI_TRIBE] = 'Dakini';
	    TribesStrings[ProtagonistStats.YAKSHINI_TRIBE] = 'Yakshini';
	    TribesStrings[ProtagonistStats.RAKSHASI_TRIBE] = 'Rakshasi'; 
	    ElementalStrings[WorldRoom.SPACE_TYPE] = 'Space';
	    ElementalStrings[WorldRoom.WATER_TYPE] = 'Water';
	    ElementalStrings[WorldRoom.EARTH_TYPE] = 'Earth';
	    ElementalStrings[WorldRoom.FIRE_TYPE] = 'Fire';
	    ElementalStrings[WorldRoom.AIR_TYPE] = 'Air'; 
	    ElementalStrings[WorldRoom.PURITY_TYPE] = 'Purity'; 
	    ElementalStrings[WorldRoom.BALANCE_TYPE] = 'Balance'; 
	    ElementalStrings[WorldRoom.CORRUPTION_TYPE] = 'Corruption'; 
	    super();
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
	    //return true; // !!! debug issues, remove as soon as possible !!!
	    return this.artefacts.wheel.obtained && this.artefacts.vajra.obtained && this.artefacts.jewel.obtained && this.artefacts.lotus.obtained && this.artefacts.sword.obtained; 
	}

	public function updateSlotParams():void {
	    var headUnit:Number = 5 / 8 * this.heightRatio;
	    var headWidth:Number = headUnit * 0.75 * this.wideRatio;
	    this.vaginaSlot.stretchedDiameter.fromValue = headWidth * 0.75 / 7;
	    this.vaginaSlot.stretchedDiameter.toValue = headWidth * 0.75;
	    this.anusSlot.stretchedDiameter.fromValue = headWidth * 0.6 / 10;
	    this.anusSlot.stretchedDiameter.toValue = headWidth * 0.6;
	    this.mouthSlot.stretchedDiameter.fromValue = headWidth * 0.45 / 3;
	    this.mouthSlot.stretchedDiameter.toValue = headWidth * 0.45;
	    this.vaginaSlot.stretchedLength.fromValue = headUnit * 1.6 / 7;
	    this.vaginaSlot.stretchedLength.toValue = headUnit * 1.6;
	    this.anusSlot.stretchedLength.fromValue = headUnit * 1.3 / 13;
	    this.anusSlot.stretchedLength.toValue = headUnit * 1.3;
	    this.mouthSlot.stretchedLength.fromValue = headUnit * 0.7 / 5;
	    this.mouthSlot.stretchedLength.toValue = headUnit * 0.7;
	    if (this.vaginaSlot.slot != null)
		this.vaginaSlot.slot.depth = this.vaginaSlot.stretchedLength.valueFrac;
	    if (this.anusSlot.slot != null)
		this.anusSlot.slot.depth = this.anusSlot.stretchedLength.valueFrac;
	    if (this.mouthSlot.slot != null)
		this.mouthSlot.slot.depth = this.mouthSlot.stretchedLength.valueFrac;
	}

	public override function set level(lev:int):void {
	    super.level = lev;
	    this.updateSlotParams();
	}

	public override function set constitution(v:Number):void {
	    var needRebuild:Boolean = this.constitution != v;
	    super.constitution = v;
	    this.updateSlotParams();
	    if (needRebuild && protagonist != null) {
		protagonist.rebuild();
	    }
	}

	public override function takeExp(dExp:Number):void {
	    var l:int = this.level;
	    super.takeExp(dExp);
	    this.updateSlotParams();
	    if (this.level > l) {
		protagonist.rebuild();
		this.statsDialog.widgets.log.show("Level Up! You are growing to level " + this.level.toString() + ".");
	    }
	}

	public override function takePleasure(dv:Number):Boolean {
	    var l:int = this.maxPleasure.level;
	    var isOrgasm:Boolean = super.takePleasure(dv);
	    if (isOrgasm) {
		this.takeExp(this.pleasure.max); // ?multiply on level?
		this.pleasure.value *= 0.2;
		this.statsDialog.widgets.log.show("Orgasm experience!");
		this.save();
	    }
	    if (this.maxPleasure.level > l) {
		this.statsDialog.widgets.log.show("Your orgasm point is improving to level " + this.maxPleasure.level.toString() + ".");
	    }
	    return isOrgasm;
	}

	public function takeAffinity(slot:SlotStat):void {
	    if (slot.pleasure) {
		var stats:GenericStats = slot.slot.connectedSlot.owner['stats'];
		var obj:Object = slot.slot.connectedSlot.owner;
		this.space += stats.space * slot.pleasure / 10000;
		this.water += stats.water * slot.pleasure / 10000;
		this.earth += stats.earth * slot.pleasure / 10000;
		this.fire += stats.fire * slot.pleasure / 10000;
		this.air += stats.air * slot.pleasure / 10000;
		this.alignment += stats.alignment * slot.pleasure / 10000;
		if (obj.hasOwnProperty('artefact') && obj.artefact != null && obj.artefact.nameReal == 'Pacifier') {
		    this.alignment +=  ((this.alignment > 0) ? -1 : 1) * slot.pleasure / 10000;
		}
		protagonist.color = this.mixedElementsColor;
		protagonist.bodyUserData.auraColor = this.auraColor;
		protagonist.bodyUserData.auraIntencity = this.auraIntencity;
		protagonist.headUserData.auraColor = this.auraColor;
		protagonist.headUserData.auraIntencity = this.auraIntencity;
		protagonist.handLUserData.auraColor = this.auraColor;
		protagonist.handLUserData.auraIntencity = this.auraIntencity;
		protagonist.handRUserData.auraColor = this.auraColor;
		protagonist.handRUserData.auraIntencity = this.auraIntencity;
		protagonist.wasUpdated = true;
		if (obj.hasOwnProperty('blissDonated') && obj.hasOwnProperty('artefact') && obj.artefact != null && !obj.artefact.obtained && obj.stats) {
		    if (this.space >= stats.space && this.water >= stats.water && this.earth >= stats.earth && this.fire >= stats.fire && this.air >= stats.air && 
			(obj.artefact.nameReal == 'Chastity Belt' && this.alignment == 1 || obj.artefact.nameReal == 'Anal Tentacle' && 
			 this.alignment == -1 || obj.artefact.nameReal == 'Pacifier' && Math.round(this.alignment * 100) == 0 || 
			 obj.artefact.nameReal != 'Chastity Belt' && obj.artefact.nameReal != 'Anal Tentacle' && obj.artefact.nameReal != 'Pacifier')) {
			obj.blissDonated += slot.pleasure;
		    }
		    if (obj.blissDonated > obj.blissToObtain) {
			obj.blissDonated = obj.blissToObtain;
			obj.artefact.obtained = true;
			this.statsDialog.widgets.log.show("Artefact absorbed: " + obj.artefact.name + ".");
			this.statsDialog.widgets.message.show(new Message(obj.artefact.name + ", powerful artefact of the " + this.ElementalStrings[obj.artefact.colorRaw] + " is now absorbed into yourself and ready to help on your quest! You can read artefact description by going to <i>nfo screen and rolling mouse over artefact icon.", "Insubstantial voice wispering...", 0xaaaaaa, Icons.Insubstantial));
			this.statsDialog.widgets.wheel.needUpdate = true;
			this.statsDialog.widgets.vajra.needUpdate = true;
			this.statsDialog.widgets.jewel.needUpdate = true;
			this.statsDialog.widgets.lotus.needUpdate = true;
			this.statsDialog.widgets.sword.needUpdate = true;
			this.statsDialog.widgets.chastityBelt.needUpdate = true;
			this.statsDialog.widgets.pacifier.needUpdate = true;
			this.statsDialog.widgets.analTentacle.needUpdate = true;
		    }
		}
		protagonist.wasUpdated = true;
	    }
	}

	public override function takePain(dv:Number, stat:ExpStat = null):Boolean {
	    var painBefore:Number = this.pain.value / this.pain.max;
	    var l:int = this.maxPain.level;
	    var isDeath:Boolean = super.takePain(dv);
	    var painAfter:Number = this.pain.value / this.pain.max;
	    if (stat != null) {
		stat.exp += dv * stat.level * stat.level / 4; //this._expPool.leakValue(dv * this.pain.value / this.pain.max);
	    }
	    if (painBefore < 0.95 && painAfter >= 0.95) {
		this.takeExp(this.pain.value * this.level * this.level);
		this.statsDialog.widgets.log.show("Near-death experience!");
	    }
	    if (this.maxPain.level > l) {
		this.statsDialog.widgets.log.show("Your pain treshold is improving to level " + this.maxPain.level.toString() + ".");
	    }
	    if (isDeath && !this.buddhaMode)  {
		this.death = true; // that's all baby, we'll meet in the AfterWorld
	    }
	    return isDeath;
	}

	public function initStats():void {
	    this.statsDialog.widgets.space.setTooltip("Your affinity with a Space element. 0% means there is no Space in you, 100% means you are made of pure Space.");
	    this.statsDialog.widgets.water.setTooltip("Your affinity with a Water element. 0% means there is no Water in you, 100% means you are made of pure Water.");
	    this.statsDialog.widgets.earth.setTooltip("Your affinity with an Earth element. 0% means there is no Earth in you, 100% means you are made of pure Earth.");
	    this.statsDialog.widgets.fire.setTooltip("Your affinity with a Fire element. 0% means there is no Fire in you, 100% means you are made of pure Fire.");
	    this.statsDialog.widgets.air.setTooltip("Your affinity with an Air element. 0% means there is no Air in you, 100% means you are made of pure Air.");
	    this.statsDialog.widgets.karma.setTooltip("Your Karma. -100 means you are totally corrupted, +100 means you are totally pure, 0 means pefect balance.");
	    this.statsDialog.widgets.levelup.setTooltip("You've reached new level and have upgrade points available.");
	    this.statsDialog.widgets.constitutionup.setTooltip("Press to upgrade your constitution.");
	    this.statsDialog.widgets.painresup.setTooltip("Press to upgrade your pain resistance.");
	    this.statsDialog.widgets.arouseup.setTooltip("Press to upgrade your arousal boost.");
	    this.statsDialog.widgets.speedup.setTooltip("Press to upgrade your speed.");
	    this.statsDialog.widgets.painres.setTooltip("Pain resistance. Higher this stat is, slower pain is increasing.");
	    this.statsDialog.widgets.arouse.setTooltip("Asousal boost. Higher this stat is, faster bliss is increasing.");
	    this.statsDialog.widgets.constitution.setTooltip("Constitution. Higher this stat is, more fat and less sensitive you are. Sensitivity means you are sensitive to both pain and bliss, so use this stat wise. If you are thin you must increase it, if you are fat you must avoid increasing.");
	    this.statsDialog.widgets.speed.setTooltip("Speed. Higher this stat is, more quick you are. Be careful, being too quick is not good for a light body, it can become uncontrollable. ");
	    this.statsDialog.widgets.pool.setTooltip("Experience pool. Once you get experience, it goes there. Then, you can reallocate exp from pool to other stats by making certain actions. I.e. when you are taking pain, your Pain Treshold stat is getting experience from pool; when you take pleasure, your Orgasm Point is improving, etc.");
	    this.statsDialog.widgets.points.setTooltip("Stat points. Once you have level up, you get some points to spend on following stats: Pain Resistance, Arousal Boost, Constitution, Speed. Unallocated points shown there.");
	    this.statsDialog.widgets.age.setTooltip("Your current incarnation age measured in hours and minutes.");
	    this.statsDialog.widgets.map.setTooltip("The world map. Only previously explored areas are shown there. Your current position is displaying as a white dot. Different colors means different Realms. Artefacts are displaying as dark colored spots.");
	    this.statsDialog.widgets.constitutionup.callback = this.constitutionUpClickHandler;
	    this.statsDialog.widgets.painresup.callback = this.painResistanceUpClickHandler;
	    this.statsDialog.widgets.arouseup.callback = this.arousalBoostUpClickHandler;
	    this.statsDialog.widgets.speedup.callback = this.speedUpClickHandler;
	    this.statsDialog.widgets.vaginaslot.slot = this.vaginaSlot;
	    this.statsDialog.widgets.mouthslot.slot = this.mouthSlot;
	    this.statsDialog.widgets.anusslot.slot = this.anusSlot;
	    this.statsDialog.widgets.rhandslot.slot = this.rightHandSlot;
	    this.statsDialog.widgets.lhandslot.slot = this.leftHandSlot;
	    this.statsDialog.widgets.vaginaslot.stats = this;
	    this.statsDialog.widgets.mouthslot.stats = this;
	    this.statsDialog.widgets.anusslot.stats = this;
	    this.statsDialog.widgets.rhandslot.stats = this;
	    this.statsDialog.widgets.lhandslot.stats = this;
	    this.statsDialog.widgets.wheel.artefact = this.artefacts.wheel;
	    this.statsDialog.widgets.vajra.artefact = this.artefacts.vajra;
	    this.statsDialog.widgets.jewel.artefact = this.artefacts.jewel;
	    this.statsDialog.widgets.lotus.artefact = this.artefacts.lotus;
	    this.statsDialog.widgets.sword.artefact = this.artefacts.sword;
	    this.statsDialog.widgets.chastityBelt.artefact = this.artefacts.chastityBelt;
	    this.statsDialog.widgets.pacifier.artefact = this.artefacts.pacifier;
	    this.statsDialog.widgets.analTentacle.artefact = this.artefacts.analTentacle;
	    this.statsDialog.widgets.wheel.stats = this;
	    this.statsDialog.widgets.vajra.stats = this;
	    this.statsDialog.widgets.jewel.stats = this;
	    this.statsDialog.widgets.lotus.stats = this;
	    this.statsDialog.widgets.sword.stats = this;
	    this.statsDialog.widgets.chastityBelt.stats = this;
	    this.statsDialog.widgets.pacifier.stats = this;
	    this.statsDialog.widgets.analTentacle.stats = this;
	    this.statsDialog.widgets.panel.titleString = this.name + " the " + TribesStrings[this.tribe];
	}

	public function updateStats():void {
	    this.takePain(this.mouthSlot.painD, this.mouthSlot.stretchedDiameter);
	    this.takePain(this.mouthSlot.painL, this.mouthSlot.stretchedLength);
	    this.takePleasure(this.mouthSlot.pleasure);
	    this.takeAffinity(this.mouthSlot);
	    this.mouthSlot.updatePosition();
	    this.takePain(this.vaginaSlot.painD, this.vaginaSlot.stretchedDiameter);
	    this.takePain(this.vaginaSlot.painL, this.vaginaSlot.stretchedLength);
	    this.takePleasure(this.vaginaSlot.pleasure);
	    this.takeAffinity(this.vaginaSlot);
	    this.vaginaSlot.updatePosition();
	    this.takePain(this.anusSlot.painD, this.anusSlot.stretchedDiameter);
	    this.takePain(this.anusSlot.painL, this.anusSlot.stretchedLength);
	    this.takePleasure(this.anusSlot.pleasure);
	    this.takeAffinity(this.anusSlot);
	    this.anusSlot.updatePosition();
	    this.statsDialog.widgets.space.value = this.space;
	    this.statsDialog.widgets.water.value = this.water;
	    this.statsDialog.widgets.earth.value = this.earth;
	    this.statsDialog.widgets.fire.value = this.fire;
	    this.statsDialog.widgets.air.value = this.air;
	    this.statsDialog.widgets.karma.value = this.alignment;
	    this.statsDialog.widgets.pain.value = this.pain.value / this.pain.max;
	    this.statsDialog.widgets.pain.valueString = int(this.pain.value).toString();
	    this.statsDialog.widgets.pain.setTooltip("A pain you are struggle. Reaching your pain treshold value makes you dead, so keep an eye on this stat well.\nPain treshold: " + Math.ceil(this.pain.max).toString());
	    this.statsDialog.widgets.pleasure.value = this.pleasure.value / this.pleasure.max;
	    this.statsDialog.widgets.pleasure.valueString = int(this.pleasure.value).toString();
	    this.statsDialog.widgets.pleasure.setTooltip("A bliss you are enjoing. Reaching your orgasm point value cause you to overflow with a bliss ang get experience. More bliss you've accumulated, more experience you get.\nOrgasm point: " + Math.ceil(this.pleasure.max).toString());
	    this.statsDialog.widgets.level.value = this.exp.tnlRatio;
	    this.statsDialog.widgets.level.valueString = this.exp.level.toString() + "L";
	    var expString:String = "Progress bar shows an experience needed to reach next level (TNL).\nCurrent level: {0}\nTotal experience: {1}\nTNL: {2}";
	    this.statsDialog.widgets.level.setTooltip("Your character experience. With each experience level you will get points to improve yourself.\n" + StringUtil.substitute(expString, this.exp.level.toString(), Math.ceil(this.exp.exp).toString(), Math.ceil(this.exp.tnl).toString()));
	    this.statsDialog.widgets.maxpain.value = this.maxPain.tnlRatio;
	    this.statsDialog.widgets.maxpain.valueString = this.maxPain.level.toString() + "L";
	    this.statsDialog.widgets.maxpain.setTooltip("Pain treshold. Higher this stat is, more pain you can stand before you die.\n" + StringUtil.substitute(expString, this.maxPain.level.toString(), Math.ceil(this.maxPain.exp).toString(), Math.ceil(this.maxPain.tnl).toString()));
	    this.statsDialog.widgets.painres.value = this.painResistanceLevel / 50;
	    this.statsDialog.widgets.painres.valueString = this.painResistanceLevel.toString() + "L";
	    this.statsDialog.widgets.maxpleasure.value = this.maxPleasure.tnlRatio;
	    this.statsDialog.widgets.maxpleasure.valueString = this.maxPleasure.level.toString() + "L";
	    this.statsDialog.widgets.maxpleasure.setTooltip("Orgasm point. Higher this stat is, more bliss you can stand without reaching orgasm.\n" + StringUtil.substitute(expString, this.maxPleasure.level.toString(), Math.ceil(this.maxPleasure.exp).toString(), Math.ceil(this.maxPleasure.tnl).toString()));
	    this.statsDialog.widgets.arouse.value = this.arousalBoostLevel / 50;
	    this.statsDialog.widgets.arouse.valueString = this.arousalBoostLevel.toString() + "L";
	    this.statsDialog.widgets.constitution.value = this.constitutionLevel / 50;
	    this.statsDialog.widgets.constitution.valueString = this.constitutionLevel.toString() + "L";
	    this.statsDialog.widgets.speed.value = this.speedLevel / 50;
	    this.statsDialog.widgets.speed.valueString = this.speedLevel.toString() + "L";
	    this.statsDialog.widgets.pool.value = this.expPool;
	    this.statsDialog.widgets.pool.valueString = int(this.expPool).toString();
	    this.statsDialog.widgets.points.value = int(this.pointPool);
	    this.statsDialog.widgets.points.valueString = int(this.pointPool).toString();
	    if (this.age % 1000 < 100) {
		this.statsDialog.widgets.age.value = this.age;
		this.statsDialog.widgets.age.valueString = this.leadingZero(Math.floor(this.age / (1000*60*60))) + ":" + this.leadingZero(Math.floor((this.age % (1000*60*60)) / (1000*60)));
	    }
	    this.statsDialog.widgets.mouthd.value = this.mouthSlot.stretchedDiameter.levelFrac / 50;
	    this.statsDialog.widgets.mouthd.valueString = (this.mouthSlot.stretchedDiameter.valueFrac*100).toFixed(1);
	    this.statsDialog.widgets.mouthl.value = this.mouthSlot.stretchedLength.levelFrac / 50;
	    this.statsDialog.widgets.mouthl.valueString = (this.mouthSlot.stretchedLength.valueFrac*100).toFixed(1);
	    this.statsDialog.widgets.vaginad.value = this.vaginaSlot.stretchedDiameter.levelFrac / 50;
	    this.statsDialog.widgets.vaginad.valueString = (this.vaginaSlot.stretchedDiameter.valueFrac*100).toFixed(1);
	    this.statsDialog.widgets.vaginal.value = this.vaginaSlot.stretchedLength.levelFrac / 50;
	    this.statsDialog.widgets.vaginal.valueString = (this.vaginaSlot.stretchedLength.valueFrac*100).toFixed(1);
	    this.statsDialog.widgets.anusd.value = this.anusSlot.stretchedDiameter.levelFrac / 50;
	    this.statsDialog.widgets.anusd.valueString = (this.anusSlot.stretchedDiameter.valueFrac*100).toFixed(1);
	    this.statsDialog.widgets.anusl.value = this.anusSlot.stretchedLength.levelFrac / 50;
	    this.statsDialog.widgets.anusl.valueString = (this.anusSlot.stretchedLength.valueFrac*100).toFixed(1);
	    this.statsDialog.upgradeAvailable = (this.pointPool > 0);
	    this.statsDialog.update();
	}

	public function constitutionUpClickHandler(event:MouseEvent = null):void {
	    if (this.pointPool > 0 && this.constitutionLevel < 50) {
		this.constitution = this.constitutionLevel + 1;
		this.pointPool -= 1;
		this.statsDialog.widgets.log.show("Your Constitution is upgraded to level " + this.constitutionLevel.toString() + ".");
		if (this.pointPool == 0)
		    this.statsDialog.upgradeAvailable = false;
	    }
	}

	public function painResistanceUpClickHandler(event:MouseEvent = null):void {
	    if (this.pointPool > 0 && this.painResistanceLevel < 50) {
		this.painResistance = this.painResistanceLevel + 1;
		this.pointPool -= 1;
		this.statsDialog.widgets.log.show("Your Pain Resistance is upgraded to level " + this.painResistanceLevel.toString() + ".");
		if (this.pointPool == 0)
		    this.statsDialog.upgradeAvailable = false;
	    }
	}

	public function arousalBoostUpClickHandler(event:MouseEvent = null):void {
	    if (this.pointPool > 0 && this.arousalBoostLevel < 50) {
		this.arousalBoost = this.arousalBoostLevel + 1;
		this.pointPool -= 1;
		this.statsDialog.widgets.log.show("Your Arousal Boost is upgraded to level " + this.arousalBoostLevel.toString() + ".");
		if (this.pointPool == 0)
		    this.statsDialog.upgradeAvailable = false;
	    }
	}

	public function speedUpClickHandler(event:MouseEvent = null):void {
	    if (this.pointPool > 0 && this.speedLevel < 50) {
		this.speed = this.speedLevel + 1;
		this.pointPool -= 1;
		this.statsDialog.widgets.log.show("Your Speed is upgraded to level " + this.speedLevel.toString() + ".");
		if (this.pointPool == 0)
		    this.statsDialog.upgradeAvailable = false;
	    }
	}

	public override function set space(v:Number):void {
	    var valBefore:Number = this.space;
	    super.space = v;
	    if (this.space == 1 && valBefore != 1 && this.statsDialog != null)
		this.statsDialog.widgets.log.show("Your are made of pure Space now.");
	}

	public override function set water(v:Number):void {
	    var valBefore:Number = this.water;
	    super.water = v;
	    if (this.water == 1 && valBefore != 1 && this.statsDialog != null)
		this.statsDialog.widgets.log.show("Your are made of pure Water now.");
	}

	public override function set earth(v:Number):void {
	    var valBefore:Number = this.earth;
	    super.earth = v;
	    if (this.earth == 1 && valBefore != 1 && this.statsDialog != null)
		this.statsDialog.widgets.log.show("Your are made of pure Earth now.");
	}

	public override function set fire(v:Number):void {
	    var valBefore:Number = this.fire;
	    super.fire = v;
	    if (this.fire == 1 && valBefore != 1 && this.statsDialog != null)
		this.statsDialog.widgets.log.show("Your are made of pure Fire now.");
	}

	public override function set air(v:Number):void {
	    var valBefore:Number = this.air;
	    super.air = v;
	    if (this.air == 1 && valBefore != 1 && this.statsDialog != null)
		this.statsDialog.widgets.log.show("Your are made of pure Air now.");
	}

	public override function set alignment(v:Number):void {
	    var valBefore:Number = this.alignment;
	    super.alignment = v;
	    if (this.alignment == 1 && valBefore != 1 && this.statsDialog != null)
		this.statsDialog.widgets.log.show("Your are totally Pure now.");
	    if (this.alignment == -1 && valBefore != -1 && this.statsDialog != null)
		this.statsDialog.widgets.log.show("Your are totally Corrupted now.");
	    if (Math.round(this.alignment * 100) == 0 && Math.round(valBefore) != 0 && this.statsDialog != null)
		this.statsDialog.widgets.log.show("Your are of perfect Balance now.");
	}
	
	public function save():void {
	    if (this.buddhaMode)
		return;
	    var saveObj:Object = {'ageConfirmed': this.ageConfirmed,
				  'space': this._space,
				  'water': this._water,
				  'earth': this._earth,
				  'fire': this._fire,
				  'air': this._air,
				  'alignment': this._alignment,
				  'tendencyRatio': this._tendencyRatio,
				  'alignmentTendency': this._alignmentTendency,
				  'pain': this._pain.save(),
				  'pleasure': this._pleasure.save(),
				  'expPool': this._expPool.save(),
				  'pointPool': this._pointPool.save(),
				  'level': this._level.save(),
				  'maxPain': this._maxPain.save(),
				  'maxPleasure': this._maxPleasure.save(),
				  'constitution': this._constitution.save(),
				  'painResistance': this._painResistance.save(),
				  'arousalBoost': this._arousalBoost.save(),
				  'speed': this._speed.save(),
				  'hairColor': this.hairColor,
				  'hairLength': this.hairLength,
				  'eyesColor': this.eyesColor,
				  'tribe': this._tribe,
				  'vagina': this.vaginaSlot.save(),
				  'anus': this.anusSlot.save(),
				  'mouth': this.mouthSlot.save(),
				  'leftHand': this.leftHandSlot.save(),
				  'rightHand': this.rightHandSlot.save(),
				  'name': this.name,
				  'artefacts': {}
				};
	    for (var key:String in this.artefacts) {
		saveObj.artefacts[key] = artefacts[key].save();
	    }
	    Main.save.data['stats'] = saveObj;
	    Main.save.flush();
	}

	public function load():Boolean {
	    if (Main.save.data.hasOwnProperty('stats')) {
		var saveObj:Object = Main.save.data.stats;
		this._space = saveObj.space;
		this._water = saveObj.water;
		this._earth = saveObj.earth;
		this._fire = saveObj.fire;
		this._air = saveObj.air;
		this._alignment = saveObj.alignment;
		this._alignmentTendency = saveObj.alignmentTendency;
		this._tendencyRatio = saveObj.tendencyRatio;
		this._pain.load(saveObj.pain);
		this._pleasure.load(saveObj.pleasure);
		this._expPool.load(saveObj.expPool);
		this._pointPool.load(saveObj.pointPool);
		this._level.load(saveObj.level);
		this._maxPain.load(saveObj.maxPain);
		this._maxPleasure.load(saveObj.maxPleasure);
		this._constitution.load(saveObj.constitution);
		this._painResistance.load(saveObj.painResistance);
		this._arousalBoost.load(saveObj.arousalBoost);
		this._speed.load(saveObj.speed);
		this.hairColor = saveObj.hairColor;
		this.hairLength = saveObj.hairLength;
		this.eyesColor = saveObj.eyesColor;
		this._tribe = saveObj.tribe;
		this.ageConfirmed = saveObj.ageConfirmed;
		if (saveObj.hasOwnProperty('artefacts')) {
		    for (var key:String in this.artefacts) {
			artefacts[key].load(saveObj.artefacts[key]);
		    }
		}
		if (saveObj.hasOwnProperty('vagina')) {
		    this.vaginaSlot.load(saveObj.vagina, this.artefacts);
		    this.anusSlot.load(saveObj.anus, this.artefacts);
		    this.mouthSlot.load(saveObj.mouth, this.artefacts);
		    this.leftHandSlot.load(saveObj.leftHand, this.artefacts);
		    this.rightHandSlot.load(saveObj.rightHand, this.artefacts);
		}
		if (saveObj.hasOwnProperty('name')) {
		    this.name = saveObj.name;
		}
		return true;
	    }
	    return false;
	}

	private function leadingZero(num : Number) : String {
	    if(num < 10) {
		return "0" + num;
	    }
	    return num.toString();
	}

    }
	
}