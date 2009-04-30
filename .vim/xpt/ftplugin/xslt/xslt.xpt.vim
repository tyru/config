if exists("b:__XSLT_XPT_VIM__")
    finish
endif
let b:__XSLT_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ html/html
      \ xml/xml
      \ xml/wrap

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT sort hint=<xsl:sort\ ...
<xsl:sort select="`what^" />
..XPT

XPT valueof hint=<xsl:value-of\ ...
<xsl:value-of select="`what^" />
..XPT

XPT apply hint=<xsl:apply-templates\ ...
<xsl:apply-templates select="`what^" />
..XPT

XPT param hint=<xsl:param\ ...
<xsl:param name="`name^" `select...^select="\`expr\^"^^ />
..XPT

XPT import hint=<xsl:import\ ...
<xsl:import href="`URI^" />
..XPT

XPT include hint=<xsl:include\ ...
<xsl:include href="`URI^" />
..XPT

XPT stylesheet hint=<xsl:stylesheet\ ...
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="`cursor^/^">
    </xsl:template>
</xsl:stylesheet>
..XPT

XPT template hint=<xsl:template\ match=\ ...
<xsl:template match="`match^">
    `cursor^
</xsl:template>
..XPT

XPT foreach hint=<xsl:for-each\ select=\ ...
<xsl:for-each select="`match^">
    `cursor^
</xsl:for-each>
..XPT

XPT if hint=<xsl:if\ test=\ ...
<xsl:if test="`test^">
    `cursor^
</xsl:if>
..XPT

XPT choose hint=<xsl:choose\ ...
<xsl:choose>
  <xsl:when test="`expr^">
    `^
  </xsl:when>`...^
  <xsl:when test="`ex^">
    `what^
  </xsl:when>`...^
  `otherwise...^<xsl:otherwise>
    \`cursor\^
  </xsl:otherwise>^^
</xsl:choose>
..XPT

XPT when hint=<xsl:when\ test=\ ...
<xsl:when test="`ex^">
  `what^
</xsl:when>
..XPT

