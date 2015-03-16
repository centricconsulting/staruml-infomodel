package com.centric.infomodel.structure;

import javax.json.JsonObject;

import org.apache.commons.lang3.StringEscapeUtils;

public abstract class Element {

	public String id;
	public String parentId;
	public String name;
	public String documentation;
	
	public static String getParentRef(JsonObject GenericJsonObject)
	{
		JsonObject RefJsonObject = GenericJsonObject.getJsonObject("_parent");
		if (RefJsonObject != null)
		{
			return RefJsonObject.getString("$ref", null);
		} else {
			return null;
		}
	}
	
	public static String finalizeXml(StringBuilder sourceXml)
	{
		
		final String xmlDeclaration = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\" ?>\r\n";
		
		return xmlDeclaration + sourceXml.toString();
		
	}
	
	public static String escapeXml(String xml)
	{		
		return StringEscapeUtils.escapeXml11(xml);	
	}
	
}
