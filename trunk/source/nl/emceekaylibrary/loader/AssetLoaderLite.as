// [mck] heel bruut gewoon gepikt

/**  
 * AssetLoaderLite: small and smart preloader for AS3
 *   
 * @author Michael Randolph
 */
 
/**
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 Michael Randolph
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * http://www.opensource.org/licenses/mit-license.php
 *    
 */
 
 /**
 * Quick Info
 * ----------
 * 
 * AssetLoaderLite Goal: Create a single-class loader with a small (preferably less than 4k) footprint
 * Supported Types: .jpg, .jpeg, .gif, .png, .swf, .xml, .mp3, .f4a, .f4b, .txt, .css, server script responses, any generic binary data
 * 
 * Props Object
 * ------------
 * PUBLIC
 * id: id for this file, if it's not provided, one will be generated
 * type: override for type.  Normally this is determined, but you're allowed to pass an override.
 * context: assign a new LoaderContext or SoundLoaderContext
 * 
 * PRIVATE
 * _started: set to true when the load has started
 * _loaded: set to true when the load has completed
 * _loader: a pointer to the loader object
 * _bytesLoaded: the number of loaded bytes
 * _bytesTotal: the total number of bytes
 */
package nl.emceekaylibrary.loader
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	/**
	 *  Dispatched while files are downloading
	 *
	 *  @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	/**
	 *  Dispatched when files are finished downloading
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	*   Manages content loading in AS3
	*   
	*   @example Basic usage:
	<listing version="3.0">
	package  
	{
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.events.ProgressEvent;
		import nl.emceekaylibrary.loader.AssetLoaderLite;

		public class MainSimple extends MovieClip
		{
			
			private const ASSET_LOADER_ID	:String = "default_AssetLoaderLite";
			private const ASSET_XML_ID		:String = "default_XML_ID";
			
			private var _assetLoaderLite:AssetLoaderLite;
			
			public function MainSimple() 
			{
				trace( "MainSimple.MainSimple" );

				// load xml
				
				//Create a new AssetLoaderLite instance.  The ID passed will let you get this instance from anywhere.
				_assetLoaderLite = new AssetLoaderLite(ASSET_LOADER_ID);

				//Add some files
				_assetLoaderLite.addFile("xml/slideshow_simple.xml", {id:ASSET_XML_ID});
				var jpgID:String = _assetLoaderLite.addFile("images/test1.jpg");
				_assetLoaderLite.addFile("images/test2.jpg", {id:"test2"});
				_assetLoaderLite.addFile("images/test3.jpg", {type:AssetLoaderLite.TYPE_BINARY});
				_assetLoaderLite.addFile("images/test4.jpg", {id:"test4", type:AssetLoaderLite.TYPE_BINARY});
				_assetLoaderLite.addFile("xml/test.xml", {id:"helloXml"});
				_assetLoaderLite.addFile("fontswf/calibri_font.swf", {id:"font", context:new LoaderContext(false, ApplicationDomain.currentDomain)});
				_assetLoaderLite.addFile("mp3/test.mp3", {id:"testSound"});
				_assetLoaderLite.addFile("swf/FP7.swf", {id:"oldswf", type:AssetLoaderLite.TYPE_AVM1MOVIE});
				_assetLoaderLite.addFile("txt/test.txt", {id:"txt"});
				_assetLoaderLite.addFile("css/test.css", {id:"css"});

				//Add some event listeners
				_assetLoaderLite.addEventListener(ProgressEvent.PROGRESS, onLoadProgress, false, 0, true);
				_assetLoaderLite.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);

				//Start the loading
				_assetLoaderLite.start();
			}
			
			private function onLoadProgress(e:ProgressEvent):void 
			{
				trace( "MainSimple.onLoadProgress :: " + (Math.round(e.bytesLoaded / e.bytesTotal ) * 100) + "%");
			}
		
			private function onLoadComplete(e:Event):void 
			{
				_assetLoaderLite.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				_assetLoaderLite.removeEventListener(Event.COMPLETE, onLoadComplete);
				
				var _xml:XML 		= _assetLoaderLite.getXml(ASSET_XML_ID);
				var _xml2:XML 		= _assetLoaderLite.getXml("helloXml");
				var _jpg:Bitmap 	= _assetLoaderLite.getXml(jpgID);
				var _jpg:Bitmap 	= _assetLoaderLite.getBitmap("test2");
		
				var _txt			=  _assetLoaderLite.getAssetLoaderLiteById("testAssetLoaderLite").getTxt("txt");
				
				trace( "_xml : " + _xml );
			}
		}
	}
	</listing>
	* 
	*   @langversion ActionScript 3.0
	*   @playerversion 9.0.124
	* 
	*   @author Michael Randolph
	*   @since 2009
	*/
	public class AssetLoaderLite extends EventDispatcher {
		/** Tells AssetLoaderLite to use a <code>Loader</code> for loading*/
		public static const TYPE_BITMAP:String = "TYPE_BITMAP";
		/** Tells AssetLoaderLite to use a <code>Loader</code> for loading*/
		public static const TYPE_SWF:String = "TYPE_SWF";
		/** Tells AssetLoaderLite to use a <code>Loader</code> for loading*/
		public static const TYPE_AVM1MOVIE:String = "TYPE_AVM1MOVIE";
		/** Tells AssetLoaderLite to use a <code>URLLoader</code> for loading*/
		public static const TYPE_XML:String = "TYPE_XML";
		/** Tells AssetLoaderLite to use a <code>URLLoader</code> for loading*/
		public static const TYPE_TEXT:String = "TYPE_TEXT";
		/** Tells AssetLoaderLite to use a <code>URLLoader</code> for loading*/
		public static const TYPE_CSS:String = "TYPE_CSS";
		/** Tells AssetLoaderLite to use a <code>URLLoader</code> for loading*/
		public static const TYPE_BINARY:String = "TYPE_BINARY";
		/** Tells AssetLoaderLite to use a <code>Sound</code> for loading*/
		public static const TYPE_SOUND:String = "TYPE_SOUND";
		
		/** Hash that AssetLoaderLite.getAssetLoaderLiteById accesses to get the correct AssetLoaderLite*/
		private static var _hashIdToAssetLoaderLite:Dictionary = new Dictionary(true);
		
		/** Hash that maps extensions to their internal types*/
		private var _hashExtToType:Dictionary = registerExtensions([{type:TYPE_BITMAP, extensions:[".jpg", ".jpeg", ".gif", ".png"]}, {type:TYPE_SWF, extensions:[".swf"]}, {type:TYPE_BINARY, extensions:[".*"]},{type:TYPE_XML, extensions:[".xml"]}, {type:TYPE_SOUND, extensions:[".mp3, .f4a, .f4b"]}, {type:TYPE_TEXT, extensions:[".txt"]}, {type:TYPE_CSS, extensions:[".css"]}]);
		/** Hash that maps each file's ID to it's respective loader*/
		private var _hashIdToLoader:Dictionary = new Dictionary(true);
		/** Hash that maps each file's loader to it's respective properties object*/
		private var _hashLoaderToProps:Dictionary = new Dictionary(true);
		/** Hash that maps each <code>Loader</code>'s <code>LoaderInfo</code> to it's respective <code>Loader</code>*/
		private var _hashLoaderInfoToLoader:Dictionary = new Dictionary(true);
		/** Number that stores the current percentage for the ProgressEvent*/
		private var _nCalculatedPercent:Number = 0;
		/** Integer that stores the current number of files in this AssetLoaderLite*/
		private var _nTotalLoaders:int = 0;
		/** Integer that stores the current number of files loaded during loading*/
		private var _nTotalLoadersLoaded:int = 0;
		/** Boolean that stores whether we're using HTTP HEAD requests or not*/
		private var _bUseHeadRequests:Boolean;
		
		/**
		 *  Creates a new AssetLoaderLite instance.  To use HTTP HEAD requests, these requirements must be met:
		 * 
		 *  @param id  A name that can be used to get this AssetLoaderLite later using AssetLoaderLite.getAssetLoaderLiteById
		 *  @param useHeadRequests  Specifies whether HTTP HEAD requests get used or not.
		 * 
		 *  1. useHeadRequests must be set to true.
		 *  2. The SWF must be on a web server (<code>Security.sandboxType == Security.REMOTE</code>).
		 *  3. The SWF must be running in a browser (<code>Capabilities.playerType == "ActiveX" || Capabilities.playerType == "Plugin"</code>).
		 *  4. ExternalInterface must be available.
		 *  5. AssetLoaderLite.js must be available.
		 * 
		 *  If useHeadRequests is set to true and any of the other requirements fail, useHeadRequests will be set to false.		 
		 * */ 
		public function AssetLoaderLite(id:String, useHeadRequests:Boolean = true) {
			_hashIdToAssetLoaderLite[id] = this;
			(_bUseHeadRequests = (!useHeadRequests ? false : (Security.sandboxType != Security.REMOTE ? false : (!(Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn") ? false : (!ExternalInterface.available ? false : (!ExternalInterface.call("AssetLoaderLite.available") ? false : true)))))) ? initCallbacks() : void;
		}
		
		/**
		 *  Gets a AssetLoaderLite instance from anywhere.
		 *  
		 *  @param id  The ID of the AssetLoaderLite you previously created.
		 */
		public static function getAssetLoaderLiteById(id:String):AssetLoaderLite {
			return AssetLoaderLite(_hashIdToAssetLoaderLite[id]);
		}
		
		/**
		 *  Adds a file to the list of files to be loader.
		 *  @param url  	url to the file you want to download
		 *  @param props  	properties object (look down)
		 *  					id - the id of this file, default is autogenerated.
		 *  					type - the type of this file, default is determined from file extension.
		 *  					context - the <code>LoaderContext</code> or <code>SoundLoaderContext</code> for this file.
		 */
		public function addFile(url:*, props:Object = null):String {
			var error:Error = (props = buildPropsObject(url, props)).context ? (((props.context is LoaderContext && props.type != TYPE_SOUND) || (props.context is SoundLoaderContext && props.type == TYPE_SOUND)) ? (isUniqueId(props.id) ? null : new ArgumentError("id in props object is not unique.")) : new ArgumentError("context in props object must be a LoaderContext (for graphics) or SoundLoaderContext (for sound)")) : new Error("this should never appear");
			
			if (!error) {
				_nTotalLoaders++;
				
				switch (props.type) {
					case TYPE_BITMAP:
					case TYPE_SWF:
					case TYPE_AVM1MOVIE:
						props._loader = new Loader();
						_hashLoaderInfoToLoader[props._loader.contentLoaderInfo] = props._loader;
						break;
					case TYPE_XML:
					case TYPE_TEXT:
					case TYPE_CSS:
						props._loader = new URLLoader();
						break;
					case TYPE_BINARY:
						props._loader = new URLLoader();
						props._loader.dataFormat = URLLoaderDataFormat.BINARY;
						break;
					case TYPE_SOUND:
						props._loader = new Sound();
						break;
				}
				
				_hashIdToLoader[props.id] = props._loader;
				_hashLoaderToProps[props._loader] = props;
				
				return props.id;
			} 
			else {
				throw error;
				return null;
			}
		}
		
		/** Starts the loading process */
		public function start():void 
		{
			for (var loader:* in _hashLoaderToProps)
				if (_bUseHeadRequests)
					getTotalSizeFromHeadRequest(_hashLoaderToProps[loader]);
				else
					startLoader(loader);
		}
		
		/**
		 * Deletes an asset with the specified id'
		 * 
		 * @param id  The id of the asset you'd like to delete
		 */
		public function deleteAssetById(id:String):void {
			var loader:* = _hashIdToLoader[id];
			
			delete _hashIdToLoader[id];
			loader is Loader ? delete _hashLoaderInfoToLoader[loader.contentLoaderInfo] : void;
			delete _hashLoaderToProps[loader];
			
			loader = null;
		}
		
		/** 
		 * Deletes everything in this AssetLoaderLite
		 */
		public function dispose():void {
			for (var loader:* in _hashLoaderToProps)
				deleteAssetById(_hashLoaderToProps[loader].id);
			
			for (var ext:* in _hashExtToType)
				delete _hashExtToType[ext];
		}
		
		/** 
		 * Returns an asset without any type checking
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like
		 */
		public function getUntyped(id:String):* {
			return getAssetById(id);
		}
		
		/** 
		 * Returns an asset casted as XML
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as XML
		 */
		public function getXml(id:String):XML {
			return getAssetById(id, XML) as XML;
		}
		
		/** 
		 * Returns an asset casted as a String
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as a String
		 */
		public function getText(id:String):String {
			return getAssetById(id, String) as String;
		}
		
		/** 
		 * Returns an asset casted as a StyleSheet
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as a StyleSheet
		 */
		public function getStyleSheet(id:String):StyleSheet {
			var css:StyleSheet = new StyleSheet();
			
			css.parseCSS(getAssetById(id, String) as String);
			
			return css;
		}
		
		/** 
		 * Returns an asset casted as a Sound
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as a Sound
		 */
		public function getSound(id:String):Sound {
			return getAssetById(id, Sound) as Sound;
		}
		
		/** 
		 * Returns the loader object for a given id
		 * 
		 * @param id  id for the asset who's loader you're looking for
		 * @return  the loader you're looking for
		 */
		public function getLoader(id:String):* {
			return _hashIdToLoader[id];
		}
		
		/** 
		 * Returns an asset casted as a MovieClip
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as a MovieClip
		 */
		public function getMovieClip(id:String):MovieClip {
			return getAssetById(id, MovieClip) as MovieClip;
		}
		
		/** 
		 * Returns an asset casted as a Sprite
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as a Sprite
		 */
		public function getSprite(id:String):Sprite {
			return getAssetById(id, Sprite) as Sprite;
		}
		
		/** 
		 * Returns an asset casted as an AVM1Movie
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as an AVM1Movie
		 */
		public function getAVM1Movie(id:String):AVM1Movie {
			return getAssetById(id, AVM1Movie) as AVM1Movie;
		}
		
		/** 
		 * Returns an asset casted as a Bitmap
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as a Bitmap
		 */
		public function getBitmap(id:String):Bitmap {
			return getAssetById(id, Bitmap) as Bitmap;
		}
		
		/** 
		 * Returns a Bitmap asset's BitmapData
		 * 
		 * @param id  id of the Bitmap you're looking for
		 * @return  the Bitmap asset's BitmapData
		 */
		public function getBitmapData(id:String):BitmapData {
			return getBitmap(id).bitmapData as BitmapData;
		}
		
		/** 
		 * Returns an asset casted as a ByteArray
		 * 
		 * @param id  id of the asset you'd like
		 * @return  the asset you'd like casted as a ByteArray
		 */
		public function getByteArray(id:String):ByteArray {
			return getAssetById(id, ByteArray) as ByteArray;
		}
		
		/**
		 * Returns a boolean if id id loaded
		 * 
		 * @param	id 		id of the asset you'd like to check if is loaded
		 * @return		true if is loaded else false
		 */
		public function isIDLoaded (id:String):Boolean {
			return isAssetByIdLoaded(id);
		}
		
		//event listeners
		private function onLoadComplete(evt:Event):void {
			var loader:* = getLoaderFromEvent(evt);
			var dispatcher:IEventDispatcher = loader is Loader ? loader.contentLoaderInfo : loader;
				
			dispatcher.removeEventListener(Event.COMPLETE, onLoadComplete);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			
			_hashLoaderToProps[loader]._loaded = true;			
			_nTotalLoaders == ++_nTotalLoadersLoaded ? dispatchEvent(new Event(Event.COMPLETE)) : void;
		}
		
		private function onLoadProgress(evt:ProgressEvent):void	{
			var nAllBytesLoaded:int = 0;
			var nAllBytesTotal:int = 0;
			var currentProps:Object = _hashLoaderToProps[getLoaderFromEvent(evt)];
			
			currentProps._started = true;
			currentProps._bytesLoaded = evt.bytesLoaded;
			currentProps._bytesTotal = _bUseHeadRequests ? currentProps._bytesTotal : evt.bytesTotal;
			
			for each (var props:Object in _hashLoaderToProps) {
				nAllBytesLoaded += props._bytesLoaded;
				nAllBytesTotal += props._bytesTotal;
			}
			
			if (!_bUseHeadRequests) {
				var nPercent:Number = 0;				
				
				for each (var otherProps:Object in _hashLoaderToProps)
					if (otherProps._bytesTotal > 0 && otherProps != currentProps)
						nPercent += (1 / _nTotalLoaders) * (otherProps._bytesLoaded / otherProps._bytesTotal);
							
				nPercent = Math.max(Math.min((evt.bytesLoaded / evt.bytesTotal) * (1 / _nTotalLoaders) + nPercent, 1), 0);
				_nCalculatedPercent = nPercent > _nCalculatedPercent ? nPercent : _nCalculatedPercent;
			} 
			else {
				_nCalculatedPercent = Math.max(Math.min(((Math.floor(((nAllBytesLoaded / nAllBytesTotal) * 100))) * .01), 1), 0);
			}
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, nAllBytesLoaded, nAllBytesTotal));
		}
		
		//getter setters
		public function get calculatedPercent():Number {
			return _nCalculatedPercent;
		}
		
		//private functions
		private function registerExtensions(arr:Array):Dictionary {
			var dict:Dictionary = new Dictionary(true);
			
			arr.forEach(function(obj:*, index:int, arr:Array):void {
				obj.extensions.forEach(function(ext:*, index:int, arr:Array):void {
					dict[ext] = obj.type;
				});
			});
			
			return dict;
		}
		
		private function buildPropsObject(url:*, props:Object):Object {
			if (!props)
				props = new Object();
			
			props.url = (url is String ? new URLRequest(url) : (url is URLRequest ? url : new ArgumentError("url")));
			
			if (props.url is ArgumentError)
				throw props.url;
			
			props.type = props.type || determineType(URLRequest(props.url).url);
			props.context = props.context ? props.context : (props.type == TYPE_SOUND ? new SoundLoaderContext() : new LoaderContext());
			props.id = props.id || generateUniqueId();
			props._started = false;
			props._loaded = false;
			props._bytesLoaded = 0;
			props._bytesTotal = 0;
			
			return props;
		}
		
		private function determineType(strUrl:String):String {
			return _hashExtToType[strUrl.substring(strUrl.lastIndexOf(".")).toLowerCase()];
		}
		
		private function startLoader(loader:*):void	{
			var dispatcher:IEventDispatcher = loader is Loader ? loader.contentLoaderInfo : loader;
			
			dispatcher.addEventListener(Event.COMPLETE, onLoadComplete);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			
			loader is Loader ? loader.load(_hashLoaderToProps[loader].url, _hashLoaderToProps[loader].context) : (loader is Sound ? loader.load(_hashLoaderToProps[loader].url, _hashLoaderToProps[loader].context) : loader.load(_hashLoaderToProps[loader].url));
		}
		
		private function getAssetById(id:String, type:Class = null):* {
			var loader:* = _hashIdToLoader[id];
			var asset:*;
			
			if (loader is Loader)
				asset = loader.content;
			else if (loader is URLLoader)
				asset = loader.data;
			else if (loader is Sound)
				asset = loader;
			else
				throw new ArgumentError("invalid id");
			
			if (type)
				return type(asset);
			else
				return asset;
		}
		
		private function isAssetByIdLoaded(id:String):Boolean
		{
			var loader:* = _hashIdToLoader[id];
			var isAssetLoaded:Boolean = false;
			if (loader != null) isAssetLoaded = true; 
			return isAssetLoaded;
		}		
		
		private function receiveTotalSizeFromHeadRequest(strId:String, nSize:int):void {
			var bComplete:Boolean = true;
			
			_hashLoaderToProps[_hashIdToLoader[strId]]._bytesTotal = nSize;
			
			for each (var props:Object in _hashLoaderToProps)
				if (props._bytesTotal == 0)
					bComplete = false;
			
			if (bComplete)
				for (var loader:* in _hashLoaderToProps)
					startLoader(loader);
		}
		
		private function receiveErrorFromHeadRequest():void	{
			_bUseHeadRequests = false;
			
			for (var loader:* in _hashLoaderToProps) {
				startLoader(loader);
			}
		}
		
		private function getTotalSizeFromHeadRequest(props:Object):void	{			
			ExternalInterface.call("AssetLoaderLite.getFileSize", URLRequest(props.url).url, props.id, ExternalInterface.objectID);
		}
		
		private function isUniqueId(strId:String):Boolean {
			if (_hashIdToLoader[strId])
				return false;
			else
				return true;
		}
		
		private function initCallbacks():void
		{
			ExternalInterface.addCallback("receiveFileSize", receiveTotalSizeFromHeadRequest);
			ExternalInterface.addCallback("receiveError", receiveErrorFromHeadRequest);
		}
		
		private function getLoaderFromEvent(evt:Event):* {
			return evt.target is LoaderInfo ? _hashLoaderInfoToLoader[evt.target] : (evt.target is Sound ? Sound(evt.target) : URLLoader(evt.target));
		}
		
		private function generateUniqueId():String {			
			return String(Math.floor(1 + (Math.random() * (2147483647 - 1))));
		}
	}
}