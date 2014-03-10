<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs"
    version="3.0" xmlns="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="root" select="/"/>
    <xsl:variable name="interlocutors"
        select="distinct-values(tokenize(string-join((//speech/@speaker, //speech/@addressee),' '),'\s+'))"/> 
    <xsl:variable name="totalPersons" select="count($interlocutors)"/>
    <xsl:variable name="degrees" select="360 div $totalPersons"/>
    <xsl:variable name="greatCircleRadius" select="600"/>
    <xsl:variable name="radius" select="12"/>
    <xsl:template match="/">
        <svg width="100%" height="100%" style="overflow-x: auto; overflow-y: auto" viewBox="0 0 1100 700">
            <g transform="translate({$greatCircleRadius + 30,$greatCircleRadius + 30})">
                <line x1="-{$greatCircleRadius}" y1="0" x2="{$greatCircleRadius}" y2="0"
                    stroke="black" stroke-width="2"/>
                <line x1="0" y1="-{$greatCircleRadius}" x2="0" y2="{$greatCircleRadius}"
                    stroke="black" stroke-width="2"/>
                <xsl:apply-templates select="//person[@identifier = $interlocutors]"/>
            </g>
        </svg>
    </xsl:template>
    <xsl:template match="person">
        <xsl:variable name="speaker" select="@identifier"/>
        <!--        <xsl:variable name="radius"
            select="count(//speech[(@speaker,tokenize(@addressee,'\s+')) = current()/@identifier])"/>
-->
        <xsl:variable name="localDegrees" select="$degrees * position()"/>
        <xsl:variable name="radians" select="math:pi() * $localDegrees div 180"/>
        <xsl:variable name="xpos" select="$greatCircleRadius * math:cos($radians)"/>
        <xsl:variable name="ypos" select="$greatCircleRadius * math:sin($radians)"/>
        <circle r="{$radius}" cx="{$xpos}" cy="{$ypos}" stroke="red" fill-opacity="0"/>
        <text x="{$xpos + $radius + 2}" y="{$ypos + 2}">
            <xsl:value-of select="@identifier"/>
        </text>
        <xsl:for-each select="$interlocutors">
            <xsl:if
                test="$root//speech[@speaker = $speaker and tokenize(@addressee,'\s+') = current()]">
                <xsl:for-each
                    select="$root//speech[@speaker=$speaker and tokenize(@addressee,'\s+') = current()]/tokenize(@addressee,'\s+')">
                    <xsl:variable name="positionAddressee"
                        select="index-of($interlocutors,current())"/>
                    <xsl:variable name="degreesAddressee" select="$degrees * $positionAddressee"/>
                    <xsl:variable name="radiansAddressee"
                        select="math:pi() * $degreesAddressee div 180"/>
                    <xsl:variable name=" xposAddressee"
                        select="$greatCircleRadius * math:cos($radiansAddressee)"/>
                    <xsl:variable name="yposAddressee"
                        select="$greatCircleRadius * math:sin($radiansAddressee)"/>
                    <line stroke="black" stroke-width="2" x1="{$xpos}" y1="{$ypos}"
                        x2="{$xposAddressee}" y2="{$yposAddressee}"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
