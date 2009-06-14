if exists("b:__CPP_CPP_XPT_VIM__")
  finish
endif
" To avoid loading the C version...
let b:__C_C_XPT_VIM__ = 1
let b:__CPP_CPP_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()


call extend(s:v, { '$TRUE': 'true'
                \, '$FALSE' : 'false'
                \, '$NULL' : 'NULL'
                \, '$UNDEFINED' : ''
                \, '$BRACKETSTYLE' : ""
                \, '$INDENT_HELPER' : ';' }, 'force')

" inclusion
XPTinclude
      \ _common/common
      \ _comment/c.like
      \ _condition/c.like
      \ _loops/c.like
      \ _loops/java.like
      \ _structures/c.like
      \ _preprocessor/c.like
      \ c/wrap


" ========================= Function and Varaibles =============================
function! s:f.cleanTempl( ctx, ... )
  let notypename = substitute( a:ctx,"\\s*typename\\s*","","g" )
  let cleaned = substitute( notypename, "\\s*class\\s*", "", "g" )
  return cleaned
endfunction


" ================================= Snippets ===================================
XPTemplateDef

XPT all  hint=...begin,\ ...end,
`v^.begin(), `v^.end(), `cursor^
 

XPT vector hint=vector<..>\ ..;
vector<`type^> `var^;
`cursor^


XPT map hint=map<..,..>\ ..;
map<`typeKey^,`val^>   `name^;
`cursor^


XPT class   hint=class or struct
XSet class_or_struct=struct
`class_or_struct^ `className^ {
public:
    `className^(`ctorParam^) {
    }
    ~`className^() {
    }
    `className^(const `className^ &cpy) {
    }
    `cursor^
private:
}; /* `class_or_struct^ `className^ */
..XPT


XPT fun=..\ ..\ (..)
`int^
`name^(`_^^) {
    `cursor^
}


XPT namespace hint=namespace\ {}
namespace `name^ {
    `cursor^
}
..XPT


XPT main hint=main\ (argc,\ argv)
int
main(int argc, char *argv[]) {
    `cursor^
    return 0;
}


XPT templateclass   hint=template\ <>\ class
template <`templateParam^>
class `className^ {
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
`className^<`_^cleanTempl(R('templateParam'))^^>::`className^( `ctorParam^ )
{
}
 
template <`templateParam^>
`className^<`_^cleanTempl(R('templateParam'))^^>::~`className^()
{
}
 
template <`templateParam^>
`className^<`_^cleanTempl(R('templateParam'))^^>::`className^( const `className^ &cpy )
{
}
..XPT

