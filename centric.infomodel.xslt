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

          <section id="domain-container">
            <xsl:apply-templates select="//project/model" mode="domain-container">
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

              <xsl:call-template name="information" />
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

  <xsl:template match="model" mode="domain-container">

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

        <xsl:apply-templates select="class" mode="domain-container">          
          <xsl:sort select="name"/>
        </xsl:apply-templates>
      
      </ul>
    </div>

  </xsl:template>

  <xsl:template match="class" mode="domain-container">

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
  CONTENT CONTAINERS
  #################################################################

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

      <table class="attribute">

        <!-- DOMAINS -->

        <tr>
          <td class="header" colspan="2">
            <span class="header">
              Project Details
            </span>
          </td>
        </tr>
        
        <tr class="altcolor">
          <td>
            <span class="label">
              File Name
            </span>
          </td>
          <td>
            <xsl:value-of select="file-name"/>
          </td>
        </tr>

        <tr>
          <td>
            <span class="label">
              Last Modified
            </span>
          </td>
          <td>
            <xsl:value-of select="modified-date"/>
          </td>
        </tr>

        <tr class="altcolor">
          <td>
            <span class="label">
              Version
            </span>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length(version)=0">
                <em>Not specified.</em>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="version"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>

        <tr>
          <td>
            <span class="label">
              Author
            </span>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length(author)=0">
                <em>Not specified.</em>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="author"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>

        <tr class="altcolor">
          <td>
            <span class="label">
              Copyright
            </span>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length(copyright)=0">
                <em>Not specified.</em>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="copyright"/>
              </xsl:otherwise>
            </xsl:choose>            
          </td>
        </tr>

      </table>

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
              Metrics &amp; Sets
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

  <!--
  ###########################################################################
  Information Content Container
  ###########################################################################
  -->


  <xsl:template name="information">


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
      This document represents a library of business information.
    </span>

    <table class="attribute">

      <!-- DOMAINS -->

      <tr>
        <td class="header">
          <span class="header">
            Domains
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <b>Domains represent a collection of related concepts.
            Within a domain each named conept has a specific definition.</b>
            
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <img src="resources/model_nav.png" style="width:30px;height:auto;" />
            Domains are represented by a globe.
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <img src="resources/diagram_nav.png" style="width:30px;height:auto;" />
            Diagrams allow you to visualize relationships between concepts.
          </span>
        </td>
      </tr>
      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> Each domain is implemented as a <b>model</b> in StarUML.
          </span>
        </td>
      </tr>

      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> Diagrams are images of <b>class diagrams</b> created in StarUML.
          </span>
        </td>
      </tr>


      <!-- CLASSES -->
      <tr>
        <td class="header">
          <span class="header">
            Concepts
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <b>Concepts are generic entities that play a role in the business.
            They may be described by attributes, merics, formulas or events that occur in their business lifecycle.</b>
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <img src="resources/definition.png" />
            Quotes indicate that that a description has been provided.
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <img src="resources/enum_flag.png" />
            Horizontal bars indicate that instance values have been specified. These values may represent a complete set
            or they may be several representative examples.
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <img src="resources/attributes_flag.png" />
            Dots indicate that attributes, metrics or formulas have been specified.
          </span>
        </td>
      </tr>
      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> Each concept is implemented as a <b>class</b> in StarUML.
          </span>
          </td>
      </tr>

      <!-- Attributes -->
      <tr>
        <td class="header">
          <span class="header">
            Attributes
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <b>Attributes reside within concepts. Each describes a single instance of a concept.</b>
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <span class="marker">
              <img src="resources/grain.png" />
            </span>
            A metric may resolve to a value that is represented by a Concept.  In that case,
            a link to the concept is provided for simple navigation.
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <span class="marker">0..*</span>
            Multiplicity of attributes is typically <b>1</b>, meaning that every
            one instance of a concept is described-by or is related-to exactly one
            of the associated attribute.  In some cases multiplicity may be differnt than 1.  For example,
            a "Department" may have an attribute of "Employees" with a multiplicity of <b>1..*</b>, meaning that
            each one department has one-to-may employees.
          </span>
        </td>
      </tr>

      <tr class="altcolor">
        <td>
          <span class="description">
            <span class="namespace">
              Concept
            </span>
            An attribute may represent another concept ("Employer") or collection of concepts ("Skills"). In that case,
            a link to that concept is provided for simple navigation. Often
            the related concept has a distinct role that it plays. For example, "Top Skill" may be a reference to a "Skill"
            concept playing the role of "Top Skill".
          </span>
        </td>
      </tr>

      <tr class="altcolor">
        <td>
          <span class="description">
            <span class="marker">
              <img src="resources/identifier.png" />
            </span>
            An attribute is considered to be an identifier if it uniquely identifies each instance of the concept.
            Examples may include "Order Number", "SSN", "Country Code".
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <span class="marker">Derived</span> Indicates that an attribute is derived in some manner of forumla or other logic.
            In most cases, attributes are assigned rather than derived.
          </span>
        </td>
      </tr>


      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> Each attribute is implemented as an <b>attribute</b> in StarUML.
          </span>
        </td>
      </tr>

      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> An attribute is considered part of the concept grain
            when the <b>attribute >> isUnique</b> checkbox is checked in StarUML.
          </span>
        </td>
      </tr>

      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> Multiplicity is selected in the <b>attribute >>  multiplicity</b> dropdown in StarUML.
          </span>
        </td>
      </tr>

      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> The relationship to another concept is done by selecting a <b>class</b>
            from the <b>attribute >> stereotype</b> selector in StarUML.
          </span>
        </td>
      </tr>

      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> An attribute is considered an identifier if the
            <b>attribute >> isID</b> checkbox is checked in StarUML.
          </span>
        </td>
      </tr>

      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> An attribute is considered to be derived if the
            <b>attribute >> isDerived</b> checkbox is checked in StarUML.
          </span>
        </td>
      </tr>

      <!-- METRICS -->
      <tr>
        <td class="header">
          <span class="header">
            Metrics &amp; Sets
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <b>
              Metrics are formulas that act across sets of information to (a) aggregate values, or (b) identify a set of values.
              Metrics and sets may be associated with a concept while not necessarily describing a single instance of the concept.
              That is a fundamental difference between attributes and metrics.
            </b>
          </span>
        </td>
      </tr>

      <tr class="altcolor">
        <td>
          <span class="description">
            <span class="namespace">
              Concept
            </span>
            A metric may resolve to a concept ("Grade") or collection (set) of concepts ("Qualified Members"). In that case,
            a link to the concept is provided for simple navigation. 
          </span>
        </td>
      </tr>

      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> Each metric is implemented as an <b>operation</b> in StarUML.
          </span>
        </td>
      </tr>

      <!-- METRICS -->
      <tr>
        <td class="header">
          <span class="header">
            Instances
          </span>
        </td>
      </tr>
      <tr class="altcolor">
        <td>
          <span class="description">
            <b>A concept may have instances that should be defined.  For example, the concept "Product Type"
            may have instances of "Clothing", "Sporting Goods", etc.  Instances are still conceptual in nature and 
            inherit the attributes, metrics and other characteristics of the reference concept.</b>
          </span>
        </td>
      </tr>

      <tr class="implementation">
        <td>
          <span class="description">
            <span class="marker">StarUML</span> Each set of instances are represented by an <b>enumeration</b> in StarUML.
            A <b>class</b> should only have a single <b>enumeration</b> associated with it, though it is possible to create more.
            Within the <b>enumeration</b> are <b>enumeration literals</b>, each of which describes an instance.
          </span>
        </td>
      </tr>

    </table>


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

    var model = document.getElementById("domain-container");

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
