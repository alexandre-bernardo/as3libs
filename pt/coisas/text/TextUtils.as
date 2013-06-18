package pt.coisas.text {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextUtils {
		static private var allowInstantiation:Boolean;
	    static private var instance:TextUtils;
		static public const LINE:String = "line";
		static public const WORD:String = "word";
		static public const CHAR:String = "char";
		
		public function TextUtils() {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use TextUtils methods instead of new.");
			}
		}
	    static private function getInstance():TextUtils {
			if (instance == null) {
				allowInstantiation = true;
				instance = new TextUtils();
				allowInstantiation = false;
			}
			return instance;
	    }
		//Should be called in constructor!
		
		//PDV: Incluir opção para encapsular dentro de uma sprite, para facilitar posteriores animações
		//TODO incluir várias cores e várias fontes
		static public function breakTextApart(textField:TextField, breakType:String = CHAR, hide:Boolean = false):Array {
			//getInstance();
			
			if(textField){
				var copy:Array = new Array();
				var textFormat:TextFormat = textField.getTextFormat();
				var textSprite:Sprite = textField.parent as Sprite;
				var tf:TextField;
				var rect:Rectangle;
				
				//textfield can't be autokerned!!!
				switch (breakType) {
					case CHAR:
						for (var i:int = 0; i < textField.length; i++) {
							rect = textField.getCharBoundaries(i);
							
							if (rect) {
								tf = new TextField();
								tf.defaultTextFormat = textFormat;
								//tf.blendMode = BlendMode.LAYER;
								tf.text = textField.text.charAt(i);
								tf.embedFonts = true;
								tf.selectable = false;
								tf.autoSize = TextFieldAutoSize.LEFT;
								tf.antiAliasType = AntiAliasType.ADVANCED;
								
								tf.x = textField.x + rect.x - 2 - 6; //2 gutter pixels | 6 pixels???
								tf.y = textField.y + rect.y - 2; //2 gutter pixels
								
								tf.alpha = hide ? 0 : 1;
								
								copy.push(tf);
								textSprite.addChild(tf);
							}
						}
						break;
					case WORD:
						var textArray:Array = textField.text.split(/[\n\r ]/); //newline | carrier return | space
						var wordIndex:int = 0;
						for (var j:int = 0; j < textArray.length; j++) {
							wordIndex = textField.text.indexOf(textArray[j], wordIndex + (j > 0 ? textArray[j-1].length : 0));
							rect = textField.getCharBoundaries(wordIndex);
							
							if (rect) {
								tf = new TextField();
								tf.defaultTextFormat = textFormat;
								//tf.blendMode = BlendMode.LAYER;
								tf.text = textArray[j];//textField.text.charAt(i);
								tf.embedFonts = true;
								tf.selectable = false;
								tf.autoSize = TextFieldAutoSize.LEFT;
								tf.antiAliasType = AntiAliasType.ADVANCED;
								
								tf.x = textField.x + rect.x - 2 - 6; //2 gutter pixels | 6 pixels???
								tf.y = textField.y + rect.y - 2; //2 gutter pixels
								
								tf.alpha = hide ? 0 : 1;
								
								copy.push(tf);
								textSprite.addChild(tf);
							}
						}
						break;
					case LINE: //BUGGY!
						for (var k:int = 0; k < textField.numLines; k++) {
							tf = new TextField();
							tf.defaultTextFormat = textFormat;
							//tf.blendMode = BlendMode.LAYER;
							tf.text = textField.getLineText(k);
							tf.embedFonts = true;
							tf.selectable = false;
							tf.autoSize = TextFieldAutoSize.LEFT; //check
							tf.antiAliasType = AntiAliasType.ADVANCED;
							
							tf.x = textField.x;
							tf.y = textField.y + k * (textField.textHeight + 2) / textField.numLines; //2 gutter pixels???
							
							tf.alpha = hide ? 0 : 1;
							
							copy.push(tf);
							textSprite.addChild(tf);
						}
						break;
				}
				textSprite.removeChild(textField);
				return copy;
			} else {
				return null;
			}
		}
	}
	
}