package pt.coisas.util
{
	public class Validation
	{
		
		public static function validateEmail(str:String):Boolean {
			var pattern:RegExp = /\s*+(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+\s*/;
			var resultStr:Object = pattern.exec(str);
		
			if (resultStr == null) {
				return false;
			}
			if (str.length == resultStr[0].length) {
				return true;
			} else {
				return false;
			}
		}
		
		public function Validation()
		{
			trace("DO NOT INSTANTIATE OUTBOX.VALIDATIONS -> Singleton");
		}

	}
}