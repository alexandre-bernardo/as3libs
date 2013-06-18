package pt.coisas.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class BitmapScaling
	{
		/** Storage for the singleton instance. */  
   		private static const _instance:BitmapScaling = new BitmapScaling( SingletonLock );  
		
		
		//TODO Comentar e optimizar método slice3Scaling
		public static function slice3Scaling(mc:Sprite, firstCoord:int, secondCoord:int, orientation:String, size:int):void 
		{ 
			
			
			var orBitmapData:BitmapData = new BitmapData(mc.width, mc.height,true,0x00FFFFFF);
			orBitmapData.draw(mc);
			
			var _width:int = orBitmapData.width;
			var _height:int = orBitmapData.height;
			
			var bitmapBA:ByteArray;
			
			/* var fBA:ByteArray;
			var lBA:ByteArray;
			var mBA:ByteArray; */
			
			var fRect:Rectangle;
			var lRect:Rectangle;
			var mRect:Rectangle;
			var fmRect:Rectangle;
			
			//var finalRect:Rectangle;
			var finalBitmapData:BitmapData;
			var newCoord:int;
			var mFinal:int;
			var num:int;
			var i:int;
			
			if (orientation == BitmapScalingOrientation.HORIZONTAL) {
				
				//finalRect = new Rectangle(0,0,size,orBitmapData.height);
				finalBitmapData = new BitmapData(size,_height);
				
				fRect = new Rectangle(0,0,firstCoord,_height);
				bitmapBA = orBitmapData.getPixels(fRect);
				bitmapBA.position = 0;
				finalBitmapData.setPixels(fRect,bitmapBA);
				
				
				lRect = new Rectangle(secondCoord,0,orBitmapData.width - secondCoord,_height);
				bitmapBA = orBitmapData.getPixels(lRect);
				bitmapBA.position = 0;
				newCoord = size - lRect.width;
				lRect = new Rectangle(newCoord,0,size - newCoord,_height);
				finalBitmapData.setPixels(lRect,bitmapBA);
				
				mFinal = size - fRect.width - lRect.width;
				
				mRect = new Rectangle(firstCoord,0,secondCoord - firstCoord,_height);
				bitmapBA = orBitmapData.getPixels(mRect);
				bitmapBA.position = 0;
				
				
				
				num = Math.floor(mFinal/mRect.width);
				for (i = 0; i < num; i++) {
					fmRect = new Rectangle(firstCoord + i*mRect.width,0,mRect.width,_height);
					finalBitmapData.setPixels(fmRect,bitmapBA);
					bitmapBA.position = 0;
				}
				
				fmRect = new Rectangle(firstCoord + i*mRect.width, 0, mFinal - i*mRect.width, _height);
				mRect.width = fmRect.width
				bitmapBA = orBitmapData.getPixels(mRect);
				bitmapBA.position = 0;
				finalBitmapData.setPixels(fmRect,bitmapBA);
				
				
			} else if (orientation == BitmapScalingOrientation.VERTICAL) {
				//finalRect = new Rectangle(0,0,_width,size);
				finalBitmapData = new BitmapData(_width,size);
				
				fRect = new Rectangle(0,0,_width,firstCoord);
				bitmapBA = orBitmapData.getPixels(fRect);
				bitmapBA.position = 0;
				finalBitmapData.setPixels(fRect,bitmapBA);
				
				lRect = new Rectangle(0,secondCoord,_width,_height - secondCoord);
				bitmapBA = orBitmapData.getPixels(lRect);
				bitmapBA.position = 0;
				newCoord = size - lRect.height;
				lRect = new Rectangle(0,newCoord,_width,size - newCoord);
				finalBitmapData.setPixels(lRect,bitmapBA);
				
				mFinal = size - fRect.height - lRect.height;
				
				mRect = new Rectangle(0,firstCoord,_width,secondCoord - firstCoord);
				bitmapBA = orBitmapData.getPixels(mRect);
				bitmapBA.position = 0;
				
				num = Math.floor(mFinal/mRect.height);
				for (i = 0; i < num; i++) {
					
					fmRect = new Rectangle(0, firstCoord + i*mRect.height,_width,mRect.height);
					finalBitmapData.setPixels(fmRect,bitmapBA);
					bitmapBA.position = 0;
				}
				
				fmRect = new Rectangle(0, firstCoord + i*mRect.height, _width, mFinal - i*mRect.height);
				mRect.height = fmRect.height;
				bitmapBA = orBitmapData.getPixels(mRect);
				bitmapBA.position = 0;
				finalBitmapData.setPixels(fmRect,bitmapBA);
				
			} else {
				throw new Error("BitmapScaling :: Incorrect orientation");
			}
			
			var bmp:Bitmap = new Bitmap(finalBitmapData,"auto",true);
			mc.removeChildAt(0);
			mc.addChild(bmp);
			
			//return new Bitmap(finalBitmapData,"auto",true);
		}
		
		//TODO Comentar método slice9Scaling
		public static function slice9Scaling(mc:Sprite, innerRectangle:Rectangle, width:int, height:int):void 
		{ 
			slice3Scaling(mc,innerRectangle.x, innerRectangle.x+innerRectangle.width,BitmapScalingOrientation.HORIZONTAL,width);
			slice3Scaling(mc,innerRectangle.y, innerRectangle.y+innerRectangle.height,BitmapScalingOrientation.VERTICAL,height);
			
		}
		
		
		
		
		
		
		public function BitmapScaling (lock:Class)
		{
			if ( lock != SingletonLock ) {  
            	throw new Error( "Invalid Singleton access. Static Class. Use BitmapScaling.instance." );  
        	} 
		}
		
		public static function get instance():BitmapScaling {
			return _instance;
		}

	}
}

/** 
 * This is a private class declared outside of the package 
 * that is only accessible to classes inside of this as 
 * file.  Because of that, no outside code is able to get a 
 * reference to this class to pass to the constructor, which 
 * enables us to prevent outside instantiation. 
 */  
class SingletonLock{}