package nl.emceekay.sldshw.skin.apple 
{
	import flash.events.Event;
	import nl.emceekay.sldshw.BaseBuild;
	import nl.emceekay.sldshw.skin.apple.view.AppleMenu;
	import nl.emceekay.sldshw.skin.apple.view.AppleSlide;
	
	/**
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class BuildApple extends BaseBuild
	{
		
		private var _appleMenu:AppleMenu;
		
		public function BuildApple() 
		{
			trace( "+ BuildApple.BuildApple" );
			super();
		}
		
		override protected function initialize():void 
		{
			trace( "+ BuildApple.initialize" );
			
			// extra menu, on top of the default navigation
			_appleMenu = new AppleMenu();
			
			// create dirNavigation 	
			super.initialize();
			
			// slide container
			var _slide:AppleSlide = new AppleSlide();
			target.addChild(_slide);
			
			// appleMenu on top
			target.addChild(_appleMenu);			
		}
		
		
		override protected function onResizeHandler(e:Event):void 
		{
			_appleMenu.x = (target.stage.stageWidth - _appleMenu.width) / 2;
			_appleMenu.y = (target.stage.stageHeight - _appleMenu.height) - 20;
		}
		
		
	} // end class

} // end package