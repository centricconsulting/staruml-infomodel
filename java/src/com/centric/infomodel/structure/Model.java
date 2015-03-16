package com.centric.infomodel.structure;

import java.util.ArrayList;
import java.util.List;

import javax.json.JsonArray;
import javax.json.JsonObject;

public class Model extends Element {
	
	public List<Diagram> Diagrams = new ArrayList<Diagram>();
	
	public Model(JsonObject json)
	{
		populate(json);  	
	}
	
	public void populate(JsonObject json)
	{
		// required
		this.name = json.getString("name");
		this.id = json.getString("_id");
		
		// optional
		this.documentation = json.getString("documentation", null);
		this.parentId = Element.getParentRef(json);
		
		JsonArray JsonResults = json.getJsonArray("ownedElements");
		
		for(int n = 0; n < JsonResults.size(); n++)
		{
			JsonObject JsonResult = JsonResults.getJsonObject(n);
			
			if(JsonResult.getString("_type").equals("UMLClassDiagram"))
			{
				this.Diagrams.add(new Diagram(JsonResult));
			}
		}	
	}

}
