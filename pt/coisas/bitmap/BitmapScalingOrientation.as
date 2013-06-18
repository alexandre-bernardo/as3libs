package pt.coisas.bitmap
{
	public class BitmapScalingOrientation
	{
		
		
		
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		
		/** Storage for the singleton instance. */  
   		private static const _instance:BitmapScalingOrientation = new BitmapScalingOrientation( SingletonLock );  
		
		public function BitmapScalingOrientation (lock:Class)
		{
			if ( lock != SingletonLock ) {  
            	throw new Error( "Invalid Singleton access. Static Class. Use BitmapScalingOrientation.instance." );  
        	} 
		}
		
		public static function get instance():BitmapScalingOrientation {
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