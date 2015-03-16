package com.centric.infomodel.html;

import java.io.File;
import java.io.StringReader;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class Builder {

	public static void  transform(StringReader xmlStringReader, String xsltTemplateFilePath, String targetHtmlFilePath)
	{
				
        // reference the xslt source
        Source xsltStreamSource = new StreamSource(new File(xsltTemplateFilePath));
                
        // reference the xml source file
        Source xmlStreamSource = new StreamSource(xmlStringReader);
        
        // perform the transformation
        TransformerFactory factory = TransformerFactory.newInstance();        
        
		try {
			
			Transformer transformer = factory.newTransformer(xsltStreamSource);
			transformer.transform(xmlStreamSource, new StreamResult(new File(targetHtmlFilePath)));
			
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}
	
}
