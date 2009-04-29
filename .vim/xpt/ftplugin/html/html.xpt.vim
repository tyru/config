if exists("b:__HTML_HTML_XPT_VIM__")
  finish
endif
let b:__HTML_HTML_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion
XPTinclude 
      \ _common/common
      \ _comment/xml
" ========================= Function and Varaibles =============================
fun! s:f.createTable(...) "{{{
  let nrow_str = inputdialog("num of row:")
  let nrow = nrow_str + 0

  let ncol_str = inputdialog("num of column:")
  let ncol = ncol_str + 0
  

  let l = ""
  let i = 0 | while i < nrow | let i += 1
    let j = 0 | while j < ncol | let j += 1
      let l .= "<tr>\n<td id=\"`pre^_".i."_".j."\"></td>\n</tr>\n"
    endwhile
  endwhile
  return "<table id='`id^'>\n".l."</table>"

endfunction "}}}


" ================================= Snippets ===================================
call XPTemplate('doctype_html3', [
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'])
call XPTemplate('doctype_html4_frameset', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">'])
call XPTemplate('doctype_html4_loose', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">'])
call XPTemplate('doctype_html4_strict', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">'])
call XPTemplate('doctype_html41_frameset', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">'])
call XPTemplate('doctype_html41_loose', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'])
call XPTemplate('doctype_html41_strict', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">'])
call XPTemplate('doctype_xthml1_frameset', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">'])
call XPTemplate('doctype_xhtml1_strict', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'])
call XPTemplate('doctype_xhtml1_transitional', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'])
call XPTemplate('doctype_xhtml11', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/1999/xhtml">'])


call XPTemplate("html", [
      \"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">",
      \"<html>",
      \"  <head>",
      \"    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=`encoding^utf-8^\"/>",
      \"    <link rel=\"stylesheet\" type=\"text/css\" href=\"\" />",
      \"    <style></style>",
      \"    <title>`title^E('%:r')^</title>",
      \"    <script language=\"javascript\" type=\"text/javascript\">",
      \"      <!-- -->",
      \"    </script>",
      \"  </head>",
      \"  <body>",
      \"    `cursor^",
      \"  </body>",
      \"</html>"
      \])
call XPTemplate('t', [ '<`name^span^ `attr^>`cursor^</`name^>' ])
call XPTemplate("id", {'syn' : 'tag'}, 'id="`^"')
call XPTemplate("class", {'syn' : 'tag'}, 'class="`^"')
call XPTemplate('a', '<a href="`href^">`cursor^</a>')
call XPTemplate("div", '<div`^>`cursor^</div>')
call XPTemplate("p", '<p`^>`cursor^</p>')
call XPTemplate("br", '<br/>')
call XPTemplate("h1", '<h1>`cr^^`cursor^`cr^^</h1>')
call XPTemplate("h2", '<h2>`cursor^</h2>')
call XPTemplate("h3", '<h3>`cursor^</h3>')
call XPTemplate("h4", '<h4>`cursor^</h4>')
call XPTemplate("h5", '<h5>`cursor^</h5>')
call XPTemplate("h6", '<h6>`cursor^</h6>')
call XPTemplate("h7", '<h7>`cursor^</h7>')
call XPTemplate("h8", '<h8>`cursor^</h8>')

call XPTemplate('table', [ '`createTable()^' ])
call XPTemplate('table2', [
      \ '<table>',
      \ '  <tr>',
      \ '    <td>`text^^</td>`...2^', 
      \ '    <td>`text^^</td>`...2^', 
      \ '  </tr>`...0^', 
      \ '  <tr>',
      \ '    <td>`text^^</td>`...1^', 
      \ '    <td>`text^^</td>`...1^', 
      \ '  </tr>`...0^', 
      \ '</table>'
      \])

call XPTemplate('table3', [
      \ '<table id="`id^">`CntStart("i", "0")^',
      \ '  <tr>`CntStart("j", "0")^',
      \ '    <td id="`^R("id")_{Cnt("i")}_{CntIncr("j")}^">`text^^</td>`...2^', 
      \ '    <td id="`^R("id")_{Cnt("i")}_{CntIncr("j")}^">`text^^</td>`...2^', 
      \ '  </tr>`tr...^', 
      \ '  <tr>',
      \ '    <td id="\`\^CntStart("j","0")R("id")_{CntIncr("i")}_{CntIncr("j")}\^">\`text\^\^</td>\`td...\^', 
      \ '    <td id="\\\`\\\^R("id")_{Cnt("i")}_{CntIncr("j")}\\\^">\\\`text\\\^\\\^</td>\\\`td...\\\^\^\^', 
      \ '  </tr>\`tr...\^^^', 
      \ '</table>'
      \])
call XPTemplate("script", [ '<script language="javascript" type="text/javascript">', '`cursor^', '</script>'])
call XPTemplate("scrlink", [ '<script language="javascript" type="text/javascript" src="`cursor^"></script>'])


call XPTemplate('p_', '<p>`wrapped^</p>')
call XPTemplate('div_', '<div>`wrapped^</div>')
call XPTemplate('h1_', '<h1>`wrapped^</h1>')
call XPTemplate('h2_', '<h2>`wrapped^</h2>')
call XPTemplate('h3_', '<h3>`wrapped^</h3>')
call XPTemplate('h4_', '<h4>`wrapped^</h4>')
call XPTemplate('h5_', '<h5>`wrapped^</h5>')
call XPTemplate('h6_', '<h6>`wrapped^</h6>')
call XPTemplate('a_', '<a href="">`wrapped^</a>')






