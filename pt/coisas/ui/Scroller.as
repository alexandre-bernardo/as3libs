package pt.coisas.ui {
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	
	public class Scroller extends EventDispatcher {
		private var content:DisplayObject;
		private var mask:Shape = new Shape();
		private var scrollHandle:Sprite;
		private var scrollBar:Sprite;
		
		private var scrollPercent:Number = new Number(0);
		private var pressed:Boolean = false;
		private var scrollBarRect:Rectangle;
		private var dragYYPoint:Number;
		private var padding:Number;
		private var contentHeight:Number;
		
		private var timer:Timer;
		
		private var _visible:Boolean;
		public function Scroller(content:*, scrollHandle:Sprite, scrollBar:* = null, padding:Number = 0, maskRect:Rectangle = null, 
								 isContentGrabbable:Boolean = false, scrollHandleScalable:Boolean = false) {
			if (content is DisplayObject) this.content = content;
			else if (content is Array) {
				//BUGGY!!!
				this.content = new Sprite();
				content.sortOn("x", Array.NUMERIC);
				this.content.x = content[0].x;
				content.sortOn("y", Array.NUMERIC);
				this.content.y = content[0].y;
				content[0].parent.addChild(this.content);
				for each (var obj in content) {
					obj.x -= this.content.x;
					obj.y -= this.content.y;
					Sprite(this.content).addChild(obj);
				}
			}
			else throw new Error("content must be a DisplayObject or an Array of DisplayObjects.");
			
			if(!scrollBar && !maskRect) throw new Error("Define either scrollBar or maskRect.");
			
			if (scrollHandleScalable) scrollHandle.height = scrollBar ? Math.pow(scrollBar.height, 2) / this.content.height
																	  : Math.pow(maskRect.height, 2) / this.content.height;
			
			if (!scrollBar) this.scrollBarRect = new Rectangle(scrollHandle.x, scrollHandle.y, 0, maskRect.height - scrollHandle.height);// - scrollHandle.y);
			else {
				//BUGGY!!!
				if(scrollBar is DisplayObject) this.scrollBar = scrollBar;
				this.scrollBarRect = new Rectangle(scrollBar.x, scrollBar.y, 0, scrollBar.height - scrollHandle.height);// - scrollBar.y);
			}
			
			mask.graphics.beginFill(0xFFFFFF);
			if(!maskRect){
				mask.x = this.content.x;
				mask.y = this.scrollBarRect.y;
				mask.graphics.drawRect(0, 0, scrollBarRect.x - this.content.x, this.scrollBarRect.height + scrollHandle.height);
			} else{
				mask.x = maskRect.x;
				mask.y = maskRect.y;
				mask.graphics.drawRect(0, 0, maskRect.width, maskRect.height);
			}
			mask.graphics.endFill();
			contentHeight = this.content.height + padding - mask.height;
			//mask.cacheAsBitmap = true;
			try {
				this.content.parent.addChild(mask);
			} catch (err:Error){
				trace("Error: Mask must be animated individually...");
			}
			
			this.content.cacheAsBitmap = true;
			this.content.mask = mask;
			if(isContentGrabbable){
				//content.addEventListener(MouseEvent.MOUSE_OVER, showHand, false, 0, true);
				//content.addEventListener(MouseEvent.MOUSE_OUT, hideHand, false, 0, true);
				this.content.addEventListener(MouseEvent.MOUSE_DOWN, grabContent, false, 0, true);
			}
			
			this.padding = padding;
			this.scrollHandle = scrollHandle;
			scrollHandle.tabEnabled = false;
			scrollHandle.addEventListener(MouseEvent.MOUSE_DOWN, moveHandle, false, 0, true);
			this.content.addEventListener(MouseEvent.MOUSE_WHEEL, moveWheel, false, 0, true);
			
			timer = new Timer(250);
			timer.addEventListener(TimerEvent.TIMER, timerElapsed, false, 0, true);
			
			verifyHeight();
		}
		
		private function timerElapsed(e:TimerEvent = null):void {
			dispatchEvent(new ScrollerEvent(ScrollerEvent.SCROLLED, new Point(content.x, content.y), true));
		}
		
		private function grabContent(e:MouseEvent):void {
			content.stage.addEventListener(MouseEvent.MOUSE_UP, releaseContent, false, 0, true);
			pressed = true;
			dragYYPoint = e.currentTarget.mouseY;
			Mouse.cursor = MouseCursor.HAND;
			content.addEventListener(MouseEvent.MOUSE_MOVE, dragContent, false, 0, true);
		}
		
		private function dragContent(e:MouseEvent):void {
			//BUG check for all situations...
			if(content.y <= mask.y && content.y >= -(contentHeight + padding)){
				scrollPercent = content.y + e.currentTarget.mouseY - dragYYPoint;
				if(scrollPercent > 0) scrollPercent = 0;
				else if(scrollPercent < -(contentHeight + padding)) scrollPercent = -(contentHeight + padding);
				TweenLite.to(content, 0.5, {y:scrollPercent, ease:Cubic.easeOut});
				TweenLite.to(scrollHandle, 0.5, {y:scrollBarRect.y - scrollPercent * scrollBarRect.height / (contentHeight + padding), ease:Cubic.easeOut});
				if(!timer.running){
					timerElapsed();
					timer.start();
				}
			}
			/*
			if(content.y <= mask.y && content.y + content.height >= mask.y + mask.height){
				scrollPercent = e.currentTarget.mouseY - dragYYPoint;
			} else {
				scrollPercent = (content.y + content.height) / 2 > (mask.y + mask.height) / 2 ? 0 : -contentHeight;
			}
			if(scrollPercent > 0) scrollPercent = 0;
			else if(scrollPercent < -contentHeight) scrollPercent = -contentHeight;
			
			TweenLite.to(content, 0.3, {y:scrollPercent, ease:Cubic.easeOut});
			TweenLite.to(scrollHandle, 0.3, {y: -(scrollBar.y + scrollHeight) * scrollPercent / contentHeight, 
											 ease:Cubic.easeOut});
			*/
		}
		
		private function releaseContent(e:MouseEvent):void {
			if(pressed){
				content.removeEventListener(MouseEvent.MOUSE_MOVE, dragContent);
				content.stage.removeEventListener(MouseEvent.MOUSE_UP, releaseContent);
				pressed = false;
				Mouse.cursor = MouseCursor.AUTO;
				//The Mouse was released outside the target Box
				//trace(m.target)
				if (e.currentTarget != e.target) {
					trace('onReleasedOutside');
				} else {
					//The Mouse was released inside the target Box
					trace('onRelease');
				}
				timer.stop();
				timerElapsed();
			}
		}
		
		private function showHand(e:MouseEvent):void {
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function hideHand(e:MouseEvent):void {
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function moveWheel(e:MouseEvent):void {
			if(scrollHandle.y - e.delta*3 >= scrollBarRect.y && scrollHandle.y - e.delta*3 <= scrollBarRect.y + scrollBarRect.height){
				scrollHandle.y -= e.delta*3;
				moveContent();
			}
		}
		
		private function moveHandle(m:MouseEvent):void {
			content.stage.addEventListener(MouseEvent.MOUSE_UP, releaseHandle, false, 0, true);
			pressed = true;
			
			scrollHandle.startDrag(false, scrollBarRect);
			scrollHandle.addEventListener(Event.ENTER_FRAME, moveContent, false, 0, true);
		}
		
		private function releaseHandle(m:MouseEvent):void {
			if(pressed){
				scrollHandle.stopDrag();
				scrollHandle.removeEventListener(Event.ENTER_FRAME, moveContent);
				content.stage.removeEventListener(MouseEvent.MOUSE_UP, releaseHandle);
				pressed = false;
				//The Mouse was released outside the target Box
				//trace(m.target)
				if (m.currentTarget != m.target) {
					trace('onReleasedOutside');
				} else {
					//The Mouse was released inside the target Box
					trace('onRelease');
				}
				timer.stop();
				timerElapsed();
			}
		}
		private function moveContent(e:Event = null):void {
			scrollPercent = (100 / scrollBarRect.height) * (scrollHandle.y - scrollBarRect.y);
			TweenLite.to(content, 0.5, {y:mask.y + ((mask.height - (content.height + padding)) / 100) * scrollPercent, ease:Cubic.easeOut});
			if(!timer.running){
				timerElapsed();
				timer.start();
			}
		}
		public function verifyHeight():void {
			if (mask.height >= content.height) {
				scrollHandle.visible = _visible = false;
				scrollHandle.alpha = 0;
				if(scrollBar) scrollBar.visible = false;
				scrollHandle.removeEventListener(MouseEvent.MOUSE_DOWN, moveHandle);
				content.removeEventListener(MouseEvent.MOUSE_WHEEL, moveWheel);
			} else {
				scrollHandle.visible = _visible = true;
				scrollHandle.alpha = 1;
				if(scrollBar) scrollBar.visible = true;
				scrollHandle.addEventListener(MouseEvent.MOUSE_DOWN, moveHandle, false, 0, true);
				content.addEventListener(MouseEvent.MOUSE_WHEEL, moveWheel, false, 0, true);
			}
			contentHeight = content.height + padding - mask.height;
		}
		public function setHeight(newHeight:Number):void {
			mask.height = newHeight - mask.y;
			if(scrollBar) scrollBar.height = newHeight - scrollBar.y;
			scrollBarRect.height = newHeight - scrollBarRect.y - scrollHandle.height;
			verifyHeight();
		}
		public function setWidth(newWidth:Number):void {
			mask.width = newWidth;
			mask.x = newWidth / 2 - mask.width / 2;
			scrollHandle.x = newWidth;
			if(scrollBar) scrollBar.x = scrollHandle.x;
			scrollBarRect.x = scrollHandle.x;
		}
		public function onResize(newWidth:int, newHeight:int):void {
			setHeight(newHeight);
			setWidth(newWidth);
		}
		public function destroy():void {
			if (timer){
				timer.stop();
				timer = null;
			}
		}
		
		public function get visible():Boolean { return _visible; }
	}
}