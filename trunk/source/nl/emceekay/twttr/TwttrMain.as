package nl.emceekay.twttr 
{
	import com.greensock.easing.*;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import nl.emceekay.twttr.data.enum.Emoticons;
	import nl.emceekay.twttr.view.Balloon;
	import nl.noiselibrary.events.DynamicEvent;
	/**
	 * // nl.emceekay.twttr.TwttrMain
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class TwttrMain extends TwttrBase
	{
		
		//default: http://twitter.com/matthijskamstra
		private var _url:String = "http://twitter.com/statuses/user_timeline/27657030.rss"; 
		
		private var _txt:TextField;
		private var _tContainer:MovieClip;
		
		private var sheet:StyleSheet = new StyleSheet();
        private var cssReady:Boolean = false;
		private var loader:URLLoader = new URLLoader();
		private var tweetArray:Array = [];
		
		public function TwttrMain() 
		{
			stage.scaleMode = "noScale";
            stage.align = "TL";
			
			_txt = tContentTxt;
			_txt.autoSize = "left";
			_txt.htmlText = "loading rss";
			
			_tContainer = tContainer;
			
			getFeed(_url);
			loadCSS();
			
			//trace( "test140Char() : " + test140Char() );
			
			addEventListener ("tweet", onTest);
			
		}
		
		private function onTest(e:DynamicEvent):void 
		{
			trace( "TwttrMain.onTest > e : " + e );
			var _obj:Object = e.dynamicObject;
			showTweetID (_obj.id);
			
		}
		
		
		private function loadCSS():void
		{
			var req:URLRequest = new URLRequest("css/twttr_style.css");
            loader.load(req);
		
            loader.addEventListener(IOErrorEvent.IO_ERROR	, errorHandler);
            loader.addEventListener(Event.COMPLETE			, loaderCompleteHandler);
		}
		
		public function errorHandler(e:IOErrorEvent):void 
		{
            _txt.htmlText = "Couldn't load the style sheet file.";
        }

        public function loaderCompleteHandler(event:Event):void 
		{
			trace( "TwttrMain.loaderCompleteHandler > event : " + event );
            sheet.parseCSS(loader.data);
            cssReady = true;
			
			_txt.styleSheet 	= sheet;
        }
		
		override protected function init():void 
		{
			trace( "TwttrMain.init" );
			
			var _tTweetContainer:MovieClip = this.tTweetContainer;
			
			_txt.htmlText 	= "<p>";
			var _total:int = getTweetTotal();
			for (var i:int = 0; i < _total; i++) 
			{
				_txt.htmlText += (getTitle(i) + "<br><span class='date'>" + getDate(i) + "</span><br><br>");
				
				var _balloon:Balloon = new Balloon();
				_balloon.setID (i);
				_balloon.setStyleSheet(sheet);
				_balloon.setTxt("<p>" + getTitle(i) + "<br><span class='date'>" + getDate(i) + "</span></p>");
				_balloon.x = 165;
				_balloon.y = 180 - _balloon.height;
				_balloon.visible = false;
				_balloon.alpha = 0;
				
				_balloon.rotation = 90;
				_tTweetContainer.addChild(_balloon);
				
				tweetArray.push(_balloon); // collect balloons
			}
			
			_txt.htmlText 	+= "</p>";
			
			showTweetID(0);
		}
		
		private function showTweetID(inID:int = 0):void
		{
			var _balloon:MovieClip = tweetArray[inID];
			TweenMax.to (_balloon, .5, {autoAlpha:1, rotation:0, ease:Back.easeOut});
		}	
		
		
		
		//////////////////////////////////////// test ////////////////////////////////////////
		
		
		private function test140Char ():String
		{
			var _str:String = ""
			for (var i:int = 0; i < 140; i++) 
			{
				_str += "x";
			}
			return _str;
		}
		
	
		
	} // end class

}