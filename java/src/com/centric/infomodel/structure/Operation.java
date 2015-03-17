package com.centric.infomodel.structure;

import javax.json.JsonObject;

import org.w3c.dom.Element;

public class Operation extends ProjectElement {

	public Operation(JsonObject json)
	{
		populate(json);  	
	}
	
	public void populate(JsonObject json)
	{
	}
	
	public void populateXmlElement(Element parentElement)
	{		
	}
	
}
