//package nl.slideshow
package nl.emceekay.sldshw
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import nl.emceekaylibrary.loader.AssetLoaderLite;
	import nl.emceekaylibrary.utils.AlignUtil;
	import nl.emceekaylibrary.utils.PixelUtil;
	import nl.emceekaylibrary.utils.StageUtil;
	import nl.emceekay.sldshw.data.enum.SlideshowID;
	/**
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class BaseMain extends MovieClip
	{
		
		public static var instance			:MovieClip;
		public static var LAYER_0			:MovieClip;
		public static var LAYER_1			:MovieClip;
		public static var LAYER_2			:MovieClip;
		public static var LAYER_3			:MovieClip;
		public static var LAYER_BOTTOM		:MovieClip;
		
		private static var _xmlSource		:String = "";
		
		private var assetLoaderLite			:AssetLoaderLite;
		
		private static var _isDebugMode		:Boolean = false;
		
		//
		public function BaseMain() 
		{
			//trace( "BaseMain.BaseMain" );
			
			// layers for position everything
			LAYER_0 			= new MovieClip();
			LAYER_1 			= new MovieClip();
			LAYER_2 			= new MovieClip();
			LAYER_3 			= new MovieClip();
			LAYER_BOTTOM 		= new MovieClip();
			
			LAYER_0.name 		= "layer0";
			LAYER_1.name 		= "layer1";
			LAYER_2.name 		= "layer2";
			LAYER_3.name 		= "layer3";
			LAYER_BOTTOM.name 	= "layerBottom";
			
			addChild(LAYER_BOTTOM);
			addChild(LAYER_3);
			addChild(LAYER_2);
			addChild(LAYER_1);
			addChild(LAYER_0);
			
			//////////////////////////////////////// for the glory of [mck] ///////////////////////////////////////////////  
			// right click menu
			StageUtil.init(this);
			// pixel logo
			var logo:Sprite = PixelUtil.mckIcon();
			LAYER_0.addChild (logo);
			new AlignUtil (logo, AlignUtil.BOTTOM_RIGHT, new Rectangle(0, 0, logo.width + 6, logo.height + 5), true);
			//////////////////////////////////////// for the glory of [mck] ///////////////////////////////////////////////  
			
			// instance
			BaseMain.instance = this;
			
			loadXML ();
		}
		
		private function loadXML ():void
		{
			if (xmlSource == "") {
				trace( "!! " + toString() + ".loadXML > xmlSource: " + xmlSource);
				trace ("!! use :: xmlSource = 'xml/foobar.xml';")
				return;
			}
			// load xml
			
			//Create a new AssetLoaderLite instance.  The ID passed will let you get this instance from anywhere.
			assetLoaderLite = new AssetLoaderLite(SlideshowID.ASSET_LOADER_ID);
			
			//Add some files
			assetLoaderLite.addFile(_xmlSource, {id:SlideshowID.ASSET_XML_ID});
			
			//Add some event listeners
			assetLoaderLite.addEventListener(ProgressEvent.PROGRESS	, _onLoadProgress, false, 0, true);
			assetLoaderLite.addEventListener(Event.COMPLETE			, _onLoadComplete, false, 0, true);

			//Start the loading
			assetLoaderLite.start();
		}
		
		
		//////////////////////////////////////// handlers ////////////////////////////////////////
		
		
		private function _onLoadProgress(e:ProgressEvent):void 
		{
			assetLoaderLite.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			onLoadProgress(e);
		}
		
		private function _onLoadComplete(e:Event):void 
		{
			assetLoaderLite.removeEventListener(Event.COMPLETE, _onLoadComplete);
			onLoadComplete(e);
		}
		
		// override these functions
		protected function onLoadComplete(e:Event):void 
		{
			if (isDebugMode) trace( "!! override :: BaseMain.onLoadComplete > e : " + e );
		}
		
		protected function onLoadProgress(e:ProgressEvent):void 
		{
			if (isDebugMode) trace( "!! override :: BaseMain.onLoadProgress :: " + (Math.round(e.bytesLoaded / e.bytesTotal ) * 100) + "%");
		}
		
		
		//////////////////////////////////////// override functions ////////////////////////////////////////
		
		
		override public function toString():String { return getQualifiedClassName(this); }
		
		
		//////////////////////////////////////// getters / setters ////////////////////////////////////////
		
		
		public function get xmlSource():String { return _xmlSource; }
		public function set xmlSource(value:String):void { _xmlSource = value; }
		
		static public function get isDebugMode():Boolean { return _isDebugMode; }
		static public function set isDebugMode(value:Boolean):void { _isDebugMode = value; }
		
		
		
	} // end class

} // end package