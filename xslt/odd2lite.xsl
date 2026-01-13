<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="3.0"
    exclude-result-prefixes="tei teix">
    
    <xsl:import href="https://www.tei-c.org/release/xml/tei/stylesheet/odds/odd2lite.xsl"/>

    <!-- Inject exemplum/@type into the wovenodd label cell so it survives into HTML. -->
    <xsl:template name="showExample">
        <xsl:variable name="exampleTypeRaw" select="normalize-space(@type)"/>
        <xsl:variable name="exampleTypeLabel"
            select="
                if ($exampleTypeRaw = '') then
                    'P5'
                else if (lower-case($exampleTypeRaw) = 'lex0') then
                    'Lex-0'
                else
                    $exampleTypeRaw"/>
        <xsl:choose>
            <xsl:when test="parent::tei:attDef">
                <xsl:element namespace="{$outputNS}" name="{$rowName}">
                    <xsl:element namespace="{$outputNS}" name="{$cellName}">
                        <xsl:attribute name="{$colspan}">
                            <xsl:text>2</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element namespace="{$outputNS}" name="{$rowName}">
                    <xsl:element namespace="{$outputNS}" name="{$cellName}">
                        <xsl:attribute name="{$rendName}">
                            <xsl:text>wovenodd-col1</xsl:text>
                        </xsl:attribute>
                        <xsl:element namespace="{$outputNS}" name="{$hiName}">
                            <xsl:attribute name="{$rendName}">
                                <xsl:text>label</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="{$langAttributeName}">
                                <xsl:value-of select="$documentationLanguage"/>
                            </xsl:attribute>
                            <xsl:sequence select="tei:i18n('Example')"/>
                        </xsl:element>
                        <xsl:text> </xsl:text>
                        <xsl:element namespace="{$outputNS}" name="label">
                            <xsl:attribute name="{$rendName}">exampleSource</xsl:attribute>
                            <xsl:value-of select="$exampleTypeLabel"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element namespace="{$outputNS}" name="{$cellName}">
                        <xsl:attribute name="{$rendName}">
                            <xsl:text>wovenodd-col2</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
