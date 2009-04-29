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
call XPTemplate('sort','<xsl:sort select="`what^" />')
call XPTemplate('valueof', '<xsl:value-of select="`what^" />' )
call XPTemplate('apply', '<xsl:apply-templates select="`what^" />' )
call XPTemplate('param', '<xsl:param name="`name^" `select...^select="\`expr\^"^^ />')
call XPTemplate('import', '<xsl:import href="`URI^" />')
call XPTemplate('include', '<xsl:include href="`URI^" />')

call XPTemplate( "stylesheet", [
		\ '<xsl:stylesheet version="1.0"',
		\ '                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >',
		\ '',
		\ '    <xsl:output method="xml" indent="yes"/>',
		\ '',
		\ '    <xsl:template match="`cursor^/^">',
		\ '    </xsl:template>',
		\ '</xsl:stylesheet>'
        \ ])

call XPTemplate('template', [
            \ '<xsl:template match="`match^">',
            \ '    `cursor^',
            \ '</xsl:template>'
            \])

call XPTemplate('foreach', [
            \ '<xsl:for-each select="`match^">',
            \ '    `cursor^',
            \ '</xsl:for-each>'
            \])

call XPTemplate('if', [
            \ '<xsl:if test="`test^">',
            \ '    `cursor^',
            \ '</xsl:if>'
            \])

call XPTemplate('choose', [
            \ '<xsl:choose>',
            \ '  <xsl:when test="`expr^">',
            \ '    `^',
            \ '  </xsl:when>`...^',
            \ '  <xsl:when test="`ex^">',
            \ '    `what^',
            \ '  </xsl:when>`...^',
            \ '  `otherwise...^<xsl:otherwise>',
            \ '    \`cursor\^',
            \ '  </xsl:otherwise>^^',
            \ '</xsl:choose>'
            \])

