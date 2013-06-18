package pt.coisas.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpriteBlock extends Sprite {
		public static const HORIZONTAL:String = "HORIZONTAL";
		public static const VERTICAL:String = "VERTICAL";
		
		private var alignment:String;
		private var padding:Number;
		private var children:Array = [];
		private var rect:Rectangle;
		
		public function SpriteBlock(options:Object = null) {
			this.alignment = options["alignment"] || HORIZONTAL;
			this.padding = options['padding'] || 2;
			this.rect = options['rect'] || null;
			
			for each (var child:DisplayObject in options.children) {
				addChild(child);
			}
		}
		override public function addChild(child:DisplayObject):DisplayObject {
			var i:int = children.length - 1;
			
			if(i < 0) child.x = child.y = 0;
			else {
				var width:Number = children[i].x + children[i].width + padding;
				var height:Number = children[i].y + children[i].height + padding;
				
				if(alignment == HORIZONTAL){
					child.x = width + child.width > rect.width ? 0 : width;
					child.y = width + child.width > rect.width ? this.height + padding : children[i].y;
				}
				else if(alignment == VERTICAL){
					child.x = height + child.height > rect.height ? this.width + padding : children[i].x;
					child.y = height + child.height > rect.height ? 0 : height;
				}
			}
			children.push(child);
			return super.addChild(child);
		}
		
	}

}