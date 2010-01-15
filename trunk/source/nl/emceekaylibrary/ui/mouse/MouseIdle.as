package nl.emceekaylibrary.ui.mouse
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * 
	 * @example					
			var _MouseIdle:MouseIdle = new MouseIdle (this.stage, 2000);
			_MouseIdle.addEventListener(MouseIdle.MOUSE_IDLE	, onEventHandler);
			_MouseIdle.addEventListener(MouseIdle.MOUSE_ACTIVE	, onEventHandler);
			_MouseIdle.start();
			
			private function onEventHandler(e:Event):void {	trace( "MouseIdleMain.onEventHandler > e : " + e ); }
	 * 
	 * 
	 * A small utility class that allows you to see if a user has been inactive with the mouse.  
	 * The class will dispatch a MouseIdleEvent
	 * 
	 * 
	 * @author Matthijs Kamstra aka [mck]
	 * @author Matt Przybylski [http://www.reintroducing.com]
	 * @version 1.0
	 */
	public class MouseIdle extends EventDispatcher
	{

		private var _stage:Stage;
		private var _inactiveTime:int;
		private var _timer:Timer;
		private var _idleTime:int;
		private var _isMouseActive:Boolean;
		
		public static const MOUSE_ACTIVE	:String = "mouse Active Event";	// Dispatched when the mouse becomes active, repeatedly on MOUSE_MOVE</li>
		public static const MOUSE_IDLE		:String = "mouse Idle Event";		// Dispatched when the mouse becomes inactive, params object holds idle time ("time")</li>

		/**
		 * Creates an instance of hte MouseIdle class.
		 *
		 * <p>
		 * The class will dispatch two events:
		 * <ul>
		 * <li>MouseIdleEvent.MOUSE_ACTIVE: Dispatched when the mouse becomes active, repeatedly on MOUSE_MOVE</li>
		 * <li>MouseIdleEvent.MOUSE_IDLE: Dispatched when the mouse becomes inactive, params object holds idle time ("time")</li>
		 * </ul>
		 * </p>
		 *
		 * @param 	inStage 		The stage object to use for the mouse tracking
		 * @param 	inInactiveTime 	The time, in milliseconds, to check if the user is active or not (default: 1000)
		 *
		 * @return void
		 */
		public function MouseIdle(inStage:Stage, inInactiveTime:int = 1000):void
		{
			super();
			_stage = inStage;
			_inactiveTime = inInactiveTime;
			_timer = new Timer(_inactiveTime);
		}
		
		/**
		 * Starts the MouseIdle and allows it to check for mouse inactivity.
		 *
		 * @return void
		 */
		public function start():void
		{
			_stage.addEventListener(MouseEvent.MOUSE_MOVE	, onMouseMove);
			_timer.addEventListener(TimerEvent.TIMER		, onTimer);
			_timer.start();
		}
		
		/**
		 * Stops the MouseIdle from checking for mouse inactivity.
		 *
		 * @return void
		 */
		public function stop():void
		{
			_idleTime = 0;
			_timer.reset();
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
		}

		/**
		 * Reset the timer if the mouse moves, user is active.
		 */
		private function onMouseMove(e:MouseEvent):void
		{
			_isMouseActive = true;
			_idleTime = 0;
			_timer.reset();
			_timer.start();
			dispatchEvent(new Event(MouseIdle.MOUSE_ACTIVE,true));
		}
		/**
		 * Runs if the user is inactive, sets the idle time.
		 */
		private function onTimer(e:TimerEvent):void
		{
			_isMouseActive = false;
			_idleTime += _inactiveTime;
			dispatchEvent(new Event (MouseIdle.MOUSE_IDLE,true));
		}

		/**
		 * Returns a boolean value that specifies if the mouse is active or not.
		 *
		 * @return Boolean
		 */
		public function get isMouseActive():Boolean
		{
			return _isMouseActive;
		}
		/**
		 * Returns an integer representing the amount of time the user's mouse has been inactive, in milliseconds
		 *
		 * @return int
		 */
		public function get idleTime():int
		{
			return _idleTime;
		}
/*
		override public function toString():String
		{
			return getQualifiedClassName(this);
		}
*/
	} // end class

} // end package