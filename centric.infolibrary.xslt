<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" method="text" omit-xml-declaration="yes" indent="no" />
  <xsl:strip-space elements="*"/>


  <xsl:template match="/">

    <!-- column headers --> 
    <xsl:text disable-output-escaping="yes">Entity&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Attribute&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Class&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Type&#x9;</xsl:text>
    <xsl:text disable-output-escaping="yes">Description&#xa;</xsl:text>

    <xsl:apply-templates select="//model/class">
      <xsl:sort select="name" data-type="text"/>
    </xsl:apply-templates>

  </xsl:template>

  <!-- CREATE CLASS ROWS --> 
  <xsl:template match="class">

    <!-- Entity Column --> 
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>
    
    <!-- Attribute Column --> 
    <!-- exclude attribute for classes -->
    <xsl:text disable-output-escaping="yes">{Not Applicable}&#x9;</xsl:text>
    
    <!-- Class Column --> 
    <xsl:text disable-output-escaping="yes">Entity&#x9;</xsl:text>

    <!-- Type Column --> 
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>    

    <!-- Description Column --> 
    <xsl:value-of select="normalize-space(documentation)"/>
    <xsl:text disable-output-escaping="yes">&#xa;</xsl:text>
    

    <xsl:apply-templates select="attribute">
      <xsl:sort select="name" data-type="text"/>
    </xsl:apply-templates>


    <xsl:apply-templates select="operation">
      <xsl:sort select="name" data-type="text"/>
    </xsl:apply-templates>

  </xsl:template>

  <!-- CREATE ATTRIBUTE ROWS --> 
  <xsl:template match="attribute">

    <!-- Entity Column --> 
    <xsl:value-of select="ancestor::class/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>
    
    <!-- Attribute Column --> 
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>
    
    <!-- Class Column --> 
    <xsl:choose>
      <xsl:when test="is-derived='true'">Derived</xsl:when>
      <xsl:otherwise>Attribute</xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>

    <!-- Type Column --> 
    <xsl:choose>
      <xsl:when test="string-length(stereotype-name)=0"><xsl:value-of select="type"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="stereotype-name"/></xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>    

    <!-- Description Column --> 
    <xsl:value-of select="normalize-space(documentation)"/>
    <xsl:text disable-output-escaping="yes">&#xa;</xsl:text>    
    
  </xsl:template>

  <!-- CREATE OPERATION ROWS --> 
  <xsl:template match="operation">

    <!-- Entity Column --> 
    <xsl:value-of select="ancestor::class/name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>
    
    <!-- Attribute Column --> 
    <xsl:value-of select="name"/>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>
    
    <!-- Class Column -->     
    <xsl:text disable-output-escaping="yes">Derived&#x9;</xsl:text>

    <!-- Type Column --> 
    <xsl:choose>
      <xsl:when test="string-length(stereotype/name)=0"></xsl:when>
      <xsl:otherwise><xsl:value-of select="stereotype/name"/></xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">&#x9;</xsl:text>    
    
    <!-- Description Column --> 
    <xsl:value-of select="normalize-space(documentation)"/>
    <xsl:text disable-output-escaping="yes">&#xa;</xsl:text>    
    
  </xsl:template>   

</xsl:stylesheet>
