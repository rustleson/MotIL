//===========================================================
//=========================================================//
//						-=ANTHEM=-
//	file: .as
//
//	copyright: Matthew Bush 2007
//
//	notes:
//
//=========================================================//
//===========================================================



//===========================================================
// FPS COUNTER CLASS
//===========================================================
package General{
	
	import flash.display.Sprite;
	import flash.text.*;
	import flash.utils.getTimer;
	import flash.events.*;
	import flash.system.System;

	public class FpsCounter extends Sprite{
		
            //[Embed(source="../Assets/Borgnine.ttf", fontFamily="Borgnine", mimeType="application/x-font-truetype", embedAsCFF="true")]
            //public const FONT_BORGNINE:String;
		//======================
		// constructor
		//======================
		public function FpsCounter(){
			
		    //var embeddedFont:Font = new Borgnine();
		    //var format:TextFormat = new TextFormat();
		    //format.font = "Borgnine";//embeddedFont.fontName;
		    //format.color = 0xFFFFFF;
		    //format.size = 10;
			// create text field
			textBox = new TextField();
			textBox.text = "...";
			textBox.textColor = 0xaa1144;
			textBox.selectable = false;
			//textBox.antiAliasType = AntiAliasType.ADVANCED;
			//textBox.embedFonts = true;
			//textBox.defaultTextFormat = format;
			
			textBox2 = new TextField();
			textBox2.text = "...";
			textBox2.width = 150;
			textBox2.textColor = 0xaa1144;
			textBox2.selectable = false;
			textBox2.y = 15;
			//textBox2.antiAliasType = AntiAliasType.ADVANCED;
			//textBox2.embedFonts = true;
			//textBox2.defaultTextFormat = format;
			
			textBox3 = new TextField();
			textBox3.text = "...";
			textBox3.textColor = 0xaa1144;
			textBox3.selectable = false;
			textBox3.y = 30;
			//textBox3.antiAliasType = AntiAliasType.ADVANCED;
			//textBox3.embedFonts = true;
			//textBox3.defaultTextFormat = format;
			
			// set initial lastTime
			oldT = getTimer();
			
			addChild(textBox);
			addChild(textBox2);
			addChild(textBox3);
		}
		
		//======================
		// update function
		//======================
		public function update():void{
			var newT:uint = getTimer();
			var f1:uint = newT-oldT;
			mfpsCount += f1;
			if (avgCount < 1){
				textBox.text = String(Math.round(1000/(mfpsCount/30))+" fps average");
				avgCount = 30;
				mfpsCount = 0;
			}
			avgCount--;
			oldT = getTimer();
			
			textBox3.text = Math.round(System.totalMemory/(1024*1024)) + " MB used";
			textBox3.appendText("\nSeed: " + Main.seed);
			textBox3.appendText("\nVersion: " + Main.version);
			textBox3.appendText("\n<F8> to hide");
			
		}
		
		
		public function updatePhys(oldT2:uint):void{
			var newT:uint = getTimer();
			var f1:uint = newT-oldT2;
			mfpsCount2 += f1;
			if (avgCount2 < 1){
				textBox2.text = String("Physics: "+Math.round(mfpsCount2/30)+" ms (" +Math.round(1000/(mfpsCount2/30))+" fps)");
				avgCount2 = 30;
				mfpsCount2 = 0;
			}
			avgCount2--;
		}
		
		
		//======================
		// updateend function
		//======================
		public function updateEnd():void{
			// wrong
			/*var newT:uint = getTimer();
			var f1:uint = newT-oldT;
			mfpsCount2 += f1;
			if (avgCount2 < 1){
				textBox2.text = String(Math.round(1000/(mfpsCount2/30))+" fps uncapped");
				avgCount2 = 30;
				mfpsCount2 = 0;
			}
			avgCount2--;*/
			
		}
		
		
		//======================
		// private variables
		//======================
		private var textBox:TextField;
		private var textBox2:TextField;
		private var textBox3:TextField;
		private var mfpsCount:int = 0;
		private var mfpsCount2:int = 0;
		private var avgCount:int = 30;
		private var avgCount2:int = 30;
		private var oldT:uint;
	}
}




// End of file
//===========================================================
//===========================================================


