package Engine.Stats {
	
    import Engine.Objects.Slot;
    import Box2D.Dynamics.Joints.*;

    public class SlotStat {

	public var slot:Slot; 
	public var stretchedDiameter:ExpStat; 
	public var stretchedLength:ExpStat;
	public var artefactAttached:ArtefactStat;
	public var name:String = "slot";
	private var previousPosition:Number = 0;

	public function SlotStat():void {
	    this.stretchedDiameter = new ExpStat();
	    this.stretchedLength = new ExpStat();
	    this.artefactAttached = new ArtefactStat()
	}

	public function get painD():Number {
	    var pos:Number = this.currentPosition;
	    var d:Number = (this.slot != null && this.slot.connectedSlot != null) ? this.slot.connectedSlot.getDiameter(pos) : 0;
	    if (d > this.stretchedDiameter.valueFrac) {
		var ld:Number = (this.stretchedDiameter.toValue - this.stretchedDiameter.fromValue) / 50;
		return Math.exp((d - this.stretchedDiameter.valueFrac) / ld) / 10;
	    } else 
		return 0
	}

	public function get painL():Number {
	    var pos:Number = this.currentPosition;
	    if (pos > this.stretchedLength.valueFrac * 0.8 && this.dL > 0) {
		return (1 + pos - this.stretchedLength.valueFrac * 0.8) * (1 + this.dL);
	    } else 
		return 0
	}

	public function get pleasure():Number {
	    var pos:Number = this.currentPosition;
	    var d:Number = (this.slot != null && this.slot.connectedSlot != null) ? this.slot.connectedSlot.getDiameter(pos) : 0;
	    var f:Number;
	    if (d <= this.stretchedDiameter.valueFrac) {
		f = d / this.stretchedDiameter.valueFrac;
		return this.stretchedDiameter.valueFrac * f * f * (Math.abs(this.dL)*100) * 10;
	    } else {
		//f = 2 - d / this.stretchedDiameter.valueFrac;
		f = 1;//(f < 0) ? 0 : f; // ??comment this line??
		return this.stretchedDiameter.valueFrac * f * f * (Math.abs(this.dL)*100) * 10;
	    }
	}

	public function get dL():Number {
	    return this.currentPosition - this.previousPosition;
	}

	public function updatePosition():void {
	    this.previousPosition = this.currentPosition;
	    // TODO: mother slot disconnecting freely when father slot is popping out
	    //if (this.slot != null && !this.slot.isFree && this.currentPosition <= 0) {
	    //this.slot.disconnect();
	    //}
	}

	private function get currentPosition():Number {
	    if (this.slot != null && this.slot.joint != null)
		return -this.slot.joint.GetJointTranslation();
	    else
		return 0
	}


    }
	
}