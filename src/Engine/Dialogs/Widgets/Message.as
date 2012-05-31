package Engine.Dialogs.Widgets {
	
    public class Message {

	public var color:uint;
	public var text:String;
	public var title:String;
	public var icon:Function;

	public function Message($text:String, $title:String = "", $color:uint = 0xeeeeee, $icon:Function = null) {
	    this.color= $color;
	    this.text = $text;
	    this.title = $title;
	    this.icon = $icon;
	}
					      

    }

}