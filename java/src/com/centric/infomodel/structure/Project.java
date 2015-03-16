package com.centric.infomodel.structure;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.json.JsonArray;
import javax.json.JsonObject;

public class Project  extends Element {
	
	public Date modifiedDate;
	public String author;
	public String copyright;
	public String version;
	
	public List<Model> Models = new ArrayList<Model>();
	
	
	public Project(JsonObject json, Date modifiedDate)
	{
		populate(json, modifiedDate);	   			
	}
	
	public void populate(JsonObject json, Date modifiedDate)
	{

		this.modifiedDate = modifiedDate;
		
		// Required
		this.name = json.getString("name");
		this.id = json.getString("_id");
	    
		// optional
		this.documentation = json.getString("documentation", null);
	    this.author = json.getString("author", null);
	    this.copyright = json.getString("copyright", null);	
	    this.version = json.getString("version", null);
		
		JsonArray JsonResults = json.getJsonArray("ownedElements");
		
		for(int n = 0; n < JsonResults.size(); n++)
		{
			JsonObject JsonResult = JsonResults.getJsonObject(n);
			
			if(JsonResult.getString("_type").equals("UMLModel"))
			{
				this.Models.add(new Model(JsonResult));
			}
		}
	}
	
	public String getXML()
	{
		return "";
		
	}
	
	
	
	
}
