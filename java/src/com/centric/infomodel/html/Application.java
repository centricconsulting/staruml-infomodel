package com.centric.infomodel.html;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.FilenameUtils;
import org.w3c.dom.Document;

import com.centric.infomodel.structure.Project;

public class Application {

    public static void main(String[] args) throws IOException, ParserConfigurationException, TransformerException  {
		
    	// argument inputs
		String JsonFilePath = "C:\\Users\\jeff.kanel\\Temporary\\Untitled.mdj";
		String HtmlFilePath = "C:\\Users\\jeff.kanel\\Temporary\\target\\test.html";
		String XsltFilePath = "C:\\Working\\GitHub\\staruml-infomodel\\centric.infomodel.xslt";

		// build xml file path
		String HtmlFileBaseName = FilenameUtils.getBaseName(HtmlFilePath);
		String HtmlFolderPath = FilenameUtils.getFullPath(HtmlFilePath);
		String XmlFileName = HtmlFileBaseName + ".xml";		
		String XmlFilePath = FilenameUtils.concat(HtmlFolderPath, XmlFileName);
		
		System.out.println(XmlFilePath);
		
		// populate the project structure
		Project project = new Project(getDocumentJsonObject(JsonFilePath), JsonFilePath);
		
		// retrieve the xml document
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();		
		
		project.populateXmlElement(doc);
		
		// generate the html document
		Builder.transformXml(doc, XsltFilePath, HtmlFilePath);
		
		// generate the xml document
		Builder.saveXml(doc, XmlFilePath);
		
		
		
	}

    public static JsonObject getDocumentJsonObject(String JsonFilePath) throws IOException
    {
		InputStream fis = new FileInputStream(JsonFilePath);       
        JsonReader jsonReader = Json.createReader(fis);        
        JsonObject ProjectJsonObject = jsonReader.readObject();
		jsonReader.close();
		fis.close();
		
		return ProjectJsonObject;
    }
	
	public static String getXmlFromDocument(Document doc) throws TransformerException
	{
		
		   DOMSource domSource = new DOMSource(doc.getDocumentElement());		  
		   
	       StringWriter writer = new StringWriter();
	       StreamResult result = new StreamResult(writer);
	       
	       TransformerFactory tf = TransformerFactory.newInstance();
	       Transformer transformer = tf.newTransformer();
	       
	       // adds new line between each element
	       transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	       
	       // adds indenting based on xml structure
	       transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
	       
	       transformer.transform(domSource, result);
	       
	       return writer.toString();
	       
	}
    
}
