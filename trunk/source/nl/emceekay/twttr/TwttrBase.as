package nl.emceekay.twttr 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import nl.emceekay.twttr.data.enum.Emoticons;
	/**
	 * // nl.emceekay.twttr.TwttrBase
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class TwttrBase extends MovieClip
	{
		//default: http://twitter.com/matthijskamstra
		private var _url:String = "http://twitter.com/statuses/user_timeline/27657030.rss"; 
		
		private var _feed:XML;
		private var _converted_feed:XML;
		
		
		
		// constructor
		public function TwttrBase() { trace( "+ TwttrBase.TwttrBase" ); }
		
		//////////////////////////////////////// loading rss / show rss ////////////////////////////////////////
		
		/**
		 * get the rss feed
		 * @param	inURL	path to the rss
		 */
		public function getFeed (inURL:String) : void 
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onFeedHandler);
			loader.load(new URLRequest(inURL));
		}

		private function onFeedHandler (e:Event):void 
		{
			feed 			= new XML(e.target.data);
			//converted_feed	= convertTweet(feed); // werkt niet moet ee 
			
			var _item:XMLList = feed.channel.item;
			for each (var feedItem:XML in _item){
				
				var _title			:String = feedItem.title;
				var _description	:String = feedItem.description;
				var _pubDate		:String = feedItem.pubDate;
				var _guid			:String = feedItem.guid;
				var _link			:String = feedItem.link;
				
				//_title 		= convertTweet(_title);
				//_description 	= convertTweet(_description);
			}
			
			
			init();
		}
		
		
		//////////////////////////////////////// init (override!!) ////////////////////////////////////////
		
		
		// if xml/rss is loaded use this function to start your application
		protected function init():void
		{
			trace( "TODO :: override protected function init():void {}" );
		}
		
		
		//////////////////////////////////////// get parts of rss/xml ////////////////////////////////////////
		
		
		/**
		 * 
		 * @param	inID
		 * @return
		 */
		public function getTitle (inID:int):String 
		{
			var _item:XMLList = feed.channel.item;
			return convertTweet(_item[inID].title);
		}
		
		/**
		 * 
		 * @return
		 */
		public function getTweetTotal ():int
		{
			var _item:XMLList = feed.channel.item;
			return _item.length();
		}
		
		/**
		 * 
		 * @param	inID
		 * @return
		 */
		public function getDate (inID:int):String
		{
			var _item:XMLList = feed.channel.item;
			return _item[inID].pubDate;
		}
		
		//////////////////////////////////////// twitter specific ////////////////////////////////////////
		
		// one place to convert the tweet
		private function convertTweet (inString:String):String
		{
			var _str:String = inString;
			_str = twttrStripName(_str);
			_str = twttrConvertHTTP(_str); 
			_str = twttrConvertMention(_str);
			_str = twttrConvertHashtag(_str);
			_str = twttrConvertSmileys(_str);
			return _str;
		}
		
		// remove the writers name from the tweet
		private function twttrStripName (inString:String):String
		{
			var _str:String = inString;
			var _charNumber:Number = _str.indexOf(":");
			return _str.substr(_charNumber + 2);
		}
		
		// convert http-strings to links
		private function twttrConvertHTTP(inString:String):String
		{
			var _str:String = inString;	
			var _array:Array = _str.split(" ");
			for (var i:int = 0; i < _array.length; i++) 
			{
				var _str2:String = twttrStripChar(_array[i]);
				if (_array[i].indexOf("http") != -1) 
				{
					_array[i] = "<u><a href='" + _str2 + "' target='_blank'>" +_array[i] + "</a></u>";
				}
			}
			return _array.join(" ");
		}
		
		// convert mentions (@) to links
		private function twttrConvertMention(inString:String):String
		{
			var _str:String = inString;
			var _array:Array = _str.split(" ");
			for (var i:int = 0; i < _array.length; i++) 
			{
				var _str2:String = twttrStripChar(_array[i]);
				if (_array[i].substr(0, 1) == "@") 
				{
					_array[i] = "<u><a href='http://www.twitter.com/" + _str2.split("@")[1] + "' target='_blank'>" +_array[i] + "</a></u>";
				}
			}
			return _array.join(" ");
		}
		
		// convert hashtags (#) to links
		private function twttrConvertHashtag(inString:String):String
		{
			var _str:String = inString;
			var _array:Array = _str.split(" ");
			for (var i:int = 0; i < _array.length; i++) 
			{
				var _str2:String = twttrStripChar(_array[i]);
				if (_array[i].substr(0, 1) == "#") 
				{
					_array[i] = "<u><a href='http://twitter.com/search?q=%23" + _str2.split("#")[1] + "' target='_blank'>" +_array[i] + "</a></u>";
				}
			}
			return _array.join(" ");
		}		
		
		// [mck] this doesn't work ... images move to the next line
		private function twttrConvertSmileys(inString:String):String
		{
			var _str:String = inString;
			// [mck] this doesn't work ... images move to the next line
			//_str = Emoticons.convertEmoticon(_str);
			return _str;
		}
		
		// remove "strange" characters from the end of the string
		private function twttrStripChar(inString:String):String
		{
			var _str:String = inString;
			var _charArray:Array = [',', ';', ':', ' ', '-', '_'];
			for (var i:int = 0; i < _charArray.length; i++) 
			{
				if (_str.charAt(_str.length - 1) == _charArray[i]) {
					_str = _str.substr(0, _str.length - 1);
				}
			}
			return _str;
		}
		
		
		//////////////////////////////////////// getter / setter ////////////////////////////////////////
		
		
		public function get url():String { return _url; }
		public function set url(value:String):void { _url = value; }
		
		public function get feed():XML { return _feed; }
		public function set feed(value:XML):void { _feed = value; }
		
		public function get converted_feed():XML { return _converted_feed; }	
		public function set converted_feed(value:XML):void { _converted_feed = value; }
		
		
		
		
	} // end class

} // end package