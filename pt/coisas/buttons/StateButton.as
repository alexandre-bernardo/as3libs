///////////////////////////////////////////////////////////
//  StateButton.as
//  Macromedia ActionScript Implementation of the Class StateButton
//  Generated by Enterprise Architect
//  Created on:      24-Aug-2010 17:14:56
//  Original author: Alexandre
///////////////////////////////////////////////////////////

package pt.coisas.buttons {
	import flash.events.MouseEvent;

	/**
	 * @author Alexandre
	 * @version 1.0
	 * @created 24-Aug-2010 17:14:56
	 */
	dynamic public class StateButton extends BasicButton {
		private var _selected:Boolean = false;
		private var _group_id:String = "group_1";
		
		private var buttonDown:Function = null;
		private var buttonOver:Function = null;
		private var buttonOut:Function = null;
		private var buttonUp:Function = null;
		
		public function StateButton() {
			//super();
			addEventListener(ButtonEvent.RELEASE, releaseButton, false, 0, true);
		}
		
		private function releaseButton(e:ButtonEvent):void {
			selected = false;
			buttonOut.call(null, e);
		}
		override public function setStates(buttonDown:Function, buttonOver:Function, buttonOut:Function, buttonUp:Function = null):void {
			this.buttonDown = buttonDown;
			this.buttonOver = buttonOver;
			this.buttonOut = buttonOut;
			this.buttonUp = buttonUp;
			
			super.setStates(buttonHandler, buttonOver, buttonOut, buttonUp);
		}
		override public function removeStates(buttonDown:Function, buttonOver:Function, buttonOut:Function, buttonUp:Function = null):void {
			super.removeStates(buttonHandler, buttonOver, buttonOut, buttonUp);
			
			this.buttonDown = null;
			this.buttonOver = null;
			this.buttonOut = null;
			this.buttonUp = null;
		}
		/*
		override public function setDown(buttonDown:Function):void {
			this.buttonDown = buttonDown;
			super.setDown(buttonDown);
		}
		override public function removeDown(buttonDown:Function):void {
			this.buttonDown = null;
			super.removeDown(buttonDown);
		}
		*/
		public function buttonHandler(e:MouseEvent):void {
			if(!_selected){
				selected = true;
				buttonDown.call(null, e);
			} 
		}
		
		public function select():void{
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void {
			_selected = value;
			if(_selected) super.removeStates(buttonHandler, buttonOver, buttonOut, buttonUp);
			else super.setStates(buttonHandler, buttonOver, buttonOut, buttonUp);
		}
		
		public function get group_id():String { return _group_id; }
		
		public function set group_id(value:String):void {
			_group_id = value;
		}
	}//end StateButton
}