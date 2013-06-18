package pt.coisas.util
{
	public class TextUtil
	{
		public function TextUtil()
		{
			trace("DO NOT INSTANTIATE Outbox^TextUtils -> Singleton");
		}
		
		/*******
		 * Função que substitui num texto uma tag html simples (ex:<b>, <strong>, ..) por uma classe CSS inserido com span (ex:<span class='nome'>....</span>.
		 * Detecta automaticamente o fecho da tag, sem necessidade de este ser inserido
		 * @params str:String com o texto a substituir, tag:String a tag a substituir(ex: <b>), className:String nome para a classe que vai ser inserida
		 * @returns String com a tag subsituida
		 ********/
		public static function tagToClassReplacer(str:String, tag:String, className:String):String {
				
			if (tag.split(" ").length > 1) return str; //simple tags only
			
			var closeTag:String = tag.substr(0,1)+"/"+tag.substring(1);
				
			var newTag:String = "<span class='"+className+"'>";
			var closeNewTag:String = "</span>";
			
			var regExp:RegExp = new RegExp(tag,"gi");
			var tempStr:String = str.replace(regExp,newTag);
			
			if (tempStr != str) {
				regExp = new RegExp(closeTag,"gi");
				tempStr = tempStr.replace(regExp,closeNewTag);
			}
			
			return tempStr;
		}
		
		
		/*******
		 * Função que substitui num texto várias tags html simples (ex:<b>, <strong>, ..) por classes CSS inseridas com span (ex:<span class='nome'>....</span>.
		 * Detecta automaticamente o fecho da tag, sem necessidade de este ser inserido
		 * @params str:String com o texto a substituir, tag:Array com as tag a substituir(ex: <b>), className:Arrays com o nome das classes que vai ser inserida
		 * @returns String com a tag subsituida
		 ********/
		public static function multipleTagsToClassReplacer(str:String, tag:Array, className:Array):String {
				
			var closeTag:Array = new Array();
			var newTag:String;
			var closeNewTag:String = "</span>";
			var regExp:RegExp;
			var tempStr:String = str;
			
			for (var i:int = 0; i < tag.length; i++) {
		
				if (tag[i].split(" ").length > 1) return str; //simple tags only
		
				closeTag.push(tag[i].substr(0,1)+"/"+tag[i].substring(1));
				
				newTag = "<span class='"+className[i]+"'>";
		
				regExp = new RegExp(tag[i],"gi");
				tempStr = tempStr.replace(regExp,newTag);
				
				if (tempStr != str) {
					regExp = new RegExp(closeTag[i],"gi");
					tempStr = tempStr.replace(regExp,closeNewTag);
				}
			}
			return tempStr;
		}
		
	}
}