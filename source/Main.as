package  
{
	import nl.emceekaylibrary.core.NoiseMain;
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class Main extends NoiseMain
	{
		
		public function Main() 
		{
			trace( "Main.Main" );
			
			if (stage) { 
				initialize();
			} else { 
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			}
		}
		
		
		//////////////////////////////////////// listeners ////////////////////////////////////////
		
		
		private function initialize(e:Event = null):void 
		{
			trace ('--------------------------------------------------------------------------------------');
			for (var i:uint = 0; i < this.numChildren; i++){
				trace ('var _' + this.getChildAt(i).name + ':' + this.getChildAt(i).toString().split("[object ").join("").split("]").join("") + " = " + this.getChildAt(i).name + ';');
			}
			trace ('--------------------------------------------------------------------------------------');
		}
		
	} // end class
	
} // end package