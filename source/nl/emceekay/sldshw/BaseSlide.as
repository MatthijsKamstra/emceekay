package nl.emceekay.sldshw
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getQualifiedClassName;
	import nl.emceekaylibrary.loader.AssetLoaderLite;
	import nl.emceekay.sldshw.data.enum.EventNames;
	import nl.emceekay.sldshw.data.enum.SlideshowID;

	/**
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class BaseSlide extends MovieClip
	{
		private var _xml					:XML;
		public var assetLoaderLite			:AssetLoaderLite;
		public var totalImg					:int;
		
		protected var imgArray				:Array = [];
		private var imgCounter				:int = 0;
		private var slideCounter			:int = 0;
		private var counter					:int = 0;
		
		private static var isDebugMode		:Boolean = BaseMain.isDebugMode;
		
		public function BaseSlide() 
		{
			trace( "BaseSlide.BaseSlide" );
			
			assetLoaderLite 	= AssetLoaderLite.getAssetLoaderLiteById(SlideshowID.ASSET_LOADER_ID);
			_xml 				= assetLoaderLite.getXml(SlideshowID.ASSET_XML_ID);
			
			// make sure that buttons beneath the slide show still work
			mouseEnabled 	= false;
			mouseChildren 	= false;
			
			if (stage) { 
				initialize(null);
			} else { 
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			}
		}
		
		protected function initialize(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			this.stage.addEventListener(Event.RESIZE				, _onResizeHandler);	
			this.stage.addEventListener(EventNames.NAV_RIGHT_EVENT	, dirNavHandler);
			this.stage.addEventListener(EventNames.NAV_LEFT_EVENT	, dirNavHandler);
			
			// cursors left and right on the keyboard for navigation
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN 		,onKeyDownHandler); 
			
			totalImg = _xml.item.length();
			
			// create container....
			for (var i:int = 0; i < totalImg; i++) 
			{
				//trace( "_xml.item[i].@url : " + _xml.item[i].@url );
				var imgContainer:Sprite = new Sprite();
				imgContainer.name = "imgContainer_" + i;
				imgContainer.x = i * this.stage.stageWidth; // [mck] not necessary, but nice for testing 
				this.addChild(imgContainer);
				imgArray.push(imgContainer);
			}
			
			// add files to loader
			for (i = 0; i < totalImg; i++) 
			{
				var url:String = _xml.item[i].@url;
				//trace( "url : " + url );
				assetLoaderLite.addFile(url, { id:"img" + i } );
			}
			
			//Add some event listeners
			//assetLoaderLite.addEventListener(ProgressEvent.PROGRESS, onLoadProgress, false, 0, true);
			assetLoaderLite.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			assetLoaderLite.start();			
			
			//qeueLoadingImg();
		}
		
		private function onLoadComplete(e:Event):void 
		{
			assetLoaderLite.removeEventListener(Event.COMPLETE, onLoadComplete);
			
			for (var i:int = 0; i < totalImg ; i++) 
			{
				var _bitmap:Bitmap = assetLoaderLite.getBitmap("img" + i);
				_bitmap.smoothing = true; // [mck] nicer images when fullscreen
				
				var _sprite:Sprite = Sprite(imgArray[i]);
				_sprite.addChild(_bitmap);
				
			}
			// position containers in correct place
			_onResizeHandler(null);
		}
		
		private function onLoadProgress(e:ProgressEvent):void 
		{
		}
		
		private function qeueLoadingImg(inCounter:int = 0):void
		{
			if (imgCounter == _xml.item.length())
				imgCounter = 0;
			else
				imgCounter ++;
			counter++;
		}
		
		protected function _onResizeHandler(e:Event):void 
		{
			// move imgContainers
			for (var i:int = 0; i < totalImg ; i++) 
			{
				var _sprite:Sprite = imgArray[i];
				_sprite.scaleX = 1;
				_sprite.scaleY = 1;
				// check if image is bigger then stage (width height)
				if (_sprite.width > stage.stageWidth || _sprite.height > stage.stageHeight) 
				{
					_sprite.width 	= stage.stageWidth;
					_sprite.height 	= stage.stageHeight;
					if (_sprite.scaleX <= _sprite.scaleY) {
						_sprite.scaleY = _sprite.scaleX;
					} else {
						_sprite.scaleX = _sprite.scaleY; 
					}
				} 
				_sprite.x = (i * stage.stageWidth) + ((stage.stageWidth - _sprite.width) / 2);
				_sprite.y = (stage.stageHeight - _sprite.height) / 2;
			}	
			
			// position baseslide on the correct position
			this.x = -slideCounter * this.stage.stageWidth;
			
			// do everthing else (resize)
			onResizeHandler (e);
		}
		
		// override
		protected function onResizeHandler(e:Event):void 
		{ 
			if (isDebugMode) trace( "BaseSlide.onResizeHandler > e : " + e );
		}
		
		
		private function dirNavHandler(e:Event):void 
		{
			var btnType:String = e.type;
			switch (btnType) {
				case EventNames.NAV_RIGHT_EVENT:
					if (slideCounter >= (totalImg - 1)) {
						slideCounter = 0;
					} else {
						slideCounter++;
					}
					break;
				case EventNames.NAV_LEFT_EVENT:
					if (slideCounter == 0) {
						slideCounter = (totalImg - 1);
					} else {
						slideCounter--;
					}
					break;
				default:
					trace("case '"+btnType+"':\r\ttrace ('--- "+btnType+"');\r\tbreak;" );
			}
			// move
			this.x = -slideCounter * this.stage.stageWidth;
		}
		
		/**
		 * listen to the keyboard input
		 * cursor left and right for previous-image and next-image
		 */
		private function onKeyDownHandler(e:KeyboardEvent):void 
		{
			var _keycode:int = e.keyCode;
			var LEFT:int 	= 37; // left cursor on keyboard
			var RIGHT:int 	= 39; // right cursor on keyboard
			if (_keycode == LEFT) {
				dispatchEvent (new Event(EventNames.NAV_LEFT_EVENT, true));
			} else {
				dispatchEvent (new Event(EventNames.NAV_RIGHT_EVENT, true));
			}
		}
		
		override public function toString():String 
		{
			return getQualifiedClassName(this);
		}
		
	} // end class

} // end package