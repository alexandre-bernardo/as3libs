package pt.coisas.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Alexandre Bernardo
	 */
	
	public class DisplayGroup extends SpritePlus {
		public var regPointPos:String;
		public var customRegPoint:Point;
		
		public function DisplayGroup(objsToGroup:Array, regPointPos:String = "TOPLEFT", customRegPoint:Point = null) {
			this.regPointPos = regPointPos;
			this.customRegPoint = customRegPoint;
			
			var parentObj:DisplayObjectContainer = objsToGroup[0].parent;
			var layerIndex:int = parentObj.getChildIndex(objsToGroup[0]);
			
			//objs must be index ordered
			for each (var obj:DisplayObject in objsToGroup) {
				this.addChild(obj);
				//children.push(obj);
			}
			parentObj.addChildAt(this, layerIndex);
			setRegPoint(regPointPos, customRegPoint);
		}
		
		//TODO sort objs according to their childIndex
		private function sortObjs(objs:Array):Array {
			var newObjs:Array = [];
			
			return newObjs;
		}
		
	}

}