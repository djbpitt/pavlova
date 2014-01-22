<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs"
    version="3.0" xmlns="http://www.w3.org/2000/svg" xmlns:djb="http://www.obdurodon.org">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="root" select="/"/>
    <xsl:variable name="speeches" as="element()+">
        <speech speaker="greg" addressee="elisa"/>
        <speech speaker="greg" addressee="elisa"/>
        <speech speaker="greg" addressee="elisa"/>
        <speech speaker="greg" addressee="david"/>
        <speech speaker="greg" addressee="david"/>
        <speech speaker="greg" addressee="elisa"/>
        <speech speaker="elisa" addressee="meg"/>
        <speech speaker="elisa" addressee="david"/>
        <speech speaker="elisa" addressee="david"/>
        <speech speaker="david" addressee="greg"/>
    </xsl:variable>
    <xsl:variable name="persons"
        select="distinct-values($speeches//@speaker | $speeches//@addressee)"/>
    <xsl:variable name="interlocutors"
        select="distinct-values(tokenize(string-join((//speech/@speaker, //speech/@addressee),' '),'\s+'))"/>
    <xsl:variable name="totalPersons" select="count($interlocutors)"/>
<!--    <xsl:variable name="speeches" select="//speech"/>-->
    <xsl:variable name="totalSpeeches" select="count(//speech/@speaker)"/>
    
    <xsl:variable name="degrees" select="360 div ($totalPersons)"/>
    <xsl:variable name="greatCircleRadius" select="600"/>
    
    <xsl:function name="djb:arcPosition">
        <!--
            $personOffset is position in sequence of $persons, starting from 1
            $startPosition is lcation to start next arc (and end of preceding one)
        -->
        <xsl:param name="personOffset"/>
        <xsl:param name="startAngle"/>
        <xsl:if test="$personOffset le count($persons)">
            <xsl:variable name="currentPerson" select="$persons[$personOffset]"/>
            <xsl:variable name="endAngle"
                select="$startAngle + $degrees * (count($speeches/@speaker[. eq $currentPerson]) + count($speeches/@addressee[. eq $currentPerson])) "/>"/>
            <xsl:sequence
                select="concat($currentPerson,' starts at ',$startAngle,' and ends at ',$endAngle)"/>
        <xsl:sequence select="djb:arcPosition($personOffset + 1,$endAngle)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="/">
        <svg width="100%" height="100%">
            <g>
                <xsl:sequence select="djb:arcPosition(1,0)"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
