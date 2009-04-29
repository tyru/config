if exists("b:__OCAML_XPT_VIM__")
    finish
endif

let b:__OCAML_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate( "letin", [
               \"let `name^ `^^ =",
               \"    `what^ `...^",
               \"and `subname^ `^^ =",
               \"    `subwhat^`...^",
               \"in",
               \""])

call XPTemplate( "letrecin", [
               \"let rec `name^ `^^ =",
               \"    `what^ `...^",
               \"and `subname^ `^^ =",
               \"    `subwhat^`...^",
               \"in",
               \""])

call XPTemplate( 'if', [
               \ 'if `cond^',
               \ '    then `thenexpr^',
               \ '`else...^    else \`cursor\^^^',
               \ ''])

call XPTemplate( "match", [
               \"match `expr^ with",
               \"  | `what0^ -> `with0^ `...^",
               \"  | `what^ -> `with^`...^",
               \""])

call XPTemplate( "moduletype", [
               \ "module type `name^ `^^ = sig",
               \ "    `cursor^",
               \ "end",
               \ ""] )

call XPTemplate( "module", [
               \ "module `name^ `^^ = struct",
               \ "    `cursor^",
               \ "end",
               \ ""] )

call XPTemplate( "class", [
               \ "class `^^ `name^ =",
               \ "object (self)",
               \ "    `cursor^",
               \ "end",
               \ ""] )

call XPTemplate( "classtype", [
               \ "class type `name^ =",
               \ "object",
               \ "   method `field0^ : `type0^ `...^",
               \ "   method `field^ : `type^`...^",
               \ "end",
               \ ""] )
            

call XPTemplate( "classtypecom", [
               \ "(** `class_descr^^ *)",
               \ "class type `name^ =",
               \ "object",
               \ "   (** `method_descr^^ *)",
               \ "   method `field0^ : `type0^ `...^",
               \ "   (** `method_descr2^^ *)",
               \ "   method `field^ : `type^`...^",
               \ "end",
               \ ""] )

call XPTemplate( "typesum", [
               \ "type `^ `typename^ =",
               \ "  | `constructor^ `...^",
               \ "  | `constructor2^`...^",
               \ "" ])
            
call XPTemplate( "typesumcom", [
               \ "(** `typeDescr^ *)",
               \ "type `^ `typename^ =",
               \ "  | `constructor^ (** `ctordescr^ *) `...^",
               \ "  | `constructor2^ (** `ctordescr^ *)`...^",
               \ "" ])

call XPTemplate( "typerecord", [
               \ "type `^ `typename^ =",
               \ "    { `recordField^ : `fType^ `...^",
               \ "    ; `otherfield^ : `othertype^`...^",
               \ "    }",
               \ "" ])

call XPTemplate( "typerecordcom", [
               \ "(** `type_descr^ *)",
               \ "type `^ `typename^ =",
               \ "    { `recordField^ : `fType^ (** `desc^ *) `...^",
               \ "    ; `otherfield^ : `othertype^ (** `desc^ *)`...^",
               \ "    }",
               \ "" ])
            
call XPTemplate('try', [
            \ 'try `expr^',
            \ 'with `exc^ -> `rez^`...^',
            \ '   | `exc2^ -> `rez2^`...^'
            \])

