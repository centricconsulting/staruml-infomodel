<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" indent="yes" />
  <xsl:preserve-space elements="*" />

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
            <li class="logo">
              <a href="#" onclick="javascript:displayContent('project-{//project/@id}');">
                <img src="resources/starlogo.png" />
                <img class="logo" src="resources/logo.png" />
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
            
            <xsl:apply-templates select="//project" mode="content-container">
              <xsl:sort select="name" order="ascending"/>
            </xsl:apply-templates>

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

            <!--
            #################################################################
            Class Contents
            #################################################################
            -->

            <xsl:apply-templates select="//project/model/class" mode="content-container">
              <xsl:sort select="name" order="ascending"/>
            </xsl:apply-templates>

            <!--
            #################################################################
            Information Contents
            #################################################################
            -->

            <div class="control" id="information">

              <xsl:attribute name="style">display:none;</xsl:attribute>

              <table class="title">
                <tr>

                  <td>
                    <span class="title">
                      Information
                    </span>
                  </td>

                </tr>
              </table>

              <span class="section">
                <span class="definition">
                  <img src="resources/definition.png" />
                  Describes how to navigate and even customize this document.
                </span>
              </span>

            </div>

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


  <!--
  ###########################################################################
  Project Content Container
  ###########################################################################
  -->

  <xsl:template match="project" mode="content-container">

    <!-- project div -->
    <div class="control" id="project-{@id}" style="display:block;">

      <table class="title"><tr>

          <td>
            <span class="title">
              <xsl:value-of select="name"/>
            </span>
          </td>

      </tr></table>

      <span class="section">
        <span class="definition">
        <img src="resources/definition.png" />
        <xsl:choose>
          <xsl:when test="string-length(documentation)=0">
            <em>Documentation is not available.</em>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="documentation"/>
          </xsl:otherwise>
        </xsl:choose>
        </span>
      </span>

    </div>

  </xsl:template>

  <!--
  ###########################################################################
  Model Content Container
  ###########################################################################
  -->

  <xsl:template match="model" mode="content-container">

    <!-- project div -->
    <div class="control" id="model-{@id}" style="display:none;">


      <table class="title">
        <tr>
          <td>
            <span class="title">
              <xsl:value-of select="name"/>
            </span>
          </td>
        </tr>
      </table>

      <span class="section">
        <span class="definition">
          <img src="resources/definition.png" />
          <xsl:choose>
            <xsl:when test="string-length(documentation)=0">
              <em>Documentation is not available.</em>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="documentation"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </span>

    </div>
  </xsl:template>

  <!--
  ###########################################################################
  Diagram Content Container
  ###########################################################################
  -->

  <xsl:template match="diagram" mode="content-container">

    <div class="control" id="diagram-{@id}" style="display:none;">

      <table class="title"><tr>

          <td class="namespace">
            <span class="namespace">
              <a href="#" onclick="javascript:displayGlobal('model-{ancestor::model/@id}','model-{ancestor::model/@id}');">
                <xsl:value-of select="ancestor::model/name"/>
              </a>
            </span>
          </td>

          <td>
            <span class="title">
              <xsl:value-of select="name"/>
            </span>
          </td>

      </tr></table>


      <span class="section">
        <span class="definition">
        <img src="resources/definition.png" />
        <xsl:choose>
          <xsl:when test="string-length(documentation)=0">
            <em>Documentation is not available.</em>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="documentation"/>
          </xsl:otherwise>
        </xsl:choose>
        </span>
      </span>

      <img class="diagram" src="diagrams/diagram_{@id}.svg"></img>

    </div>
  </xsl:template>

  <!--
  ###########################################################################
  Class Content Container
  ###########################################################################
  -->

  <xsl:template match="class" mode="content-container">

    <!-- project div -->
    <div class="control" id="class-{@id}" style="display:none;">


     <table class="title"><tr>

          <td class="namespace">
            <span class="namespace">
              <a href="#" onclick="javascript:displayGlobal('model-{ancestor::model/@id}','model-{ancestor::model/@id}');">
                <xsl:value-of select="ancestor::model/name"/>
              </a>
            </span>
          </td>

          <td>
            <span class="title">
              <xsl:value-of select="name"/>
            </span>
          </td>

      </tr></table>

      <span class="section">
        <span class="definition">
        <img src="resources/definition.png" />
        <xsl:choose>
          <xsl:when test="string-length(documentation)=0">
            <em>Documentation is not available.</em>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="documentation"/>
          </xsl:otherwise>
        </xsl:choose>
        </span>
      </span>

      <table class="attribute">

        <!--
        ##############################################
        ### Attribute Table Rows
        ##############################################
        -->

        <xsl:if test="count(attribute)>0" >
        <tr>
          <td class="header" colspan="3">
          <span class="header">
            Attributes
          </span>
          </td>
        </tr>

          <xsl:apply-templates select="attribute" mode="content-container">
            <xsl:sort select="is-unique" order="descending" />
            <xsl:sort select="name"/>
          </xsl:apply-templates>

        </xsl:if>

        <!--
        ##############################################
        ### Operation Table Rows
        ##############################################
        -->
        <xsl:if test="count(operation)>0" >
        <tr>
          <td class="header" colspan="3">
            <span class="header">
              Operations
            </span>
          </td>
        </tr>

        <xsl:apply-templates select="operation" mode="content-container" />

        </xsl:if>

        <!--
        ##############################################
        ### Enums Literals Table Rows
        ##############################################
        -->

        <xsl:apply-templates select="enum" mode="content-container">
          <xsl:sort select="name" />
        </xsl:apply-templates>

      </table>

    </div>

  </xsl:template>

    <!--
  ###########################################################################
  Enum Content Container
  ###########################################################################
  -->

  <xsl:template match="enum" mode="content-container">

    <xsl:if test="count(enumliteral)>0" >
      <tr>
        <td class="header" colspan="3">
          <span class="header">
            
            <xsl:if test="string-length(name)>0">
              <span class="description">
                <span class="marker">
                  <xsl:value-of select="name"/>
                </span>
              </span>
            </xsl:if>

          </span>
        </td>
      </tr>

      <xsl:apply-templates select="enumliteral" mode="content-container" />
    </xsl:if>
  </xsl:template>


  <!--
  ###########################################################################
  Enum Literal Content Container
  ###########################################################################
  -->

  <xsl:template match="enumliteral" mode="content-container">

    <tr>
      <xsl:if test="position() mod 2 = 1">
        <xsl:attribute name="class">altcolor</xsl:attribute>
      </xsl:if>

      <td colspan="2">
        <span class="label">
          <xsl:value-of select="name"/>
        </span>
      </td>

      <td>

        <span class="description">
          <xsl:choose>
            <xsl:when test="string-length(documentation)=0">
              Documentation is not available.
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="documentation"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </td>
    </tr>

  </xsl:template>

  <!--
  ###########################################################################
  Model-Attribute Content Container
  ###########################################################################
  -->

  <xsl:template match="attribute" mode="content-container">

  <tr>
      <xsl:if test="position() mod 2 = 1">
        <xsl:attribute name="class">altcolor</xsl:attribute>
      </xsl:if>

    <td>
      <span class="label">

        <xsl:if test="is-unique = 'true'">
          <span class="marker">
            <img src="resources/grain.png" />
          </span>
        </xsl:if>

        <xsl:if test="multiplicity != '1'">
          <span class="marker">
            <xsl:value-of select="multiplicity"/>
          </span>
        </xsl:if>


        <xsl:value-of select="name"/>
      </span>
    </td>

      <td>
      <xsl:choose>
        <!-- ideally lookup the class from the class id -->
        <xsl:when test="string-length(@stereotype-class-id)>0">

          <span class="namespace">
            <a href="#" onclick="javascript:displayGlobal('model-{ancestor::project/model[class/@id=current()/@stereotype-class-id]/@id}','class-{@stereotype-class-id}');">
              <xsl:value-of select="ancestor::project/model/class[@id=current()/@stereotype-class-id]/name"/>
            </a>
          </span>

        </xsl:when>

        <!-- otheriwe use the name -->
        <xsl:when test="string-length(stereotype-name)>0">
          <span class="description">
            <xsl:value-of select="stereotype-name"/>
          </span>
        </xsl:when>

        <!-- otherwise use the type (i.e. data type) -->
        <xsl:when test="string-length(type)>0">
          <span class="description">
              <xsl:value-of select="type"/>
          </span>
        </xsl:when>

      </xsl:choose>
    
    </td>



    <td>

        <span class="description">

          <xsl:if test="is-identifier = 'true'">
            <span class="marker">
              <img src="resources/identifier.png" />
            </span>
          </xsl:if>

          <xsl:if test="is-derived = 'true'">
            <span class="marker">
              Derived
            </span>
          </xsl:if>

          <xsl:choose>
            <xsl:when test="string-length(documentation)=0">
              Documentation is not available.
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="documentation"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
    </td>
    </tr>
  </xsl:template>


  <!--
  ###########################################################################
  Model-Operations Content Container
  ###########################################################################
  -->

  <xsl:template match="operation" mode="content-container">

    <tr>
      <xsl:if test="position() mod 2 = 1">
        <xsl:attribute name="class">altcolor</xsl:attribute>
      </xsl:if>
      <td>
        <span class="label">
          <xsl:value-of select="name"/>
        </span>
      </td>

      <td>
        <xsl:choose>
          <!-- ideally lookup the class from the class id -->
          <xsl:when test="string-length(@stereotype-class-id)>0">

            <span class="namespace">
              <a href="#" onclick="javascript:displayGlobal('model-{ancestor::project/model[class/@id=current()/@stereotype-class-id]/@id}','class-{@stereotype-class-id}');">
                <xsl:value-of select="ancestor::project/model/class[@id=current()/@stereotype-class-id]/name"/>
              </a>
            </span>

          </xsl:when>

          <!-- otheriwe use the name -->
          <xsl:when test="string-length(stereotype-name)>0">
            <span class="description">
              <xsl:value-of select="stereotype-name"/>
            </span>
          </xsl:when>

        </xsl:choose>

      </td>

      <td>
        <span class="description">
          <xsl:choose>
            <xsl:when test="string-length(documentation)=0">
              Documentation is not available.
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="documentation"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </td>
    </tr>
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

  -->
  ]]>
  </xsl:template>


</xsl:stylesheet>
