package pt.coisas.loader {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class ScriptLoader extends URLLoader {
		private var request:URLRequest;
		
		public function ScriptLoader(url:String, callback:Function = null, method:String = URLRequestMethod.GET, vars:URLVariables = null) {
			if (url && url != "") {
				this.dataFormat = URLLoaderDataFormat.TEXT;
				this.request = new URLRequest(url);
				if(vars) this.request.data = vars;
				this.request.method = method;
				if(callback != null) this.addEventListener(Event.COMPLETE, callback);
				this.addEventListener(IOErrorEvent.IO_ERROR, handleError);
				this.load(request);
			}
		}
		
		private function handleError(e:IOErrorEvent):void {
			trace("ioErrorHandler: " + e);
		}
	}
}
