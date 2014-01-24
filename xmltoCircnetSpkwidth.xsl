<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs"
    version="3.0" xmlns="http://www.w3.org/2000/svg" xmlns:djb="http://www.obdurodon.org">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="root" select="/"/>
    <xsl:variable name="interlocutors"
        select="distinct-values(tokenize(string-join((//speech/@speaker, //speech/@addressee),' '),'\s+'))"/>
    <xsl:variable name="totalPersons" select="count($interlocutors)"/>
   <xsl:variable name="speeches" select="//speech"/>
    <xsl:variable name="totalSpeeches" select="count(//speech) + count(//speech[@addressee])"/>
<xsl:variable name="degrees" select="360 div $totalSpeeches"/>
    <xsl:variable name="greatCircleRadius" select="1200"/>
 <!--   <xsl:variable name="radius" select="12"/>-->
    
    <xsl:template match="/">
        <svg width="1000%" height="1000%">
            <g transform="translate({$greatCircleRadius + 30,$greatCircleRadius + 30})">
                <line x1="-{$greatCircleRadius}" y1="0" x2="{$greatCircleRadius}" y2="0"
                    stroke="black" stroke-width="2"/>
                <line x1="0" y1="-{$greatCircleRadius}" x2="0" y2="{$greatCircleRadius}"
                    stroke="black" stroke-width="2"/>
                
              <!--  <xsl:apply-templates select="//person[@identifier = $interlocutors]"/>-->
                <xsl:sequence select="djb:arcPosition(1,0)"/>
         
                
            </g>
        </svg>
    </xsl:template>  
   
   
    <xsl:function name="djb:arcPosition">
        <!--
            $personOffset is position in sequence of $persons, starting from 1
            $startPosition is lcation to start next arc (and end of preceding one)
        -->
        <xsl:param name="personOffset"/>
        <xsl:param name="startAngle"/> 
        <xsl:if test="$personOffset le count($interlocutors)">
            <xsl:variable name="currentPerson" select="$interlocutors[$personOffset]"/>
            <xsl:variable name="endAngle"
                select="$startAngle + $degrees * (count($speeches/@speaker[. eq $currentPerson]) + count($speeches/@addressee[. eq $currentPerson])) "/>
            <xsl:variable name="stAngleRad" select="math:pi() * $startAngle div 180"/>
            <xsl:variable name="endAngleRad" select="math:pi() * $endAngle div 180"/>
            <xsl:variable name="xpos1" select="$greatCircleRadius * math:cos($stAngleRad)"/>
            <xsl:variable name="ypos1" select="$greatCircleRadius * math:sin($stAngleRad)"/>
            <xsl:variable name="xpos2" select="$greatCircleRadius * math:cos($endAngleRad)"/>
            <xsl:variable name="ypos2" select="$greatCircleRadius * math:sin($endAngleRad)"/>
            
            <path d="M{$xpos1},{$ypos1}, A{$greatCircleRadius, $greatCircleRadius}, 0 0,1 {$xpos2},{$ypos2}" style="stroke:#660000; fill:none"/>
               
            <text x="{$xpos1 + 5}" y="{$ypos1 + 5}">
                <xsl:value-of select="$currentPerson"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="$endAngleRad"/>
                <xsl:text>radians, or </xsl:text>
                <xsl:value-of select="$endAngle"/>
                <xsl:text>degrees.</xsl:text>
            </text>  
            <line x1="0" y1="0" x2="{$xpos1}" y2="{$ypos1}" style="stroke:#006600;"/>
      
            
 <xsl:sequence select="djb:arcPosition($personOffset + 1,$endAngle)"/>
        </xsl:if>
    </xsl:function>

     

    
   <!-- <xsl:template match="person">
       
        <xsl:variable name="speaker" select="@identifier"/>
       <xsl:variable name="radius"
            select="count(//speech[(@speaker,tokenize(@addressee,'\s+')) = current()/@identifier])"/>
        <xsl:variable name="localDegrees" select="((count($speeches/@speaker[. eq current()/@identifier]) + count($speeches/@addressee[. eq current()/@identifier])) div 360)"/>
       <!-\- <xsl:variable name="localDegrees" select="$degrees * $startPosition[$speaker=$currentPerson]"/>-\->
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
                    <xsl:variable name="degreesAddressee" select="$localDegrees * $positionAddressee"/>
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
    </xsl:template>-->
</xsl:stylesheet>
