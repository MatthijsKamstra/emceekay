package nl.emceekay.sldshw.skin.apple 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import nl.emceekaylibrary.loader.AssetLoaderLite;
	import nl.emceekay.sldshw.BaseMain;
	
	/**
	 * // nl.emceekay.sldshw.skin.apple.MainApple
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class MainApple extends BaseMain
	{
		private var assetLoaderLite:AssetLoaderLite;
		
		
		public function MainApple() 
		{
			trace( "+ MainApple.MainApple" );
			
			//isDebugMode = true;
			
			xmlSource = "xml/slideshow_simple.xml";
			
			super();
		}
		
		
		override protected function onLoadComplete(e:Event):void 
		{
			//trace( "+ MainApple.onLoadComplete > e : " + e );
			new BuildApple();
		}
		
		
		override protected function onLoadProgress(e:ProgressEvent):void 
		{
			// trace( "MainApple.onLoadProgress :: " + (Math.round(e.bytesLoaded / e.bytesTotal ) * 100) + "%");
		}
		
		
		
	} // end class
	
} // end package