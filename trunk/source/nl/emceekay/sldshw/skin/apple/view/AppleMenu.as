package nl.emceekay.sldshw.skin.apple.view 
{
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import nl.emceekaylibrary.ui.mouse.MouseBlocker;
	import nl.emceekaylibrary.ui.mouse.MouseIdle;
	import nl.emceekaylibrary.utils.Dump;
	import nl.emceekay.sldshw.data.enum.EventNames;
	import nl.emceekay.sldshw.data.enum.NavNames;
	
	/**
	 * // nl.emceekay.sldshw.skin.apple.view.AppleMenu
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class AppleMenu extends MovieClip
	{
		private var _tIndexIcon:MovieClip;
		private var _tFullScreenBtn:MovieClip;
		private var _tNavNextBtn:MovieClip;
		private var _tNavPrevBtn:MovieClip;
		private var _tPlayBtn:MovieClip;
		private var _tCloseBtn:MovieClip;
		private var _tPauseBtn:MovieClip;
		private var _tAppleMenuBg:MovieClip;
		
		public function AppleMenu() 
		{
			trace( "+ AppleMenu.AppleMenu" );
			
			_tIndexIcon 		= this.getChildByName('tIndexIcon') as MovieClip;
			_tFullScreenBtn 	= this.getChildByName('tFullScreenBtn') as MovieClip;
			_tNavNextBtn 		= this.getChildByName('tNavNextBtn') as MovieClip;
			_tNavPrevBtn 		= this.getChildByName('tNavPrevBtn') as MovieClip;
			_tPlayBtn 			= this.getChildByName('tPlayBtn') as MovieClip;
			_tPauseBtn 			= this.getChildByName('tPauseBtn') as MovieClip;
			_tAppleMenuBg		= this.getChildByName('tAppleMenuBg') as MovieClip;
			//_tCloseBtn 			= this.getChildByName('tCloseBtn') as MovieClip;
			
			_tIndexIcon.addEventListener(MouseEvent.CLICK, onClickHandler);
			_tFullScreenBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			_tNavNextBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			_tNavPrevBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			_tPlayBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			_tPauseBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			_tAppleMenuBg.addEventListener(MouseEvent.MOUSE_DOWN	, onDragHandler);
			_tAppleMenuBg.addEventListener(MouseEvent.MOUSE_UP		, onDragHandler);
			//_tCloseBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			// some default settings
			_tPauseBtn.visible = false;
			_tFullScreenBtn.gotoAndStop(1);
			
			if (stage)
				initialize(null);
			else 
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			
		}
			
		private function initialize(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			// listeners
			this.stage.addEventListener(EventNames.NAV_IS_FULLSCREEN	, onEventHandler);
			this.stage.addEventListener(EventNames.NAV_IS_NORMALSCREEN	, onEventHandler);
			this.stage.addEventListener(EventNames.NAV_PLAY_EVENT		, onEventHandler);
			this.stage.addEventListener(EventNames.NAV_PAUZE_EVENT		, onEventHandler);
			
			// mouse idle
			var _mouseIdle:MouseIdle = new MouseIdle(this.stage			, 3000);
			_mouseIdle.addEventListener(MouseIdle.MOUSE_IDLE			, onEventHandler);
			_mouseIdle.addEventListener(MouseIdle.MOUSE_ACTIVE			, onEventHandler);
			_mouseIdle.start();
		}
		
		private function onDragHandler(e:MouseEvent):void 
		{
			var _type:String = e.type;
			switch (_type) {
				case MouseEvent.MOUSE_DOWN:
					this.startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					this.stopDrag();
					break;
				default:
					trace("case '"+_type+"':\r\ttrace ('---> "+_type+"');\r\tbreak;" );
			}
		}	
		
		


		private function goFullScreen():void
		{
			trace( "AppleMenu.goFullScreen" );
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			} else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		
		private function onEventHandler(e:Event):void 
		{
			var _name:String = e.type;
			switch (_name) {
				case EventNames.NAV_PAUZE_EVENT:
					_tPlayBtn.visible 	= true;
					_tPauseBtn.visible 	= false;
					break;
				case EventNames.NAV_PLAY_EVENT:
					_tPlayBtn.visible 	= false;
					_tPauseBtn.visible 	= true;
					break;
				case EventNames.NAV_IS_FULLSCREEN:
					_tFullScreenBtn.gotoAndStop("isFullScreen");
					goFullScreen();
					break;
				case EventNames.NAV_IS_NORMALSCREEN:
					_tFullScreenBtn.gotoAndStop("isNormalScreen");
					goFullScreen();
					break;
				case MouseIdle.MOUSE_IDLE:
					TweenLite.to (this, .5, { alpha:0 } );
					break;
				case MouseIdle.MOUSE_ACTIVE:
					TweenLite.to (this, .5, { alpha:1 } );
					break;					
				default:
					trace("case '"+_name+"':\r\ttrace ('---> "+_name+"');\r\tbreak;" );
			}
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			var _name:String = e.target.name;
			switch (_name) {
				case 'tNavPrevBtn':
					dispatchEvent (new Event(EventNames.NAV_LEFT_EVENT, true));
					break;
				case 'tPlayBtn':
					dispatchEvent (new Event(EventNames.NAV_PLAY_EVENT, true));
					break;
				case 'tPauseBtn':
					dispatchEvent (new Event(EventNames.NAV_PAUZE_EVENT, true));
					break;
				case 'tNavNextBtn':
					dispatchEvent (new Event(EventNames.NAV_RIGHT_EVENT, true));
					break;
				case 'tIndexIcon':
					dispatchEvent (new Event(EventNames.NAV_INDEX_EVENT, true));
					break;
				case 'tFullScreenBtn':
					dispatchEvent (new Event(EventNames.NAV_FULL_EVENT, true));
					break;
				case 'tCloseBtn':
					dispatchEvent (new Event(EventNames.NAV_CLOSE_EVENT, true));
					break;
				default:
				trace("case '"+_name+"':\r\ttrace ('---> "+_name+"');\r\tbreak;" );
			}
		}
		
		
	} // end class
	
} // end package