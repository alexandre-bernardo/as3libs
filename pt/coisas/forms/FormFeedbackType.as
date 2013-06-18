package pt.coisas.forms
{
	public class FormFeedbackType
	{
		
		public static const SYMBOL:String = "symbol";
		public static const SYMBOL_LEFT:String = "symbolLeft";
		public static const SYMBOL_RIGHT:String = "symbolRight";
		public static const SYMBOL_INSIDE:String = "symbolInside";
		public static const IN_FIELD:String = "inField";
		public static const ERROR_FIELD:String = "errorField";
		
		
		public function FormFeedbackType()
		{
			trace("Singleton -> do not instantiate FormFeedbackType");
		}

	}
}