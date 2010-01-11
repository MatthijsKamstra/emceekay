/**
* ...
* @author Default
* @version 0.1
*/

package nl.emceekaylibrary.events 
{
	import nl.emceekaylibrary.core.LocalController;
	import flash.events.Event;

	public class LocalControllerEvent extends Event
	{
		public static const ON_LOADED:String = "onLoaded";
		
		public static const ON_SHOW:String = "show";
		public static const ON_HIDE:String = "hide";
		public static const ON_SHOW_FINISHED:String = "onShowFinished";
		public static const ON_HIDE_FINISHED:String = "onHideFinished";

		public static const ON_DISABLED:String = "onDisabled";
		public static const ON_ENABLED:String = "onEnabled";

		
		private var _target:LocalController;
		
		public function LocalControllerEvent(type:String, target:LocalController, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			_target = target;
		}
		
		// clone functie 
		
		
		
	}
	
}
