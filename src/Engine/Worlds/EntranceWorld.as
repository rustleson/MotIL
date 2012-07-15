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

package Engine.Worlds {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import General.Input;
    import Engine.Objects.*;
    import Engine.Stats.*;
    import Engine.Dialogs.*;
    import Engine.Dialogs.Widgets.*;
    import flash.events.Event;
    import flash.display.*;
    import flash.geom.Matrix;
    import Box2D.Dynamics.Controllers.*;
	
    public class EntranceWorld extends World {
		
	public var bc:b2BuoyancyController = new b2BuoyancyController();
	public var dialog:EntranceDialog;
	public var helpDialog:HelpDialog;
	//public var finished:Boolean = false; // flag for the Main would know when to destroy this world

	private var backgroundsCache:Object = new Object();
	private var roomTypes:Array = [WorldRoom.SPACE_TYPE, WorldRoom.WATER_TYPE, WorldRoom.EARTH_TYPE, WorldRoom.FIRE_TYPE, WorldRoom.AIR_TYPE, WorldRoom.CORRUPTION_TYPE, WorldRoom.BALANCE_TYPE, WorldRoom.PURITY_TYPE ];
	private var impulseCounter:uint = 0;

	public function EntranceWorld($stats:ProtagonistStats, seed:uint, rebirth:Boolean = false){
			
	    // backgrounds
	    for each (var type:uint in this.roomTypes) {
		this.backgroundsCache[type] = Utils.buildBackgrounds(type, appWidth, appHeight);
	    }
	    this.backgrounds = this.backgroundsCache[WorldRoom.SPACE_TYPE];
	    world.SetGravity(new b2Vec2(0, 0));
			
	    objects['protagonist'] = new Protagonist(world, -150 / physScale, 0, 150 / physScale, $stats);
	    objectsOrder = ['protagonist'];
	    
	    for each (var obj:WorldObject in objects) {
		for each (var body:b2Body in obj.bodies) {
		    bc.AddBody(body);
		}
	    }
	    bc.normal.Set(0,-1);
	    bc.offset = 10000 / physScale;
	    bc.density = 0.0001;
	    bc.linearDrag = 0.01;
	    bc.angularDrag = 0.01;
	    world.AddController(bc);
	    this.dialog = new EntranceDialog(Main.appWidth, Main.appHeight, $stats, rebirth);
	    this.dialog.sprite = Main.statsSprite;
	    this.stats = $stats;
	    objects['protagonist'].stats = $stats;
	    if (rebirth) {
		this.dialog.state = 'death';
	    } else if (!stats.ageConfirmed) {
		this.dialog.state = "warning";
	    } else {
		this.dialog.state = "mainMenu";
	    }
	    this.dialog.rebuild();
	    this.helpDialog = new HelpDialog(appWidth, appHeight);
	    this.helpDialog.rebuild();
	    Main.helpSprite.graphics.clear();
	}

	public override function update():void {
	    this.dialog.update();
	    if (this.dialog.state == "help" && this.helpDialog.state != 'visible') {
		this.helpDialog.toggleHide();
	    }
	    if (Input.isKeyPressed(27) && this.helpDialog.state == 'visible') {
		this.dialog.state = "mainMenu";
		this.helpDialog.toggleHide();
	    }
	    if (this.helpDialog.state == 'hidden' && !this.helpDialog.widgets.close.transitionComplete) {
		this.dialog.state = "mainMenu";
	    }
	    this.helpDialog.update();
	    if (this.stats.wasUpdated) {
		objects['protagonist'].rebuild();
		this.stats.wasUpdated = false;
	    }
	    if (this.dialog.state == 'generation2' && this.dialog.widgets.mandala.activeRealm >= 0) {
		this.backgrounds = this.backgroundsCache[this.dialog.widgets.mandala.realmType];
		switch (this.dialog.widgets.mandala.activeRealm) {
		  case 0:
		      if (!this.stats.air) {
			  this.stats.wasUpdated = true;
			  this.dialog.widgets.info.show(new Message("REALM OF AIR\nOne of the easiest starting realms, after Space. You will find large rooms, open space and flying monsters there. Also, this realm posesses a powerful artifact, which will allow you to cut through bondages.", "The Realm", 0xaaaaaa), true);
		      }
		      this.stats.air = 1;
		      break;
		  case 1:
		      if (!this.stats.water) {
			  this.stats.wasUpdated = true;
			  this.dialog.widgets.info.show(new Message("REALM OF WATER\nMedium difficulty. You will find large underwater caverns and tentacled monsters there. Also, this realm posesses a powerful artifact, which will allow you to stun monsters.", "The Realm", 0xaaaaaa), true);
		      }
		      this.stats.water = 1;
		      break;
		  case 2:
		      if (!this.stats.earth) {
			  this.stats.wasUpdated = true;
			  this.dialog.widgets.info.show(new Message("REALM OF EARTH\nMedium difficulty. You will find tunnels, small rooms and crawling monsters there. Also, this realm posesses a powerful artifact, which will allow you to open secret walls.", "The Realm", 0xaaaaaa), true);
		      }
		      this.stats.earth = 1;
		      break;
		  case 3:
		      if (!this.stats.fire) {
			  this.stats.wasUpdated = true;
			  this.dialog.widgets.info.show(new Message("REALM OF FIRE\nHardest of all starting realms. You will find tunnels, rubble and fire spirits there. Also, this realm posesses a powerful artifact, which will allow you to seduce monsters.", "The Realm", 0xaaaaaa), true);
		      }
		      this.stats.fire = 1;
		      break;
		  case 4:
		      if (!this.stats.space) {
			  this.stats.wasUpdated = true;
			  this.dialog.widgets.info.show(new Message("REALM OF SPACE\nEasiest of all starting realms. You will find vast open space and lonely spacemen there. Also, this realm posesses a powerful artifact, which will allow you to teleport yourself.", "The Realm", 0xaaaaaa), true);
		      }
		      this.stats.space = 1;
		      break;
		  default:
		    break;
		}
	    } else if (this.dialog.state == 'generation2' && this.dialog.widgets.mandala.transitionComplete) {
		this.dialog.widgets.info.show(this.dialog.realmMessage, true);
	    }

	    if (this.dialog.state == 'generation3' && this.dialog.widgets.tribes.activeTribe > 0) {
		switch (this.dialog.widgets.tribes.activeTribe) {
		  case ProtagonistStats.DAKINI_TRIBE:
		      if (this.stats.tribe != ProtagonistStats.DAKINI_TRIBE) {
			  this.stats.wasUpdated = true;
			  this.dialog.widgets.info.show(new Message("Dakinis are good spirits of wisdom and knowledge with a strong tendences to Purity. Dakini is the easiest Tribe to play, because they are perfectly balanced in sensitivity, which means they are not very easy to kill like Rakshasi, but also not very hard to level-up like Yakshini. This gives Dakini a lot of flexibility in development.", "The Tribe", 0xaaaaaa), true);
		      }
		      this.stats.tribe = ProtagonistStats.DAKINI_TRIBE;
		      break;
		  case ProtagonistStats.YAKSHINI_TRIBE:
		      if (this.stats.tribe != ProtagonistStats.YAKSHINI_TRIBE) {
			  this.stats.wasUpdated = true;
			  this.dialog.widgets.info.show(new Message("Yakshinis are nature spirits and guardians of the treasures of the world with tendences to neutrality. Due to they fat bodies, they are insensitive to both pain and bliss, which makes them hard to achive orgasm and hard to level up. On the other hand, they are hard to kill also, and can handle thicker things from the beginning.", "The Tribe", 0xaaaaaa), true);
		      }
		      this.stats.tribe = ProtagonistStats.YAKSHINI_TRIBE;
		      break;
		  case ProtagonistStats.RAKSHASI_TRIBE:
		      if (this.stats.tribe != ProtagonistStats.RAKSHASI_TRIBE) {
			  this.stats.wasUpdated = true;
			  this.dialog.widgets.info.show(new Message("Rakshasis are evil demonesses, with strong tendences to Corruption. Due to they thin bodies, they are very sensitive to both bliss and pain. This makes them hard characters to play, because they could die very easily. On the other hand, they are multi-orgasmic from the beginning, and levelling up lightning fast.", "The Tribe", 0xaaaaaa), true);
		      }
		      this.stats.tribe = ProtagonistStats.RAKSHASI_TRIBE;
		      break;
		  default:
		    break;
		}
	    } else if (this.dialog.state == 'generation3') {
		this.dialog.widgets.info.show(this.dialog.tribeMessage, true);
		if (this.stats.tribe != 0) {
		    this.stats.tribe = 0;
		    this.stats.alignmentTendency = 0;
		    this.stats.alignment = 0;
		    this.stats.wasUpdated = true;
		}
	    }

	    this.impulseCounter++;
	    if (impulseCounter % 52 == 0) {
		var t:Number = Math.random();
		if (t < 0.25) {
		    Input.emulateKeyPress(65);
		} else if (t < 0.5) {
		    Input.emulateKeyPress(68);
		} else if (t < 0.75) {
		    Input.emulateKeyPress(83);
		} else if (t < 1) {
		    Input.emulateKeyPress(87);
		}
	    }
	    super.update();
	    if (impulseCounter % 52 == 0) {
		Input.emulateKeyRelease(65);
		Input.emulateKeyRelease(68);
		Input.emulateKeyRelease(83);
		Input.emulateKeyRelease(87);
	    }
	}

	public override function deconstruct():void {
	    for each (var objName:String in this.objectsOrder) {
		this.objects[objName].clearStuff();
		delete this.objects[objName];
	    }
	    this.sprite.graphics.clear();
	    while(this.sprite.numChildren > 0) {   
		this.sprite.removeChildAt(0); 
	    }
	    this.dialog.destroy();
	    this.helpDialog.destroy();
	}

    }
	
}