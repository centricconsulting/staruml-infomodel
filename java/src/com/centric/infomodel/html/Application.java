package com.centric.infomodel.html;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;

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

import org.w3c.dom.Document;

import com.centric.infomodel.structure.Project;

public class Application {

    public static void main(String[] args) throws IOException, ParserConfigurationException, TransformerException  {
		
		String JsonFilePath = "C:\\Users\\jeff.kanel\\Temporary\\Untitled.mdj";
		//String xsltTemplateFilePath = "C:\\Users\\jeff.kanel\\AppData\\Roaming\\StarUML\\extensions\\user\\centric.information-model\\template.xslt";
		//String targetHtmlFilePath = "C:\\Users\\jeff.kanel\\Temporary\\target\\infomodel.html";
		//String targetXmlFilePath = "C:\\Users\\jeff.kanel\\Temporary\\target\\infomodel.xml";
		
		// generate the xml
		//StringReader xmlStringReader = JsonToXml.generateXmlStringReader(JsonFilePath);
		InputStream fis = new FileInputStream(JsonFilePath);       
        JsonReader jsonReader = Json.createReader(fis);        
        JsonObject ProjectJsonObject = jsonReader.readObject();
		jsonReader.close();
		fis.close();
		
		
		Project project = new Project(ProjectJsonObject, JsonFilePath);
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();		
		
		project.populateXmlElement(doc);
		
		String x = Application.getXmlFromDocument(doc);
		
		
		System.out.println(x);
		
		/*
		File xmlFile = new File(targetXmlFilePath);
		
		FileWriter xmlFileWriter = new FileWriter(xmlFile);
		xmlFileWriter.write(xml);
		xmlFileWriter.flush();
		xmlFileWriter.close();
		
		*/
		
		// transform
		// Builder.transform(xmlStringReader, xsltTemplateFilePath, targetHtmlFilePath);
		
	}
    

	public static Date getFileModifiedDate(String filePath)
	{
		File file = new File(filePath);
		return new Date(file.lastModified());		
	}
	
	public static String getFileName(String filePath)
	{		
		Path p = Paths.get(filePath);
		return p.getFileName().toString();
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
