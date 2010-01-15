package nl.emceekay.sldshw
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import nl.emceekay.sldshw.data.enum.NavNames;


	/**
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class BaseBuild extends MovieClip
	{
		private var rightNav				:MovieClip;
		public var leftNav					:MovieClip;
		protected var target				:MovieClip;
		
		private static var isDebugMode		:Boolean = BaseMain.isDebugMode;
		
		public function BaseBuild() 
		{
			trace( toString() + ".BaseBuild" );
			
			target = BaseMain.LAYER_BOTTOM;
			
			target.stage.addEventListener(Event.RESIZE, _onResizeHandler);
			
			initialize();
		}
		
		protected function initialize():void 
		{
			trace( toString() + ".initialize" );
			
			// basic navigation
			rightNav 	= new BaseDirNav();
			leftNav		= new BaseDirNav();
			
			rightNav.name 	= NavNames.NAV_RIGHT;
			leftNav.name 	= NavNames.NAV_LEFT;
			
			leftNav.x	= 0;
			rightNav.x 	= target.stage.stageWidth - rightNav.width;
			
			target.addChild(rightNav);
			target.addChild(leftNav);			
			
			_onResizeHandler(null);
		}
		
		
		private function _onResizeHandler(e:Event):void 
		{
			leftNav.x = 0;
			rightNav.x = target.stage.stageWidth - rightNav.width;
			onResizeHandler(e);
		}
		
		protected function onResizeHandler(e:Event):void 
		{
			if (isDebugMode) trace( "!! override >> BaseBuild.onResizeHandler > e : " + e );
			//trace( "!! override >> " + toString() + ".onResizeHandler > e : " + e );
		}
		
		override public function toString():String 
		{
			return getQualifiedClassName(this);
		}
		
	} // end class

} // end package