/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 */ 

//package com.bumpslide.util {
package nl.emceekaylibrary.utils
{
	import flash.utils.describeType;

	/**
	 * Object Dumper (AS3)
	 * 
	 * This code was not written by David Knape, but he found it useful to keep around, 
	 * and it has been modified from it's original in various ways.
	 * 
	 * The original version can be found at http://qops.blogspot.com/2007/06/dump-as3.html
	 */ 
	public class Dump {

		
		/**
		 * get all objects on the timeline, and so you can use it in a class.
		 * @param	inDisplayObj		timeline
		 * 
		 * @example		import nl.noiselibrary.utils.Dump;
		 * 				Dump.output(this);
		 * 
		 * 				nl.noiselibrary.utils.Dump.output(this);
		 * 
		 */
		public static function output ( inDisplayObj:Object) :void
		{
			trace ('----[ ' + inDisplayObj.name +' ]----------------------------------------------------------------------------------');
			for (var i:uint = 0; i < inDisplayObj.numChildren; i++){
				trace ('var _' + inDisplayObj.getChildAt(i).name + ':' + inDisplayObj.getChildAt(i).toString().split("[object ").join("").split("]").join("") + " = this.getChildByName('" + inDisplayObj.getChildAt(i).name + "') as " +inDisplayObj.getChildAt(i).toString().split("[object ").join("").split("]").join("")+ ";");
			}
			trace ('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
			for (var ii:uint = 0; ii < inDisplayObj.numChildren; ii++){
				trace ('var _' + inDisplayObj.getChildAt(ii).name + ':' + inDisplayObj.getChildAt(ii).toString().split("[object ").join("").split("]").join("") + " = " + inDisplayObj.getChildAt(ii).name + ";" );
			}
			trace ('--------------------------------------------------------------------------------------');
		}
		
		// trace
		public static function Trace(o:Object):void {
			trace(object(o));
		}

		// return the result string
		public static function object(o:Object):String {
			str = "";
			dump(o);
			// remove the lastest \n
			str = str.slice(0, str.length - 1);
			return str;
		}
		
		private static var n:int = 0;
		private static var str:String;

		private static function dump(o:Object):void {
			if(n > 5) {
				str += "...recusion_limit..." + "\n"; 
				return;
			}
			n++;
			var type:String = describeType(o).@name;
			if(type == 'Array') {
				dumpArray(o);
			} else if (type == 'Object') {
				dumpObject(o);
			} else {
				appendStr(o);
			}
			n--;
		}

		private static function appendStr(s:Object):void {
			str += s + '\n';
		}

		private static function dumpArray(a:Object):void {
			var type:String;
			for (var i:String in a) {
				type = describeType(a[i]).@name;
				if (type == 'Array' || type == 'Object') {
					appendStr(getSpaces() + "[" + i + "]:");
					dump(a[i]);
				} else {
					appendStr(getSpaces() + "[" + i + "]:" + a[i]);
				}
			}
		}

		private static function dumpObject(o:Object):void {
			var type:String;
			for (var i:String in o) {
				type = describeType(o[i]).@name;
				if (type == 'Array' || type == 'Object') {
					appendStr(getSpaces() + i + ":");
					dump(o[i]);
				} else {
					appendStr(getSpaces() + i + ":" + o[i]);
				}
			}
		}

		private static function getSpaces():String {
			var s:String = "";
			for(var i:int = 1;i < n; i++) {
				s += "  ";
			}
			return s;
		}
	}
}