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
    <xsl:variable name="totalSpeeches" select="count(//speech)"/>
 <!-- <xsl:variable name="degrees" select="360 div $totalPersons"/>-->
    <xsl:variable name="greatCircleDiameter" select="600"/>
 <!--   <xsl:variable name="radius" select="12"/>-->
    
   
    <xsl:variable name="persons"
        select="distinct-values($speeches//@speaker | $speeches//@addressee)"/>
   <!-- <xsl:function name="djb:arcPosition">
        <!-\-
            $personOffset is position in sequence of $persons, starting from 1
            $startPosition is lcation to start next arc (and end of preceding one)
        -\->
        <xsl:param name="personOffset"/>
        <xsl:param name="startPosition"/>
        <xsl:if test="$personOffset le count($persons)">
            <xsl:variable name="currentPerson" select="$persons[$personOffset]"/>
            <xsl:variable name="localDegrees" select="(count($speeches/@speaker[. eq $currentPerson]) + count($speeches/@addressee[. eq $currentPerson])) div 360"/>
            <xsl:variable name="radians" select="math:pi() * $localDegrees div 180"/>
            <xsl:variable name="xpos" select="$greatCircleDiameter * math:cos($radians)"/>
            <xsl:variable name="ypos" select="$greatCircleDiameter * math:sin($radians)"/>
            
            
         <!-\-   <xsl:variable name="endPosition"
                select="$startPosition + count($speeches/@speaker[. eq $currentPerson]) + count($speeches/@addressee[. eq $currentPerson])"/>-\->
  <!-\-<xsl:sequence
                select="concat($currentPerson,' starts at ',$startPosition,' and ends at ',$endPosition)"/>
       -\->
            
            <!-\-    <xsl:variable name="localDegrees" select="$startPosition[$currentPerson] div 360"/>-\->
         <xsl:sequence
                select="concat($currentPerson,' position is defined by ',$radians,' radians.')"/>
        
            <xsl:sequence select="djb:arcPosition($personOffset,$radians)"/>
        </xsl:if>
    </xsl:function>
    
<xsl:template match="/">
        <svg width="100%" height="100%">
            <g>
                <xsl:sequence select="djb:arcPosition(1,0)"/>
            </g>
        </svg>
    </xsl:template>-->
     
<xsl:template match="/">
        <svg width="1000%" height="1000%">
            <g transform="translate({$greatCircleDiameter + 30,$greatCircleDiameter + 30})">
                <line x1="-{$greatCircleDiameter}" y1="0" x2="{$greatCircleDiameter}" y2="0"
                    stroke="black" stroke-width="2"/>
                <line x1="0" y1="-{$greatCircleDiameter}" x2="0" y2="{$greatCircleDiameter}"
                    stroke="black" stroke-width="2"/>
                
                <xsl:apply-templates select="//person[@identifier = $interlocutors]"/>
            </g>
        </svg>
    </xsl:template>
    
    <xsl:template match="person">
       
        <xsl:variable name="speaker" select="@identifier"/>
       <xsl:variable name="radius"
            select="count(//speech[(@speaker,tokenize(@addressee,'\s+')) = current()/@identifier])"/>
        <xsl:variable name="localDegrees" select="((count($speeches/@speaker[. eq current()/@identifier]) + count($speeches/@addressee[. eq current()/@identifier])) div 360)"/>
       <!-- <xsl:variable name="localDegrees" select="$degrees * $startPosition[$speaker=$currentPerson]"/>-->
        <xsl:variable name="radians" select="math:pi() * $localDegrees div 180"/>
        <xsl:variable name="xpos" select="$greatCircleDiameter * math:cos($radians)"/>
        <xsl:variable name="ypos" select="$greatCircleDiameter * math:sin($radians)"/>
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
                        select="$greatCircleDiameter * math:cos($radiansAddressee)"/>
                    <xsl:variable name="yposAddressee"
                        select="$greatCircleDiameter * math:sin($radiansAddressee)"/>
                    <line stroke="black" stroke-width="2" x1="{$xpos}" y1="{$ypos}"
                        x2="{$xposAddressee}" y2="{$yposAddressee}"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
