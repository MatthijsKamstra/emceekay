package nl.emceekay.twttr.view 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import nl.noiselibrary.core.LocalController;
	import nl.noiselibrary.events.DynamicEvent;
	import nl.noiselibrary.utils.Dump;
	
	/**
	 * // nl.emceekay.twttr.view.Balloon
	 * ...
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class Balloon extends LocalController
	{
		private var _tBalloon:MovieClip;
		private var _tContentTxt:TextField;
		private var _tRightBtn:MovieClip;
		private var _tLeftBtn:MovieClip;
		
		private var id:int = 0;
		
		public function Balloon() 
		{
			//trace( "Balloon.Balloon" );
			
			//Dump.output(this);
			
			_tRightBtn 		= this.getChildByName('tRightBtn') as MovieClip;
			_tLeftBtn 		= this.getChildByName('tLeftBtn') as MovieClip;
			
			_tBalloon 		= this.getChildByName('tBalloon') as MovieClip;
			_tContentTxt 	= this.getChildByName('tContentTxt') as TextField;
			
			_tContentTxt.autoSize = TextFieldAutoSize.LEFT;
			
			
			_tRightBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			_tLeftBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			//trace( "Balloon.onClickHandler > e : " + e );
			
			var slide:int = id;
			
			var _name:String = e.target.name;
			switch (_name) {
				case 'tRightBtn':
					slide = id + 1;
					break;		
				case 'tLeftBtn':
					slide = id - 1;
					break;
				default:
					trace("case '"+_name+"':\r\ttrace ('---> "+_name+"');\r\tbreak;" );
			}
			
			//dispatchEvent (new Event("tweet", true));
			dispatchEvent ( new DynamicEvent("tweet", { id:slide },true )) ;
			
		}
		
		
		public function setStyleSheet (inSheet:StyleSheet):void
		{
			_tContentTxt.styleSheet = inSheet;
		}
		
		
		public function setTxt (inString:String):void
		{
			_tContentTxt.htmlText = inString;
			resizeBalloon ();
		}
		
		public function setID(inID:int):void
		{
			id = inID;
			if (id == 0) {
				_tLeftBtn.visible = false;
			}
		}
		
		private function resizeBalloon ():void
		{
			_tBalloon.height = _tContentTxt.height + (_tContentTxt.y * 2) + 20;
		}
		
		
	} // end class

}