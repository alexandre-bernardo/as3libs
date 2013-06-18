package pt.coisas.forms
{
	public class FormFieldType
	{
		
		
		public static const TEXT:String = "textInput";
		public static const EMAIL:String = "emailInput";
		public static const PASSWORD:String = "passwordInput";
		public static const DAY:String = "dayInput";
		public static const MONTH:String = "monthInput";
		public static const YEAR:String = "yearInput";
		
		public static const COMBO_BOX:String = "comboBox";
		public static const RADIO_BUTTON_GROUP:String = "radioButtonGroup";
		public static const CHECK_BOX:String = "checkBox";

		
		public function FormFieldType()
		{
			trace("Singleton -> do not instantiate FormFieldType");
		}

	}
}