if exists("b:__CPP_CPP_XPT_VIM__")
  finish
endif
let b:__CPP_CPP_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, { '$TRUE': 'true'
               \ , '$FALSE' : 'false'
               \ , '$NULL' : 'NULL'
               \ , '$UNDEFINED' : ''
               \ , '$BRACKETSTYLE' : "\n"
               \ , '$INDENT_HELPER' : ';'})

" inclusion
XPTinclude
      \ _common/common
      \ _structures/c.like
      \ _preprocessor/c.like
      \ c/wrap
      \ _loops/c.like
      \ _loops/java.like

" ========================= Function and Varaibles =============================
function! s:f.cleanTempl( ctx, ... )
  let notypename = substitute( a:ctx,"\\s*typename\\s*","","g" )
  let cleaned = substitute( notypename, "\\s*class\\s*", "", "g" )
  return cleaned
endfunction


" ================================= Snippets ===================================

XPTemplateDef

XPT namespace hint=namespace\ {}
namespace `name^
{
    `cursor^
}


XPT main hint=main\ (argc,\ argv)
int main(int argc, char *argv[])
{
    `cursor^
    return 0;
}


XPT fun=..\ ..\ (..)
`int^ `name^(`_^^)
{
    `cursor^
}


XPT class   hint=class+ctor
class `className^
{
public:
    `className^( `ctorParam^ );
    ~`className^();
    `className^( const `className^ &cpy );
    `cursor^
private:
};
 
// Scratch implementation
// feel free to copy/paste or destroy
`className^::`className^( `ctorParam^ )
{
}
 
`className^::~`className^()
{
}
 
`className^::`className^( const `className^ &cpy )
{
}


XPT templateclass   hint=template\ <>\ class
template
    <`templateParam^>
class `className^
{
public:
    `className^( `ctorParam^ );
    ~`className^();
    `className^( const `className^ &cpy );
    `cursor^
private:
};
 
// Scratch implementation
// feel free to copy/paste or destroy
template <`templateParam^>
`className^<`^cleanTempl(R('templateParam'))^^>::`className^( `ctorParam^ )
{
}
 
template <`templateParam^>
`className^<`^cleanTempl(R('templateParam'))^^>::~`className^()
{
}
 
template <`templateParam^>
`className^<`^cleanTempl(R('templateParam'))^^>::`className^( const `className^ &cpy )
{
}


XPT try hint=try\ ...\ catch...
try
{
    `what^
}`...^
catch ( `except^ )
{
    `handler^
}`...^
`catch...^catch ( ... )
{
    \`cursor\^
}^^


