<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" method="text" omit-xml-declaration="yes" indent="no" />
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">

    <!-- column headers --> 
    <xsl:text disable-output-escaping="yes">Subject&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Entity&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Class&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Attribute&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Type&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Grain&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Reference&#x9;</xsl:text>    
    <xsl:text disable-output-escaping="yes">Multiplicity&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Realization&#x9;</xsl:text>    
    <xsl:text disable-output-escaping="yes">Description&#xa;</xsl:text>

    <!-- all instances are called separately --> 
    <xsl:apply-templates select="//entity[ancestor::subject[1]/name!='Attribute Classes']">
      <xsl:sort select="ancestor::subject[1]/name" data-type="text"/>
      <xsl:sort select="name" data-type="text"/>
    </xsl:apply-templates>

    <!-- all instances are called separately --> 
    <xsl:apply-templates select="//enum[ancestor::subject[1]/name!='Attribute Classes']/instance">
      <xsl:sort select="ancestor::subject[1]/name" data-type="text"/>
      <xsl:sort select="entity[@id=current()/ancestor::enum[1]/@reference-object-id]/name" data-type="text" />
      <xsl:sort select="name" data-type="text"/>
    </xsl:apply-templates>

  </xsl:template>


  <!-- ##################################################################################### -->
  <!-- CREATE ENTITY ROWS -->
  <!-- ##################################################################################### -->
  
  <xsl:template match="entity">

    <xsl:variable name="entity-id" select="./@id" />

    <!-- Subject Column --> 
    <xsl:value-of select="ancestor::subject[1]/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Entity Column --> 
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Class Column --> 
    <xsl:text disable-output-escaping="yes">Entity&#x9;</xsl:text>

    <!-- Attribute Column --> 
    <!-- exclude attribute for classes -->
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Type Column --> 
    <xsl:text disable-output-escaping="yes">[Reference]&#x9;</xsl:text>

    <!-- Grain Column-->
    <xsl:if test="count(/attribute[@is-unique='true'])=0">Grain</xsl:if>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Reference Column-->
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Multiplicity Column-->
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Realization Column--> 
    <xsl:choose>
    <xsl:when test="@visibility='public'">Physical</xsl:when>
    <xsl:otherwise>Virtual</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>  

    <!-- Description Column --> 
    <xsl:value-of select="normalize-space(description)"/>

    <!-- END OF LINE -->
    <xsl:text disable-output-escaping="yes">&#xa;</xsl:text> 
  
    <!-- Express children of entity -->
    <!-- ### Entity >> Attributes ###  -->
    <xsl:apply-templates select="attribute">
      <xsl:sort select="name" data-type="text"/>
    </xsl:apply-templates>

    <!-- ### Entity >> Measures ###  -->
    <xsl:apply-templates select="measure">
      <xsl:sort select="name" data-type="text"/>
    </xsl:apply-templates>

  </xsl:template>

  <!-- ##################################################################################### -->
  <!-- CREATE ATTRIBUTE ROWS --> 
  <!-- ##################################################################################### -->
  
  <xsl:template match="attribute">

    <!-- Subject Column --> 
    <xsl:value-of select="ancestor::subject[1]/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Entity Column --> 
    <xsl:value-of select="ancestor::entity[1]/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Class Column --> 
    <xsl:text disable-output-escaping="yes">Attribute&#x9;</xsl:text>

    <!-- Attribute Column --> 
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Type Column --> 
    <xsl:choose>
      <xsl:when test="string-length(@reference-object-id)>0">[Reference]</xsl:when>
      <xsl:when test="//entity[@id=current()/@type-object-id]"><xsl:value-of select="//entity[@id=current()/@type-object-id]/name"/></xsl:when>
      <xsl:otherwise>{Unknown}</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Grain Column-->
    <xsl:if test="@is-unique='true'">Grain</xsl:if>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Reference Column-->
    <xsl:value-of select="//entity[@id=current()/@reference-object-id]/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Multiplicity Column-->
    <xsl:value-of select="multiplicity"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Realization Column--> 
    <xsl:choose>
    <xsl:when test="@visibility='public'">Physical</xsl:when>
    <xsl:otherwise>Virtual</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Description Column --> 
    <xsl:value-of select="normalize-space(description)"/>
    
    <!-- END OF LINE -->
    <xsl:text disable-output-escaping="yes">&#xa;</xsl:text>   
    
  </xsl:template>

  <!-- ##################################################################################### -->
  <!-- CREATE MEASURE ROWS -->  
  <!-- ##################################################################################### -->
  
  <xsl:template match="measure">

    <!-- Subject Column --> 
    <xsl:value-of select="ancestor::subject[1]/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Entity Column --> 
    <xsl:value-of select="ancestor::entity[1]/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Class Column -->     
    <xsl:text disable-output-escaping="yes">Measure&#x9;</xsl:text>

        <!-- Attribute Column --> 
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Type Column --> 
    <xsl:choose>
      <xsl:when test="string-length(@reference-object-id)>0">[Reference]</xsl:when>
      <xsl:when test="//entity[@id=current()/@type-object-id]"><xsl:value-of select="//entity[@id=current()/@type-object-id]/name"/></xsl:when>
      <xsl:otherwise>{Unknown}</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Grain Column-->
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Reference Column-->
    <xsl:value-of select="//entity[@id=current()/@reference-object-id]/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Multiplicity Column-->
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Realization Column--> 
    <xsl:choose>
    <xsl:when test="@visibility='public'">Physical</xsl:when>
    <xsl:otherwise>Virtual</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>    
    
    <!-- Description Column -->
    <xsl:value-of select="normalize-space(description)"/>
    <xsl:if test="string-length(specification)>0">
    <xsl:if test="string-length(description)>0"> </xsl:if>[Specification] <xsl:value-of select="normalize-space(specification)" />
    </xsl:if>
    
    <!-- END OF LINE -->  
    <xsl:text disable-output-escaping="yes">&#xa;</xsl:text>       
    
  </xsl:template>   

  <!-- ##################################################################################### -->
  <!-- CREATE INSTANCE ROWS -->  
  <!-- ##################################################################################### -->
  
  <xsl:template match="instance">

    <xsl:variable name="entity-id" select="ancestor::enum[1]/@reference-object-id" />

    <!-- Subject Column -->
    <xsl:choose>
      <xsl:when test="//entity[@id=$entity-id]/ancestor::subject[1]"><xsl:value-of select="//entity[@id=$entity-id]/ancestor::subject[1]/name"/></xsl:when>
      <xsl:otherwise>{<xsl:value-of select="ancestor::subject[1]/name"/>}</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Entity Column -->
    <xsl:choose>
      <xsl:when test="//entity[@id = $entity-id]"><xsl:value-of select="//entity[@id = $entity-id]/name"/></xsl:when>
      <xsl:otherwise>{<xsl:value-of select="ancestor::enum[1]/name"/>}</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Class Column -->     
    <xsl:text disable-output-escaping="yes">Instance&#x9;</xsl:text>

    <!-- Attribute Column --> 
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Type Column --> 
    <xsl:text disable-output-escaping="yes">[Reference]&#x9;</xsl:text>    

    <!-- Grain Column -->
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Reference Column-->
    <xsl:choose>
      <xsl:when test="//entity[@id = $entity-id]"><xsl:value-of select="//entity[@id = $entity-id]/name"/></xsl:when>
      <xsl:otherwise>{<xsl:value-of select="ancestor::enum[1]/name"/>}</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Multiplicity Column-->
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Realization Column--> 
    <xsl:choose>
    <xsl:when test="@visibility='public'">Physical</xsl:when>
    <xsl:otherwise>Virtual</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>   

    <!-- Description Column --> 
    <xsl:value-of select="normalize-space(description)"/>
    
    <!-- END OF LINE -->
    <xsl:text disable-output-escaping="yes">&#xa;</xsl:text>      
    
  </xsl:template>   
 

</xsl:stylesheet>
