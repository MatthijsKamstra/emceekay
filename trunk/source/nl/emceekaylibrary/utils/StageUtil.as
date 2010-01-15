package nl.emceekaylibrary.utils 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class StageUtil 
	{
		
		public function StageUtil() 
		{
			
		}

		
		/**
		 * Parameterized Stage initialization.
		 * @param framerate movie framerate
		 * @param align stage alignment
		 * @param scale stage scaleMode.
		 * @param quality movie quality
		 * @param focusRect add object border focus
		 */
		static public function init(target:DisplayObject, customContext:Boolean = true , framerate : int = 31, align : String = "TL", scale : String = "noScale", quality : String = "HIGH", focusRect : Boolean = false) : void 
		{
			// Canvas.stage.frameRate = framerate;
			target.stage.align = align;
			target.stage.scaleMode = scale;
			target.stage.quality = quality;
			target.stage.stageFocusRect = focusRect;
			
			if (customContext)
			{
				// contextmenu
				var mck:ContextMenuItem = new ContextMenuItem("Made by [mck]");
				var _menu:ContextMenu = new ContextMenu();
				_menu.hideBuiltInItems();
				_menu.customItems = [mck];
				(target as InteractiveObject).contextMenu = _menu;
				
			}
			
		}
		
	}
	
}