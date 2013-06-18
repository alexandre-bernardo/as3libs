package pt.coisas.ui {
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alexandre Bernardo
	 */
	public class ScrollerEvent extends Event {
		public static const SCROLLED:String = "scroller_scrolled";
		private var _newPos:Point;
		
		public function ScrollerEvent(type:String, newPos:Point, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this._newPos = newPos;
		} 
		
		public override function clone():Event { 
			return new ScrollerEvent(type, _newPos, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ScrollerEvent", "type", "newPos", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get newPos():Point { return _newPos; }
		
	}
	
}