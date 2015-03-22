<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" indent="yes" />

  <xsl:template match="/">

    <html>
      <head>

        <link rel="shortcut icon" href="resources/favicon.ico" type="image/x-icon" />

        <title>
          <xsl:value-of select="//project/name"/>
        </title>

        <script type="text/javascript">
          <xsl:call-template name="script" />
        </script>

        <link href="resources/centric.infomodel.css" rel="stylesheet" type="text/css" />
      
      </head>
      <body>


        <nav id="titlebar">

          <ul>
            <li>
              <a href="#">
                <img src="resources/logo.png" />
              </a>
            </li>
            <li>
              <a href="#" onclick="javascript:displayElement('project-{id}');">
                <xsl:value-of select="//project/name"/>
              </a>
            </li>

            <xsl:if test="//project/version">
            <li>
              Version <xsl:value-of select="//project/version"/>
            </li>
            </xsl:if>
           
          </ul>

        </nav>

        <nav id="menubar">

          <ul>

            <xsl:apply-templates select="//project/model" mode="nav">
              <xsl:sort select="name" order="ascending"/> 
            </xsl:apply-templates>

          </ul>

        </nav>

        <div id="main-container">

          <section id="model-container">
            <xsl:apply-templates select="//project/model" mode="model-container">
              <xsl:sort select="name" order="ascending"/>
            </xsl:apply-templates>     
          </section>

          <section id="content-container">
          Contents
          </section>

        </div>


        <footer>
          test footer
        </footer>

      </body>
    </html>
  </xsl:template>

  <!--
  #################################################################
  Navigation Templates
  #################################################################
  -->

  <xsl:template match="model" mode="nav">
    
      <li>
        <a class="nav" href="#" onclick="javascript:displayElement('model-{id}')">
          <img src="resources/model.png" class="nav-icon"/>
          <span>
            <xsl:value-of select="name"/>
          </span>
        </a>
      </li>

      <xsl:apply-templates select="diagram" mode="nav">
        <xsl:sort select="name"/>
      </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="diagram" mode="nav">

      <li>
        <a class="nav" href="#" onclick="javascript:displayElement('diagram-{id}')">
          <img src="resources/diagram.png" class="nav-icon"/>
          <span>
            <xsl:value-of select="name"/>
          </span>
        </a>
      </li>

  </xsl:template>

  <xsl:template match="class" mode="nav">

    <li>
      <a class="nav" href="#" onclick="javascript:displayEntity('class-{@id}');">
        <span>
          <xsl:value-of select="name"/>
        </span>
      </a>
    </li>

  </xsl:template>


  <!--
  #################################################################
  Model Container Templates
  #################################################################
  -->

  <xsl:template match="model" mode="model-container">
   
    <xsl:choose>
      <xsl:when test="position()=1">
        <xsl:variable name="display-style" select="'display:block;'"/> 
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="display-style" select="'display:none;'"/>      
      </xsl:otherwise>
    </xsl:choose>

    <div class="model" id="model-{@id}"  style="$display-style">
      <!-- list all the classes -->
      <ul>

        <xsl:apply-templates select="class" mode="model-container">          
          <xsl:sort select="name"/>
        </xsl:apply-templates>
      
      </ul>
    </div>

  </xsl:template>

  <xsl:template match="class" mode="model-container">

    <li>

      <xsl:if test="position() mod 2 = 1">
        <xsl:attribute name="class">altcolor</xsl:attribute>
      </xsl:if>

      <a class="nav" href="#" onclick="javascript:displayEntity('class-{@id}');">
        <span>
          <xsl:value-of select="name"/>
        </span>
      </a>
    </li>

  </xsl:template>


  <!--
  #################################################################
  Content Templates
  #################################################################
  -->

  <xsl:template match="diagram" mode="content">
    <div class="content" id="diagram-{@id}"  style="display:none;">
      <img class="diagram" src="diagrams/diagram_{@id}.svg"></img>
    </div>
  </xsl:template>




  <xsl:template name="script">
  <![CDATA[
  <!--   
    
  function displayEntity(elementId)
  {

    var elements = document.getElementsByTagName("div");
   
    for (var i = 0; i < elements.length; i++) { 

      var currentElementId = elements[i].id; 
      var currentElementClass = elements[i].getAttribute("class");
       
      if (currentElementClass == "content")
      {
        if(currentElementId == elementId) 
        {
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


</xsl:stylesheet>
