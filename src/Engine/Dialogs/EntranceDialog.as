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

	public function EntranceDialog(w:Number, h:Number):void {
	    super(w, h);
	    this.widgets['warning'] = new MessageWidget(90, 90, w - 180, h - 220, w - 180, h - 220, 0x111111);
	    this.widgets['question'] = new QuestionWidget(90, 90, w - 180, h - 320, w - 180, h - 320, 0x111111);
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
	    this.widgetsOrder = ['warning', 'question'];
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
	    if (s == "question1") {
		this.widgets.question.submitted = false;
		this.widgets.question.show(new Message("What is the medical term for the butt fucking?", "Question 1", 0xaaaaaa));
	    }
	    if (s == "question2") {
		this.widgets.question.submitted = false;
		this.widgets.question.show(new Message("What does 'Shokushu Goukan' means in Japanese?", "Question 2", 0xaaaaaa));
	    }
	    if (s == "mainMenu") {
		this.stats.generated = true;
	    }
	}

	public override function update():void {
	    super.update();
	    if (this.widgets.warning.state == 'hidden' && this.widgets.warning.transitionComplete && this.stats != null && (this.state == 'warning' || this.state == 'wrongAnswer')) {
		this.state = "question1";
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
		
	    }
	}

    }
	
}