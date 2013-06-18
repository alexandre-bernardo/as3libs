package pt.coisas.util
{
	public class PHPDateUtil
	{
		/**
		 * return Date and Time in PHP/MySQL Format (YYYY-MM-DD HH:MM:SS)
		 * 
		 * @param Date
		 * @return String
		 */	
		public static function getDateAndTime( date:Date ):String
		{
			var phpDate:PHPDateUtil = new PHPDateUtil();
			
			var dateStr:String = 	phpDate.getYear( date ) + "-" + 
									phpDate.getMonth(date) + "-" + 
									phpDate.getDayOfMonth(date) + " " + 
									phpDate.getHours(date) + ":" + 
									phpDate.getMinutes(date) + ":" + 
									phpDate.getSeconds(date);
			
			return dateStr;
		}
		
		/**
		 * return Only Date in PHP/MySQL Format (YYYY-MM-DD)
		 * 
		 * @param Date
		 * @return String
		 */	
		public static function getDate( date:Date ):String
		{
			var phpDate:PHPDateUtil = new PHPDateUtil();
			
			var dateStr:String = 	phpDate.getYear( date ) + "-" + 
									phpDate.getMonth(date) + "-" + 
									phpDate.getDayOfMonth(date);
			
			return dateStr;
		}
		
		
		/**
		 * return seconds (such as 0-59 or 00-59)
		 * 
		 * @param Flag to add leading zero, optional default = true
		 * @return String
		 */	
		private function getSeconds( date:Date, leadingZero:Boolean = true ):String
		{
			if( leadingZero == true && date.getSeconds() <= 9 )
			{
				return "0" + date.getSeconds().toString();
			}
			return String( date.getSeconds() );
		}
		
		/**
		 * returns the minutes (such as 0-59 or 00-59)
		 * 
		 * @param flag for adding a leading zero, optional default = true
		 * @return String
		 */
		private function getMinutes( date:Date, leadingZero:Boolean = true ):String
		{
			if( leadingZero == true && date.getMinutes() <= 9 )
			{
				return "0" + date.getMinutes().toString();
			}
			return String( date.getMinutes() );
		}
	
	
		/**
		 * returns the hours in diffrent formats( such as 0-12, 00-12, 0-23, 
		 * 00-23 )
		 * 
		 * @param Boolean switch to add a leading zero, optional
		 * @param Boolean switch to get in in 12h instead 24h, optional
		 * @return String
		 */
		private function getHours( date:Date, leadingZero:Boolean = true, twelfHours:Boolean = false ):String
		{
			var hours:int;
			if( twelfHours == true )
			{
				if( date.getHours() > 12 )
				{
					hours = date.getHours() - 12;
				}
			}
			else
			{
				hours = date.getHours();
			}
			
			if( leadingZero == true && hours <= 9 )
			{
				return "0" + hours.toString();
			}
			return String( hours );
		}
		
		/**
		 * returns the year (such as 2008 or 08)
		 * 
		 * @param Boolean flag to get the year as two digits
		 * @return String
		 */
		private function getYear( date:Date, twoDigits:Boolean = false ):String
		{
			if( twoDigits == true )
			{
				//cut the year for the last two digits and return it
				return String( date.getFullYear() ).substr( 2,2 );
			}
			return String( date.getFullYear() );
		}

		/**
		 * returns the month (1-12 or 01-12), with optional leading zero
		 * 
		 * @param Boolean optional flag to add a leading zero
		 * @return String month (1-12 or 01-12)
		 */
		private function getMonth( date:Date, leadingZero:Boolean = true ):String
		{
			var month:Number = date.getMonth() + 1;
			if( leadingZero == true && month <= 9 )
			{
				return "0" + String( month );
			}
			return String( month );
		}

		/**
		 * returns day of the month (1-31 or 01-31), with optional leading zero
		 * 
		 * @param Boolean optional flag to add a leading zero to the day 
		 * @return day of the month (1-31 or 01-31)
		 */
		private function getDayOfMonth( date:Date, leadingZero:Boolean = true ):String
		{
			if( leadingZero == true && date.getDate() <= 9 )
			{
				return "0" + String( date.getDate() );
			}
			return String( date.getDate() );
		}
	}
}