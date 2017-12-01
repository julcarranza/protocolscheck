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
    <xsl:text>Interface&#x9;Peer Router&#x9;&#x9;State&#xa;</xsl:text>
    <xsl:text>---------&#x9;--------------------&#x9;-------&#xa;</xsl:text>
     <xsl:for-each select="lc:isis-adjacency-information/lc:isis-adjacency">
        <xsl:value-of select='lc:interface-name'/><xsl:text>&#x9;&#x9;</xsl:text>
        <xsl:value-of select='lc:system-name'/><xsl:text>&#x9;</xsl:text>
        <xsl:value-of select='lc:adjacency-state'/><xsl:text>&#xa;</xsl:text>
     </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

