<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" indent="yes" />

  <xsl:template match="/">

    <html>
      <head>
        <title>
          <xsl:value-of select="//project/name"/>
        </title>
        <style type="text/css">
          <xsl:call-template name="stylesheet" />
        </style>
        <script type="text/javascript">
          <xsl:call-template name="script" />
        </script>
      </head>
      <body>
        <span class="header-label">
          <xsl:value-of select="//project/name"/>
        </span>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="entity">
    <div id="{concat('entity-',logical-name)}">
      <table class="entity-header">
        <tr>
          <td>
            <xsl:value-of select="position"/>. <xsl:value-of select="logical-name"/> <xsl:text> [Entity]</xsl:text>
          </td>
        </tr>
      </table>

      <!-- main property table -->
      <table class="entity-prop">
        <tr>
          <td class="label" nowrap="true">Name:</td>
          <td class="content-primary" width="100%">
            <xsl:value-of select="logical-name"/>
          </td>
        </tr>
        <tr>
          <td class="label" nowrap="true">Definition:</td>
          <td class="content" width="100%">
            <xsl:value-of select="definition"/>
          </td>
        </tr>
        <tr>
          <td class="label" nowrap="true">Notes:</td>
          <td class="content" width="100%">
            <xsl:value-of select="note"/>
          </td>
        </tr>
        <tr>
          <td class="label" nowrap="true">Semantic:</td>
          <td class="content" width="100%">
            <xsl:value-of select="semantic-description"/>
          </td>
        </tr>
      </table>

      <!-- secondary properies table -->
      <table class="entity-prop">
        <tr>
          <td class="label" nowrap="true">Frame-Sensitive:</td>
          <td class="content"  width="30%">
            <xsl:value-of select="frame-sensitive-flag"/>
          </td>
          <td class="label" nowrap="true">Content-Type:</td>
          <td class="content"  width="30%">
            <xsl:value-of select="content-type"/>
          </td>
        </tr>
        <tr>
          <td class="label" nowrap="true">Physical Name:</td>
          <td class="content">
            <xsl:value-of select="physical-name"/>
          </td>
          <td class="label" nowrap="true">Structure Type:</td>
          <td class="content">
            <xsl:value-of select="structure-type"/>
          </td>
        </tr>
      </table>

      <div id="key-groups">
        <table class="key-group">
          <td class="label" nowrap="true">Key Group</td>
          <td class="label" nowrap="true">Notation</td>
          <td class="label" nowrap="true">Function</td>
          <td class="label" nowrap="true">Attribute List</td>
          <xsl:apply-templates select="key-groups/key-group" />
        </table>
      </div>

      <div id="attributes">
        <xsl:apply-templates select="attributes/attribute">
          <xsl:sort select="position" data-type="number"/>
        </xsl:apply-templates>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="key-group">
    <!-- secondary properies table -->
    <tr>
      <td class="content-primary" nowrap="true">
        <b>
          <xsl:value-of select="logical-name"/>
        </b>
      </td>
      <td class="content" nowrap="true">
        <xsl:value-of select="model-name"/>
      </td>
      <td class="content" nowrap="true">
        <xsl:value-of select="functional-type"/>
      </td>
      <td class="content">
        <xsl:value-of select="attribute-list"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="attribute">
    <table class="attribute-header">
      <tr>
        <td>
          <xsl:value-of select="ancestor::entity/position"/>.<xsl:value-of select="position"/>.
          <xsl:value-of select="logical-name"/> <xsl:text> [Attribute]</xsl:text>
        </td>
      </tr>
    </table>

    <!-- main property table -->
    <table class="attribute-prop">
      <tr>
        <td class="label" nowrap="true">Name:</td>
        <td class="content-primary" width="100%">
          <xsl:value-of select="logical-name"/>
        </td>
      </tr>
      <tr>
        <td class="label" nowrap="true">Parent:</td>
        <td class="content-primary" width="100%">
          <xsl:value-of select="entity-logical-name"/>
        </td>
      </tr>
      <tr>
        <td class="label" nowrap="true">Definition:</td>
        <td class="content" width="100%">
          <xsl:value-of select="definition"/>
        </td>
      </tr>
      <tr>
        <td class="label" nowrap="true">Notes:</td>
        <td class="content" width="100%">
          <xsl:value-of select="note"/>
        </td>
      </tr>
      <tr>
        <td class="label" nowrap="true">Semantic:</td>
        <td class="content" width="100%">
          <xsl:value-of select="semantic-description"/>
        </td>
      </tr>
      <tr>
        <td class="label" nowrap="true">Sample:</td>
        <td class="content" width="100%">
          <xsl:value-of select="sample-value"/>
        </td>
      </tr>
    </table>

    <!-- secondary properies table -->
    <table class="attribute-prop">
      <tr>
        <td class="label" nowrap="true">Required Flag:</td>
        <td class="content"  width="30%">
          <xsl:value-of select="required-flag"/>
        </td>
        <td class="label" nowrap="true">Trimmed Flag:</td>
        <td class="content"  width="30%">
          <xsl:value-of select="trimmed-flag"/>
        </td>
      </tr>
      <tr>
        <td class="label" nowrap="true">Unicode Flag:</td>
        <td class="content">
          <xsl:value-of select="unicode-flag"/>
        </td>
        <td class="label" nowrap="true">Case Indicator:</td>
        <td class="content">
          <xsl:value-of select="case-indicator"/>
        </td>
      </tr>
      <tr>
        <td class="label" nowrap="true">Data Length:</td>
        <td class="content"  width="30%">
          <xsl:value-of select="data-length"/>
        </td>
        <td class="label" nowrap="true">Data Precision:</td>
        <td class="content"  width="30%">
          <xsl:value-of select="data-precision"/>
        </td>
      </tr>
      <tr>
        <td class="label" nowrap="true">Physical Type:</td>
        <td class="content">
          <xsl:value-of select="physical-data-type"/>
        </td>
        <td class="label" nowrap="true">Physical Name:</td>
        <td class="content">
          <xsl:value-of select="structure-name"/>
        </td>
      </tr>
    </table>

    <!-- processing directives -->
    <table class="attribute-prop">
      <tr>
        <td class="label" nowrap="true">Result</td>
        <td class="label" nowrap="true">Action</td>
        <td class="label" nowrap="true">Default Value</td>
      </tr>
      <tr>
        <td class="content-primary">Unspecified</td>
        <td class="content">
          <xsl:value-of select="unspecified-action"/>
        </td>
        <td class="content">
          <xsl:value-of select="unspecified-default"/>
        </td>
      </tr>
      <tr>
        <td class="content-primary">Unresolved</td>
        <td class="content">
          <xsl:value-of select="unresolved-action"/>
        </td>
        <td class="content">
          <xsl:value-of select="unresolved-default"/>
        </td>
      </tr>
      <tr>
        <td class="content-primary">Error</td>
        <td class="content">
          <xsl:value-of select="error-action"/>
        </td>
        <td class="content">
          <xsl:value-of select="error-default"/>
        </td>
      </tr>
    </table>

  </xsl:template>

  <xsl:template name="stylesheet">
    <![CDATA[
  <!--

  BODY {
  font-family: Verdana,Arial;
  font-size: 8pt;
  }

  DIV {
  display: block;
  }

  TABLE {
  border: 0px;
  border-collapse: collapse;
  }

  TABLE TD {
  font-family: Verdana,Arial;
  font-size: 8pt;
  padding: 4px;
  padding-right: 8px;
  border: 0px;
  vertical-align: top;
  }

  SELECT {
  font-family: Verdana,Arial;
  font-size: 8pt;
  }

  .header-label {
  font-family: Verdana,Arial;
  font-size: 14pt;
  color: #664499;
  font-weight: bold;
  }

  TABLE.filter TD {
  vertical-align: middle;
  font-weight: bold;
  }


  TABLE.entity-header {
  width: 7in;
  border: 1px solid #999999;
  margin-bottom: 8px;
  }

  TABLE.entity-header TD {
  font-weight: bold;
  background-color: #CCCCFF;
  }

  TABLE.entity-prop {
  width: 7in;
  margin-bottom: 8px;
  }

  TABLE.entity-prop TD {
  border: 1px solid #CCCCCC;
  } 

  TABLE.entity-prop TD.label {
  font-weight: bold;
  background-color: #ECECEC;   
  }

  TABLE.entity-prop TD.content-primary {
  font-weight: bold;
  color: #336699;
  }      

  TABLE.key-group {
  width: 7in;
  margin-bottom: 8px;
  }

  TABLE.key-group TD {
  border: 1px solid #CCCCCC;
  } 

  TABLE.key-group TD.label {
  font-weight: bold;
  background-color: #ECECEC;
  }

  TABLE.key-group TD.content-primary {
  font-weight: bold;
  color: #336699;
  }    

  TABLE.attribute-header TD {
  font-weight: bold;
  background-color: #FED980;
  }

  TABLE.attribute-header {
  width: 6.5in;
  margin-left: 0.5in;
  border: 1px solid #FED980;
  margin-bottom: 8px;
  }

  TABLE.attribute-prop {
  width: 6.5in;
  margin-left: 0.5in;
  margin-bottom: 8px;
  }

  TABLE.attribute-prop TD {
  border: 1px solid #FED980;
  } 

  TABLE.attribute-prop TD.label {
  font-weight: bold;
  background-color: #ECECEC;   
  }

  TABLE.attribute-prop TD.content-primary {
  font-weight: bold;
  color: #FEECBF;
  }       

  -->
  ]]>
  </xsl:template>

  <xsl:template name="script">
    <![CDATA[
  <!--

  function loadXMLDoc(fname)
  {
    var xmlDoc;

    if (window.ActiveXObject) {
      xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
    } else if (document.implementation && document.implementation.createDocument) {
      xmlDoc=document.implementation.createDocument("","",null);
    } else {
      alert('Your browser cannot handle this script');
    }
    
    xmlDoc.async=false;     
    xmlDoc.load(fname);
    return(xmlDoc);
  }

  function loadTransform()
  {
    xml=loadXMLDoc("erwin_document.xml");
    xsl=loadXMLDoc("erwin_transform_html.xsl");
    
    // perform and apply the xsl transform
    if (window.ActiveXObject) {
      ex=xml.transformNode(xsl);
      document.getElementById("doc-body").innerHTML=ex;
      document.title = xml.selectSingleNode("//model/name").text;
    } else if (document.implementation && document.implementation.createDocument) {
      xsltProcessor=new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl);
      resultDocument = xsltProcessor.transformToFragment(xml,document);
      document.getElementById("doc-body").appendChild(resultDocument);
      document.title=xml.evaluate("//model/name",xml,null,XPathResult.STRING_TYPE,null).stringValue;
    }         
  }
  
  
  function toggleHideAttributes(hide)
  {

    elements = document.getElementsByTagName("div");
    
    for (var i = 0; i < elements.length; i++) {
    
      elementId = elements[i].attributes.getNamedItem("id").value;  
      if (elementId=="attributes"){
        if (hide==false){
        elements[i].style.display = 'block';
        } else {
        elements[i].style.display = 'none';
        }
      }
    }
  }
    
    
  function displayEntity(entity)
  {
    elements = document.getElementsByTagName("div");
    
    for (var i = 0; i < elements.length; i++) { 
    
      elementId = elements[i].attributes.getNamedItem("id").value;

      if (elementId.substr(0,6)=="entity"){
      
        if (entity=="ALL_ENTITIES") {
          elements[i].style.display = 'block';
        } else if(elementId=="entity-" + entity) {
          elements[i].style.display = 'block';
        } else {
          elements[i].style.display = 'none';
        }
      }
    }
  }

  -->
  ]]>
  </xsl:template>

</xsl:stylesheet>
