package nl.emceekay.sldshw
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import nl.emceekay.sldshw.data.enum.EventNames;
	import nl.emceekay.sldshw.data.enum.NavNames;
	/**
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class BaseDirNav extends MovieClip
	{
		private var _tHitArea				:Sprite;
		private var HIT_AREA_ALPHA			:Number = 0.0;
		
		private static var isDebugMode		:Boolean = BaseMain.isDebugMode;
		
		public function BaseDirNav() 
		{
			//trace(toString() + ".BaseDirNav" );
			
			var container:Sprite = new Sprite();
			addChild(container);
			
			var _shape:Shape = new Shape();
            _shape.graphics.beginFill(0xFFCC00);
            _shape.graphics.drawRect(0, 0, 50, 50);
            _shape.graphics.endFill();
            container.addChild(_shape);
			
			_tHitArea = container;
			
			_tHitArea.alpha 	= isDebugMode ? 0.3 : HIT_AREA_ALPHA; // [mck] see where the left/right nav is
			
			this.buttonMode 	= true;
			
			_tHitArea.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			if (stage) { 
				initialize();
			} else { 
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			}
		}
		
		private function initialize(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			this.stage.addEventListener(Event.RESIZE, onResizeHandler);
			
			onResizeHandler();
		}		
		
		
		//////////////////////////////////////// Handlers ////////////////////////////////////////
		

		private function onClickHandler(e:MouseEvent):void 
		{
			var btnName:String = e.currentTarget.parent.name;
				
			switch (btnName) {
				case NavNames.NAV_RIGHT:
					dispatchEvent (new Event(EventNames.NAV_RIGHT_EVENT, true));
					break;
				case NavNames.NAV_LEFT:
					dispatchEvent (new Event(EventNames.NAV_LEFT_EVENT, true));
					break;
				default:
					trace("case '"+btnName+"':\r\ttrace ('--- "+btnName+"');\r\tbreak;" );
			}
		}
		
		private function onResizeHandler(e:Event = null):void 
		{
			_tHitArea.width 	= this.stage.stageWidth / 3;
			_tHitArea.height 	= this.stage.stageHeight;
		}
		
		override public function toString():String 
		{
			return getQualifiedClassName(this);
		}
		
	} // end class

} // end package