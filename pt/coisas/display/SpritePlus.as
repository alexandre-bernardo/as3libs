package pt.coisas.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Alexandre Bernardo
	 */
	dynamic public class SpritePlus extends Sprite {
		public static const TOP:String = "TOP";
		public static const BOTTOM:String = "BOTTOM";
		public static const LEFT:String = "LEFT";
		public static const RIGHT:String = "RIGHT";
		public static const CENTER:String = "CENTER";
		public static const CUSTOM:String = "CUSTOM";
		
		public var children:Array;
		private var sorted:Boolean = false;
		private var sortedOn:String = "none";
		private var regPoint:String = "";
		
		public function SpritePlus(options:Object = null) {
			for (var prop:String in options){
				this[prop] = options[prop];
			}
			updateChildren();
		}
		public function getChildrenByClass(childClass:Class):Array {
			return children.filter(function(item:*, index:int, array:Array){return item is childClass});
		}
		public function sortChildren(sortOn:String, sortOptions:* = Array.NUMERIC):void {
			if(!sorted || sortedOn != sortOn){ //check to avoid ressorting
				//trace("Sorted!");
				children.sortOn(sortOn, sortOptions);
				sorted = true;
				sortedOn = sortOn;
			}
		}
		public override function addChild(child:DisplayObject):DisplayObject {
			children.push(child);
			return super.addChild(child);
		}
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject {
			children.splice(index, 0, child);
			return super.addChildAt(child, index);
		}
		public override function removeChild(child:DisplayObject):DisplayObject {
			children.splice(children.indexOf(child), 1);
			return super.removeChild(child);
		}
		public override function removeChildAt(index:int):DisplayObject {
			children.splice(index, 1);
			return super.removeChildAt(index);
		}
		public function setRegPoint(regPointPos:String, regPoint:Point = null):void {
			var rect:Rectangle = this.getBounds(this.parent);
			//trace(rect + " | (" + this.x +"," + this.y + ")");
			
			var distX:Number = 0;
			var distY:Number = 0;
			
			if(regPointPos == CUSTOM && regPoint){
				distX = regPoint.x - this.x;
				distY = regPoint.y - this.y;
			}
			else if(regPointPos != this.regPoint){
				if(regPointPos.match(CENTER)){
					distX = (rect.left + rect.width / 2) - this.x;
					distY = (rect.top + rect.height/ 2) - this.y;
				}
				if(regPointPos.match(TOP)){
					distY = rect.top - this.y;
				} 
				else if(regPointPos.match(BOTTOM)){
					distY = rect.bottom - this.y;
				}
				if(regPointPos.match(LEFT)){
					distX = rect.left - this.x;
				}
				else if(regPointPos.match(RIGHT)){
					distX = rect.right - this.x;
				}
			}
			this.x += distX;
			this.y += distY
			setChildrenPos(-distX, -distY);
			this.regPoint = regPointPos;
		}
		private function setChildrenPos(newXX:Number, newYY:Number):void {
			for each (var child:DisplayObject in children) {
				child.x += newXX;
				child.y += newYY;
			}
		}
		public function clear():void {
			for each (var child in children) {
				removeChild(child);
			}
		}
		public function updateChildren():void {
			children = [];
			for (var i:int = 0; i < numChildren; i++) {
				children.push(getChildAt(i));
			}
		}
	}
}