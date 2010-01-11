package nl.emceekaylibrary.events
{
	import flash.events.Event;
	
	/**
	 * @example 	
			package  
			{
				import flash.display.MovieClip;
				import flash.events.Event;
				import flash.events.MouseEvent;
				import nl.noiselibrary.events.DynamicEvent;
				
				public class MainDynamicEvent extends MovieClip
				{
					public function MainDynamicEvent() 
					{
						this.stage.addEventListener(MouseEvent.CLICK, onClickHandler);
						this.stage.addEventListener("onGameFinishEvent", onGameFinishHandler);
					}
					
					private function onClickHandler(e:MouseEvent):void 
					{
						dispatchEvent(new DynamicEvent("onGameFinishEvent", {name:"henk", age:3, winner:true, getrouwd:true} , true));
					}
					
					private function onGameFinishHandler(e:DynamicEvent):void 
					{
						var _obj:Object = e.dynamicObject;
						for( var i:String in _obj ) trace( "key : " + i + ", value : " + _obj[ i ] );
					}
				}
			}
	 * 
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class DynamicEvent extends Event 
	{
		public static const DYNAMIC_EVENT:String = "onDynamicEvent";
		public var dynamicObject:Object;
		
		public function DynamicEvent(type:String, inDynamicObject:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			dynamicObject = inDynamicObject;
		} 
		
		public override function clone():Event 
		{  
			return new DynamicEvent( type, dynamicObject, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DynamicEvent", "dynamicObject", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}