package pt.coisas.loader
{
	import caurina.transitions.*;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class ItemLoader extends Sprite
	{
		
		private var percent:Number;
		public var loader:Loader;
		private var loaderContext:LoaderContext;
		private var container:Sprite;
		
		private var delayTween:Number = 0;
		private var _content:DisplayObject;
		
		private var animSpeed:Number;
	
	
		public function ItemLoader(url:String,alvo:Sprite,fadeTime:Number = 0.5)
		{
	
			animSpeed = fadeTime;		
			container = alvo;
						
			if ( url && url!= "") {	
				
				loaderContext = new LoaderContext(true);
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				
				loader = new Loader();
				//loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				
				var request:URLRequest = new URLRequest(url);
				loader.load(request,loaderContext);
			}
		}
		
		//==================================
		//init
		//==================================
		private function initHandler(e:Event):void
		{
			var loader:Loader = Loader(e.target.loader);
			var info:LoaderInfo = LoaderInfo(loader.contentLoaderInfo);
			
		}

		private function ioErrorHandler(e:IOErrorEvent):void
		{
			trace("ioErrorHandler: " + e);
			dispatchEvent(new Event("itemLoadingError",true));
		}
		
		//==================================
		//complete
		//==================================

		private function completeHandler(e:Event):void
		{
			e.target.content.alpha = 0;
			container.addChild(e.target.content);
			_content = e.target.content;
			clearContainer();
			
			dispatchEvent(new Event("itemLoaded",true));
			
			Tweener.addTween(e.target.content,{alpha:1,time:animSpeed, delay:delayTween, transition:'easeInCubic'});
			
		}
		
		private function clearContainer():void {
			
			if (container.numChildren > 1) {
				var mc:DisplayObject = container.getChildAt(0);
				Tweener.addTween(mc,{alpha:0,time:animSpeed, delay:0, transition:'easeInCubic',onComplete:removeChildItem, onCompleteParams:[mc]});
			} 			
			
		}
		
		//==================================
		// progress
		//==================================
		private function progressHandler(e:ProgressEvent):void {
			var loaderInfo:LoaderInfo=LoaderInfo(e.target);
			percent = loaderInfo.bytesLoaded/loaderInfo.bytesTotal;
			
		}
		
		/**
		 * Remove com fadeout o item
		 * PARAMS: item: DisplayObject a ser removido
		 **/
		 public function removeItem (mc:DisplayObject):void {
		  	Tweener.addTween(mc,{alpha:0,time:animSpeed,transition:'easeInCubic',onComplete:removeChildItem, onCompleteParams:[mc]});
		 }
		
		/**
		 * Remove efectivamente o item do container
		 **/
		private function removeChildItem(mc:DisplayObject):void {
			container.removeChild(mc);
		}
		
		
		public function getContent ():DisplayObject {
			return _content;
		}
	}
}
