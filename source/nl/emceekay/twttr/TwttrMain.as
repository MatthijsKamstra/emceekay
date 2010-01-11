package nl.emceekay.twttr 
{
	import com.greensock.easing.*;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import nl.emceekay.twttr.data.enum.Emoticons;
	import nl.emceekay.twttr.view.Balloon;
	import nl.noiselibrary.events.DynamicEvent;
	import nl.noiselibrary.utils.Dump;
	import nl.noiselibrary.utils.Link;
	/**
	 * // nl.emceekay.twttr.TwttrMain
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class TwttrMain extends TwttrBase
	{
		
		//default: http://twitter.com/matthijskamstra
		private var _url:String = "http://twitter.com/statuses/user_timeline/27657030.rss"; 
		
		private var _tContainer:MovieClip;
		
		private var sheet:StyleSheet = new StyleSheet();
        private var cssReady:Boolean = false;
		
		private var loader:URLLoader = new URLLoader();
		private var tweetArray:Array = [];
		
		// ids (current en previous "tweet") and total tweets
		private var previousID:Number;
		private var currentID:Number;
		
		private var myTimer:Timer;
		private const TIMER_DELAY:int = 5000; // autoplay
		
		public function TwttrMain() 
		{
			stage.scaleMode = "noScale";
            stage.align = "TL";
			
			//Dump.output(this);
			
			var _tFollowMeBtn:MovieClip= this.getChildByName('tFollowMeBtn') as MovieClip;
			_tFollowMeBtn.addEventListener (MouseEvent.CLICK, onClickHandler);
			
			_tContainer = tContainer;
			
			getFeed(_url);
			loadCSS();
			
			myTimer = new Timer(TIMER_DELAY);
            myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            
			
			//trace( "test140Char() : " + test140Char() );
			
			addEventListener ("tweet", onTweetChangeHandler);
			
		}
		
		private function loadCSS():void
		{
			var req:URLRequest = new URLRequest("css/twttr_style.css");
            loader.load(req);
		
            loader.addEventListener(IOErrorEvent.IO_ERROR	, errorHandler);
            loader.addEventListener(Event.COMPLETE			, loaderCompleteHandler);
		}
		
		/**
		 * override init from TwttrBase
		 */
		override protected function init():void 
		{
			var _tTweetContainer:MovieClip = this.tTweetContainer;
			
			for (var i:int = 0; i < getTweetTotal(); i++) 
			{
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
			showTweetID(0);
			
			myTimer.start();
		}
		
		private function showTweetID(inID:int = 0):void
		{
			var _balloon:MovieClip = tweetArray[inID];
			TweenMax.to (_balloon, .5, { autoAlpha:1, rotation:0, ease:Back.easeOut } );
			
			if (!isNaN (previousID)) {
				hidePreviousTweet(previousID);
			}
			previousID 	= inID;
			currentID 	= inID;
		}	
		
		private function hidePreviousTweet(inPreID:int):void
		{
			var _balloon:MovieClip = tweetArray[inPreID];
			TweenMax.to (_balloon, .5, { autoAlpha:0, rotation:90, ease:Back.easeOut } );
		}
		
		
		//////////////////////////////////////// handlers ////////////////////////////////////////
		
		
		private function timerHandler(e:TimerEvent):void 
		{
			//trace( "TwttrMain.timerHandler > e : " + e );
			var showID:Number = currentID + 1;
			if (showID >= getTweetTotal()) {
				showID = 0;
			}
			showTweetID(showID);
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			//<a href="http://www.twitter.com/MatthijsKamstra"><img src="http://twitter-badges.s3.amazonaws.com/t_mini-a.png" alt="Follow MatthijsKamstra on Twitter"/></a>
			Link.to("http://www.twitter.com/MatthijsKamstra", Link.WINDOW_BLANK);
		}
		
		private function onTweetChangeHandler(e:DynamicEvent):void 
		{
			//trace( "TwttrMain.onTweetChangeHandler > e : " + e );

			var _obj:Object = e.dynamicObject;
			showTweetID (_obj.id);
			
			myTimer.reset();
			myTimer.start();
		}
		
		// loading css
		public function errorHandler(e:IOErrorEvent):void 
		{
			trace( "TwttrMain.errorHandler > e : " + e );
			trace( "\t|\tCouldn't load the style sheet file." );
        }
		
		// loading css complete
        public function loaderCompleteHandler(event:Event):void 
		{
            sheet.parseCSS(loader.data);
            cssReady = true;
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