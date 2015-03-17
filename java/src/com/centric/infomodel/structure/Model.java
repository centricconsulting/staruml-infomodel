package com.centric.infomodel.structure;

import java.util.ArrayList;
import java.util.List;

import javax.json.JsonArray;
import javax.json.JsonObject;
 

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class Model extends ProjectElement {
	
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
		this.documentation = json.getString("documentation", ProjectElement.EMPTY_STRING);
		this.parentRefId = ProjectElement.getParentRef(json);
		
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
	
	public void populateXmlElement(Element parentElement)
	{

		Document doc = parentElement.getOwnerDocument();
		
		// spawn the top element
		Element childElement = doc.createElement("model");
		childElement.setAttribute("id",this.id);
		childElement.setAttribute("parent-ref-id",this.parentRefId);
		childElement.setAttribute("project-id",this.parentRefId);
		
		// add element
		Element newElement1 = doc.createElement("name");
		newElement1.appendChild(doc.createTextNode(this.name));
		childElement.appendChild(newElement1);
		
		// add element
		Element newElement2 = doc.createElement("documentation");
		newElement2.appendChild(doc.createTextNode(this.documentation));
		childElement.appendChild(newElement2);		
		
		
		for(int n = 0; n < this.Diagrams.size(); n++)
		{
			this.Diagrams.get(n).populateXmlElement(childElement);
		}
		
		
		parentElement.appendChild(childElement);
			
	}

}
