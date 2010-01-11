/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the GPL License:
* http://www.opensource.org/licenses/gpl-2.0.php 
*****************************************************************************************************/

//Main initializes the framework.  

package nl.emceekaylibrary.core
{
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	import net.hires.debug.Stats;
	import nl.noiselibrary.utils.AlignUtil;
	import nl.noiselibrary.utils.CacheBuster;
	import nl.noiselibrary.utils.StageReference;

	public class NoiseMain extends MovieClip
	{
		public var __WIDTH:int = 0;
		public var __HEIGHT:int = 0;
		
		public static var IS_BROWSER	:Boolean;
		public static var IS_ONLINE		:Boolean;
		public static var IS_DEBUG		:Boolean;
		
		protected static var _instance:NoiseMain;
		
		public function NoiseMain()
		{
			// trace( "NoiseMain.NoiseMain" );
			super();
			_instance = this;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public static function get instance():NoiseMain
		{
			return _instance;
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			StageReference.setStage(this.stage);
			if (stage.stageWidth == 0 || stage.stageHeight == 0)
			{
				addEventListener(Event.ENTER_FRAME, onWaitForWidthAndHeight);
			} else {
				_init();
			}
		}
		
		private function onWaitForWidthAndHeight(event:Event):void
		{
			if (stage.stageWidth > 0 && stage.stageHeight > 0)
			{
				removeEventListener(Event.ENTER_FRAME, onWaitForWidthAndHeight);
				_init();
			}
		}
		
		private function _init():void
		{
			//trace( "+ NoiseMain._init" );
			
			if (!__WIDTH) __WIDTH = stage.stageWidth;
			if (!__HEIGHT) __HEIGHT = stage.stageHeight;
			
			CacheBuster.isOnline 	= (stage.loaderInfo.url.indexOf("http") == 0);
			IS_ONLINE 				= (stage.loaderInfo.url.indexOf("http") == 0);
			IS_BROWSER 				= (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn");
			IS_DEBUG 				= (Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External");
			
			// for( var i:String in stage.loaderInfo ) trace( "key : " + i + ", value : " + stage.loaderInfo[ i ] );
			// stage.loaderInfo.parameters.siteXML
			// for( var i:String in stage.loaderInfo.parameters ) trace( "key : " + i + ", value : " + stage.loaderInfo.parameters[ i ] );
			
			if (this.parent is Stage)
			{
				// TODO: [mck] fix this, but I don't know what is going wrong...
				//trace( ":: (this.parent is Stage) : " + (this.parent is Stage) );
				var menu:NoiseContextMenu = new NoiseContextMenu(this);
			}
			
			if (IS_DEBUG || getBoolean ('debug')) {
				var stats:Stats = new Stats() ;
				stats.name = 'Stats';
				addChild (stats);
				//stats.x = stage.stageWidth - stats.width; // move to the right
				new AlignUtil(stats, AlignUtil.TOP_RIGHT, null, true);
			}
			
			config();
			init();
			
		}
		
		public function config():void
		{
			// stage.quality = StageQuality.BEST; // [mck] EVIL EVIL FOR framerate!!!!
			stage.scaleMode = "noScale";
            stage.align = "TL";
		}
		
		protected function init():void 
		{
			trace( "!! OVERRIDE !! :: NoiseMain.init :: override protected function init():void {}" );
		}
		
		/**
		 * parse boolean flashvar
		 */
		protected function getBoolean(param:String) : Boolean 
		{
			return stage.loaderInfo.parameters[param] == 'true' || stage.loaderInfo.parameters[param] == '1';
		}
		
		/** 
		 * get the flashVar defined in html
		 * 
		 * @example		var _xmlPath:String = getFlashVar("xml");
		 *				trace( "_xmlPath : " + _xmlPath );
		 * @param	inParam		var name 
		 * @return				value defined or null (no value defined)
		 */
		protected function getFlashVar(inParam:String) : String
		{
			return stage.loaderInfo.parameters[inParam];
		}
		
		
		
		override public function toString():String 
		{
			return getQualifiedClassName(this);
		}
		
	} // end class

} // end package