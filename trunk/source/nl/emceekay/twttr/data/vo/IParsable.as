package com.epologee.application.model.vo {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IParsable extends IDataValueObject {
		function parseXML(inXML:XML) : Boolean;
	}
}
