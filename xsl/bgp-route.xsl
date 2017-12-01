<?xml version="1.0"?>
<!-- ***************************************************************
  Author        : Julio Carranza
  Version       : 1.0
  Last Modified : 2012-05-22

  License       : BSD-Style
  Copyright (c) 2012 Julio Carranza. All Rights Reserved.
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met: 1. Redistributions of source code must retain the above
  copyright notice, this list of conditions and the following
  disclaimer.  2. Redistributions in binary form must reproduce the
  above copyright notice, this list of conditions and the following
  disclaimer in the documentation and/or other materials provided
  with the distribution.  3. The name of the author may not be used
  to endorse or promote products derived from this software without
  specific prior written permission.  THIS SOFTWARE IS PROVIDED BY
  THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
********************************************************************** -->


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lc="http://xml.juniper.net/junos/to_be_replaced/dtd/junos-routing.dtd"
    xmlns:junos="http://xml.juniper.net/junos/5.1I0/dtd/junos.dtd">
<xsl:output method="text" omit-xml-declaration="yes"/>
  <xsl:template match='/'>
  <xsl:text>Route&#x9;&#x9;</xsl:text><xsl:text>Next-hop&#x9;</xsl:text><xsl:text>AS-path&#x9;</xsl:text><xsl:text>Community&#x9;Age&#xa;</xsl:text>
  <xsl:text>--------------------------------------------------------------&#xa;</xsl:text>
  <xsl:for-each select="lc:route-information/lc:route-table[lc:table-name='inet.0']/lc:rt/lc:rt-entry[lc:protocol-name='BGP']">
   <xsl:if test="lc:active-tag='*'">
     <xsl:value-of select='../lc:rt-destination'/><xsl:text>&#x9;&#x9;</xsl:text>
     <xsl:value-of select='lc:gateway'/><xsl:text>&#x9;</xsl:text>
     <xsl:value-of select='lc:as-path'/><xsl:text>&#x9;</xsl:text>
     <xsl:value-of select='lc:communities/lc:community'/><xsl:text>&#x9;</xsl:text>
     <xsl:value-of select='lc:age'/><xsl:text>&#xa;</xsl:text>
   </xsl:if>
  </xsl:for-each>
 </xsl:template>
</xsl:stylesheet>	
