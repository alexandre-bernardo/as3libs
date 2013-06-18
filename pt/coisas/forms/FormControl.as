package pt.coisas.forms
{
	import fl.controls.ComboBox;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.managers.FocusManager;
	import pt.coisas.math.MathUtils;
	import pt.coisas.util.Validation;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class FormControl
	{
		
		private var _fields:Array;
		private var _fieldsData:Dictionary;
		private var _config:Object;
		private var tabIndexSeed:int;
		private var lastIndex:int = -1;
		
		private var _errorFields:Array;
		
		private var focusManager:FocusManager;
		
		private var _cleanListeners:Boolean;
		
		private const BASE_SEED:int = 10000;
		private const MARGIN:int = 10;
		
		
		
		/**********
		 * FormControl allows a simple way to set up basic form funcionality, such as tabIndex and form validation. 
		 * Uses MathUtils and Validation classes.
		 * @param  Array of objects with the following properties:
		 * 		   field:* name of the textfield or input object. When type is set to FormFieldType.RADIO_BUTTON_GROUP enter the group name.
		 * 		   type:String form field type. Accepts values from the FormFieldType Class
		 * 		   label:String
		 * 		   mandatory:Boolean defines the field as mandatory or not. When FormFieldType.COMBO_BOX is selected, assumes that the first field does not contain user selected data;
		 * @param Configuration object with the following properties:
		 * 		   setIndex:Boolean sets if fields are to be tabIndex or not
		 * 		   feedbackType:String sets the type of feedback. Accepts values from the FormFeedbackType Class.
		 * 		   symbol:Class class (linkage id) of the symbol to use if feedbackType is set to FormFeedbackType.SYMBOL;
		 *         symbolPlacement:String sets the placing of the symbol when feedbackType is set to FormFeedbackType.SYMBOL. Possible values are FormFeedbackType.SYMBOL_LEFT and FormFeedbackType.SYMBOL_RIGHT
		 * 		   errorColor:Number color in hexadecimal (0x000000) to use in form feedback when FormFeedbackType.IN_FIELD is selected
		 * 		   errorMsg:String error message to be displayed when feedbackType is set to FormFeedbackType.ERROR_FIELD. 
		 *         errorField:TextField textfield to be used for feedback, when FormFeedbackType.ERROR_FIELD is selected.
		 * 		   enumFields:Boolean sets wether to enumerate fields with errors, in the errorField.
		 * @see FormFieldType
		 * @see FormFeedbackType
		 * @version 0.1
		 * @author Outbox^Ativism
		 *******/
		public function FormControl(fields:Array, configurationObject:Object = null, cleanListeners:Boolean = true)
		{
			_config = (configurationObject) ? configurationObject : new Object();
			_cleanListeners = cleanListeners;
			setUpFields(fields);

			if ( _config.setIndex) setTabIndex((_config.startIndex) ? _config.startIndex : - 1 );
			
		}


		private function setUpFields(fields:Array):void 
		{
			_fields = new Array();
			_fieldsData = new Dictionary();
			var tf:TextField;
			
			
			for(var i:uint = 0; i < fields.length; i++) {
				if (fields[i].field is TextField) { 
					tf = fields[i].field;
					fields[i].startText = fields[i].field.text;
					fields[i].startTextColor = fields[i].field.textColor;
					fields[i].field.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
					fields[i].field.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler, false, 0, true);
					if ( _cleanListeners) fields[i].field.addEventListener(Event.REMOVED_FROM_STAGE, removeListeners, false, 0, true);
					if (fields[i].type == FormFieldType.DAY || fields[i].type == FormFieldType.MONTH || fields[i].type == FormFieldType.YEAR) {
						fields[i].field.restrict = "0-9";
					}
				} else if (fields[i].type != FormFieldType.RADIO_BUTTON_GROUP) {
					fields[i].field.addEventListener(FocusEvent.FOCUS_IN, onComboBoxFocusInHandler);
					if ( _cleanListeners) fields[i].field.addEventListener(Event.REMOVED_FROM_STAGE, removeComponentListeners, false, 0, true);
				} else {
					var rg:RadioButtonGroup = RadioButtonGroup.getGroup(fields[i].field);
					fields[i].startTextColor = rg.getRadioButtonAt(0).textField.textColor;
					for (var j:uint = 0; j < rg.numRadioButtons; j++) {
						rg.getRadioButtonAt(j).addEventListener(FocusEvent.FOCUS_IN, onRadioFocusInHandler);
						if ( _cleanListeners) rg.getRadioButtonAt(j).addEventListener(Event.REMOVED_FROM_STAGE, removeRadioListeners, false, 0, true);
					}
				}
				_fields.push(fields[i]);
				if (fields[i].type != FormFieldType.RADIO_BUTTON_GROUP) {
					_fieldsData[fields[i].field.name] = fields[i];
				} else {
					_fieldsData[fields[i].field] = fields[i];
				}
			}
			
		}
		
		
		
		//////////////
		//Focus Related Methods
		private function onComboBoxFocusInHandler(e:FocusEvent):void {
			
			var cb:ComboBox = ComboBox(e.currentTarget);
			
			if (_config.feedbackType == FormFeedbackType.IN_FIELD && _config.errorMsg != null && _config.errorMsg != "") {
				if (cb.textField.textField.text == _config.errorMsg ) cb.textField.textField.text = _fieldsData[cb.name].currentText;
				cb.textField.textField.textColor = _fieldsData[cb.name].startColor; 
			} 
			
			
			if (_config.feedbackType == FormFeedbackType.SYMBOL) {
				if (_fieldsData[e.currentTarget.name].errorSymbol) { 
					var symb:DisplayObject = e.currentTarget.parent.removeChild(_fieldsData[e.currentTarget.name].errorSymbol);
					symb = null;
					_fieldsData[e.currentTarget.name].errorSymbol = null;
				}
			}
		}
		
		private function onRadioFocusInHandler(e:FocusEvent):void {
			
			var rg:RadioButtonGroup = RadioButtonGroup.getGroup(e.currentTarget.groupName);
			var numBts:int = rg.numRadioButtons;
			
			for(var i:uint = 0; i < numBts; i++) {
				rg.getRadioButtonAt(i).textField.textColor = _fieldsData[e.currentTarget.groupName].startText;
			}
			
			if (_config.feedbackType == FormFeedbackType.SYMBOL) {
				if (_fieldsData[e.currentTarget.groupName].errorSymbol) { 
					var symb:DisplayObject = e.currentTarget.parent.removeChild(_fieldsData[e.currentTarget.groupName].errorSymbol);
					symb = null;
					_fieldsData[e.currentTarget.groupName].errorSymbol = null;
				}
			}
		}
		
		private function onFocusInHandler(e:FocusEvent):void {
			var tf:TextField = TextField(e.currentTarget);
			
			if(_fieldsData[tf.name].type == FormFieldType.PASSWORD) tf.displayAsPassword = true;
			if (tf.text == _fieldsData[tf.name].startText) tf.text = "";
			tf.textColor = _fieldsData[tf.name].startTextColor;
			
			if (_config.feedbackType == FormFeedbackType.IN_FIELD && _config.errorMsg != null && _config.errorMsg != "") {
				if (tf.text == _config.errorMsg ) tf.text = _fieldsData[tf.name].currentText;
			}
			
			if (_config.feedbackType == FormFeedbackType.SYMBOL) {
				if (_fieldsData[tf.name].errorSymbol) { 
					var symb:DisplayObject = tf.parent.removeChild(_fieldsData[tf.name].errorSymbol);
					symb = null;
					_fieldsData[tf.name].errorSymbol = null;
				}
			}
		}
		
		
		private function onFocusOutHandler(e:FocusEvent):void {
			var tf:TextField = TextField(e.currentTarget);
			if (tf.text =="" ) {
				tf.text = _fieldsData[tf.name].startText;
				if(_fieldsData[tf.name].type == FormFieldType.PASSWORD) tf.displayAsPassword = false;
			}
			
			var num:int = parseInt(tf.text);
			if (_fieldsData[tf.name].type == FormFieldType.DAY && (isNaN(num) || num < 1 || num > 31)) tf.text = _fieldsData[tf.name].startText;
			if (_fieldsData[tf.name].type == FormFieldType.MONTH && (isNaN(num) || num < 1 || num > 12)) tf.text = _fieldsData[tf.name].startText;
			if (_fieldsData[tf.name].type == FormFieldType.YEAR && (isNaN(num) || num < 1900)) tf.text = _fieldsData[tf.name].startText;
			
			tf.textColor = _fieldsData[tf.name].startTextColor;
		}
		
		
		private function removeListeners(e:Event):void {
			e.currentTarget.removeEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			e.currentTarget.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, removeListeners);
		}
		
		private function removeComponentListeners(e:Event):void {
			e.currentTarget.removeEventListener(FocusEvent.FOCUS_IN, onComboBoxFocusInHandler);
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, removeListeners);
		}
		
		private function removeRadioListeners(e:Event):void {
			e.currentTarget.removeEventListener(FocusEvent.FOCUS_IN, onRadioFocusInHandler);
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, removeListeners);
		}

		////////////////
		// TabIndex method
		
		private function setTabIndex(startIndex:int):void {
			
			var index:int = (startIndex == -1) ? MathUtils.randRange(BASE_SEED, BASE_SEED*2) : startIndex;
			
			for(var i:int = 0; i < _fields.length; i ++) {
				if (_fields[i].type == FormFieldType.COMBO_BOX){
					_fields[i].field.tabChildren = false;
					_fields[i].field.tabIndex = index++;
				} else if (_fields[i].type == FormFieldType.RADIO_BUTTON_GROUP) {
					var rg:RadioButtonGroup = RadioButtonGroup.getGroup(_fields[i].field);
					
					for (var j:uint = 0; j < rg.numRadioButtons; j++) {
						rg.getRadioButtonAt(j).enabled = true;
						rg.getRadioButtonAt(j).tabChildren = false;
						rg.getRadioButtonAt(j).tabIndex = index++;
					}
				} else {
					_fields[i].field.tabIndex = index++;
				}
			}
			
			lastIndex = index-1;
		}
		
		/***********
		 * Returns the last index set for the form
		 * @returns int with the last index
		 ***********/
		public function getLastIndex():int {
			return lastIndex;
		}
		
		
		/////////////////////
		
		private function validateText(field:Object):Boolean {
			var result:Boolean = true;
			
			_fieldsData[field.field.name].currentText = (field.field.text != _fieldsData[field.field.name].startText && field.field.text != _config.errorMsg) ? field.field.text : "";
			
			
			if (field.field.text == "" || field.field.text == _fieldsData[field.field.name].startText) {
				result = false;
				_errorFields.push(field);
				setFeedback(field);
			}
			
			
			return result;
		}
		
		
		private function validateEmail(field:Object):Boolean {
			_fieldsData[field.field.name].currentText = (field.field.text != _fieldsData[field.field.name].startText && field.field.text != _config.errorMsg) ? field.field.text : "";
			
			var result:Boolean = Validation.validateEmail(field.field.text);
			if (!result) {
				_errorFields.push(field);
				setFeedback(field);
			}
			
			return result;
		}
		
		
		private function validateDay(field:Object):Boolean {
			var result:Boolean = true;
			
			_fieldsData[field.field.name].currentText = (field.field.text != _fieldsData[field.field.name].startText && field.field.text != _config.errorMsg) ? field.field.text : "";
			
			if (field.field.text == "" || field.field.text == _fieldsData[field.field.name].startText) {
				result = false;
			} else {
				var dia:int = parseInt(field.field.text);
				if (isNaN(dia) || dia < 1 || dia > 31) result = false;
			}
			
			if (!result) {
				_errorFields.push(field);
				setFeedback(field);
			}
			
			return result;
		}
		
		
		private function validateMonth(field:Object):Boolean {
			var result:Boolean = true;
			
			_fieldsData[field.field.name].currentText = (field.field.text != _fieldsData[field.field.name].startText && field.field.text != _config.errorMsg) ? field.field.text : "";
			
			if (field.field.text == "" || field.field.text == _fieldsData[field.field.name].startText) {
				result = false;
			} else {
				var mes:int = parseInt(field.field.text);
				if (isNaN(mes) || mes < 1 || mes > 12) result = false;
			}
			
			if (!result) { 
				_errorFields.push(field);
				setFeedback(field);
			}
			
			return result;
		}
		
		
		private function validateYear(field:Object):Boolean {
			var result:Boolean = true;
			
			_fieldsData[field.field.name].currentText = (field.field.text != _fieldsData[field.field.name].startText && field.field.text != _config.errorMsg) ? field.field.text : "";
			
			
			if (field.field.text == "" || field.field.text == _fieldsData[field.field.name].startText) {
				result = false;
			} else {
				var ano:int = parseInt(field.field.text);
				if (isNaN(ano) || ano < 1900) result = false;
			}
			
			if (!result) {
				_errorFields.push(field);
				setFeedback(field);
			}
			
			return result;
		}
		
		
		private function validateRadioGroup(field:Object):Boolean {
			var result:Boolean = true;
			
			var rg:RadioButtonGroup = RadioButtonGroup.getGroup(field.field);
			result = (rg.selectedData != null);	
			
			if (!result) {
				_errorFields.push(field);
				setFeedbackRadioButton(field);
			}
			
			return result;
			
		}
		
		
		private function validateComboBox(field:Object):Boolean {
			var result:Boolean = true;
			var cb:ComboBox = ComboBox(field.field);
			
			_fieldsData[cb.name].currentText = (cb.textField.textField.text != _fieldsData[cb.name].startText && cb.textField.textField.text != _config.errorMsg) ? cb.textField.textField.text : "";
			
			
			result = (cb.selectedIndex > 0);
			
			if (!result) {
				_errorFields.push(field);
				setFeedbackComboBox(field);
			}
			
			return result;
			
		}
		
		/**********
		 * Validates de fields in the form, according to type and wether they are mandatory or not
		 * @returns Boolean true if the form is valide, false otherwise
		 **********/
		public function validate():Boolean {
			var result:Boolean = true;
			
			if (!_errorFields) {
				_errorFields = new Array();
			} else {
				_errorFields.splice(0);
			}
			
			
			if (_config.feedbackType == FormFeedbackType.ERROR_FIELD && _config.errorField){
				_config.errorField.text = "";
			}
			
			
			for(var i:uint = 0; i <_fields.length; i++) {
				if (_fields[i].mandatory) {
					
					switch (_fields[i].type) {
						case FormFieldType.TEXT : 				if (!validateText(_fields[i])) result = false;
																break;
						case FormFieldType.PASSWORD : 			if (!validateText(_fields[i])) result = false;
																break;
						case FormFieldType.EMAIL : 				if (!validateEmail(_fields[i])) result = false;
																break;
						case FormFieldType.DAY : 				if (!validateDay(_fields[i])) result = false;
																break;
						case FormFieldType.MONTH : 				if (!validateMonth(_fields[i])) result = false;
																break;
						case FormFieldType.YEAR : 				if (!validateYear(_fields[i])) result = false;
																break;
						case FormFieldType.RADIO_BUTTON_GROUP :	if (!validateRadioGroup(_fields[i])) result = false;
																break;
						case FormFieldType.COMBO_BOX :			if (!validateComboBox(_fields[i])) result = false;
																break;
					}
				}
				
			} 
			
			if (!result && _config.feedbackType == FormFeedbackType.ERROR_FIELD && _config.errorField){
				_config.errorField.text = _config.errorMsg;
				if (_config.enumFields) {
					_config.errorField.text +="\n";
					for( var j:uint = 0; j < _errorFields.length; j++) {
						_config.errorField.appendText(_errorFields[j].label);
						if (j < _errorFields.length - 1) _config.errorField.appendText(", ");
					}
					
				}
				if(_config.errorColor) _config.errorField.textColor = _config.errorColor;
			}
			
			return result;

		}
		
		/*******
		 * Array with the invalid fields
		 * @returns Array Object array with the invalid fields. Each object has the following properties: 
		 *                	field:* name of the textfield or input object. Note: only TextField supported at the moment.
		 * 		   			type:String form field type. Accepts values from the FormFieldType Class
		 * 		   			label:String
		 * 		   			mandatory:Boolean defines the field as mandatory or not;  
		 * 					startText:String initial text in textfields
		 * 					startColor:Number initial color of text
		 ********/
		public function getErrorFields():Array {
			return _errorFields;
		}
		
		
		
		private function setFeedback(field:Object) {
			
			if (_config.feedbackType == FormFeedbackType.IN_FIELD) {
				field.field.textColor = _config.errorColor;
				if (_config.errorMsg != null && _config.errorMsg != "") field.field.text = _config.errorMsg;
			} else if (_config.feedbackType == FormFeedbackType.SYMBOL && _config.symbol) {
				if (!_fieldsData[field.field.name].errorSymbol) { 
					var symbol:* = new _config.symbol();
					symbol.name = "symbol_"+field.field.name;
					symbol.y = field.field.y - (symbol.height - field.field.height) / 2;
					if (_config.symbolPlacement == FormFeedbackType.SYMBOL_LEFT) {
						symbol.x = field.field.x - symbol.width - MARGIN;
					} else if (_config.symbolPlacement == FormFeedbackType.SYMBOL_RIGHT) {
						symbol.x = field.field.x + field.field.width + MARGIN;
					} else if (_config.symbolPlacement == FormFeedbackType.SYMBOL_INSIDE) {
						symbol.x = field.field.x + field.field.width - symbol.width;
					}
					field.field.parent.addChild(symbol);
					_fieldsData[field.field.name].errorSymbol = symbol;
				}
			} 
		}
		
		
		private function setFeedbackRadioButton(field:Object) {
			var rg:RadioButtonGroup = RadioButtonGroup.getGroup(field.field);
			var numBts:int = rg.numRadioButtons;
			
			if (_config.feedbackType == FormFeedbackType.IN_FIELD) {
				for(var i:uint = 0; i < numBts; i++) {
					rg.getRadioButtonAt(i).textField.textColor = _config.errorColor;
				}
			
			} else if (_config.feedbackType == FormFeedbackType.SYMBOL && _config.symbol) {
				if (!_fieldsData[field.field].errorSymbol) { 
					var symbol:* = new _config.symbol();
					symbol.name = "symbol_"+field.field;
					
					var rightRB, leftRB:RadioButton;
					rightRB = rg.getRadioButtonAt(0);
					leftRB = rg.getRadioButtonAt(0);
					
					for (var j:uint = 1; j < numBts; j++) {
						if (rg.getRadioButtonAt(j).x < leftRB.x) leftRB = rg.getRadioButtonAt(j);
						if (rg.getRadioButtonAt(j).x > rightRB.x) rightRB = rg.getRadioButtonAt(j);
					}
					
					symbol.y = leftRB.y - (symbol.height - leftRB.height) / 2;
					if (_config.symbolPlacement == FormFeedbackType.SYMBOL_LEFT) {
						symbol.x = leftRB.x - symbol.width - MARGIN;
					} else if (_config.symbolPlacement == FormFeedbackType.SYMBOL_RIGHT) {
						symbol.x = rightRB.x + rightRB.width + MARGIN;
					} else if (_config.symbolPlacement == FormFeedbackType.SYMBOL_INSIDE) {
						symbol.x = rightRB.x + rightRB.width - symbol.width;
					}
					leftRB.parent.addChild(symbol);
					_fieldsData[field.field].errorSymbol = symbol;
				}
			} 
		}
		
		
		
		private function setFeedbackComboBox(field:Object) {
			
			if (_config.feedbackType == FormFeedbackType.IN_FIELD) {
				field.field.textField.textField.textColor = _config.errorColor;
				if (_config.errorMsg != null && _config.errorMsg != "") field.field.textField.textField.text = _config.errorMsg;
				
			} else if (_config.feedbackType == FormFeedbackType.SYMBOL && _config.symbol) {
				if (!_fieldsData[field.field.name].errorSymbol) { 
					var symbol:* = new _config.symbol();
					symbol.name = "symbol_"+field.field.name;
					symbol.y = field.field.y - (symbol.height - field.field.height) / 2;
					if (_config.symbolPlacement == FormFeedbackType.SYMBOL_LEFT) {
						symbol.x = field.field.x - symbol.width - MARGIN;
					} else if (_config.symbolPlacement == FormFeedbackType.SYMBOL_RIGHT) {
						symbol.x = field.field.x + field.field.width + MARGIN;
					} else if (_config.symbolPlacement == FormFeedbackType.SYMBOL_INSIDE) {
						symbol.x = field.field.x + field.field.width - symbol.width;
					}
					field.field.parent.addChild(symbol);
					_fieldsData[field.field.name].errorSymbol = symbol;
				}
			} 
		}
		
	}

}
