package nl.emceekaylibrary.utils
{
	import flash.display.Sprite;
	
	/**
	 * Quite ridiculous, actually
	 * I agree : [mck] 
	 * 
	 * example:
	 * // arrow
	 * addChild( PixelUtil.PixelIcon( [	'  * ', 
	 *                           		' *', 
	 *                           		'********', 
	 *                           		' *', 
	 *                           		'  * '] ) );
	 * 
	 * 
	 * 	var _sprite:Sprite = PixelUtil.wipPattern();
	 *	var _bitmapdata:BitmapData = new BitmapData(_sprite.width, _sprite.height);
	 *	_bitmapdata.draw(_sprite);
	 * 
	 * 
	 * @author Matthijs C. Kamstra aka [mck]
	 * @author David Knape
	 */
	public class PixelUtil extends Sprite 
	{
		// patterns
		public static const WIP_PATTERN			:Array = ['xxxxxxxxxxxxyyyyyyyyyyyy','yxxxxxxxxxxxxyyyyyyyyyyy','yyxxxxxxxxxxxxyyyyyyyyyy','yyyxxxxxxxxxxxxyyyyyyyyy','yyyyxxxxxxxxxxxxyyyyyyyy','yyyyyxxxxxxxxxxxxyyyyyyy','yyyyyyxxxxxxxxxxxxyyyyyy','yyyyyyyxxxxxxxxxxxxyyyyy','yyyyyyyyxxxxxxxxxxxxyyyy','yyyyyyyyyxxxxxxxxxxxxyyy','yyyyyyyyyyxxxxxxxxxxxxyy','yyyyyyyyyyyxxxxxxxxxxxxy','yyyyyyyyyyyyxxxxxxxxxxxx','xyyyyyyyyyyyyxxxxxxxxxxx','xxyyyyyyyyyyyyxxxxxxxxxx','xxxyyyyyyyyyyyyxxxxxxxxx','xxxxyyyyyyyyyyyyxxxxxxxx','xxxxxyyyyyyyyyyyyxxxxxxx','xxxxxxyyyyyyyyyyyyxxxxxx','xxxxxxxyyyyyyyyyyyyxxxxx','xxxxxxxxyyyyyyyyyyyyxxxx','xxxxxxxxxyyyyyyyyyyyyxxx','xxxxxxxxxxyyyyyyyyyyyyxx','xxxxxxxxxxxyyyyyyyyyyyyx'];
		public static const STRIPE_PATTERN		:Array = ['x     ','     x','    x ','   x ','  x ',' x '];
		public static const STRIPE_PATTERN2		:Array = ['xyyyyy','yyyyyx','yyyyxy','yyyxyy','yyxyyy','yxyyyy'];
		public static const TRANSPARANTIE_BG	:Array = ['yyyyyyyyxxxxxxxx','yyyyyyyyxxxxxxxx','yyyyyyyyxxxxxxxx','yyyyyyyyxxxxxxxx','yyyyyyyyxxxxxxxx','yyyyyyyyxxxxxxxx','yyyyyyyyxxxxxxxx','yyyyyyyyxxxxxxxx', 'xxxxxxxxyyyyyyyy','xxxxxxxxyyyyyyyy','xxxxxxxxyyyyyyyy','xxxxxxxxyyyyyyyy','xxxxxxxxyyyyyyyy','xxxxxxxxyyyyyyyy','xxxxxxxxyyyyyyyy','xxxxxxxxyyyyyyyy'];
		// icons
		public static const MCK_LOGO			:Array = [	'                                ', ' xxx                 xx     xxx ', ' xx                  xx      xx ',	' xx   xx xx xx  xxxx xx xx   xx ', ' xx   xxxxxxxx xx xx xxxx    xx ',	' xx   xx xx xx xx    xxxx    xx ', ' xx   xx xx xxx xxxxxxx xxx  xx ',	' xxx                        xxx ', '                                '];
		public static const ARROW_LEFT			:Array = ['  * ',' *','********',' *','  * ' ];
		
		public function PixelUtil() { }
		
		
		/**
		 * 
		 * @param	inIconArray		array with string with a character repreyenting a colour
		 * 							example: ['xy','zg'] (x:geel/yellow, y:zwart/black)
		 * @param	inObject		the colors defined used inIconArray
		 * 							example: {x:0xFFCC00, y:0x000000}
		 * @return
		 */
		static public function PixelPattern(inIconArray:Array = null, inObject:Object = null):Sprite
		{
			var sprite:Sprite = new Sprite();
			var num_rows:int = inIconArray.length;
			for ( var row:int = 0; row < num_rows; ++row)
			{
				var num_columns:int = inIconArray[row].length;
				for (var col:int = 0; col < num_columns; ++col)
				{
					var color:Number = inObject[(inIconArray[row] as String).charAt(col)] 
					sprite.graphics.beginFill(color, 1);
					sprite.graphics.drawRect(col, row, 1, 1);
				}
			}
			sprite.graphics.endFill();
			sprite.cacheAsBitmap = true;
			return sprite;
		}		
		
		
		/**
		 * 
		 * @param	inIconArray
		 * @param	inColor
		 * @return
		 */
		static public function PixelIcon(inIconArray:Array = null, inColor:Number = 0x000000):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(inColor, 1);
			var num_rows:int = inIconArray.length;
			for ( var row:int = 0; row < num_rows; ++row)
			{
				var num_columns:int = inIconArray[row].length;
				for (var col:int = 0; col < num_columns; ++col)
				{
					if ((inIconArray[row] as String).charAt(col) != " ") sprite.graphics.drawRect(col, row, 1, 1);
				}
			}
			sprite.graphics.endFill();
			sprite.cacheAsBitmap = true;
			return sprite;
		}
		
		// pattern
		
		static public function wipPattern(inStripColor:Number = 0xFFCC00, inBgColor:Number =  0x000000 ) : Sprite 
		{
			return PixelUtil.PixelPattern (PixelUtil.WIP_PATTERN,{x:inStripColor, y:inBgColor});
		}		
		
		static public function stripePattern(inStripColor:Number = 0xd9d9d9, inBgColor:Number = -1) : Sprite 
		{
			if (inBgColor == -1 ) {
				return PixelUtil.PixelIcon(PixelUtil.STRIPE_PATTERN, inStripColor);
			} else {
				return PixelUtil.PixelPattern (PixelUtil.STRIPE_PATTERN2,{x:inStripColor, y:inBgColor});
			}
		}

		static public function transparantPattern(inStripColor:Number = 0xCCCCCC, inBgColor:Number = 0xFFFFFF) : Sprite 
		{
			return PixelUtil.PixelPattern(PixelUtil.TRANSPARANTIE_BG, {x:inStripColor, y:inBgColor});
		}
		
		// icons
		
		static public function arrowLeftIcon() : Sprite 
		{
			return PixelUtil.PixelIcon(PixelUtil.ARROW_LEFT);
		}
		
		/**
		 * create a little [mck] logo
		 * 
		 * @example		// pixel logo
		 * 				var logo:Sprite = PixelUtil.mckIcon();
		 * 				addChild (logo);
		 * 
		 * @param	inStripColor	color of logo (default black/0x000000)
		 * @return		transparant sprite with a inStripColor logo 
		 */
		static public function mckIcon(inStripColor:Number = 0x000000) : Sprite 
		{
			return PixelUtil.PixelIcon(PixelUtil.MCK_LOGO, inStripColor);
		}
		
	} // end class

}// end package
