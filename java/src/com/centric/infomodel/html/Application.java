package com.centric.infomodel.html;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import java.util.Date;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;

import com.centric.infomodel.structure.Project;

public class Application {

    public static void main(String[] args) throws IOException  {
		
		String JsonFilePath = "C:\\Users\\jeff.kanel\\Temporary\\Test.mdj";
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
		
		
		Project project = new Project(ProjectJsonObject, getFileModifiedDate(JsonFilePath));
		
		System.out.println(project.name);
		
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
    

	private static Date getFileModifiedDate(String FilePath)
	{
		
		File file = new File(FilePath);
		return new Date(file.lastModified());
		
	}
    
}
