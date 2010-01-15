// from the qi framework
/**

show
hide
onShowFinished
onHideFinished


nl.emceekaylibrary.core.LocalController

*/
package nl.emceekaylibrary.core 
{
	import flash.display.Sprite;
	import nl.emceekaylibrary.events.LocalControllerEvent;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.*;	

	public class LocalController extends MovieClip
	{
		private var _labelsNeeded		:Object;
		public static var globalStage	:Stage;
		private static var _isDebugMode	:Boolean = false;
		
		// auto stuff
		private var _isAutoRemove		:Boolean = false;
		private var _isAutoHide			:Boolean = false;
		private var _isAutoBlock		:Boolean = false;
		
		private var block				:Sprite;
		
        /**
         * @private (internal)
         * Indicates whether the current execution stack is within a call later phase.
         *
         * @default false
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public static var inCallLaterPhase:Boolean=false;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var callLaterMethods:Dictionary;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _enabled:Boolean=true;

        /**
         * Creates a new UIComponent component instance.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function LocalController() {
			stop();
			
			super();
			
			if (!globalStage && stage) {
				globalStage = stage;
			}
			
			callLaterMethods = new Dictionary();
			callLater(this.addDestructor);
			
			_labelsNeeded =
			{
				  show: false
				, hide: false
				, onShowFinished: false
				, onHideFinished: false
			};
			initFrameScripts();
			
			blocker ();
		}
		
		private function initFrameScripts():void
		{
			var labels:Array = this.currentLabels;
			
			for (var i:uint = 0; i < labels.length; i++)
			{
				var label:FrameLabel = labels[i];
				
				switch(label.name)
				{
					case "show":
						//trace ("## show");
						this.addFrameScript(label.frame - 1, t_show);
						_labelsNeeded.show = true;
					break;
					case "hide":
						//trace( "## hide" );
						this.addFrameScript(label.frame - 1, t_hide);
						_labelsNeeded.hide = true;
					break;
					case "onShowFinished":
						//trace( "## onShowFinished" );
						this.addFrameScript(label.frame - 1, t_onShowFinished);
						_labelsNeeded.onShowFinished = true;
					break;
					case "onHideFinished":
						//trace( "## onHideFinished" );
						this.addFrameScript(label.frame - 1, t_onHideFinished);
						_labelsNeeded.onHideFinished = true;
					break;
				}
				
			}
			
			// let's check if all labels are present
			var errorString:String = "";
			for (var lb:String in _labelsNeeded)
			{
				if (!_labelsNeeded[lb]) errorString += "\t\tmissing label: " + lb + "\n";
			}
			if (errorString.length > 0) if (isDebugMode) trace( this + " --->\n" + errorString );
		}
	
		/**
		 * if the needed labels are in the movieclip, show will animate and dispatch an event
		 */
		public function show():void
		{
			if (isDebugMode) trace(":: " + getQualifiedClassName(this) + " :: show");
			
			if (isAutoBlock) {
				if (isDebugMode) block.alpha = 0.5;
				block.visible = true; 
			}
			
			gotoAndPlay("show");
		}
		
		public function hide():void
		{
			if (isDebugMode) trace(":: " + getQualifiedClassName(this) + " :: hide");
			
			if (isAutoBlock) {
				if (isDebugMode) block.alpha = 0.5;
				block.visible = true; 
			}
				
			gotoAndPlay("hide");
		}
		
		///////////////////////////////////////////////////////////////////////////////////////
		// added to frame
		
		public function t_show():void
		{
			var evt:LocalControllerEvent = new LocalControllerEvent(LocalControllerEvent.ON_SHOW, this);
			dispatchEvent(evt);
		}
		
		public function t_hide():void
		{
			var evt:LocalControllerEvent = new LocalControllerEvent(LocalControllerEvent.ON_HIDE, this);
			dispatchEvent(evt);
		}
		
		public function t_onShowFinished():void
		{
			if (isDebugMode) trace(":: "+getQualifiedClassName(this) + " :: onShowFinished");
			stop();
			onShowFinished();
		}
		
		public function t_onHideFinished():void
		{
			if (isDebugMode) trace(":: "+getQualifiedClassName(this) + " :: onHideFinished");
			stop();
			onHideFinished();
		}
		
		public function onShowFinished():void
		{
			if (isAutoBlock) { block.visible = false; }
			
			var evt:LocalControllerEvent = new LocalControllerEvent(LocalControllerEvent.ON_SHOW_FINISHED, this);
			dispatchEvent(evt);
		}
		
		public function onHideFinished():void
		{
			if (isAutoBlock) { block.visible = false; }
			
			var evt:LocalControllerEvent = new LocalControllerEvent(LocalControllerEvent.ON_HIDE_FINISHED, this);
			dispatchEvent(evt);
			
			if (isAutoRemove) this.parent.removeChild(this);
		}
		
		
		/////////////////////////////////////////////////////
		//
		// ready 
		//
		public function notifyMovieInialized():void
		{
			dispatchEvent(new LocalControllerEvent(LocalControllerEvent.ON_LOADED, this));
		}
		
		
        /**
         * calls the destructor
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private function _destroy(e : Event) : void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this._destroy);
			destroy();
		}

        /**
         * actual destructor
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function destroy() : void
		{
		}

        /**
         * Adds a destructor
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private function addDestructor() : void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, this._destroy);
		}

        [Inspectable(defaultValue=true, verbose=1)]
        /**
         * Gets or sets a value that indicates whether the component can accept user interaction.
         * A value of <code>true</code> indicates that the component can accept user interaction; a
         * value of <code>false</code> indicates that it cannot.
         *
         * <p>If you set the <code>enabled</code> property to <code>false</code>, the color of the
         * container is dimmed and user input is blocked (with the exception of the Label and ProgressBar components).</p>
         *
         * @default true
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        override public function get enabled():Boolean { return _enabled; }

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function set enabled(value:Boolean):void {
			if (value == _enabled) { return; }
			_enabled = value;
			//invalidate(InvalidationType.STATE);
		}

        [Inspectable(defaultValue=true, verbose=1)]
        /**
         * Gets or sets a value that indicates whether the current component instance is visible.
         * A value of <code>true</code> indicates that the current component is visible; a value of
         * <code>false</code> indicates that it is not.
         *
         * <p>When this property is set to <code>true</code>, the object dispatches a
         * <code>show</code> event. When this property is set to <code>false</code>,
         * the object dispatches a <code>hide</code> event. In either case,
         * the children of the object do not generate a <code>show</code> or
         * <code>hide</code> event unless the object specifically writes an
         * implementation to do so.</p>
         *
         * @default true
         *
         * @see #event:hide
         * @see #event:show
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function get visible():Boolean {
			return super.visible;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function set visible(value:Boolean):void {
			if (super.visible == value) { return; }
			super.visible = value;
			//var t:String = (value) ? ComponentEvent.SHOW : ComponentEvent.HIDE;
			//dispatchEvent(new ComponentEvent(t, true));
		}
		
		// change debug mode
		static public function get isDebugMode():Boolean { return _isDebugMode; }
		static public function set isDebugMode(value:Boolean):void { _isDebugMode = value; }
		
		// change autoRemove mode
		public function get isAutoRemove():Boolean { return _isAutoRemove; }
		public function set isAutoRemove(value:Boolean):void { _isAutoRemove = value; }
		
		// auto hide (WERKT NIET)
		public function get isAutoHide():Boolean { return _isAutoHide; }
		public function set isAutoHide(value:Boolean):void { _isAutoHide = value; }
		
		// auto block
		public function get isAutoBlock():Boolean { return _isAutoBlock; }
		public function set isAutoBlock(value:Boolean):void { _isAutoBlock = value; }
		
		
		// blocker
		private function blocker ():void
		{
			block = new Sprite();
			block.graphics.clear();
			block.graphics.beginFill(0xff3333, 1);
			block.graphics.drawRect(0, 0, this.width,this.height);
			block.graphics.endFill();
			block.visible = false;
			block.alpha = 0;
			this.addChild(block);
		}
		
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function callLater(fn:Function, ... args):void {
			if (inCallLaterPhase) { return; }
			
			callLaterMethods[fn] = args;
			if (stage != null) {
				stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
				stage.invalidate();
			} else {
				addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function callLaterDispatcher(event:Event):void {
			if (event.type == Event.ADDED_TO_STAGE) {
				removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
				// now we can listen for render event:
				stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
				stage.invalidate();
				
				return;
			} else {
				event.target.removeEventListener(Event.RENDER,callLaterDispatcher);
				if (stage == null) {
					// received render, but the stage is not available, so we will listen for addedToStage again:
					addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
					return;
				}
			}

			inCallLaterPhase = true;
			
			var methods:Dictionary = callLaterMethods;
			for (var method:Object in methods) {
				method.apply(method, methods[method]);
				delete(methods[method]);
			}
			inCallLaterPhase = false;
		}

		
		public override function toString () : String {
			return getQualifiedClassName(this);
		}
		
	}

}