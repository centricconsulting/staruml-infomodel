<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" indent="yes" />

  <!--
  #################################################################
  Root Template - Processing Starts Here
  #################################################################
  -->

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

        <!--
        #################################################################
        Title Bar
        #################################################################
        -->

        <nav id="titlebar">

          <ul>
            <li>
              <a href="#">
                <img src="resources/logo.png" />
              </a>
            </li>
            <li>
              <a href="#" onclick="javascript:displayContent('project-{//project/@id}');">
                <xsl:value-of select="//project/name"/>
              </a>
            </li>

            <xsl:if test="string-length(//project/version) > 0">
            <li>
              Version <xsl:value-of select="//project/version"/>
            </li>
            </xsl:if>
           
          </ul>

        </nav>

        <!--
        #################################################################
        Menu Bar
        #################################################################
        -->

        <nav id="menubar">

          <ul>

            <xsl:apply-templates select="//project/model" mode="nav">
              <xsl:sort select="name" order="ascending"/> 
            </xsl:apply-templates>

            <li class="information">
              <a class="nav" href="#" onclick="javascript:displayContent('information');">
                <img src="resources/information.png" class="nav-icon"/>
                <span>
                  Information
                </span>
              </a>
            </li>


          </ul>

        </nav>

        <div id="main-container">

          <section id="model-container">
            <xsl:apply-templates select="//project/model" mode="model-container">
              <xsl:sort select="name" order="ascending"/>
            </xsl:apply-templates>     
          </section>

          <section id="content-container">

            <!--
            #################################################################
            Project Contents
            #################################################################
            -->

            <div class="control" id="project-{//project/@id}">


              <span class="title">
                <xsl:value-of select="//project/name"/>
              </span>

              <span>
                <img src="resources/definition.png" />
                
            <xsl:choose>
              <xsl:when test="string-length(//project/documentation)=0">
              Documentation is not available.
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="//project/documentation"/>
              </xsl:otherwise>
            </xsl:choose>

              </span>

              <span class="section-header">
                Project Information
              </span>

            </div>

            <!--
            #################################################################
            Information Contents
            #################################################################
            -->

            <div class="control" id="information">

              <xsl:attribute name="style">display:none;</xsl:attribute>

              <span class="title">
                Information
              </span>

              <span>
                <img src="resources/information.png" />
                Describes how to navigate and even customize this document.
              </span>

              
            </div>

            <!--
            #################################################################
            Model Contents
            #################################################################
            -->

            <xsl:apply-templates select="//project/model" mode="content-container">
              <xsl:sort select="name" order="ascending"/>
            </xsl:apply-templates>

            <!--
            #################################################################
            Diagram Contents
            #################################################################
            -->

            <xsl:apply-templates select="//project/model/diagram" mode="content-container">
              <xsl:sort select="name" order="ascending"/>
            </xsl:apply-templates>

          </section>

        </div>


        <footer>
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
        <a class="nav" href="#" onclick="javascript:displayGlobal('model-{@id}','model-{@id}');">
          <img src="resources/model_nav.png" class="nav-icon"/>
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
        <a class="nav" href="#" onclick="javascript:displayGlobal('model-{@model-id}','diagram-{@id}');">
          <img src="resources/diagram_nav.png" class="nav-icon"/>
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

    <div class="control" id="model-{@id}">

      <xsl:choose>
        <xsl:when test="position()=1">
          <xsl:attribute name="style">
            display:block;
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="style">
            display:none;
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

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

      <a class="nav" href="#" onclick="javascript:displayContent('class-{@id}');">
        <span>
          <xsl:value-of select="name"/>
        </span>


        <xsl:choose>
          <xsl:when test="(count(attribute) > 0) or (count(operation) > 0)">
            <img src="resources/attributes_flag.png" title="{name} has attributes." />
          </xsl:when>
          <xsl:otherwise>
            <div class="placeholder" />
          </xsl:otherwise>
        </xsl:choose>

      <xsl:choose>
        <xsl:when test="count(enum/enumliteral) > 0">
          <img src="resources/enum_flag.png" title="{name} has enumerations." />
        </xsl:when>
        <xsl:otherwise>
          <div class="placeholder" />
        </xsl:otherwise>
      </xsl:choose>


        <xsl:choose>
          <xsl:when test="string-length(documentation) > 0">
            <img src="resources/definition.png" title="{name} has a definition." />
          </xsl:when>
          <xsl:otherwise>
            <div class="placeholder" />
          </xsl:otherwise>
        </xsl:choose>


      </a>
    </li>

  </xsl:template>


  <!--
  #################################################################
  Content Templates
  #################################################################
  -->


  <xsl:template match="model" mode="content-container">

    <!-- project div -->
    <div class="control" id="model-{@id}" style="display:none;">


      <span class="title">
        <xsl:value-of select="name"/>
      </span>

      <span>
        <img src="resources/definition.png" />

        <xsl:choose>
          <xsl:when test="string-length(documentation)=0">
            Documentation is not available.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="documentation"/>
          </xsl:otherwise>
        </xsl:choose>

        
      </span>

    </div>

  </xsl:template>

  <xsl:template match="diagram" mode="content-container">

    <div class="control" id="diagram-{@id}" style="display:none;">

      <span class="title">
        <xsl:value-of select="name"/>
      </span>

      <span>
        <img src="resources/definition.png" />

        <xsl:choose>
          <xsl:when test="string-length(documentation)=0">
            Documentation is not available.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="documentation"/>
          </xsl:otherwise>
        </xsl:choose>

      </span>

      <img class="diagram" src="diagrams/diagram_{@id}.svg"></img>

    </div>
  </xsl:template>




  <xsl:template name="script">
  <![CDATA[
  <!--   
    

  function displayGlobal(modelid, contentid)
  {

    displayModel(modelid);
    displayContent(contentid);
  }


  function displayModel(modelid)
  {

    var model = document.getElementById("model-container");

    var elements = model.getElementsByTagName("div");
   
    for (var i = 0; i < elements.length; i++) { 

      var currentElementId = elements[i].id; 
      var currentElementClass = elements[i].getAttribute("class");
       
      if (currentElementClass == "control")
      {
        if (currentElementId == modelid)
        {
          elements[i].style.display = 'block';
        } else {
          elements[i].style.display = 'none';
        }
      }
    }
  }


  function displayContent(contentid)
  {
 
    var content = document.getElementById("content-container");

    var elements = content.getElementsByTagName("div");
   
    for (var i = 0; i < elements.length; i++) { 

      var currentElementId = elements[i].id; 
      var currentElementClass = elements[i].getAttribute("class");
       
      if (currentElementClass == "control")
      {
        if (currentElementId == contentid)
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
