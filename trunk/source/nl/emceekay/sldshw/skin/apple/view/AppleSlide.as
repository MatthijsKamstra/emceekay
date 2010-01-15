package nl.emceekay.sldshw.skin.apple.view 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import nl.emceekaylibrary.utils.Dump;
	import nl.emceekay.sldshw.BaseMain;
	import nl.emceekay.sldshw.BaseSlide;
	import nl.emceekay.sldshw.data.enum.EventNames;
	/**
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class AppleSlide extends BaseSlide
	{
		private var isFullScreenMode	:Boolean = false;
		private var isIndexMode			:Boolean = false;
		private var myTimer:Timer;
		
		public function AppleSlide() 
		{
			trace( "+ AppleSlide.AppleSlide" );
			super();
		}
		
		override protected function initialize(e:Event):void 
		{
			super.initialize(e);
			// add some extra EventListeners
			this.stage.addEventListener(EventNames.NAV_FULL_EVENT	, onEventHandler);
			//this.stage.addEventListener(EventNames.NAV_INDEX_EVENT	, onEventHandler);
			this.stage.addEventListener(EventNames.NAV_PLAY_EVENT	, onEventHandler);
			this.stage.addEventListener(EventNames.NAV_PAUZE_EVENT	, onEventHandler);
			this.stage.addEventListener(EventNames.NAV_LEFT_EVENT	, onEventHandler);
			this.stage.addEventListener(EventNames.NAV_RIGHT_EVENT	, onEventHandler);
		}
		
		private function onEventHandler(e:Event):void 
		{
			//trace( "AppleSlide.onEventHandler > e : " + e );
			
			//BaseMain.LAYER_1.visible = false;
			
			var _type:String = e.type;
			switch (_type) {
				case EventNames.NAV_PLAY_EVENT:
					//trace ('---> controller_Play_Event');
					myTimer = new Timer(2000);
					myTimer.addEventListener(TimerEvent.TIMER , onTickHandler);
					myTimer.start();
					break;
				case EventNames.NAV_PAUZE_EVENT:
					myTimer.stop();
					break;
				/*				
 				case EventNames.NAV_INDEX_EVENT:
					//trace ('---> controller_Index_Event');
						trace( "isIndexMode : " + isIndexMode );
					if (isIndexMode) {
						isIndexMode = false;
						Dump.output(this);
					} else {
						isIndexMode = true;
						buildIndex();
					}
					BaseMain.LAYER_3.visible = isIndexMode;
					
					if (myTimer != null){
						myTimer.stop();
					}
					break;
					*/
				case EventNames.NAV_FULL_EVENT:
					if (isFullScreenMode){
						isFullScreenMode = false;
						dispatchEvent (new Event(EventNames.NAV_IS_NORMALSCREEN, true));
					} else {
						isFullScreenMode = true;
						dispatchEvent (new Event(EventNames.NAV_IS_FULLSCREEN, true));
					}
				case EventNames.NAV_LEFT_EVENT:
				case EventNames.NAV_RIGHT_EVENT:
					_onResizeHandler(null);
					break;
				default:
					trace("case '"+_type+"':\r\ttrace ('---> "+_type+"');\r\tbreak;" );
			}
		}
		
		private function onTickHandler(e:TimerEvent):void 
		{
			//trace( "AppleSlide.onTickHandler > e : " + e );
			dispatchEvent(new Event(EventNames.NAV_RIGHT_EVENT , true));
		}
		
		/**
		 * index of all images
		 */
		/*private function buildIndex():void
		{
			trace( "AppleSlide.buildIndex" );

			var xMax:int = Math.ceil(Math.sqrt(totalImg) );
			
			var xPos:int = 0;
			var yPos:int = 0;
			
			var _width:int 	= Math.floor(stage.stageWidth / (xMax));
			var _height:int = Math.floor(stage.stageHeight/ (totalImg - 1 - xMax));
			var _size:int = (_width <= _height) ? _width : _height;
			
			var indexContainer:MovieClip = new MovieClip();
			trace( "indexContainer : " + indexContainer );
			for (var i:int = 0; i < totalImg ; i++) 
			{
				var __bitmap:Bitmap = assetLoaderLite.getBitmap("img" + i);
				__bitmap.smoothing = true; // [mck] nicer images when fullscreen
				
				var __sprite:Sprite = new Sprite();
				
				indexContainer.addChild(__sprite);
				
				__sprite.addChild(__bitmap);
				
				__sprite.width 	= _size;
				__sprite.height 	= _size;
				if (__sprite.scaleX <= __sprite.scaleY) {
					__sprite.scaleY = __sprite.scaleX;
				} else {
					__sprite.scaleX  = __sprite.scaleY; 
				}
				
				__sprite.x = xPos * _width  + ((_width - __sprite.width)*.5);
				__sprite.y = yPos * _height + ((_height - __sprite.height)*.5);
				
				// grid
				if (xPos >= xMax-1) {
					xPos = 0;
					yPos++;
				} else {
					xPos++;
				}
				
				
				
			}
			
			BaseMain.LAYER_3.addChildAt(indexContainer, 0);
			
		}	*/
		/*	
		private function reMoveSlideShow():void 
		{
			trace( "AppleSlide.reMoveSlideShow" );
				
			var totalImg:int = imgArray.length;
			var xMax:int = Math.ceil(Math.sqrt(totalImg) );
			
			var xPos:int = 0;
			var yPos:int = 0;
			
			var _width:int 	= Math.floor(stage.stageWidth / (xMax));
			var _height:int = Math.floor(stage.stageHeight/ (totalImg - 1 - xMax));
			var _size:int = (_width <= _height) ? _width : _height;
			
			// resize imgContainers
			for (var i:int = 0; i < totalImg ; i++) 
			{
				var _sprite:Sprite = imgArray[i];
				_sprite.width 	= _size;
				_sprite.height 	= _size;
				if (_sprite.scaleX <= _sprite.scaleY) {
					_sprite.scaleY = _sprite.scaleX;
				} else {
					_sprite.scaleX  = _sprite.scaleY; 
				}
				
				_sprite.x = xPos * _width  + ((_width - _sprite.width)*.5);
				_sprite.y = yPos * _height + ((_height - _sprite.height)*.5);
				
				// grid
				if (xPos >= xMax-1) {
					xPos = 0;
					yPos++;
				} else {
					xPos++;
				}
				
				// [mck] little hack... 
				_sprite.parent.x = 0; // [mck] reset container to zero
			}
		}*/
		
		override protected function onResizeHandler(e:Event):void 
		{
			//trace( "AppleSlide.onResizeHandler > e : " + e );
			var totalImg:int = imgArray.length;
			// resize imgContainers
			for (var i:int = 0; i < totalImg ; i++) 
			{
				var _sprite:Sprite = imgArray[i];
				// fullscreen mode
				if (isFullScreenMode) {
					_sprite.width 	= stage.stageWidth;
					_sprite.height 	= stage.stageHeight;
					if (_sprite.scaleX <= _sprite.scaleY) {
						_sprite.scaleY = _sprite.scaleX;
					} else {
						_sprite.scaleX  = _sprite.scaleY; 
					}
				} 
				// reposition x/y position sprite
				_sprite.x = (i * stage.stageWidth) + ((stage.stageWidth - _sprite.width) / 2);
				_sprite.y = (stage.stageHeight - _sprite.height) / 2;
			}
		}
		
		
	} // end class

} // end package