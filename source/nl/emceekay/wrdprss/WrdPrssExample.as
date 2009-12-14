package nl.emceekay.wrdprss 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	/**
	 * // nl.emceekay.wrdprss.WrdPrssExample
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class WrdPrssExample extends MovieClip
	{
		//default: http://www.matthijskamstra.nl/blog/wp-rss2.php?cat=11 || [mck] Urban papercraft RSS feed
		private var url:String = "http://www.matthijskamstra.nl/blog/wp-rss2.php?cat=11"; 
		
		private var _txt:TextField;
		
		public function WrdPrssExample() 
		{
			stage.scaleMode = "noScale";
            stage.align = "TL";
			
			// generate textfield
			_txt = new TextField()
            _txt.x = 10;
            _txt.y = 10;
            _txt.width = stage.stageWidth - 20;
            _txt.height =  stage.stageHeight - 20;
			_txt.wordWrap = true;
			_txt.multiline = true;
			_txt.autoSize = "left";
			addChild(_txt);
			
			// start 
			getFeed(url);
		}
		
		//////////////////////////////////////// loading rss / show rss ////////////////////////////////////////
		
		private function getFeed (inURL:String) : void 
		{
			_txt.htmlText = "loading...";
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onFeedHandler);
			loader.load(new URLRequest(inURL));
		}

		private function onFeedHandler (e:Event):void 
		{
			_txt.htmlText = "";
			var _feed:XML = new XML(e.target.data.split("content:encoded").join("content")); // can't get "content:encoded" so convert that to "content"
			var _item:XMLList = _feed.channel.item;
			for each (var feedItem:XML in _item){
				var _title			:String = feedItem.title; 			// title post
				var _link			:String = feedItem.link;			// url of post 
				var _comments		:String = feedItem.comments;		// url of comments
				var _pubDate		:String = feedItem.pubDate;			// publication data
				var _guid			:String = feedItem.guid; 			// permalink
				var _description	:String = feedItem.description;		// short description post
				var _content		:String = feedItem.content;			// content post (original xml-node == "<content:encoded>")
				
				//trace( "_content : " + _content );
				
				//_title = convertFeed(_title);
				
				_txt.htmlText += "<b>" + _title + "</b><br><i>" + _pubDate + "</i><br>" + _content + "<br><br>";
			}
			
			trace (_feed.channel.item[0].content);
			
		}
		
		//////////////////////////////////////// wordpress specific ////////////////////////////////////////
		
		// hmmmm a lot to make it work with the html properties of Flash
		
	} // end class

} // end package