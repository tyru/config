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
XPTemplateDef

XPT letin hint=let\ ..\ =\ ..\ in
let `name^ `^^ =
    `what^ `...^
and `subname^ `^^ =
    `subwhat^`...^
in
..XPT

XPT letrecin hint=let\ rec\ ..\ =\ ..\ in
let rec `name^ `^^ =
    `what^ `...^
and `subname^ `^^ =
    `subwhat^`...^
in
..XPT

XPT if hint=if\ ..\ then\ ..\ else\ ..
if `cond^
    then `thenexpr^`else...^
    else \`cursor\^^^
..XPT

XPT match hint=match\ ..\ with\ ..\ ->\ ..\ |
match `expr^ with
  | `what0^ -> `with0^ `...^
  | `what^ -> `with^`...^
..XPT

XPT moduletype hint=module\ type\ ..\ =\ sig\ ..\ end
module type `name^ `^^ = sig
    `cursor^
end
..XPT

XPT module hint=module\ ..\ =\ struct\ ..\ end
module `name^ `^^ = struct
    `cursor^
end
..XPT

XPT class hint=class\ ..\ =\ object\ ..\ end
class `^^ `name^ =
object (self)
    `cursor^
end
..XPT

XPT classtype hint=class\ type\ ..\ =\ object\ ..\ end
class type `name^ =
object
   method `field0^ : `type0^ `...^
   method `field^ : `type^`...^
end
..XPT
            

XPT classtypecom hint=(**\ ..\ *)\ class\ type\ ..\ =\ object\ ..\ end
(** `class_descr^^ *)
class type `name^ =(**\ ..\ *)\ class\ type\ ..\ =\ object\ ..\ end
object
   (** `method_descr^^ *)
   method `field0^ : `type0^ `...^
   (** `method_descr2^^ *)
   method `field^ : `type^`...^
end
..XPT

XPT typesum hint=type\ ..\ =\ ..\ |\ ..
type `^ `typename^ =
  | `constructor^ `...^
  | `constructor2^`...^
..XPT
            
XPT typesumcom hint=(**\ ..\ *)\ type\ ..\ =\ ..\ |\ ..
(** `typeDescr^ *)
type `^ `typename^ =
  | `constructor^ (** `ctordescr^ *) `...^
  | `constructor2^ (** `ctordescr^ *)`...^
..XPT

XPT typerecord hint=type\ ..\ =\ {\ ..\ }
type `^ `typename^ =
    { `recordField^ : `fType^ `...^
    ; `otherfield^ : `othertype^`...^
    }
..XPT

XPT typerecordcom hint=(**\ ..\ *)type\ ..\ =\ {\ ..\ }
(** `type_descr^ *)
type `^ `typename^ =
    { `recordField^ : `fType^ (** `desc^ *) `...^
    ; `otherfield^ : `othertype^ (** `desc^ *)`...^
    }
..XPT
            
XPT try hint=try\ ..\ with\ ..\ ->\ ..
try `expr^
with `exc^ -> `rez^`...^
   | `exc2^ -> `rez2^`...^
..XPT

