package nl.makesomenoise.c1000hyves.model.vo {
	import com.epologee.application.model.vo.IParsable;

	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class HyvesUserVO implements IParsable {
		public var id : String;
		public var iconSmall : String;
		public var name : String;
		public var profileURL : String;
		//
		public var image : BitmapData;
		public var selected : Boolean = false;

		public function HyvesUserVO(inId : String = "") {
			id = inId;
		}
		

		/**
		<root>
			<userid>258b926459fa48f5</userid>
			<picture>http://94.100.120.149/772450001-772500000/772497501-772497600/772497506_3_CkJv.jpeg</picture>
			<name>Eric-Paul</name>
		</root>
		 */
		public function parseXML(inXML : XML) : Boolean {
			id = inXML.userid;
			iconSmall = inXML.picture;
			name = inXML.child("name");
			
			return name != null && id != null;
		}

		public function drawImage(inSource : IBitmapDrawable, inRect:Rectangle) : BitmapData {
			image = new BitmapData(inRect.width, inRect.height, false, 0);
			image.draw(inSource);
			return image;
		}

		public function toString() : String {
			return id;
		}
	}
}
