package pt.coisas.math
{
	public class MathUtils
	{
		
		public static function randRange(min:Number, max:Number):Number {
		    return Math.floor(Math.random() * (max - min) + min);
		}
		//normalize(value, min, max) takes a value within a given range and converts it to a number between 0 and 1 (actually it can be outside that range if the original value is outside its range).
		public static function normalize(value:Number, minimum:Number, maximum:Number):Number {
			return (value - minimum) / (maximum - minimum);
		}
		//interpolate(min, max, value) is linear interpolation. It takes a normalized value and a range and returns the actual value for the interpolated value in that range.
		public static function interpolate(normValue:Number, minimum:Number, maximum:Number):Number {
			return minimum + (maximum - minimum) * normValue;
		}
		//map(value, min1, max1, min2, max2) takes a value in a given range (min1, max1) and finds the corresonding value in the next range(min2, max2).
		public static function map(value:Number, min1:Number, max1:Number, min2:Number, max2:Number):Number {
			return interpolate( normalize(value, min1, max1), min2, max2);
		}
		/*	Radians to degrees	*/
		public static function toDegrees(radians:Number):Number {
			return radians * 180 / Math.PI;
		}
 
		/*	Degrees to radians	*/
		public static function toRadians(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
	}
}