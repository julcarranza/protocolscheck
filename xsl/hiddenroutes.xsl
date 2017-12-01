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
  <xsl:for-each select="lc:route-information/lc:route-table/lc:rt/lc:rt-entry">
   <xsl:text>Prefix: </xsl:text><xsl:value-of select='../lc:rt-destination'/><xsl:text>/</xsl:text><xsl:value-of 
select='../lc:rt-prefix-length'/><xsl:text>&#xa;</xsl:text> 
   <xsl:text>State: </xsl:text><xsl:value-of select='lc:rt-entry-state'/><xsl:text>&#xa;</xsl:text> 
   <xsl:text>Protocol: </xsl:text><xsl:value-of select='lc:protocol-name'/><xsl:text>&#xa;</xsl:text> 
   <xsl:text>Next-hop: </xsl:text><xsl:value-of select='lc:protocol-nh/lc:to'/><xsl:text>&#xa;</xsl:text> 
   <xsl:text>AS Path: </xsl:text><xsl:value-of select='lc:as-path'/><xsl:text>&#xa;</xsl:text> 
   <xsl:for-each select="lc:route-flap-damping">
	<xsl:text>Route Flap Damping&#xa;</xsl:text> 
	<xsl:text>Last-merit: </xsl:text><xsl:value-of select='lc:last-merit'/><xsl:text>&#xa;</xsl:text>
	<xsl:text>Merit: </xsl:text><xsl:value-of select='lc:merit'/><xsl:text>&#xa;</xsl:text>
	<xsl:text>Damping-parameters: </xsl:text><xsl:value-of select='lc:damping-parameters'/><xsl:text>&#xa;</xsl:text>
	<xsl:text>Route-flap-count: </xsl:text><xsl:value-of select='lc:route-flap-count'/><xsl:text>&#xa;</xsl:text>
	<xsl:text>Last-update: </xsl:text><xsl:value-of select='lc:last-update'/><xsl:text>&#xa;</xsl:text>
	<xsl:text>First-update : </xsl:text><xsl:value-of select='lc:first-update '/><xsl:text>&#xa;&#xa;</xsl:text>
   </xsl:for-each>  
  </xsl:for-each>
 </xsl:template>
</xsl:stylesheet>
