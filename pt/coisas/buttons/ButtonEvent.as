///////////////////////////////////////////////////////////
//  ButtonEvent.as
//  Macromedia ActionScript Implementation of the Class ButtonEvent
//  Generated by Enterprise Architect
//  Created on:      17-Jul-2009 00:38:34
//  Original author: Alexandre
///////////////////////////////////////////////////////////

package pt.coisas.buttons {
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author Alexandre
	 * @version 1.0
	 * @created 17-Jul-2009 00:38:34
	 */
	public class ButtonEvent extends MouseEvent {
		public static const BUTTON_DOWN:String = "button_down";
		public static const RELEASE:String = "release";
		private var _buttonGroup:String;
		
		public function ButtonEvent(type:String, buttonGroup:String = "group_1", bubbles:Boolean = true) {
			super(type, bubbles);
			_buttonGroup = buttonGroup;
		}
		public override function clone():Event {
			return new ButtonEvent(type, buttonGroup);
		}
		
		public function get buttonGroup():String { return _buttonGroup; }
	}//end ButtonEvent
}