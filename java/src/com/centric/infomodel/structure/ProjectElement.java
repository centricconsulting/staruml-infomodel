package com.centric.infomodel.structure;

import javax.json.JsonObject;

public abstract class ProjectElement {

	public String id;
	public String parentRefId;
	public String name;
	public String documentation;
	
	public static final String EMPTY_STRING = "";
	
	public static String getParentRef(JsonObject GenericJsonObject)
	{
		return getRef(GenericJsonObject, "_parent");
	}
	
	public static String getRef(JsonObject GenericJsonObject, String refLabel)
	{
		JsonObject RefJsonObject = GenericJsonObject.getJsonObject(refLabel);
		
		if (RefJsonObject != null)
		{
			return RefJsonObject.getString("$ref", null);
		} else {
			return null;
		}
	}
}
