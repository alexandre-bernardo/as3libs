package pt.coisas.util
{
	public class StringUtil
	{
		public function StringUtil()
		{
		}

		/***
		 * Splits a string into an array of strings with the size entered
		 * Useful for dividing strings beyond the 64k limit
		 * @params String the string to split uint the size o the new strings
		 * @returns array of strings with the size specified
		 ***/
		public static function stringSizeSplit(str:String, size:uint):Array {
			var strArray:Array = new Array();
			var numSplits:int = Math.ceil(str.length/size);
			
			for(var i:int = 0; i < numSplits; i++) {
				strArray.push(str.substring(i*size,(i+1)*size));
			}
			
			return strArray;
	
		}
	}
}