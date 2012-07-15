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

package Engine.Dialogs {
	
    import Engine.Stats.ProtagonistStats;
    import Engine.Dialogs.Widgets.*;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class EntranceDialog extends Dialog{

	private var _state:String = 'hidden';
	public var stats:ProtagonistStats;
	public var realmMessage:Message = new Message("Choose starting elemental Realm. Your character will be born with a color and maximum affinity with the Realm. Think wise, because probably she will also keep reborning in the same Realm for a certain period.", "The Realm", 0xaaaaaa);
	public var tribeMessage:Message = new Message("Choose starting Tribe. Unlike elemental affinity, Tribe is permanent for a single incarnation. Different tribes have different effects, advantages and shortcomings. Roll mouse over Tribe circle to read detailed info.", "The Tribe", 0xaaaaaa);
	private var rebirth:Boolean = false;
	private var nameSelected:Boolean = false;

	public function EntranceDialog(w:Number, h:Number, $stats:ProtagonistStats, $rebirth:Boolean = false):void {
	    super(w, h);
	    this.stats = $stats;
	    this.rebirth = $rebirth;
	    this.widgets['warning'] = new MessageWidget(90, 90, w - 180, h - 220, w - 180, h - 220, 0x111111);
	    this.widgets['story'] = new MessageWidget(90, 40, w - 180, h - 80, w - 180, h - 80, 0x111111);
	    this.widgets['question'] = new QuestionWidget(90, 150, w - 180, h - 320, w - 180, h - 320, 0x111111);
	    var menuItems:Array = new Array("New Game", "Continue", "Help");
	    if (this.stats.tribe == 0) {
		menuItems.splice(1, 1);
	    }
	    this.widgets['menu'] = new MenuWidget(220, 210, 200, h - 320, 0x333333, 0.5, menuItems);
	    this.widgets['mandala'] = new RotatingMandalaWidget(w / 2, h / 2);
	    this.widgets['tribes'] = new TribesWidget(w / 2, h / 2);
	    this.widgets['backbutton'] = new ButtonWidget(10, h - 35, this.backClick, 0x444444, "<< Back");
	    this.widgets['info'] = new MessageWidget(95, 380, w - 105, h - 390, w - 105, h - 390, 0x111111, false, false, false);
	    this.widgets.warning.titleFormat = new TextFormat("Huge", 8, 0xff7744);
	    this.widgets.warning.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.widgets.warning.messageFormat = new TextFormat("LargeEstudio", 8, 0xff7744);
	    this.widgets.warning.messageFormat.align = TextFieldAutoSize.LEFT;	    
	    this.widgets.warning.titleDY = -7;	    
	    this.widgets.story.titleFormat = new TextFormat("Huge", 8, 0xeeeeee);
	    this.widgets.story.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.widgets.story.messageFormat = new TextFormat("LargeEstudio", 8, 0xeeeeee);
	    this.widgets.story.messageFormat.align = TextFieldAutoSize.LEFT;	    
	    this.widgets.story.titleDY = -7;	    
	    this.widgets.question.titleFormat = new TextFormat("Huge", 8, 0xaaaaaa);
	    this.widgets.question.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.widgets.question.messageFormat = new TextFormat("LargeEstudio", 8, 0xaaaaaa);
	    this.widgets.question.messageFormat.align = TextFieldAutoSize.LEFT;	    
	    this.widgets.question.titleDY = -7;	    
	    this.widgets.info.titleFormat = new TextFormat("Huge", 8, 0xeeeeee);
	    this.widgets.info.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.widgets.info.messageFormat = new TextFormat("LargeEstudio", 8, 0xeeeeee);
	    this.widgets.info.messageFormat.align = TextFieldAutoSize.LEFT;	    
	    this.widgets.info.titleDY = -7;	    
	    this.widgetsOrder = ['mandala', 'tribes', 'warning', 'story', 'question', 'info', 'menu', 'backbutton'];
	}

	public function get state():String {
	    return this._state;
	}

	public function set state(s:String):void {
	    this._state = s;
	    for each(var widgetName:String in this.widgetsOrder) {
		if (widgetName != 'mandala')
		    this.widgets[widgetName].hidden();
	    }
	    if (s == "warning") {
		this.widgets.warning.show(new Message("This game contains explicit scenes of the adult nature. If you didn't reach adult age in your country, please leave immediately. Otherwise, be warned, a lot of scenes in the game are containing nudity, hardcore sexual actions, bestiality with fictional creatures and rape. Although graphics is very abstract and there are not much anatomic details, it would be enough to insult a person who is not ready for the things described above. To ensure you are adult and in this type of things, please answer questions following this warning message. Once you'll answer correctly, you will not see this warning again.", "Content Warning", 0xff7744));
	    }
	    if (s == "death") {
		this.widgets.warning.show(new Message("Unfortunately, you have been died. But since you was enlightened before death, you have an option to choose Realm, Tribe and appearance of your future incarnation. Think wise and good luck!", "Necrolog", 0xff7744));
		this.widgets.mandala.large();
	    }
	    if (s == "wrongAnswer") {
		this.widgets.warning.show(new Message("Unfortunately, your answer was wrong. You can try again as many time as you wish, if you're really need to pass this test.", "Wrong Answer", 0xff7744));
	    }
	    if (s == "story") {
		this.widgets.story.show(new Message("\nA lonely female spirit, wandering through time and space once came to the gates of the great Mandala. The Mandala was pulsating with its inner lights, and those lights were constantly interpenetrate each other, producing a great bliss for the sake of three mighty Kings.\n\nThe view was so fascinating, so enchanting and so arousing, no wonder that spirit began to desire to enter the gates of Mandala with her whole heart. The Kings noticed a presence of outer desire and were heartely glad to encourage the new spirit to join them on the way of bliss.\n\nKing Ravana roared: \"Enter the Mandala, and you will know my great bliss of the Corruption!\"\n\nKing Kubera said: \"Enter the Mandala and you will know my great bliss of the Balance.\"\n\nKing Heruka wispered: \"Enter the Mandala and you will know my great bliss of the Purity...\"\n\nHence, a lonely female spirit brushed her doubts aside and came in to become the one with the Mandala...", "The Story", 0xeeeeee));
		this.widgets.mandala.large();
	    }
	    if (s == "wrongName") {
		this.widgets.warning.show(new Message("The name could not be empty. Please try again with something real or fictional, but not blank. It's your future character name after all!", "Wrong Name", 0xff7744));
	    }
	    if (s == "question1") {
		this.widgets.question.submitted = false;
		this.widgets.question.show(new Message("What is the medical term for the butt fucking?", "Question 1", 0xaaaaaa));
	    }
	    if (s == "question2") {
		this.widgets.question.submitted = false;
		this.widgets.question.show(new Message("What does 'Shokushu Goukan' means in Japanese?", "Question 2", 0xaaaaaa));
	    }
	    if (s == "mainMenu") {
		this.widgets.menu.large();
		this.widgets.mandala.small();
	    }
	    if (s == "generation1") {
		if (!this.nameSelected) {
		    this.widgets.backbutton.large();
		}
		this.widgets.question.submitted = false;
		this.widgets.question.show(new Message("Enter your character name below. The complete and unique world layout will be randomly generated basing on the name you'll enter.\n\nWARNING: generating the new world will clear all your past game progress and achievements!", "The Name", 0xaaaaaa));
		this.widgets.question.answerText.text = 'enter the name there';
		this.widgets.question.answerText.setTextFormat(this.widgets.question.answerFormat);
		this.widgets.mandala.large();
	    }
	    if (s == "generation2") {
		if (!this.rebirth) {
		    this.widgets.backbutton.large(); // prevent user to step back on rebirth stage
		}
		//this.widgets.mandala.activeRealm = -1;
		this.widgets.mandala.realmSelected = false;
		this.widgets.info.show(this.realmMessage);
		this.widgets.mandala.realm();
	    }
	    if (s == "generation3") {
		this.widgets.tribes.tribeSelected = false;
		this.widgets.backbutton.large();
		this.widgets.tribes.activeTribe = 0;
		this.widgets.info.show(this.tribeMessage);
		this.widgets.tribes.small();
	    }
	    if (s == "fadeout") {
		this.widgets.mandala.fadeout();
	    }
	    if (s == "finished") {
		this.stats.generated = true;
		//this.sprite.graphics.clear();
		//while(this.sprite.numChildren > 0) {   
		//    this.sprite.removeChildAt(0); 
		//}
	    }
	}

	public override function update():void {
	    super.update();
	    if (this.widgets.warning.state == 'hidden' && this.widgets.warning.transitionComplete && this.stats != null && (this.state == 'warning' || this.state == 'wrongAnswer')) {
		this.state = "question1";
	    }
	    if (this.widgets.warning.state == 'hidden' && this.widgets.warning.transitionComplete && this.stats != null && (this.state == 'wrongName')) {
		this.state = "generation1";
	    }
	    if (this.widgets.story.state == 'hidden' && this.widgets.story.transitionComplete && this.stats != null && (this.state == 'story')) {
		this.state = "generation1";
	    }
	    if (this.widgets.warning.state == 'hidden' && this.widgets.warning.transitionComplete && this.stats != null && (this.state == 'death')) {
		this.state = "generation2";
	    }
	    if (this.widgets.question.state == 'hidden' && this.widgets.question.transitionComplete && this.stats != null) {
		if (this.state == 'question1' && this.widgets.question.submitted) {
		    if (this.widgets.question.answer.toLowerCase() == "anal intercourse" || this.widgets.question.answer.toLowerCase() == "anal copulation") {
			// yes just "anal sex" is not a medical term
			this.state = 'question2';
		    } else {
			this.state = 'wrongAnswer';
		    }
		}
		if (this.state == 'question2' && this.widgets.question.submitted) {
		    if (this.widgets.question.answer.toLowerCase().substr(0, 8) == "tentacle") { 
			// correct answer is "tentacle rape", but not everyone knows exact translation
			// so any answer beginning with "tentacle" counts as correct
			this.stats.ageConfirmed = true;
			this.stats.save();
			this.state = 'mainMenu';
		    } else {
			this.state = 'wrongAnswer';
		    }
		}
		if (this.state == 'generation1' && this.widgets.question.submitted) {
		    if (this.widgets.question.answer != "" && this.widgets.question.answer != 'enter the name there') { 
			this.stats.space = 0;
			this.stats.water = 0;
			this.stats.earth = 0;
			this.stats.fire = 0;
			this.stats.air = 0;
			this.stats.tribe = 0;
			this.stats.hairColor = 0;
			this.stats.eyesColor = 0;
			this.stats.level = 1;
			this.stats.hairLength = 1.5;
			this.stats.alignment = 0;
			this.stats.name = this.widgets.question.answer.toLowerCase();
			this.stats.wasUpdated = true;
			this.state = 'generation2';
			this.nameSelected = true;
		    } else {
			this.state = 'wrongName';
		    }
		}
		if (this.state == 'generation2' && this.widgets.mandala.realmSelected && this.widgets.mandala.transitionComplete) {
		    this.state = 'generation3';
		}
		if (this.state == 'generation2' && this.widgets.mandala.realmSelected) {
		    this.widgets.info.hidden();
		}
		if (this.state == 'generation3' && this.widgets.tribes.tribeSelected && this.widgets.tribes.transitionComplete) {
		    //this.stats.tribe = ProtagonistStats.DAKINI_TRIBE;
		    this.stats.hairColor = 0xdd44dd;
		    this.stats.eyesColor = 0x22CC22;
		    this.stats.hairLength = 1.5;
		    this.stats.save();
		    Main.seedFromName(this.stats.name);
		    this.state = 'fadeout';
		}
		if (this.state == 'fadeout' && this.widgets.mandala.transitionComplete) {
		    Main.newCharacter = !this.rebirth;
		    this.state = 'finished';
		}
	    }
	    if (this.widgets.menu.submitted && this.widgets.menu.chosenItem == "Continue" && this.widgets.mandala.state != 'hidden') {
		this.widgets.mandala.hidden();
	    }
	    if (this.widgets.menu.state == 'hidden' && this.widgets.menu.submitted && this.widgets.menu.transitionComplete && this.stats != null) {
		if (this.widgets.menu.chosenItem == "New Game") {
		    this.state = "story";
		    this.widgets.menu.submitted = false;
		}
		if (this.widgets.menu.chosenItem == "Continue") {
		    Main.seedFromName(this.stats.name);
		    this.state = "finished";
		    this.widgets.menu.submitted = false;
		}
		if (this.widgets.menu.chosenItem == "Help") {
		    this.state = "help";
		    this.widgets.menu.submitted = false;
		}
	    }
	}

	private function backClick(e:MouseEvent):void {
	    if (this.state == 'generation1') {
		this.state = 'mainMenu';
	    }
	    if (this.state == 'generation2') {
		this.state = 'generation1';
	    }
	    if (this.state == 'generation3') {
		this.state = 'generation2';
	    }
	}

    }
	
}