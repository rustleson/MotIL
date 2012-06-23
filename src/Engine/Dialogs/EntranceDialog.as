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

	public function EntranceDialog(w:Number, h:Number, $stats:ProtagonistStats):void {
	    super(w, h);
	    this.stats = $stats;
	    this.widgets['warning'] = new MessageWidget(90, 90, w - 180, h - 220, w - 180, h - 220, 0x111111);
	    this.widgets['question'] = new QuestionWidget(90, 90, w - 180, h - 320, w - 180, h - 320, 0x111111);
	    var menuItems:Array = new Array("New Game", "Continue", "Help");
	    if (this.stats.tribe == 0) {
		menuItems.splice(1, 1);
	    }
	    this.widgets['menu'] = new MenuWidget(220, 250, 200, h - 320, 0x333333, 0.5, menuItems);
	    this.widgets.warning.titleFormat = new TextFormat("Huge", 8, 0xff7744);
	    this.widgets.warning.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.widgets.warning.messageFormat = new TextFormat("LargeEstudio", 8, 0xff7744);
	    this.widgets.warning.messageFormat.align = TextFieldAutoSize.LEFT;	    
	    this.widgets.warning.titleDY = -7;	    
	    this.widgets.question.titleFormat = new TextFormat("Huge", 8, 0xaaaaaa);
	    this.widgets.question.titleFormat.align = TextFieldAutoSize.RIGHT;	    
	    this.widgets.question.messageFormat = new TextFormat("LargeEstudio", 8, 0xaaaaaa);
	    this.widgets.question.messageFormat.align = TextFieldAutoSize.LEFT;	    
	    this.widgets.question.titleDY = -7;	    
	    this.widgetsOrder = ['warning', 'question', 'menu'];
	}

	public function get state():String {
	    return this._state;
	}

	public function set state(s:String):void {
	    this._state = s;
	    for each(var widgetName:String in this.widgetsOrder) {
		this.widgets[widgetName].hidden();
	    }
	    if (s == "warning") {
		this.widgets.warning.show(new Message("This game contains explicit scenes of the adult nature. If you didn't reach adult age in your country, please leave immediately. Otherwise, be warned, a lot of scenes in the game are containing nudity, hardcore sexual actions, bestiality with fictional creatures and rape. Although graphics is very abstract and there are not much anatomic details, it would be enough to insult a person who is not ready for the things described above. To ensure you are adult and in this type of things, please answer questions following this warning message. Once you'll answer correctly, you will not see this warning again.", "Content Warning", 0xff7744));
	    }
	    if (s == "wrongAnswer") {
		this.widgets.warning.show(new Message("Unfortunately, your answer was wrong. You can try again as many time as you wish, if you're really need to pass this test.", "Wrong Answer", 0xff7744));
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
	    }
	    if (s == "generation1") {
		this.widgets.question.submitted = false;
		this.widgets.question.show(new Message("Enter your character name below. The complete and unique world layout will be randomly generated basing on the name you'll enter.\n\nWARNING: generating the new world will clear all your past game progress and achievements!", "Step 1: The Name", 0xaaaaaa));
	    }
	    if (s == "finished") {
		this.stats.generated = true;
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
		    if (this.widgets.question.answer != "") { 
			this.stats.name = this.widgets.question.answer;
			this.stats.space = 1;
			this.stats.tribe = ProtagonistStats.DAKINI_TRIBE;
			this.stats.hairColor = 0xdd44dd;
			this.stats.eyesColor = 0x22CC22;
			this.stats.hairLength = 1.5;
			this.stats.save();
			Main.newCharacter = true;
			Main.seedFromName(this.stats.name);
			this.state = 'finished';
		    } else {
			this.state = 'wrongName';
		    }
		}
	    }
	    if (this.widgets.menu.state == 'hidden' && this.widgets.menu.submitted && this.widgets.menu.transitionComplete && this.stats != null) {
		if (this.widgets.menu.chosenItem == "New Game") {
		    this.state = "generation1";
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

    }
	
}