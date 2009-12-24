package nl.makesomenoise.c1000hyves.model.vo {
	import com.epologee.application.model.vo.IParsable;
	import com.epologee.logging.Logee;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class FriendsPageVO implements IParsable {
		public var index : int = 0;
		public var totalPages : int = 0;
		public var totalFriends : int = 0;
		public var friends : Array = [];

		/**		
		<root>
			<results>
				<total>128</total>
				<currentpage>1</currentpage>
				<totalpages>2</totalpages>
			</results>
			<friends>
				<friend>
					<userid>e3e35a4d06f91d37</userid>
					<name>Floris</name>
					<picture>http://94.100.115.48/103950001-104000000/103988901-103989000/103988920_3_ABJM.jpeg</picture>
				</friend>
				...
			</friends>
		</root>
		 */		
		public function parseXML(inXML : XML) : Boolean {
			totalFriends = parseInt(inXML.results.total);
			index = parseInt(inXML.results.currentpage);
			totalPages = parseInt(inXML.results.totalpages);
			
			var friendsList : XMLList = inXML.friends.friend;
			
			var leni : int = friendsList.length();
			for (var i : int = 0; i < leni; i++) {
				var friend : HyvesUserVO = new HyvesUserVO();
				friend.parseXML(friendsList[i]);
				friends.push(friend);
			}
			
			return index > 0;
		}
	}
}
