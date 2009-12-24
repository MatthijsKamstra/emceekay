package nl.emceekay.twttr.data.enum 
{
	/**
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class Emoticons
	{
		
		/*
		 * dutch ... not all the smileys are present, so some are joint
		 * 
		:-) :)	Standaard smiley		=) =]	Happy, gelukkig 		;-) ;)	Knipoog
		:-( :(	Droevig
		:-p :p	Tong uitsteken
		:-D :D	Lachen   		x-D xD	Hard lachen (met ogen dicht)
		:-O :o	Verbaasd		:-S :s :/	Verward				:-? :?	Zich afvragend
		:-| :|	Neutraal, geschokt     		:-X :x	Mond dicht
		*/
		
		
		public static const BIG_SMILE			:String = "bigsmile";
		public static const NEUTRAL				:String = "neutral";
		public static const SAD					:String = "sad";
		public static const SMILE				:String = "smile";
		public static const SURPRISED			:String = "surprised";
		public static const TONGUE				:String = "tongue";
		
		public static const ICON_12X12			:String = "12x12";
		public static const ICON_16X16			:String = "16x16";
		
		private static var bigsmileArray		:Array = [":-D" , ":D", "x-D" , "xD"];
		private static var neutralArray			:Array = [":-|" , ":|", ":-x" , ":x"];
		private static var sadArray				:Array = [":-(" , ":("];
		private static var smileArray			:Array = [":-)" , ":)" , "=)" , "=]" , ";-)" , ";)" ];
		private static var surprisedArray		:Array = [":-o" , ":o", ":-0" , ":0"];
		private static var tongueArray			:Array = [":-p" , ":p"];
		
		private static var _emoticonObject:Object = { 
														BIG_SMILE	: bigsmileArray, 
														NEUTRAL		: neutralArray, 
														SAD			: sadArray, 
														SMILE		: smileArray, 
														SURPRISED	: surprisedArray, 
														TONGUE		: tongueArray
													};
		
		// <img src='img/emoticon/12x12/smile.png'>
		
		
		public function Emoticons() { }
		
		
		public static function convertEmoticon (inString:String):String
		{
			//trace( "Emoticons.convertEmoticon > inString : " + inString );
			for ( var _emoticons:String in _emoticonObject) {
				//trace( "\t-\t key : " + _emoticons + ", value : " + _emoticonObject[_emoticons] );
				for ( var _emoArray:String in _emoticonObject[_emoticons] ) {
					//trace( "\t\t|\t key : " + _emoArray + ", value : " + _emoticonObject[_emoticons][_emoArray] );
					if (inString.indexOf(_emoticonObject[_emoticons][_emoArray]) != -1)
					{
						//trace ("________________________")
						//trace ("we have a hit: " +  _emoticonObject[_emoticons][_emoArray]);
						//trace( "_emoticons : " + _emoticons );
						//trace( "Emoticons[_emoticons] : " + Emoticons[_emoticons] );
						//var _emoImg:String = "<img src='img/emoticon/"+ICON_12X12+"/"+Emoticons[_emoticons]+".png' id='"+_emoticonObject[_emoticons][_emoArray]+"'>";
						var _emoImg:String = "<img src='img/emoticon/"+ICON_12X12+"/"+Emoticons[_emoticons]+".png' width='12' height='12' align='left' >";
						inString = inString.split (_emoticonObject[_emoticons][_emoArray]).join (_emoImg);
						//trace( "inString : " + inString );
						//trace ("________________________")
					}
				}
			}
			return inString;
		}
		

		
		
		
	} // end class

}