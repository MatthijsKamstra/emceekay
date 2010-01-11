//package com.bumpslide.util {
package nl.emceekaylibrary.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * Attempts to avoid popup blockers when opening links
	 */
	public class Link {

		public static const BROWSER_FIREFOX			:String = "firefox";
		public static const BROWSER_SAFARI			:String = "safari";
		public static const BROWSER_IE				:String = "ie";
		public static const BROWSER_OPERA			:String = "opera";
		public static const BROWSER_UNKNOWN			:String = "unknown";
		protected static const WINDOW_OPEN_FUNCTION	:String = "window.open";
		
		public static const WINDOW_SELF				:String = "_self";
		public static const WINDOW_BLANK			:String = "_blank";
		public static const WINDOW_PARENT			:String = "_parent";
		public static const WINDOW_TOP				:String = "_top";

		/**
		 * Open a new browser window and prevent browser from blocking it.
		 *
		 * @param url        url to be opened
		 * @param window     window target
		 * @param features   additional features for window.open function
		 */
		public static function open(url:String, window:String = "", features:String = ""):void {
			var browserName:String = getBrowserName();			     
			switch( browserName ) {
				case BROWSER_FIREFOX:
					ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
					break;
				case BROWSER_IE:
					ExternalInterface.call("function setWMWindow() {window.open('" + url + "');}");
					break;
				default:
					navigateToURL(new URLRequest(url), window);
			}
		}
		
		/**
		 * Link to a page in the same window
		 *     	"_self" specifies the current frame in the current window.
	   	 * 		"_blank" specifies a new window.
		 * 		"_parent" specifies the parent of the current frame.
		 * 		"_top" specifies the top-level frame in the current window.
		 * 
		 * 
		 * @param	url			url string where you want to go (example: "http://www.foo.br")
		 * @param	inWindow	(default: Link.WINDOW_SELF) window target ("_blank" , "_self" , )
		 */
		public static function to(url:String, inWindow:String = Link.WINDOW_SELF) : void 
		{
			navigateToURL(new URLRequest(url), inWindow);
		}
		
		/**
		 * submit to email
		 * 
		 * @param	inEmail		email-adress (example: foo@bar.nl)
		 * @param	inSubject	subject of the mail (optional)
		 * @param	inBody		body (optional)
		 */
		public static function email (inEmail:String, inSubject:String = null, inBody:String = null):void 
		{
			// mailto:recruitment@hero.nl?subject = Stage % 20lopen & body = Uw % 20reactie
			// This will pass the newline to the body of the email message:
			var mailMsg:URLRequest = new URLRequest("mailto:" + inEmail);
			var variables:URLVariables = new URLVariables();
			if (inSubject != null) {
				variables.subject = inSubject
			}
			if (inBody != null) {
				variables.body = inBody;
			}
			mailMsg.data = variables;
			mailMsg.method = URLRequestMethod.GET;
			navigateToURL(mailMsg, '_self');
		}
		
		/**
		 * return current browser name
		 */
		private static function getBrowserName():String {
			var browser:String = "unknown";
           
			if (ExternalInterface.available) {
				var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			}           
           
			if(browserAgent != null) {
				if(browserAgent.indexOf("Firefox") >= 0) {
					browser = BROWSER_FIREFOX;
				} else if(browserAgent.indexOf("Safari") >= 0) {
					browser = BROWSER_SAFARI;
				} else if(browserAgent.indexOf("MSIE") >= 0) {
					browser = BROWSER_IE;
				} else if(browserAgent.indexOf("Opera") >= 0) {
					browser = BROWSER_OPERA;
				} else {
					browser = BROWSER_UNKNOWN;
				}
			}      
			return browser;			
		}
		
		//////////////////////////////////////// social network ////////////////////////////////////////
		
		public static const DIGG			:String = "digg";
		public static const FACEBOOK		:String = "faceBook";
		public static const GOOGLE_BOOKMARK	:String = "googleBookmark";
		public static const MYSPACE			:String = "myspace";
		public static const STUMBLE_UPON	:String = "stumbleUpon";
		public static const TECHNORATI		:String = "technorati";
		public static const TWITTER			:String = "twitter";
		public static const YAHOO_BOOKMARK	:String = "yahooBookmark";
		public static const LINKEDIN		:String = "linkedinShareArticle";		
		public static const DELICIOUS		:String = "DeliciousBookmark";
		public static const REDDIT			:String	= "RedditBookmark";
			
		/**
		 * bookmark/share with for example twitter, linkedin, stumbleUpon, facebook, etc
		 * 
		 * @example		Link.shareThis ("http://www.foo.nl/bar", "Girls gadget 2009 verkiezing" , Link.TWITTER);
		 * 
		 * @param	url		url you want to share/bookmark (example: http://www.foo.nl/bar)
		 * @param	title	title of the url (example: "foobar de gekste")
		 * @param	to		bookmark to what social network (default: Link.TWITTER)
		 */
		public static function shareThis( url:String, title:String = "", to:String = TWITTER ) : void 
		{
			Link.to( getBookmarkURL(url, title, to), Link.WINDOW_BLANK );
		}
		
		public static function bookmarkThis( url:String, title:String = "", to:String = DELICIOUS ) : void 
		{
			Link.to( getBookmarkURL(url, title, to) );
		}
		
		public static function getBookmarkURL( inURL:String, inTitle:String = "", to:String = TWITTER) : String 
		{
			var url:String	 = escape(inURL);
			var title:String = escape(inTitle);
			var _link:String = "";
			switch (to) {
				case REDDIT:
					_link = 'http:/reddit.com/submit?url=' + url + '&title=' + title;
					break;
				case DIGG:
					_link =  'http://digg.com/submit?phase=2&url=' + url + '&title=' + title;
					break;
				case DIGG :
					_link =  "http://digg.com/submit?phase=2&url=" + url + "&title=" + title;
					break;
				case FACEBOOK :
					_link =  'http://www.facebook.com/sharer.php?u=' + url + '&t=' + title;
					break;
				case GOOGLE_BOOKMARK :
					_link =  "http://www.google.com/bookmarks/mark?op=add&bkmk=" + url + "&title=" + title;
					break;
				case MYSPACE :
					_link =  "http://www.myspace.com/Modules/PostTo/Pages/?u=" + url + "&t=" + title;
					break;
				case STUMBLE_UPON :
					_link =  'http://www.stumbleupon.com/submit?url=' + url + '&title=' + title;
					break;
				case TECHNORATI :
					_link =  "http://technorati.com/faves/?add=" + url;
					break;
				case TWITTER :
					if (title == "" || title == " " )
						_link =  "http://twitter.com/home?status=" + url;
					else
						_link =  "http://twitter.com/home?status=" + title + " - " + url;	
					break;
				case YAHOO_BOOKMARK :
					_link =  "http://myweb2.search.yahoo.com/myresults/bookmarklet?u=" + url + "&t=" + title;
					break;
				case LINKEDIN:
					_link =  "http://www.linkedin.com/shareArticle?mini=true&url=" + url + "&title=" + title;
					break;
				default :
					trace("case '"+to+"':\r\ttrace ('---> "+to+"');\r\tbreak;" );
			}
			return _link;
		}
		
	} // end class
}
