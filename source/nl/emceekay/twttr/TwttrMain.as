package nl.emceekay.twttr 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	/**
	 * // nl.emceekay.twttr.TwttrMain
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class TwttrMain extends MovieClip
	{
		
		//default: http://twitter.com/matthijskamstra
		private var _url:String = "http://twitter.com/statuses/user_timeline/27657030.rss"; 
		
		private var _txt:TextField;
		private var _tContainer:MovieClip;
		
		public function TwttrMain() 
		{
			_txt = tContentTxt;
			_txt.autoSize = "left";
			
			_tContainer = tContainer;
			
			//trace (">>" + twttrStripChar("http://www.foo.nl/bar,"));
			
			getTweets(rssURL);
		}
		private function getTweets (inURL:String) : void 
		{
			_txt.htmlText = "getting tweets";
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleTwitterResult);
			loader.load(new URLRequest(inURL));
		}

		private function handleTwitterResult (e:Event):void 
		{
			_txt.htmlText = "";
			var twitterFeed:XML = new XML(e.target.data);
			var twitterItems:XMLList = twitterFeed.channel.item;
			for each (var feedItem:XML in twitterItems)
			{
				var _title:String = feedItem.title;
				var _pubDate:String = feedItem.pubDate;
				var _link:String = feedItem.link;
				_title = convertTweet(_title);
				_txt.htmlText += _title + "<br><i>" + _pubDate + "</i><br><br>";
			}
			
			setupBalloons(twitterFeed);
			
		}
		
		private function setupBalloons(inXML:XML):void
		{
			//trace( "TwttrMain.setupBalloons > inXML : " + inXML );
			var _xml:XML = inXML;
			var _str:String = _xml.channel.item[0].title;
			_tContainer.tContentTxt.htmlText =  convertTweet(_str);
			//_tContainer.tContentTxt.htmlText =  test140Char();
			
		}
		
		private function test140Char ():String
		{
			var _str:String = ""
			for (var i:int = 0; i < 140; i++) 
			{
				_str += "x";
			}
			return _str;
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
		
		// TODO: [mck] convert :) to a smiley image
		private function twttrConvertSmileys(inString:String):String
		{
			var _str:String = inString;
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
		
		//////////////////////////////////////// getters / setters ////////////////////////////////////////
		
		public function get rssURL():String { return _url; }
		public function set rssURL(value:String):void {	_url = value; }

	}

}